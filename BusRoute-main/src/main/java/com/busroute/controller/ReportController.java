package com.busroute.controller;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import com.busroute.domain.Criteria;
import com.busroute.domain.PageDTO;
import com.busroute.domain.ReportVO;
import com.busroute.service.MailService;
import com.busroute.service.ReportService;
import com.busroute.service.UserService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/report/*")
@AllArgsConstructor	
public class ReportController {
	
    private final ReportService service;
    private final ServletContext servletContext;
    
    @Autowired
    private MailService mailService;
    
    @Autowired
    private UserService userService;

    @GetMapping({"/user/list", "/admin/list"})
    public String list(@ModelAttribute Criteria cri, Model model, HttpSession session,
                       RedirectAttributes rttr, HttpServletRequest request) {

        String user_id = (String) session.getAttribute("userid");
        if (user_id == null) {
            rttr.addFlashAttribute("message", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        if (cri.getStatusFilter() == null) cri.setStatusFilter("");
        if (cri.getType() == null) cri.setType("");
        if (cri.getKeyword() == null) cri.setKeyword("");
        cri.setPageStart((cri.getPageNum() - 1) * cri.getAmount());

        String uri = request.getRequestURI();
        boolean isAdmin = uri.contains("/admin/");
        String queryUserId = isAdmin ? null : user_id;

        // ✅ 파라미터를 Map에 담는다
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("type", cri.getType());
        paramMap.put("keyword", cri.getKeyword());
        paramMap.put("statusFilter", cri.getStatusFilter());
        paramMap.put("pageStart", cri.getPageStart());
        paramMap.put("amount", cri.getAmount());
        paramMap.put("user_id", queryUserId);

        List<ReportVO> list = service.getListWithPaging(paramMap);
        int total = service.getTotalCount(paramMap);

        int startNo = total - ((cri.getPageNum() - 1) * cri.getAmount());
        for (int i = 0; i < list.size(); i++) {
            list.get(i).setDisplayNo(startNo - i);
        }

        model.addAttribute("list", list);
        model.addAttribute("pageMaker", new PageDTO(cri, total));

        return isAdmin ? "report/admin/list" : "report/user/list";
    }




    // 글쓰기 페이지 요청 (GET)
    @GetMapping({"/user/write", "/admin/write"})
    public String write(HttpSession session, Model model, HttpServletRequest request, RedirectAttributes rttr) {
        String userId = (String) session.getAttribute("userid");
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        // 로그인 체크
        if (userId == null) {
            rttr.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        // 정지된 계정 제한
        if ("SUSPENDED".equals(role)) {
            rttr.addFlashAttribute("error", "정지된 계정은 글쓰기가 불가능합니다.");
            return "redirect:/";
        }

        // 작성자 정보 세팅
        ReportVO report = new ReportVO();
        report.setUsername(username);
        report.setUser_id(userId);
        model.addAttribute("user_id", userId);
        model.addAttribute("report", report);

        // 요청 URI에 따라 관리자/일반 사용자 JSP 경로 분기
        return request.getRequestURI().contains("/admin/")
                ? "/report/admin/write"
                : "/report/user/write";
    }



    

    
    
    // 글 등록 처리 (POST)
    @PostMapping({"/user/write", "/admin/write"})
    public String writePost(ReportVO report,
                            @RequestParam("uploadFiles") MultipartFile[] uploadFiles,
                            HttpSession session,
                            HttpServletRequest request,
                            RedirectAttributes rttr) {

        String userId = (String) session.getAttribute("userid");
        String role = (String) session.getAttribute("role");

        // 로그인 체크
        if (userId == null) {
            rttr.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/user/login";
        }

        // 정지된 계정 제한
        if ("SUSPENDED".equals(role)) {
            rttr.addFlashAttribute("error", "정지된 계정은 글쓰기가 불가능합니다.");
            return "redirect:/";
        }

        // 작성자 정보 설정
        report.setUser_id(userId);

        // 업로드 경로 설정 (UNC 경로)
        String uploadPath = "\\\\192.168.30.231\\upload";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 파일 저장 처리
        List<String> savedPaths = new ArrayList<>();
        for (MultipartFile file : uploadFiles) {
            if (file.isEmpty()) continue;
            try {
                String originalFilename = file.getOriginalFilename().replaceAll("\\s+", "");
                String uuid = UUID.randomUUID().toString();
                String saveName = uuid + "_" + originalFilename;
                file.transferTo(new File(uploadDir, saveName));
                savedPaths.add(saveName);
            } catch (IOException e) {
                log.error("파일 업로드 실패: " + file.getOriginalFilename(), e);
            }
        }

        // 첨부파일 정보 저장
        if (!savedPaths.isEmpty()) {
            report.setAttachmentPath(String.join(",", savedPaths));
        }

        // 등록 처리
        service.register(report);
        
        // 메일 전송 처리(접수 시 관리자에게 알림)
        try {
            String subject = "새 게시글 접수 알림";
            String content = String.format(
            	    "<div style='font-family: Segoe UI, sans-serif; padding: 20px; background-color: #f4f6f9; border-radius: 10px;'>"
            	  + "<h2 style='color: #2E86C1;'>새로운 게시글이 접수되었습니다</h2>"
            	  + "<table style='width: 100%%; border-collapse: collapse; background-color: #fff; border: 1px solid #ddd;'>"
            	  + "    <tr>"
            	  + "        <th style='width: 50px; text-align: left; padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ddd;'>작성자</th>"
            	  + "        <td style='padding: 10px; border-bottom: 1px solid #ddd;'>%s</td>"
            	  + "    </tr>"
            	  + "    <tr>"
            	  + "        <th style='width: 50px; text-align: left; padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ddd;'>카테고리</th>"
            	  + "        <td style='padding: 10px; border-bottom: 1px solid #ddd;'>"
            	  + "            <span style='background-color: #ffdd57; color: #222; font-weight: bold; padding: 4px 8px; border-radius: 5px;'>%s</span>"
            	  + "        </td>"
            	  + "    </tr>"
            	  + "    <tr>"
            	  + "        <th style='width: 50px; text-align: left; padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ddd;'>제목</th>"
            	  + "        <td style='padding: 10px; border-bottom: 1px solid #ddd;'>%s</td>"
            	  + "    </tr>"
            	  + "    <tr>"
            	  + "        <th style='width: 50px; text-align: left; padding: 10px; background-color: #f0f0f0;'>내용</th>"
            	  + "        <td style='padding: 10px; white-space: pre-wrap;'>%s</td>"
            	  + "    </tr>"
            	  + "</table>"
            	  + "<p style='font-size: 0.9em; color: #999; margin-top: 30px;'>※ 본 메일은 시스템에서 자동 발송되었습니다.</p>"
            	  + "</div>",
            	    userId,
            	    report.getCategory(),
            	    report.getTitle(),
            	    report.getContent()
            	);
            log.info("메일 전송 시작 시간: " + System.currentTimeMillis());
            mailService.sendEmail("rynhaa123@gmail.com", subject, content);
            log.info("메일 전송 호출 완료 시간: " + System.currentTimeMillis());
            log.info("메일 전송 쓰레드: " + Thread.currentThread().getName());
            
        } catch (Exception e) {
            log.error("메일 전송 실패", e);
        }

        // 요청 URI에 따라 redirect 경로 분기
        return request.getRequestURI().contains("/admin/")
                ? "redirect:/report/admin/list"
                : "redirect:/report/user/list";
    }




    // 4. 상세 조회
    @GetMapping({"/user/read", "/admin/read"})
    public void get(@RequestParam("report_id") int report_id, Model model) {
        model.addAttribute("report", service.get(report_id));
    }

    // 5. 수정 폼
    @GetMapping({"/user/modify", "/admin/modify"})
    public void modify(@RequestParam("report_id") int report_id, Model model) {
        model.addAttribute("report", service.get(report_id));
    }

    // 6. 수정 처리
    @PostMapping({"/user/modify", "/admin/modify"})
    public String modifyPost(ReportVO report,
                             @RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles,
                             @RequestParam(value = "deleteFiles", required = false) String[] deleteFiles,
                             HttpSession session,
                             HttpServletRequest request,
                             RedirectAttributes rttr) {

        // 1) 기존 게시물
        ReportVO original = service.get(report.getReport_id());

        // 2) 쓰기와 동일한 UNC 물리 경로 (절대 경로이므로 getRealPath() 를 쓰지 말 것)
        String uploadPath = "\\\\192.168.30.231\\upload";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        /* ------------------------------------------------------------------
           3) 기존 파일 배열 → 삭제 체크 안 된 것만 남김
        ------------------------------------------------------------------ */
        List<String> remainingFiles = new ArrayList<>();
        String[] oldFiles = original.getAttachmentPath() != null
                            ? original.getAttachmentPath().split(",")
                            : new String[0];

        // deleteFiles 가 null 인 경우 대비
        Set<String> deleteSet = deleteFiles == null ? Collections.emptySet()
                                                    : new HashSet<>(Arrays.asList(deleteFiles));

        for (String fileName : oldFiles) {
            if (deleteSet.contains(fileName)) {
                // 실제 파일 삭제
                File del = new File(uploadDir, fileName);
                if (del.exists()) del.delete();
            } else {
                remainingFiles.add(fileName);   // ⬅ 삭제 대상이 아니면 다시 리스트에 넣어준다
            }
        }

        /* ------------------------------------------------------------------
           4) 새로 업로드된 파일 저장
        ------------------------------------------------------------------ */
        if (uploadFiles != null) {
            for (MultipartFile mf : uploadFiles) {
                if (mf.isEmpty()) continue;

                try {
                    String originalName = mf.getOriginalFilename().replaceAll("\\s+", "");
                    String saveName     = UUID.randomUUID() + "_" + originalName;
                    mf.transferTo(new File(uploadDir, saveName));
                    remainingFiles.add(saveName);
                } catch (IOException e) {
                    log.error("파일 업로드 실패: " + mf.getOriginalFilename(), e);
                }
            }
        }

        /* ------------------------------------------------------------------
           5) DB에 저장할 attachmentPath 갱신
        ------------------------------------------------------------------ */
        if (!remainingFiles.isEmpty()) {
            report.setAttachmentPath(String.join(",", remainingFiles));
        } else {
            report.setAttachmentPath(null);   // 모든 파일이 삭제된 경우
        }

        /* ------------------------------------------------------------------
           6) 글 수정 & 상세 페이지로 리다이렉트
        ------------------------------------------------------------------ */
        service.modify(report);
        rttr.addAttribute("report_id", report.getReport_id());

        return request.getRequestURI().contains("/admin/")
               ? "redirect:/report/admin/read"
               : "redirect:/report/user/read";
    }


    // 7. 삭제 처리 (+ 파일 삭제는 선택)
    @GetMapping({"/user/remove", "/admin/remove"})
    public String remove(@RequestParam("report_id") int report_id, HttpServletRequest request,
            			HttpSession session, RedirectAttributes rttr) {
    	
        ReportVO report = service.get(report_id);
        String loginUserId = (String) session.getAttribute("userid");
        // 본인 글이 아니면 삭제 금지
        if (!report.getUser_id().equals(loginUserId)) {
            rttr.addFlashAttribute("error", "본인 글만 삭제할 수 있습니다.");
            return "redirect:" + request.getHeader("Referer");
        }
        
        
        if (report.getAttachmentPath() != null) {
            String uploadPath = servletContext.getRealPath("/upload");
            String[] paths = report.getAttachmentPath().split(",");
            for (String path : paths) {
                // path는 /resources/upload/uuid_파일명 형태
                String fileName = path.substring(path.lastIndexOf("/") + 1);
                File file = new File(uploadPath, fileName);
                if (file.exists()) {
                    file.delete();
                }
            }
        }

        service.remove(report_id);
        String uri = request.getRequestURI();
        if (uri.contains("/admin/")) {
            return "redirect:/report/admin/list";
        } else {
            return "redirect:/report/user/list";
        }
    }
    
    @PostMapping("/admin/adminReply") // 답변 등록 및 수정 동일 처리 가능
    public String adminReplyPost(@RequestParam int report_id,
                                 @RequestParam String adminReply,
                                 HttpSession session,
                                 RedirectAttributes rttr) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            rttr.addFlashAttribute("error", "관리자만 답변을 작성할 수 있습니다.");
            return "redirect:/report/admin/read?report_id=" + report_id;
        }

        ReportVO report = service.get(report_id);
        report.setAdmin_reply(adminReply);
        report.setReplied_at(new Date()); // 답변 시간 설정
        report.setStatus("처리중");
        service.modify(report);

        rttr.addFlashAttribute("message", "답변이 저장되었습니다.");
        return "redirect:/report/admin/read?report_id=" + report_id;
    }

    // 답변 삭제 처리
    @PostMapping("/admin/adminReplyDelete")
    public String adminReplyDelete(@RequestParam int report_id,
                                   HttpSession session,
                                   RedirectAttributes rttr) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            rttr.addFlashAttribute("error", "관리자만 답변을 삭제할 수 있습니다.");
            return "redirect:/report/admin/read?report_id=" + report_id;
        }

        ReportVO report = service.get(report_id);
        report.setAdmin_reply(null);   // 답변 삭제
        report.setReplied_at(null);    // 답변 시간 삭제
        report.setStatus("접수"); // ✅ 상태 복원
        service.modify(report);

        rttr.addFlashAttribute("message", "답변이 삭제되었습니다.");
        return "redirect:/report/admin/read?report_id=" + report_id;
    }
    

    @PostMapping("/admin/statusUpdate")
    @ResponseBody
    public ResponseEntity<String> updateStatus(@RequestBody Map<String, String> payload, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("관리자 권한이 필요합니다.");
        }

        String reportIdStr = payload.get("report_id");
        String newStatus = payload.get("status");
        String adminReply = payload.get("admin_reply");

        if (reportIdStr == null || newStatus == null) {
            return ResponseEntity.badRequest().body("필수 데이터가 없습니다.");
        }

        try {
            int reportId = Integer.parseInt(reportIdStr);
            ReportVO report = service.get(reportId);

            if (report == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("게시글을 찾을 수 없습니다.");
            }

            if ("완료".equals(report.getStatus()) && !"완료".equals(newStatus)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body("완료된 게시글은 상태를 변경할 수 없습니다.");
            }

            // 상태 및 댓글 저장
            report.setStatus(newStatus);
            report.setAdmin_reply(adminReply);
            report.setReplied_at(adminReply != null && !adminReply.trim().isEmpty() ? new java.util.Date() : null);
            service.modify(report);

            // 메일 전송
            String userId = report.getUser_id();
            String userEmail = userService.getEmailByUserId(userId);
            if (userEmail != null && !userEmail.isEmpty()) {
            	String subject = "게시글에 답변이 등록되었습니다.";
            	String content = String.format(
            	    "<div style='font-family: Segoe UI, sans-serif; padding: 20px; background-color: #f4f6f9; border-radius: 10px;'>"
            	  + "  <h2 style='color: #2E86C1;'>고객님께서 접수하신 글에 답변이 등록되었습니다</h2>"
            	  + "  <table style='width: 100%%; border-collapse: collapse; background-color: #fff; border: 1px solid #ddd;'>"
            	  + "    <tr>"
            	  + "      <th style='width: 100px; text-align: left; padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ddd;'>작성자</th>"
            	  + "      <td style='padding: 10px; border-bottom: 1px solid #ddd;'>%s</td>"
            	  + "    </tr>"
            	  + "    <tr>"
            	  + "      <th style='text-align: left; padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ddd;'>제목</th>"
            	  + "      <td style='padding: 10px; border-bottom: 1px solid #ddd;'>%s</td>"
            	  + "    </tr>"
            	  + "    <tr>"
            	  + "      <th style='text-align: left; padding: 10px; background-color: #f0f0f0; border-bottom: 1px solid #ddd;'>현재 상태</th>"
            	  + "      <td style='padding: 10px; border-bottom: 1px solid #ddd;'>"
            	  + "        <span style='background-color: #85C1E9; color: #222; font-weight: bold; padding: 4px 8px; border-radius: 5px;'>%s</span>"
            	  + "      </td>"
            	  + "    </tr>"
            	  + "    <tr>"
            	  + "      <th style='text-align: left; padding: 10px; background-color: #f0f0f0;'>관리자 답변</th>"
            	  + "      <td style='padding: 10px; white-space: pre-wrap;'>%s</td>"
            	  + "    </tr>"
            	  + "  </table>"
            	  + "  <p style='font-size: 0.9em; color: #999; margin-top: 30px;'>※ 본 메일은 시스템에서 자동 발송되었습니다.</p>"
            	  + "</div>",
            	  userId,
            	  report.getTitle(),
            	  newStatus,
            	  (adminReply == null || adminReply.trim().isEmpty()) ? "(답변 없음)" : adminReply
            	);

                mailService.sendEmail(userEmail, subject, content);
            }

            return ResponseEntity.ok("상태가 변경되었습니다.");
        } catch (Exception e) {
            log.error("상태 변경 오류", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }

    
    
    @GetMapping(value = "/manage/dailyStats", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<Map<String, Object>> getDailyReportStats(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to) {

        Map<String, Object> param = new HashMap<>();
        param.put("category", category);
        param.put("from", from);
        param.put("to", to);
        return service.getDailyReportStats(param);
    }

    @GetMapping(value = "/manage/categoryStats", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<Map<String, Object>> getCategoryStats() {
        return service.getCategoryStats();
    }

    @GetMapping(value = "/manage/totalCount", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Integer> getTotalCount(@RequestParam Map<String, String> params) {
        log.info("getTotalCount params: " + params);

        Map<String, Object> filteredParams = new HashMap<>();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (entry.getValue() != null && !entry.getValue().trim().isEmpty()) {
                filteredParams.put(entry.getKey(), entry.getValue().trim());
            }
        }

        int total = service.getTotalCountWithFilter(filteredParams);
        return Collections.singletonMap("total", total);
    }

    @GetMapping(value = "/manage/statusStats", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<Map<String, Object>> getStatusStats(@RequestParam Map<String, String> params) {
        return service.getStatusStats(new HashMap<>(params));
    }

    // 평균 처리시간 + 통계 페이지 이동
    @GetMapping("/manage/regraph")
    public String showGraph(Model model) {
        Integer avgSeconds = service.getAverageProcessSeconds();
        String avgTime = formatSecondsToHHMMSS(avgSeconds);
        model.addAttribute("avgProcessTime", avgTime);

        // 처리율 계산 (service에 getCompletionRate() 메서드가 있다고 가정)
        Double completionRate = service.getCompletionRate();
        if (completionRate == null) completionRate = 0.0;
        model.addAttribute("completionRate", String.format("%.1f", completionRate));

        return "report/manage/regraph";
    }

    private String formatSecondsToHHMMSS(Integer seconds) {
        if (seconds == null) return "-";
        int hours = seconds / 3600;
        int minutes = (seconds % 3600) / 60;
        int secs = seconds % 60;
        return String.format("%02d:%02d:%02d", hours, minutes, secs);
    }
    
    @GetMapping(value = "/manage/hourly-stats", produces = "application/json; charset=UTF-8")
    public ResponseEntity<Map<String, int[]>> getHourlyStats() {
        return ResponseEntity.ok(service.getHourlyCreatedAndReplied());
    }
    
    

}
