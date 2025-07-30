package com.busroute.controller;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.busroute.domain.BoardingDTO;
import com.busroute.domain.BusVO;
import com.busroute.domain.EmailLogVO;
import com.busroute.domain.PredictionVO;
import com.busroute.domain.RoleLogVO;
import com.busroute.domain.StationVO;
import com.busroute.domain.UserVO;
import com.busroute.mapper.EmailLogMapper;
import com.busroute.mapper.RouteMapper;
import com.busroute.service.BoardingService;
import com.busroute.service.LogService;
import com.busroute.service.PredictionService;
import com.busroute.service.ReportService;
import com.busroute.service.UserService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/admin/*")
@AllArgsConstructor
public class AdminController {

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private UserService userService;

	@Autowired
	private ReportService reportService;

	@Autowired
	private PredictionService predictionService;

	@Autowired
	private LogService logService;
	
	@Autowired
	private BoardingService boardingService;

	@Autowired
	private EmailLogMapper emailLogMapper;

	@Autowired
	private RouteMapper routeMapper;

	@GetMapping("/dashboard")
	public String dashboard(
	    @RequestParam(required = false) String startDate,
	    @RequestParam(required = false) String interval,
	    @RequestParam(required = false, name = "region") Integer cityCode,
	    @RequestParam(required = false) String routeId,
	    @RequestParam(required = false, defaultValue = "1") int month,
	    @RequestParam(required = false) String model,
	    HttpSession session,
	    RedirectAttributes redirectAttributes,
	    Model modelAttr) {

	    // 권한 체크
	    Object roleObj = session.getAttribute("role");
	    if (roleObj == null || !roleObj.equals("ADMIN")) {
	        redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
	        return "redirect:/admin/login";
	    }
	    
	    
	    // 기본값 세팅: 요청에 없으면 기본값 할당
	    if (cityCode == null) {
	        cityCode = 26;  // 울산
	    }

	    if (routeId == null || routeId.isEmpty()) {
	        routeId = "111";
	    }

	    if (month < 1 || month > 12) {
	        month = 1;
	    }
	    
	    

	    // 기존 predictionService 호출 (startDate 기준)
	    if (startDate != null && !startDate.isEmpty()) {
	        List<PredictionVO> predictionList = predictionService.predict(startDate, interval, 
	                                                                      cityCode != null ? cityCode.toString() : null, 
	                                                                      routeId, model);
	        modelAttr.addAttribute("predictionList", predictionList);
	    }

	    // region(cityCode), routeId, month 파라미터가 있으면 통계 조회 처리
	    Map<Integer, String> cityCodeToRegion = Map.of(
	        21, "부산",
	        22, "대구",
	        24, "광주",
	        26, "울산"
	    );

	    if (cityCode != null && routeId != null && !routeId.isEmpty()) {
	        String regionName = cityCodeToRegion.get(cityCode);
	        String actualRouteId = boardingService.getRouteIdByBusNumber(routeId);

	        if (actualRouteId != null && regionName != null) {
	            int year = 2025;
	            LocalDate start = LocalDate.of(year, month, 1);
	            YearMonth ym = YearMonth.of(year, month);
	            LocalDate endOfMonth = ym.atEndOfMonth();
	            LocalDate today = LocalDate.now();
	            LocalDate end = endOfMonth.isBefore(today) ? endOfMonth : today;

	            List<BoardingDTO> routeStats = boardingService.getDailyBoardingStats(
	                actualRouteId,
	                regionName,
	                start.toString(),
	                end.toString()
	            );

	            modelAttr.addAttribute("routeStats", routeStats);
	        } else {
	            modelAttr.addAttribute("routeStats", Collections.emptyList());
	        }
	    } else {
	        modelAttr.addAttribute("routeStats", Collections.emptyList());
	    }

	    // 노선 리스트도 모델에 담기 (기존 /stats와 동일)
	    modelAttr.addAttribute("routeListGwangju", boardingService.getRouteList("24"));
	    modelAttr.addAttribute("routeListBusan", boardingService.getRouteList("21"));
	    modelAttr.addAttribute("routeListDaegu", boardingService.getRouteList("22"));
	    modelAttr.addAttribute("routeListUlsan", boardingService.getRouteList("26"));

	    // 선택값 유지용
	    modelAttr.addAttribute("selectedRegion", cityCode);
	    modelAttr.addAttribute("selectedRouteId", routeId);
	    modelAttr.addAttribute("selectedMonth", month);

	    return "admin/dashboard";
	}

	@GetMapping("/login")
	public String login() {
		return "/admin/login";
	}

	@PostMapping("/login")
	public String login(@RequestParam String userid, @RequestParam String password, HttpSession session,
			RedirectAttributes redirectAttributes) {
		UserVO user = userService.findById(userid);
		// 비밀번호 암호화
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

		// 암호화 일치 검사
		if (user != null && encoder.matches(password, user.getPassword())) {

			if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
				redirectAttributes.addFlashAttribute("message", "관리자 권한이 없습니다.");
				return "redirect:/login";
			}

			// 사용자 id
			session.setAttribute("userid", user.getUserid());
			// 사용자 unum
			session.setAttribute("adminUnum", user.getUnum());
			// 사용자 이름
			session.setAttribute("adminName", user.getUsername());

			session.setAttribute("role", user.getRole());
			// 마지막 로그인 시간
			userService.updateLastLogin(userid);

			// 로그인 알림
			redirectAttributes.addFlashAttribute("message", "로그인되었습니다.");
			return "redirect:/admin/dashboard";
		} else {
			// 로그인 실패 알림
			redirectAttributes.addFlashAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "redirect:/admin/login";
		}
	}

	@GetMapping("/logout")
	public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
		session.invalidate();
		redirectAttributes.addFlashAttribute("message", "로그아웃되었습니다.");
		return "redirect:/dashboard";
	}

	@GetMapping("/user/list")
	public String user(HttpSession session, RedirectAttributes redirectAttributes,
			@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int pageSize,
			@RequestParam(required = false) String type, @RequestParam(required = false) String is_deleted,
			@RequestParam(required = false) String keyword, Model model) {
		Object userIdObj = session.getAttribute("userid");
		Object roleObj = session.getAttribute("role");

		if (userIdObj == null || roleObj == null || !roleObj.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		int offset = (page - 1) * pageSize;

		// 전체 검색 조건을 Map에 담기 (null이면 무시)
		Map<String, Object> params = new HashMap<>();
		params.put("offset", offset);
		params.put("pageSize", pageSize);
		params.put("type", type);
		params.put("is_deleted", is_deleted);
		params.put("keyword", keyword);

		List<UserVO> userList = userService.getAllUsers(params);
		int totalCount = userService.countAllUsers(params);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		int startPage = Math.max(1, page - 5); // 시작 페이지 (예: 현재 페이지 기준 앞 5페이지)
		int endPage = Math.min(totalPages, page + 4); // 끝 페이지 (현재 페이지 기준 뒤 4페이지)

		boolean prev = startPage > 1;
		boolean next = endPage < totalPages;

		model.addAttribute("userList", userList);
		model.addAttribute("page", page);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("type", type);
		model.addAttribute("is_deleted", is_deleted);
		model.addAttribute("keyword", keyword);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("prev", prev);
		model.addAttribute("next", next);

		return "admin/user/list";
	}

	@GetMapping("/user/detail")
	public String userDetail(@RequestParam("unum") int unum, HttpSession session, RedirectAttributes redirectAttributes,
			Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		UserVO user = userService.getUserByUnum(unum);
		if (user == null) {
			redirectAttributes.addFlashAttribute("message", "해당 사용자를 찾을 수 없습니다.");
			return "redirect:/admin/user/list";
		}

		List<Map<String, Object>> reportRowCount = reportService.countReportsByUser(user.getUserid());
		Map<String, Integer> reportStatusCount = new HashMap<>();
		for (Map<String, Object> row : reportRowCount) {
			String status = (String) row.get("status");
			int cnt = ((Number) row.get("cnt")).intValue();
			reportStatusCount.put(status, cnt);
		}
		model.addAttribute("reportStatusCount", reportStatusCount);

		model.addAttribute("user", user);
		return "/admin/user/detail";
	}

	@PostMapping("/user/update")
	public String updateUser(@RequestParam("unum") int unum, UserVO user, RedirectAttributes redirectAttributes,
			HttpSession session) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		UserVO userInfo = userService.getUserByUnum(unum);
		if (userInfo == null) {
			redirectAttributes.addFlashAttribute("message", "해당 사용자를 찾을 수 없습니다.");
			return "redirect:/admin/user/list";
		}
		userService.updateUserInfo(user); // 이메일, 전화번호, 주소, is_deleted만 업데이트
		redirectAttributes.addFlashAttribute("message", "사용자 정보가 수정되었습니다.");
		return "redirect:/admin/user/detail?unum=" + user.getUnum();
	}

	// 비밀번호 랜덤값 생성
	public String generateAlphaNumericPassword(int length) {
		// 영어 + 숫자, 5~20자 사이
		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		SecureRandom random = new SecureRandom();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < length; i++) {
			int idx = random.nextInt(chars.length());
			sb.append(chars.charAt(idx));
		}
		return sb.toString();
	}

	@PostMapping("/user/reset-password")
	public String resetPassword(@RequestParam("unum") int unum, RedirectAttributes redirectAttributes) {
		int length = ThreadLocalRandom.current().nextInt(5, 21); // 5~20 사이
		String plainPassword = generateAlphaNumericPassword(length);
		String encoded = passwordEncoder.encode(plainPassword);

		userService.resetPassword(unum, encoded);
		redirectAttributes.addFlashAttribute("passwordMessage", "비밀번호가 기본값으로 초기화되었습니다.");
		redirectAttributes.addFlashAttribute("plainPassword", plainPassword);
		return "redirect:/admin/user/detail?unum=" + unum;
	}

	@PostMapping("/auth/reset-password")
	public String resetAdminPassword(@RequestParam("unum") int unum, RedirectAttributes redirectAttributes) {
		int length = ThreadLocalRandom.current().nextInt(5, 21); // 5~20 사이
		String plainPassword = generateAlphaNumericPassword(length);
		String encoded = passwordEncoder.encode(plainPassword);

		userService.resetPassword(unum, encoded);
		redirectAttributes.addFlashAttribute("passwordMessage", "비밀번호가 기본값으로 초기화되었습니다.");
		redirectAttributes.addFlashAttribute("plainPassword", plainPassword);
		return "redirect:/admin/auth/adminAccount";
	}

	// 이메일 중복체크
	@GetMapping("/user/check-email")
	@ResponseBody
	public int checkEmailDuplicate(@RequestParam String email, @RequestParam int unum) {
		// 0이면 사용 가능, 1이면 중복
		return userService.isEmailExistsExcludeSelf(email, unum);
	}

	@GetMapping("/user/stats")
	public String userStats(Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		model.addAttribute("totalUsers", userService.getTotalUserCount()); // 총 사용자 수
		model.addAttribute("deletedUsers", userService.getDeletedUserCount()); // 탈퇴한 수
		model.addAttribute("recentLogins", userService.getRecentLoginUserCount(7)); // 최근 로그인 사용자 수
		model.addAttribute("monthlySignups", userService.getMonthlySignups()); // 월별 가입자 수
		model.addAttribute("topLoginUsers", userService.getRecentLoginUsers(10)); // 최근 로그인 사용자 정보 (최근 10명)
		model.addAttribute("regionDistribution", userService.getUserRegionDistribution()); // 지역별 사용자 분포 (막대그래프)
		model.addAttribute("roleDistribution", userService.getUserRoleCount()); // 권한별 사용자 수

		return "/admin/user/stats";
	}

	@GetMapping("/auth/userRoleChange")
	public String userRoleChange(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int pageSize, @RequestParam(required = false) String type,
			@RequestParam(required = false) String search_role, @RequestParam(required = false) String keyword,
			RedirectAttributes redirectAttributes, HttpSession session, Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		int offset = (page - 1) * pageSize;

		Map<String, Object> params = new HashMap<>();
		params.put("offset", offset);
		params.put("pageSize", pageSize);
		params.put("type", type);
		params.put("search_role", search_role);
		params.put("keyword", keyword);

		List<UserVO> userList = userService.selectAllUsersForRoleChange(params);

		int totalCount = logService.countRoleChangeLog(params);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		int startPage = Math.max(1, page - 5); // 시작 페이지 (예: 현재 페이지 기준 앞 5페이지)
		int endPage = Math.min(totalPages, page + 4); // 끝 페이지 (현재 페이지 기준 뒤 4페이지)

		boolean prev = startPage > 1;
		boolean next = endPage < totalPages;

		model.addAttribute("userList", userList);
		model.addAttribute("type", type);
		model.addAttribute("search_role", search_role);
		model.addAttribute("keyword", keyword);
		model.addAttribute("offset", offset);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("pageSize", page);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("prev", prev);
		model.addAttribute("next", next);

		return "/admin/auth/userRoleChange";
	}

	@PostMapping(value = "/auth/change-role", produces = "application/json")
	@ResponseBody
	public Map<String, Object> changeRole(@RequestBody Map<String, Object> data, HttpSession session) {
		int unum = Integer.parseInt(data.get("unum").toString());
		String newRole = (String) data.get("newRole");
		String reason = (String) data.get("reason");
		String changeType = (String) data.get("changeType");

		UserVO userInfo = userService.getUserByUnum(unum);
		int adminUnum = (int) session.getAttribute("adminUnum");
		String beforeRole = userInfo.getRole();

		Map<String, Object> result = new HashMap<>();
		try {
			// 권한 변경
			userService.updateUserRole(unum, newRole);
			// 권한 변경 로그 기록
			logService.insertRoleChangeLog(unum, beforeRole, newRole, adminUnum, reason, changeType);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", e.getMessage());
			System.out.println("오류메시지 : " + e.getMessage());
		}
		return result;
	}

	@GetMapping("/auth/adminAccount")
	public String adminAccount(@RequestParam(required = false) String type,
			@RequestParam(required = false) String is_deleted, @RequestParam(required = false) String keyword,
			RedirectAttributes redirectAttributes, HttpSession session, Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		Map<String, Object> params = new HashMap<>();
		params.put("type", type);
		params.put("is_deleted", is_deleted);
		params.put("keyword", keyword);

		List<UserVO> adminList = userService.selectAdminForRoleChange(params);
		model.addAttribute("adminList", adminList);
		model.addAttribute("type", type);
		model.addAttribute("is_deleted", is_deleted);
		model.addAttribute("keyword", keyword);

		return "/admin/auth/adminAccount";
	}

	@GetMapping("/auth/adminCreate")
	public String adminCreate(RedirectAttributes redirectAttributes, HttpSession session, Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		return "/admin/auth/adminCreate";
	}

	@PostMapping("/auth/adminCreate")
	public String adminCreatePost(UserVO user, RedirectAttributes redirectAttributes, HttpSession session,
			Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		// 임시 비밀번호 생성 및 설정
		String plainPassword = generateAlphaNumericPassword(10);
		String encodedPassword = passwordEncoder.encode(plainPassword);
		user.setPassword(encodedPassword);

		try {
			userService.insertNewAdminCreate(user);
			redirectAttributes.addFlashAttribute("passwordMessage", "관리자 계정이 생성되었습니다.");
			redirectAttributes.addFlashAttribute("plainPassword", plainPassword);
		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("message", "계정 생성에 실패했습니다: " + e.getMessage());
			return "redirect:/admin/auth/adminCreate"; // 실패 시 다시 생성 폼
		}
		return "redirect:/admin/auth/adminAccount";
	}

	@PostMapping("/auth/adminDelete")
	public String adminDelete(@RequestParam int unum, RedirectAttributes redirectAttributes, HttpSession session) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		if (unum == 0) {
			redirectAttributes.addFlashAttribute("message", "해당 관리자 계정의 정보가 없습니다.");
			return "redirect:/admin/auth/adminAccount";
		}

		userService.updateAdminNotAtive(unum);
		return "redirect:/admin/auth/adminAccount";
	}

	@PostMapping("/auth/adminActivate")
	public String adminActivate(@RequestParam int unum, RedirectAttributes redirectAttributes, HttpSession session) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		if (unum == 0) {
			redirectAttributes.addFlashAttribute("message", "해당 관리자 계정의 정보가 없습니다.");
			return "redirect:/admin/auth/adminAccount";
		}

		userService.updateAdminActivate(unum);
		return "redirect:/admin/auth/adminAccount";
	}

	@GetMapping("/auth/adminUpdate")
	public String adminUpdate(@RequestParam("unum") int unum, HttpSession session,
			RedirectAttributes redirectAttributes, Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		UserVO adminInfo = userService.getUserByUnum(unum);
		if (adminInfo == null) {
			redirectAttributes.addFlashAttribute("message", "해당 계정을 찾을 수 없습니다.");
			return "redirect:/admin/auth/adminAccount";
		}

		model.addAttribute("adminInfo", adminInfo);
		return "/admin/auth/adminUpdate";
	}

	@PostMapping("/auth/adminUpdate")
	public String adminUpdatePost(UserVO user, @RequestParam("old_password") String oldPassword, HttpSession session,
			RedirectAttributes redirectAttributes, Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		UserVO adminInfo = userService.getUserByUnum(user.getUnum());
		if (adminInfo == null) {
			redirectAttributes.addFlashAttribute("message", "해당 계정을 찾을 수 없습니다.");
			return "redirect:/admin/auth/adminAccount";
		}

		String sessionUserid = (String) session.getAttribute("userid");

		if (!sessionUserid.equals(adminInfo.getUserid())) {
			redirectAttributes.addFlashAttribute("message", "본인 계정만 수정할 수 있습니다.");
			return "redirect:/admin/auth/adminAccount";
		}

		// 비밀번호 변경 여부 확인
		if (user.getPassword() != null && !user.getPassword().isEmpty()) {
			// 기존 비밀번호 확인
			if (!passwordEncoder.matches(oldPassword, adminInfo.getPassword())) {
				redirectAttributes.addFlashAttribute("message", "기존 비밀번호가 일치하지 않습니다.");
				return "redirect:/admin/auth/adminUpdate?unum=" + user.getUnum();
			}
			// 새 비밀번호 암호화
			user.setPassword(passwordEncoder.encode(user.getPassword()));
		} else {
			// 비밀번호 수정 안 하는 경우 기존 비밀번호 유지
			user.setPassword(adminInfo.getPassword());
		}

		userService.updateAdmininfo(user);
		redirectAttributes.addFlashAttribute("message", "정상적으로 수정되었습니다.");

		return "redirect:/admin/auth/adminUpdate?unum=" + user.getUnum();
	}

	@GetMapping("/auth/roleChangeLog")
	public String roleChangeLog(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int pageSize,
			@RequestParam(value = "daterange", required = false) String daterange,
			@RequestParam(value = "change_type", required = false) String change_type,
			@RequestParam(required = false) String type, @RequestParam(required = false) String sort,
			@RequestParam(required = false) String keyword, HttpSession session, RedirectAttributes redirectAttributes,
			Model model) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		int offset = (page - 1) * pageSize;

		String startDate = null;
		String endDate = null;
		String dateRange = null;

		// 날짜 분리
		if (daterange != null && daterange.contains("~")) {
			String[] parts = daterange.split("~");
			startDate = parts[0].trim();
			endDate = parts[1].trim();
			dateRange = startDate + " ~ " + endDate;
		}

		if (dateRange == null) {
			dateRange = ""; // 값 없으면 오늘 날짜로 초기화
		}

		// 전체 검색 조건을 Map에 담기 (null이면 무시)
		Map<String, Object> params = new HashMap<>();
		params.put("offset", offset);
		params.put("pageSize", pageSize);
		params.put("type", type);
		params.put("keyword", keyword);
		params.put("sort", sort);
		params.put("change_type", change_type);
		params.put("startDate", startDate);
		params.put("endDate", endDate);

		List<RoleLogVO> logList = logService.selectRoleChangeLogList(params);

		int totalCount = logService.countRoleChangeLog(params);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		int startPage = Math.max(1, page - 5); // 시작 페이지 (예: 현재 페이지 기준 앞 5페이지)
		int endPage = Math.min(totalPages, page + 4); // 끝 페이지 (현재 페이지 기준 뒤 4페이지)

		boolean prev = startPage > 1;
		boolean next = endPage < totalPages;

		model.addAttribute("logList", logList);
		model.addAttribute("type", type);
		model.addAttribute("sort", sort);
		model.addAttribute("change_type", change_type);
		model.addAttribute("keyword", keyword);
		model.addAttribute("offset", offset);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("pageSize", page);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("prev", prev);
		model.addAttribute("next", next);
		model.addAttribute("dateRange", dateRange);
		return "/admin/auth/roleChangeLog";
	}

	@GetMapping("/limit/limitList")
	public String limitList(HttpSession session, RedirectAttributes redirectAttributes,
			@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int pageSize,
			@RequestParam(required = false) String type, @RequestParam(required = false) String role,
			@RequestParam(required = false) String keyword, Model model) {
		Object userIdObj = session.getAttribute("userid");
		Object roleObj = session.getAttribute("role");

		if (userIdObj == null || roleObj == null || !roleObj.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		int offset = (page - 1) * pageSize;

		// 전체 검색 조건을 Map에 담기 (null이면 무시)
		Map<String, Object> params = new HashMap<>();
		params.put("offset", offset);
		params.put("pageSize", pageSize);
		params.put("type", type);
		params.put("role", role);
		params.put("keyword", keyword);

		List<UserVO> limitList = userService.getSuspendedUsers(params);
		int totalCount = userService.countSuspendedUsers(params);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		int startPage = Math.max(1, page - 5); // 시작 페이지 (예: 현재 페이지 기준 앞 5페이지)
		int endPage = Math.min(totalPages, page + 4); // 끝 페이지 (현재 페이지 기준 뒤 4페이지)

		boolean prev = startPage > 1;
		boolean next = endPage < totalPages;

		model.addAttribute("limitList", limitList);
		model.addAttribute("page", page);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("type", type);
		model.addAttribute("role", role);
		model.addAttribute("keyword", keyword);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("prev", prev);
		model.addAttribute("next", next);

		return "admin/limit/limitList";
	}

	@PostMapping("/limit/roleUpdate")
	public String roleUpdate(@RequestParam("unum") int unum, @RequestParam("role") String role,
			RedirectAttributes redirectAttributes) {
		userService.updateUserRole(unum, role);
		redirectAttributes.addFlashAttribute("message", "제한 상태가 변경되었습니다.");
		return "redirect:/admin/limit/limitList";
	}

	@GetMapping("/emailcheck")
	public String emailCheck(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "10") int pageSize, @RequestParam(required = false) String keyword,
			@RequestParam(required = false) String send_status, Model model) {

		int offset = (page - 1) * pageSize;

		// 1. 총 개수 조회
		int totalCount = emailLogMapper.getTotalCount(keyword, send_status);

		// 2. 목록 조회
		List<EmailLogVO> emailList = emailLogMapper.findWithPagingAndFilter(keyword, send_status, offset, pageSize);

		// 3. 페이지네이션 계산
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);
		int startPage = Math.max(1, page - 5);
		int endPage = Math.min(totalPages, page + 4);
		boolean prev = startPage > 1;
		boolean next = endPage < totalPages;

		// 4. 모델에 담기
		model.addAttribute("emailList", emailList);
		model.addAttribute("page", page);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("prev", prev);
		model.addAttribute("next", next);
		model.addAttribute("param", Map.of("keyword", keyword != null ? keyword : "", "send_status",
				send_status != null ? send_status : ""));

		return "/admin/emailcheck";
	}

	@GetMapping("/data")
	public String admindata(@RequestParam(required = false) String startDate,
			@RequestParam(required = false) String interval, @RequestParam(required = false) String region,
			@RequestParam(required = false) String routeId, @RequestParam(required = false) String model,
			RedirectAttributes redirectAttributes, HttpSession session, Model modelAttr) {
		Object role = session.getAttribute("role");
		if (role == null || !role.equals("ADMIN")) {
			redirectAttributes.addFlashAttribute("message", "권한이 없습니다.");
			return "redirect:/admin/login";
		}

		List<BusVO> routeListGwangju = routeMapper.getRouteListByCityCode(24);
		List<BusVO> routeListBusan = routeMapper.getRouteListByCityCode(21);
		List<BusVO> routeListDaegu = routeMapper.getRouteListByCityCode(22);
		List<BusVO> routeListUlsan = routeMapper.getRouteListByCityCode(26);

		modelAttr.addAttribute("routeListGwangju", routeListGwangju);
		modelAttr.addAttribute("routeListBusan", routeListBusan);
		modelAttr.addAttribute("routeListDaegu", routeListDaegu);
		modelAttr.addAttribute("routeListUlsan", routeListUlsan);
		
		modelAttr.addAttribute("interval", interval);
		modelAttr.addAttribute("region", region);
		modelAttr.addAttribute("routeId", routeId);
		modelAttr.addAttribute("model", model);
		modelAttr.addAttribute("startDate", startDate);

		if (startDate != null && !startDate.isEmpty()) {
			List<PredictionVO> predictionList = predictionService.predict(startDate, interval, region, routeId, model);
			modelAttr.addAttribute("predictionList", predictionList);
		}

		return "/admin/data";
	}

	@GetMapping("/stats")
	public String getRouteStats(@RequestParam(required = false, name="region") Integer cityCode,
	                            @RequestParam(required = false) String routeId,
	                            @RequestParam(defaultValue = "1") int month,
	                            Model model) {
		
		 // ✅ 여기에 로그 찍기
	    System.out.println("🔍 [로그] cityCode: " + cityCode);
	    System.out.println("🔍 [로그] routeId: " + routeId);
	    System.out.println("🔍 [로그] month: " + month);

	    Map<Integer, String> cityCodeToRegion = Map.of(
	        21, "부산",
	        22, "대구",
	        24, "광주",
	        26, "울산"
	    );

	    if (cityCode != null && routeId != null && !routeId.isEmpty()) {
	        String regionName = cityCodeToRegion.get(cityCode);
	        String actualRouteId = boardingService.getRouteIdByBusNumber(routeId);

	        if (actualRouteId != null && regionName != null) {
	            int year = 2025;
	            LocalDate startDate = LocalDate.of(year, month, 1);
	            YearMonth ym = YearMonth.of(year, month);
	            LocalDate endOfMonth = ym.atEndOfMonth();
	            LocalDate today = LocalDate.now();
	            LocalDate endDate = endOfMonth.isBefore(today) ? endOfMonth : today;
	            
	            System.out.println("🔍 [로그] getDailyBoardingStats 호출 전");
	            
	            List<BoardingDTO> routeStats = boardingService.getDailyBoardingStats(
	                actualRouteId,
	                regionName,
	                startDate.toString(),
	                endDate.toString()
	            );
	            
	            System.out.println("🔍 [로그] getDailyBoardingStats 호출 후");

	            model.addAttribute("routeStats", routeStats);
	        } else {
	            model.addAttribute("routeStats", Collections.emptyList());
	        }
	    } else {
	        model.addAttribute("routeStats", Collections.emptyList());
	    }

	    model.addAttribute("routeListGwangju", boardingService.getRouteList("24"));
	    model.addAttribute("routeListBusan", boardingService.getRouteList("21"));
	    model.addAttribute("routeListDaegu", boardingService.getRouteList("22"));
	    model.addAttribute("routeListUlsan", boardingService.getRouteList("26"));

	    model.addAttribute("selectedRegion", cityCode);
	    model.addAttribute("selectedRouteId", routeId);
	    model.addAttribute("selectedMonth", month);

	    return "admin/stats";
	}


}
