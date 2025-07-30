<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    request.setAttribute("activeMenu", "user");

	String adminName = (String) session.getAttribute("adminName");
	String adminRole = (String) session.getAttribute("role");

	if (adminName == null || adminRole == null || !adminRole.equals("ADMIN")) {
%>
	<script>
		alert("권한이 없습니다.");
		location.href = "${pageContext.request.contextPath}/admin/login";
	</script>
<%
		return;
	}
%>
<c:if test="${not empty message}">
  <div class="alert alert-info" role="alert">
    ${message}
  </div>
</c:if>
<c:if test="${not empty passwordMessage}">
  <div id="pw-alert" class="alert alert-info" role="alert">
    ${passwordMessage}<br>
    초기화된 비밀번호: <span id="pw-text">${plainPassword}</span>
    <button onclick="copyText()" class="btn btn-sm btn-success">복사</button>
    <button onclick="closePwAlert()" class="btn btn-sm btn-dark">닫기</button>
  </div>
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자 상세</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>
h3 {
    width: 90%;
    margin: 0 auto 20px;
    margin-bottom: 10px;
}
.detail-container {
  width:90%;
  /* max-width: 700px; */
  margin: 40px auto;
  padding: 30px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.detail-title {
  margin-bottom: 30px;
  font-size: 24px;
  font-weight: bold;
  color: #3b507a;
}
.detail-row {
  margin-bottom: 15px;
}
.detail-label {
  font-weight: bold;
  color: #555;
}
.btn-back {
  margin-top: 30px;
}
#updateUserInfo {
	width : 90%;
	margin: 0 auto;
}
.form-control {
	margin-top:5px;
	padding : 10px 15px;
}
.form-select {
	margin-top:5px;
	padding : 10px 15px;
	width : 25%;
}


.role-label {
  padding: 4px 10px;
  border-radius: 12px;
  font-weight: bold;
  font-size: 15px;
  display: inline-block;
  transition: background-color 0.3s, color 0.3s;
  cursor: default;
}

/* 사용자 */
.user-role {
  background-color: #e3f2fd;
  color: #0d47a1;
}
.user-role:hover {
  background-color: #bbdefb;
  color: #0b3c91;
}

/* 제한된 사용자 */
.suspended-role {
  background-color: #fce4ec;
  color: #c62828;
}
.suspended-role:hover {
  background-color: #f8bbd0;
  color: #b71c1c;
}

.withdrawn-role {
  background-color: #eeeeee;
  color: #9e9e9e;
}

.withdrawn-role:hover {
  background-color: #dddddd;
  color: #7e7e7e;
}

/* 관리자 */
.admin-role {
  background-color: #e8f5e9;
  color: #2e7d32;
}
.admin-role:hover {
  background-color: #c8e6c9;
  color: #1b5e20;
}

/* 알 수 없음 */
.unknown-role {
  background-color: #f5f5f5;
  color: #777;
}
.unknown-role:hover {
  background-color: #e0e0e0;
  color: #555;
}
#emailduplicateCheck{
	margin-top:10px;
}
.alert, .alert-info {
	position:fixed;
	margin:0;
	top:0;
	left:0;
	right:0;
	z-index:9999;
	border-radius: 0px;
}

