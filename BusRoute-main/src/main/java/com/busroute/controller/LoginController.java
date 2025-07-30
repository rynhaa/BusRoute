package com.busroute.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.busroute.domain.SocialVO;
import com.busroute.domain.FavoriteRouteVO;
import com.busroute.domain.ReportVO;
import com.busroute.domain.UserVO;
import com.busroute.service.FavoriteRouteService;
import com.busroute.service.ReportService;
import com.busroute.service.UserService;

@Controller
public class LoginController {
	
	@Autowired
	private UserService Uservice;
	
	@Autowired
	private ReportService Rservice;
	
	@Autowired
    private FavoriteRouteService favoriteRouteService;
	
	// 대시보드 페이지
	@GetMapping("/dashboard")
	public String dashboard() {
		return "dashboard";
	}
	
	// 마이페이지
	@GetMapping("/mypage")
	public String myPageForm(HttpSession session,
							 Model model,
							 RedirectAttributes redirectAttributes) {
		
		
		String username = (String) session.getAttribute("username");
		String userid = (String) session.getAttribute("userid");	
		
		//로그인 정보
		UserVO user = Uservice.findById(userid);
		
		
		if(user == null) {
		    redirectAttributes.addFlashAttribute("message", "존재하지 않는 사용자입니다.");
		    return "redirect:/login";
		}
	
		
		if (userid == null) {
			redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
			return "redirect:/login";
		}
		
		// 객체로 받기
		Integer unumObj = (Integer) session.getAttribute("unum");
		// null 발생하면 오류 발생하기 때문에 0으로
		int unum = (unumObj != null) ? unumObj : 0;
		
		// 접수내역  
		List<ReportVO> reports = Rservice.findReportByUser(userid);
		
		// 즐찾 노선
		List<FavoriteRouteVO> busList = favoriteRouteService.selectFavoriteBusList(unum);
		// 즐찾 정류장
		List<FavoriteRouteVO> stationList = favoriteRouteService.selectFavoriteStationList(unum);
		
		// 접수 내역
		model.addAttribute("reports", reports);
		// 유저이름
		model.addAttribute("username",username);
		// 유저 아이디
		model.addAttribute("userid",userid);
		// 유저 고유번호
		model.addAttribute("unum",unum);
		// 자동 생성이기 때문에
		model.addAttribute("last_login_at",user.getLast_login_at());
		// 즐찾 노선, 정류장
		model.addAttribute("busList", busList);
		model.addAttribute("stationList", stationList);
		
		return "mypage";
	}
	

	
	// 로그인 페이지
	@GetMapping("/login")
	public String loginForm() {
		return "/Login";
	}
	
	@PostMapping("/login")
    public String login(@RequestParam String userid,
                        @RequestParam String password,
                        HttpSession session,
                        RedirectAttributes redirectAttributes
                        ) {
    	
    	UserVO user = Uservice.findById(userid);
    	// 비밀번호 암호화
    	BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    	
    	// 암호화 일치 검사
    	if(user != null && encoder.matches(password, user.getPassword())) {
    		// 사용자 id
    		session.setAttribute("userid", user.getUserid());
    		// 사용자 고유번호
    		session.setAttribute("unum", user.getUnum());
    		// 사용자 이름
    		session.setAttribute("username", user.getUsername());
    		// 사용자 권한 등록
    		session.setAttribute("role", user.getRole());
    		// 마지막 로그인 시간
    		Uservice.updateLastLogin(userid);
    		redirectAttributes.addFlashAttribute("userid", user.getUserid());
    		// 로그인 알림
    		redirectAttributes.addFlashAttribute("message", "로그인되었습니다.");
    		return "redirect:/dashboard";
    	}else {
    		// 로그인 실패 알림
    		redirectAttributes.addFlashAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
    		return "redirect:/login";
    	}
    }
    
    // 회원가입 페이지
    @GetMapping("/join")
    public String joinForm() {
    	return "/Join";
    }
    
    @PostMapping("/join")
    public String join(UserVO vo, HttpSession session, RedirectAttributes redirectAttributes) {
    	
    	BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    	vo.setPassword(encoder.encode(vo.getPassword()));
    	Uservice.join(vo);
    	redirectAttributes.addFlashAttribute("message", "회원가입이 완료되었습니다.");
    	return "redirect:/login";
    }
    
    // 아이디 중복체크
    @GetMapping("/idCheck")
    @ResponseBody
    public int idCheck(@RequestParam("userid") String userid) {
    	return Uservice.idCheck(userid);
    }
    
