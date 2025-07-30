<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
  String activeMenu = (String) request.getAttribute("activeMenu");
%>
<script>
function closePwAlert() {
    const pwAlert = document.getElementById("pw-alert");
    if (pwAlert) {
      pwAlert.remove();
    }
}

// 일반 메시지는 자동 제거
setTimeout(() => {
  const normalAlert = document.querySelector(".alert-info:not(#pw-alert)");
  normalAlert?.remove();
}, 5000);

// 복사 기능
function copyText() {
	const text = document.getElementById("pw-text").innerText;
	navigator.clipboard.writeText(text).then(() => {
    	alert("복사되었습니다!");
    	
    	// 복사 후 안내창 숨기기
		/* const alertBox = document.getElementById("pw-alert");
		if (alertBox) {
			//alertBox.style.display = "none";  // 바로 숨김
			alertBox.style.transition = "opacity 0.5s";
			alertBox.style.opacity = 0;
			setTimeout(() => alertBox.style.display = "none", 5000);
		} */
	});
}

document.addEventListener("DOMContentLoaded", function () {
    const countdownEl = document.getElementById("countdown");
    if (!countdownEl) return;

    let remainingTime = 30 * 60;

    function updateTimer() {
        const minutes = String(Math.floor(remainingTime / 60)).padStart(2, '0');
        const seconds = String(remainingTime % 60).padStart(2, '0');
        countdownEl.textContent = minutes + ":" + seconds;
        remainingTime--;

        if (remainingTime < 0) {
            alert("30분 동안 활동이 없어 자동 로그아웃됩니다.");
            window.location.href = "/admin/logout";
        }
    }

    updateTimer();
    setInterval(updateTimer, 1000);

    function resetTimer() {
        remainingTime = 30 * 60;
    }

    ['click', 'mousemove', 'keydown', 'scroll'].forEach(evt => {
        document.addEventListener(evt, resetTimer);
    });
});
</script>
<nav class="sidebar bg-dark text-white p-3">
  <h4 class="text-white mb-4" style="text-align: right;"><a href="${pageContext.request.contextPath}/admin/dashboard"><img src="${pageContext.request.contextPath}/resources/image/admin_icon01.png" style="width:70px; height:70px;" alt="logo"/></a></h4>

  <!-- [관리] -->
  <div class="mb-2 fw-bold text-uppercase text-secondary small">관리</div>
  <ul class="nav flex-column mb-3">
    <li class="nav-item">
      <a class="nav-link <%= "user".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/user/list">사용자 관리</a>
    </li>
    <li class="nav-item">
      <a class="nav-link <%= "auth".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/auth/userRoleChange">권한 관리</a>
    	<ul class="nav flex-column ms-3">
		    <li class="nav-item">
		      <a class="nav-link <%= "auth_user".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/auth/userRoleChange">사용자 권한 변경</a>
		    </li>
		    <li class="nav-item">
		      <a class="nav-link <%= "auth_admin".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/auth/adminAccount">관리자 계정 관리</a>
		    </li>
		    <li class="nav-item">
		      <a class="nav-link <%= "auth_log".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/auth/roleChangeLog">권한 변경 로그</a>
		    </li>
		</ul>
    </li>
    <%-- <li class="nav-item">
      <a class="nav-link <%= "limit".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/limit/limitList">제한 관리</a>
    </li> --%>
  </ul> 

  <!-- [버스 시스템] -->
  <div class="mb-2 fw-bold text-uppercase text-secondary small">버스 시스템</div>
  <ul class="nav flex-column mb-3">
    <li class="nav-item">
      <a class="nav-link <%= "bus".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/data">데이터 관리</a>
    </li>
    <li class="nav-item">
      <a class="nav-link <%= "stat".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/stats">통계</a>
    </li>
  </ul>

  <!-- [신고/접수] -->
  <div class="mb-2 fw-bold text-uppercase text-secondary small">신고 / 접수</div>
  <ul class="nav flex-column mb-3">
    <li class="nav-item">
      <a class="nav-link <%= "report".equals(activeMenu) ? "active" : "" %> text-white" href="/report/manage/regraph">신고/불편접수 통계</a>
    </li>
    <li class="nav-item">
      <a class="nav-link <%= "reportList".equals(activeMenu) ? "active" : "" %> text-white" href="/report/admin/list">접수 목록</a>
    </li>
  </ul>

  <!-- [컨텐츠] -->
  <div class="mb-2 fw-bold text-uppercase text-secondary small">공지 사항</div>
  <ul class="nav flex-column mb-3">
<%--     <li class="nav-item">
      <a class="nav-link <%= "board".equals(activeMenu) ? "active" : "" %> text-white" href="/test/stat">게시판 관리</a>
    </li>  --%>
    <li class="nav-item">
      <a class="nav-link <%= "notice".equals(activeMenu) ? "active" : "" %> text-white" href="/board/admin/list">공지 설정</a>
    </li>
  </ul>

  <!-- [기타] -->
  <div class="mb-2 fw-bold text-uppercase text-secondary small">기타</div>
  <ul class="nav flex-column">
    <li class="nav-item">
      <a class="nav-link <%= "mail".equals(activeMenu) ? "active" : "" %> text-white" href="/admin/emailcheck">이메일 전송확인</a>
    </li>
    <li class="nav-item">
      <a class="nav-link <%= "logout".equals(activeMenu) ? "active" : "" %> text-white" href="${pageContext.request.contextPath}/admin/logout">로그아웃</a>
    </li>
  </ul>
  
</nav>