.report-badge-group {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.report-badge-item {
  padding: 10px 15px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  min-width: 120px;
  justify-content: space-between;
  box-shadow: 0 2px 6px rgba(0,0,0,0.08);
}

.report-count {
  font-size: 18px;
  font-weight: 700;
  margin-left: 5px;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/include/nav.jsp" %>
<div class="d-flex">
  	<main class="flex-grow-1 p-4">
  		<!-- 30분 카운트다운 -->
  		<div id="session-timer">
		    <div class="session-box">
		        <strong>자동 로그아웃까지 남은 시간 : <span id="countdown">30:00</span></strong>
		    </div>
		</div>
		<!-- 상세보기 시작 -->
		<h3>사용자 상세정보</h3>
		<div class="detail-container">
			<div class="detail-row">
				<c:choose>
			    	<c:when test="${user.is_deleted}">
			      		<span class="role-label withdrawn-role">탈퇴회원</span>
			    	</c:when>
			    	<c:when test="${user.role == 'USER'}">
			      		<span class="role-label user-role">사용자</span>
			    	</c:when>
			    	<c:when test="${user.role == 'SUSPENDED'}">
			      		<span class="role-label suspended-role">제한된 사용자</span>
			    	</c:when>
			    	<c:when test="${user.role == 'ADMIN'}">
			      		<span class="role-label admin-role">관리자</span>
			    	</c:when>
			    	<c:otherwise>
			      		<span class="role-label unknown-role">알 수 없음</span>
			    	</c:otherwise>
			  	</c:choose>
			</div>
		    <div class="detail-row"><span class="detail-label">이름 : </span> ${user.username}</div>
		    <div class="detail-row"><span class="detail-label">아이디 : </span> ${user.userid}</div>
		    <div class="detail-row"><span class="detail-label">가입일 : </span> <fmt:formatDate value="${user.create_at}" pattern="yyyy-MM-dd HH:mm"/></div>
		    <div class="detail-row"><span class="detail-label">최근 로그인 : </span> 
		    	<c:if test="${user.last_login_at == null || user.last_login_at == ''}">
		    		최근 로그인 기록이 없습니다.
		    	</c:if>
		    	<c:if test="${user.last_login_at != null && user.last_login_at != ''}">
			    	<fmt:formatDate value="${user.last_login_at}" pattern="yyyy-MM-dd HH:mm"/>
		    	</c:if>
		    </div>
		    <hr />
		    <div class="detail-row">
				<span class="detail-label">불편·신고 접수 이력</span>
			  	<div class="report-badge-group mt-2">
			    	<div class="report-badge-item bg-secondary text-white">
			      		접수 <span class="report-count">${reportStatusCount["접수"] != null ? reportStatusCount["접수"] : 0}</span>건
			    	</div>
			    	<div class="report-badge-item bg-primary text-white">
			      		처리중 <span class="report-count">${reportStatusCount["처리중"] != null ? reportStatusCount["처리중"] : 0}</span>건
			    	</div>
		    		<div class="report-badge-item bg-dark text-white">
			      		완료 <span class="report-count">${reportStatusCount["완료"] != null ? reportStatusCount["완료"] : 0}</span>건
			    	</div>
			  	</div>
			</div>
  		</div>
		<!-- 수정 가능한 항목 -->
		<div id="updateUserInfo">
		  	<form action="/admin/user/update" method="post" onsubmit="return updateCheck(this.form);">
		    	<input type="hidden" name="unum" id="unum" value="${user.unum}" />
			    <div class="detail-row">
			      <label class="detail-label">이메일</label>
			      <input type="email" name="email" id="email" value="${user.email}" class="form-control" required />
	              <label id="emailmsg" class="msg" style="font-size:13px; display:block;"></label>
			      <input type="button" class="btn btn-success" value="이메일 중복검사" id="emailduplicateCheck">
			    </div>
			
			    <div class="detail-row">
			      <label class="detail-label">전화번호</label>
			      <input type="text" name="phone" id="phone" value="${user.phone}" class="form-control" />
			    </div>
			
			    <div class="detail-row">
			      <label class="detail-label">주소</label>
			      <input type="text" name="address" id="address" value="${user.address}" onclick="execDaumPostcode()" readonly class="form-control" />
			    </div>
			    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
				    function execDaumPostcode() {
				        new daum.Postcode({
				            oncomplete: function(data) {
				                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
				
				                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
				                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				                var addr = ''; // 주소 변수
				                var extraAddr = ''; // 참고항목 변수
				
				                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				                    addr = data.roadAddress;
				                } else { // 사용자가 지번 주소를 선택했을 경우(J)
				                    addr = data.jibunAddress;
				                }
				
				                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				                if(data.userSelectedType === 'R'){
				                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
				                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
				                        extraAddr += data.bname;
				                    }
				                    // 건물명이 있고, 공동주택일 경우 추가한다.
				                    if(data.buildingName !== '' && data.apartment === 'Y'){
				                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				                    }
				                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				                    if(extraAddr !== ''){
				                        extraAddr = ' (' + extraAddr + ')';
				                    }
				                }
				
				                // 우편번호와 주소 정보를 해당 필드에 넣는다.
				                document.getElementById("address").value = addr;
				            }
				        }).open();
				    }
				</script>
			
			    <div class="detail-row">
			      <label class="detail-label">탈퇴 여부</label>
			      <select name="is_deleted" class="form-select">
			        <option value="0" ${!user.is_deleted ? 'selected' : ''}>정상회원</option>
			        <option value="1" ${user.is_deleted ? 'selected' : ''}>탈퇴회원</option>
			      </select>
			    </div>
			
			    <div class="detail-row text-end gap-5" style="margin-top: 20px;">
			    	<button type="submit" class="btn btn-primary me-1">수정</button>
			    	<a href="/admin/user/list" class="btn btn-secondary me-1">목록</a>
					<button type="button" class="btn btn-danger" onclick="submitResetForm()">비밀번호 초기화</button>
			    </div>
		  	</form>
		  	<form id="resetForm" action="/admin/user/reset-password" method="post" style="display: none;">
			    <input type="hidden" name="unum" value="${user.unum}" />
			</form>
	  	</div>
	</main>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<script>