    // 이메일 중복체크
    @GetMapping("/emailCheck")
    @ResponseBody
    public int emailCheck(@RequestParam("email") String email) {
    	return Uservice.eamilCheck(email);
    }
    
    
    // 로그아웃
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
    	session.invalidate();
    	redirectAttributes.addFlashAttribute("message","로그아웃되었습니다.");
    	return "redirect:/dashboard";
    }
    
    // 개인정보 수정 비밀번호 확인 페이지
    @GetMapping("/pwcheck")
    public String pwCheckForm() {
    	
    	return "pwcheck";
    }
    
    
    // 개인정보 수정 비밀번호 확인
    @PostMapping("/pwcheck")
    public String pwCheck(@RequestParam String password,
    					  HttpSession session, 
    					  RedirectAttributes redirectAttributes) {
    	
    	// 비밀번호 암호화
    	BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    	    	
    	String userid = (String) session.getAttribute("userid");
    	UserVO user = Uservice.findById(userid);
    	
    	// 암호화 일치 검사
    	if (password == null || password.trim().isEmpty()) {
    		redirectAttributes.addFlashAttribute("message", "비밀번호를 입력해주세요.");
    		return "redirect:/pwcheck";
    		
    	}
    	
    	if(user != null && encoder.matches(password, user.getPassword())) {
    		return "redirect:/edit";
    		
    	}else {
    		redirectAttributes.addFlashAttribute("message", "비밀번호가 일치하지 않습니다.");
    		return "redirect:/pwcheck";
    	}
    	

    }
    
    
    // 개인정보 수정 페이지
    @GetMapping("/edit")
    public String editForm(HttpSession session,
    					   Model model) {
    	
    	String userid = (String) session.getAttribute("userid");
    	UserVO user = Uservice.findById(userid);
    	
    	model.addAttribute("user",user);
    	
    	return "edit";
    }
    
    // 개인정보 수정
    @PostMapping("/edit")
    	public String edit(UserVO vo, HttpSession session, RedirectAttributes redirectAttributes) {
    		
	    	String userid = (String) session.getAttribute("userid");
	    	vo.setUserid(userid);
	    	
	    	// 비밀번호 입력 여부 확인
	        if (vo.getPassword() == null || vo.getPassword().trim().isEmpty()) {
	            // 비밀번호 입력 없으면 기존 비밀번호 유지
	            UserVO existingUser = Uservice.findById(userid);
	            vo.setPassword(existingUser.getPassword());
	        } else {
	            // 입력하면 암호화 처리
	            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
	            vo.setPassword(encoder.encode(vo.getPassword()));
	        }
        	
        	
        	Uservice.edit(vo);
        	
        	redirectAttributes.addFlashAttribute("message", "개인정보 수정이 완료되었습니다. 다시 로그인 해주세요.");
        	session.invalidate();
        	return "redirect:/login";
    		
    	}
    
    
    // 나의 접수내역
 	@GetMapping("/myreport")
 	public String myreportForm(HttpSession session,
 							 Model model) {
 		
 		String username = (String) session.getAttribute("username");
 		String userid = (String) session.getAttribute("userid");
 		// 객체로 받기
 		Integer unumObj = (Integer) session.getAttribute("unum");
 		// null 발생하면 오류 발생하기 때문에 0으로
 		int unum = (unumObj != null) ? unumObj : 0;
 		
 		// 로그인 정보
 		UserVO user = Uservice.findById(userid);
 		// 접수내역  
 		List<ReportVO> reports = Rservice.findReportByUser(userid);
 		
 		// 접수 내역
 		model.addAttribute("reports", reports);
 		// 유저이름
 		model.addAttribute("username",username);
 		// 유저 아이디
 		model.addAttribute("userid",userid);
 		// 유저 고유번호
 		model.addAttribute("unum",unum);
 		
 		return "myreport";
 	}
 	
 	// 카카오톡 로그인
 	@PostMapping("/sociallogin")
 	@ResponseBody
 	public ResponseEntity<String> socialLogin(@RequestBody SocialVO socialUser, HttpSession session){
 		String userid = socialUser.getId();
 		String username = socialUser.getNickname();
 		String email = socialUser.getEmail();
 		String phone = socialUser.getPhone();
 		
 		UserVO user = Uservice.findById(userid);
 		
 		// 없으면 회원가입 처리
 		if (user == null) {
 	        // 아직 회원가입 안 되어있으면 DB 저장하지 않고 세션에 저장
 	        session.setAttribute("temp_userid", userid);
 	        session.setAttribute("username", username);
 	        session.setAttribute("email", email);
 	        session.setAttribute("phone", phone);
 	        return ResponseEntity.ok("needAdditionalInfo");  // 가입폼으로 이동
 	    }

 	    // 이미 가입된 경우는 바로 로그인
 	    session.setAttribute("userid", user.getUserid());
 	    session.setAttribute("username", user.getUsername());
 	    session.setAttribute("email", user.getEmail());
 	    session.setAttribute("phone", user.getPhone());
 	    
 	    // 마지막 로그인 시간
 	    Uservice.updateLastLogin(user.getUserid());
 	   
 	    return ResponseEntity.ok("success");
 	    
 		
 	}
 	
 	// 소셜 가입
 	@GetMapping("/socialjoin")
 	public String SocialJoinForm(HttpSession session, Model model) {
 		
 		
 		model.addAttribute("userid", session.getAttribute("userid"));
 		model.addAttribute("username", session.getAttribute("username"));
 		model.addAttribute("email", session.getAttribute("email"));
 		model.addAttribute("phone",session.getAttribute("phone"));
 		return "socialjoin";
 	}
 	
 	
 	@PostMapping("/socialjoin")
 	public String SocialJoin(UserVO vo, HttpSession session, RedirectAttributes redirectAttributes) {
 		
 		
 		
 		if(vo.getPhone() == null || vo.getPhone().trim().isEmpty()) {
 	        vo.setPhone((String) session.getAttribute("phone"));
 	    }
 		
 		vo.setUserid((String) session.getAttribute("temp_userid"));
 		vo.setUsername((String) session.getAttribute("username"));
 		vo.setEmail((String) session.getAttribute("email"));
 		
 	    
 	    // 전화번호, 주소는 form에서 받아온 값 (user에 들어있음)
 		
 		
 		// 비밀번호 암호화 처리
 		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
    	vo.setPassword(encoder.encode(vo.getPassword()));
 	    
 		// insert
 	    Uservice.save(vo);

 	    
 	   session.invalidate();
 	    
 	    redirectAttributes.addFlashAttribute("joinMessage", "회원가입이 완료되었습니다.");
 	   
 	    return "redirect:/login";
 	}
 	
 	@GetMapping("/navercallback")
 	public String NaverCallBackForm() {
 		return "navercallback";
 	}
 	
 	
 	// 네이버 로그인
 	@PostMapping(value = "/sociallogin/naver", produces = "application/json")
 	@ResponseBody
    public ResponseEntity<Map<String, String>> naverLogin(@RequestBody Map<String, String> body, HttpSession session) {
        String accessToken = body.get("accessToken");

        if (accessToken == null || accessToken.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("status", "fail", "message", "토큰이 없습니다."));
        }

        try {
            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Accept", "application/json");
            HttpEntity<String> entity = new HttpEntity<>(headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                    "https://openapi.naver.com/v1/nid/me",
                    HttpMethod.GET,
                    entity,
                    Map.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                Map responseBody = response.getBody();
                if ("00".equals(responseBody.get("resultcode"))) {
                    Map profile = (Map) responseBody.get("response");
                    String userid = "naver_" + profile.get("id");
                    String name = (String) profile.get("name");
                    String email = (String) profile.get("email");
                    String phone = (String) profile.get("mobile");

                    UserVO user = Uservice.findById(userid);

                    if (user == null) {
                        // 가입 안 된 사용자 세션에 임시 저장
                        session.setAttribute("temp_userid", userid);
                        session.setAttribute("username", name);
                        session.setAttribute("email", email);
                        session.setAttribute("phone", phone);

                        return ResponseEntity.ok(Map.of("status", "needAdditionalInfo"));
                    }

                    // 기존 가입자 로그인 처리
                    session.setAttribute("userid", user.getUserid());
                    session.setAttribute("username", user.getUsername());
                    session.setAttribute("email", user.getEmail());
                    session.setAttribute("phone", user.getPhone());

                    Uservice.updateLastLogin(user.getUserid());

                    return ResponseEntity.ok(Map.of("status", "success"));
                } else {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                            .body(Map.of("status", "fail", "message", "프로필 조회 실패"));
                }
            } else {
                return ResponseEntity.status(response.getStatusCode())
                        .body(Map.of("status", "fail", "message", "네이버 API 호출 실패"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("status", "fail", "message", "서버 에러"));
        }
    }
    
    
}
