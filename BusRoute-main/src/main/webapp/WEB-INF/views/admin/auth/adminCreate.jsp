<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    request.setAttribute("activeMenu", "auth_admin");

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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 계정 생성</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>
#createAdminInfo {
	width : 90%;
	margin: 0 auto;
	margin-top:30px;
}
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
.form-control {
	margin-top:5px;
	padding : 10px 15px;
}
.form-select {
	margin-top:5px;
	padding : 10px 15px;
	width : 25%;
}

#emailduplicateCheck, #idduplicateCheck {
	margin-top:6px;
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
		
		<h3>관리자 계정 생성</h3>
		
		<div id="createAdminInfo">
		  	<form action="/admin/auth/adminCreate" method="post" onsubmit="updateHiddenUserid(); return updateCheck(this.form);">
		  	 	<input type="hidden" name="password" id="password" value="" />
	    	    <label class="detail-label">아이디</label>
		    	<div style="display: flex; align-items: center;">
				  <span style="margin-top: 5px; padding: 10px 15px; background-color: #eee; border: 1px solid #ccc; border-right: none; border-radius: 10px 0 0 10px; color: #777; font-weight: bold;">
				    admin_
				  </span>
				  <input type="text" id="useridSuffix" class="form-control" placeholder="아이디 입력 (예: kim)" 
				         style="border-radius: 0 10px 10px 0; border-left: none;" oninput="updateHiddenUserid()">
				</div>
				<label id="idmsg" class="msg" style="font-size:13px; display:block;"></label>
			    <input type="button" style="margin-bottom: 15px;" class="btn btn-primary" value="아이디 중복검사" id="idduplicateCheck">
				<input type="hidden" name="userid" id="userid">
			    <div class="detail-row">
			      <label class="detail-label">이름</label>
			      <input type="text" name="username" class="form-control" />
			    </div>
			    <div class="detail-row">
			      <label class="detail-label">이메일</label>
			      <input type="email" name="email" id="email" class="form-control" required />
	              <label id="emailmsg" class="msg" style="font-size:13px; display:block;"></label>
			      <input type="button" class="btn btn-primary" value="이메일 중복검사" id="emailduplicateCheck">
			    </div>
			    <div class="detail-row">
			      <label class="detail-label">전화번호</label>
			      <input type="text" name="phone" id="phone" maxlength="13" class="form-control" />
			    </div>
			    <div class="detail-row">
			      <label class="detail-label">주소</label>
			      <input type="text" name="address" id="address" onclick="execDaumPostcode()" readonly class="form-control" />
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
			    <div class="detail-row text-end gap-5" style="margin-top: 20px;">
			    	<button type="submit" class="btn btn-danger me-1">계정 생성</button>
			    </div>
		  	</form>
	  	</div>
	</main>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<script>
let isEmailIdAvailable = false;
let isUserIdAvailable = false;

function updateHiddenUserid() {
  	const suffix = document.getElementById('useridSuffix').value.trim();
  	document.getElementById('userid').value = 'admin_' + suffix;
}
	
function updateCheck(form) {
	const userid = form.userid.value.trim();
	const email = form.email.value.trim();
	const phone = form.phone.value.trim();
	const address = form.address.value.trim();
  
	if (!userid) {
  		alert("아이디를 입력하세요.");
  		form.userid.focus();
  		return false;
	}
	
	if (!isUserIdAvailable) {
        alert("아이디 중복 확인을 해주세요.");
        return false;
    }
	
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
	// 이메일 중복 체크
	$("#email").on("input", function() {
		isEmailIdAvailable = false;
		$("#emailmsg")
        .text("이메일 중복 확인이 필요합니다.")
        .css({
            "color": "red"
        });
	});
	
	// 아이디 중복 체크
	$("#useridSuffix").on("input", function() {
		isEmailIdAvailable = false;
		$("#idmsg")
        .text("아이디 중복 확인이 필요합니다.")
        .css({
            "color": "red"
        });
	});
	
	$('#idduplicateCheck').click(function () {
	    const suffix = $('#useridSuffix').val().trim();
	    if (!suffix) {
	        alert("아이디를 입력해주세요.");
	        return;
	    }
	
	    const fullId = 'admin_' + suffix;
		
	    $.ajax({
	        url: '/idCheck',
	        type: 'GET',
	        dataType : 'json',
	        data: { userid: fullId },
	        success: function (result) {
	        	if (result === 0) {
	                $('#idmsg').text("사용 가능한 아이디입니다.").css("color", "green");
	                isUserIdAvailable = true;
	            } else {
	                $('#idmsg').text("이미 사용 중인 아이디입니다.").css("color", "red");
	                isUserIdAvailable = false;
	            }
	        },
	        error: function () {
	            alert("서버 오류가 발생했습니다.");
	        }
	    });
	});
	
	$('#emailduplicateCheck').click(function () {
	    const email = $('#email').val().trim();
	
	    $.ajax({
	        url: '/emailCheck',
	        type: 'GET',
	        dataType : 'json',
	        data: { email: email },
	        success: function (result) {
	        	if (result === 0) {
	                $('#emailmsg').text("사용 가능한 이메일입니다.").css("color", "green");
	                isEmailIdAvailable = true;
	            } else {
	                $('#emailmsg').text("이미 사용 중인 이메일입니다.").css("color", "red");
	                isEmailIdAvailable = false;
	            }
	        },
	        error: function () {
	            alert("서버 오류가 발생했습니다.");
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