let isEmailIdAvailable = false;

function submitResetForm() {
    if (confirm("비밀번호를 초기화하시겠습니까?")) {
        document.getElementById("resetForm").submit();
    }
}

function updateCheck(form) {
	const email = form.email.value.trim();
	const phone = form.phone.value.trim();
	const address = form.address.value.trim();
  
	let emailReg = /^[A-Za-z0-9_.\-]+@[A-Za-z0-9\-]+\.[A-Za-z]{2,}$/
	if (!email) {
  		alert("이메일을 입력하세요.");
  		form.email.focus();
  		return false;
	}
	if (!emailReg.test(email)) {
	  alert("정확한 이메일을 입력하세요.");
	  form.email.focus();
	  return false;
	}
	
	if (!isEmailIdAvailable) {
        alert("이메일 중복 확인을 해주세요.");
        return false;
    }

	if (!phone || !/^\d{10,11}$/.test(phone)) {
	  alert("전화번호는 숫자 10~11자리로 입력하세요.");
	  form.phone.focus();
	  return false;
	}
	
	if (!address) {
  		alert("주소를 입력하세요.");
  		form.email.focus();
  		return false;
	}
	
	return true;
}

$(document).ready(function() {
    let originalEmail = $("#email").val();
    
	// 이메일 중복 체크
	$("#email").on("input", function() {
		isEmailIdAvailable = false;
		$("#emailmsg")
        .text("이메일 중복 확인이 필요합니다.")
        .css({
            "color": "red"
        });
	});
	
	$("#emailduplicateCheck").on("click", function (e) {
        let currentEmail = $("#email").val();
        let unum = $("#unum").val();

        if (currentEmail === "") {
            $("#emailmsg").text("이메일을 입력해주세요.").css("color", "red");
            return;
        }

        if (!currentEmail.includes("@")) {
            $("#emailmsg").text("유효한 이메일 형식이 아닙니다.").css("color", "red");
            return;
        }

        if (currentEmail === originalEmail) {
            $("#emailmsg").text("현재 이메일과 동일합니다.").css("color", "gray");
            isEmailIdAvailable = true;
            return;
        }

        // AJAX 중복 체크
        $.ajax({
            url: "/admin/user/check-email",
            type: "GET",
            data: {
                email: currentEmail,
                unum: unum
            },
            dataType: "json",
            success: function (result) {
                if (result === 0) {
                    isEmailIdAvailable = true;
                    $("#emailmsg").text("사용 가능한 이메일입니다.").css("color", "blue");
                } else {
                    isEmailIdAvailable = false;
                    $("#emailmsg").text("이미 사용 중인 이메일입니다.").css("color", "red");
                }
            },
            error: function () {
                alert("중복 체크 중 오류가 발생했습니다.");
            }
        });
    });
	
	$('#phone').on('input', function() {
	    let number = $(this).val().replace(/[^0-9]/g, '');
	    let formatted = '';

	    if (number.length < 4) {
	        formatted = number;
	    } else if (number.length < 7) {
	        formatted = number.substr(0, 3) + '-' + number.substr(3);
	    } else if (number.length < 11) {
	        formatted = number.substr(0, 3) + '-' + number.substr(3, 3) + '-' + number.substr(6);
	    } else {
	        formatted = number.substr(0, 3) + '-' + number.substr(3, 4) + '-' + number.substr(7, 4);
	    }

	    $(this).val(formatted);
	});
})
</script>
