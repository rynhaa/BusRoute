<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
  
  #join-form {
    width: 650px;
    margin: 0 auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 20px 30px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  td {
    padding: 12px 10px;
    font-size: 18px;
    vertical-align: middle;
  }

  input[type="text"], input[type="password"], input[type="email"] {
    padding: 10px 15px;
    width: 70%;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-sizing: border-box;
  }

  input[type="submit"]{
    padding: 12px 18px;
    width: 100px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
  }


  input[type="submit"]:hover {
    background-color: rgb(127, 152, 202);
  }
  
  #duplicateCheck{
  	padding: 12px 18px;
    width: 100px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
    margin-left: 30px;
  }
  
  #duplicateCheck:hover{
  	background-color: rgb(127, 152, 202);
  }

  #edit{
    float:right;
  }

</style>
</head>
<body>
<c:if test="${not empty message}">
    <script>
        alert('${message}');
    </script>
</c:if>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<div id="wrapper">
	<h3>개인정보 수정</h3>
	<div id="join-form">
			<form action="/edit" method="post" onsubmit="return Edit()">
		        <table>		        	
		            <tr>
		                <td>새 비밀번호 입력</td>
		                <td><input type="password" name="password" id="password" placeholder="새 비밀번호를 입력해주세요."><br>
		                <label id="pwmsg" class="msg" style="font-size:13px; color:red">비밀번호 수정시에만 입력하세요.</label></td>
		            </tr>
		            <tr>
		            	<td>새 비밀번호 확인</td>
		            	<td><input type="password" name="passwordcheck" id="passwordcheck" placeholder="새 비밀번호를 다시 입력해주세요."><br>
		                <label id="pwcheckmsg" class="msg" style="font-size:13px"></label></td>
		            </tr>
		            <tr>
		                <td>성명</td>
		                <td><input type="text" name="username" id="username" value="${user.username}" placeholder="성명을 입력해주세요."><br>
		                <label id="namemsg" class="msg" style="font-size:13px"></label></td>
		            </tr>
		            <tr>
		                <td>전화번호</td>
		                <td><input type="text" name="phone" id="phone" value="${user.phone}" placeholder="(-)포함 전화번호를 입력해주세요."><br>
		                <label id="phonemsg" class="msg" style="font-size:13px"></label></td>
		            </tr>
		            <tr>
		                <td>이메일</td>
		                <td><input type="email" name="email" id="email" value="${user.email}" placeholder="이메일을 입력해주세요."><br>
		                <label id="emailmsg" class="msg" style="font-size:13px"></label></td>
		            </tr>
		            <tr>
		                <td>주소</td>
		                <td><input type="text" name="address" id="address" value="${user.address}" placeholder="주소를 입력해주세요."><br>
		                <label id="addressmsg" class="msg" style="font-size:13px"></label></td>
		            </tr>
		            <tr>
		                <td colspan="2"><input type="submit" value="수정하기" id="edit"></td>
		            </tr>
		        </table>
		    </form>
		</div>
</div>

<script>
	function Edit(){
		
		// 비밀번호
		let password = document.getElementById("password");
		// 비밀번호 확인
		let passwordcheck = document.getElementById("passwordcheck");
		// 성명
		let username = document.getElementById("username");
		// 전화번호
		let phone = document.getElementById("phone");
		// 이메일
		let email = document.getElementById("email");
		// 주소
		let address = document.getElementById("address");
		
		// 비밀번호
		let pwmsg = document.getElementById("pwmsg");
		// 비밀번호확인
		let pwcheckmsg = document.getElementById("pwcheckmsg")
		// 성명
		let namemsg = document.getElementById("namemsg");
		// 전화번호
		let phonemsg = document.getElementById("phonemsg");
		// 이메일
		let emailmsg = document.getElementById("emailmsg");
		// 주소
		let addressmsg = document.getElementById("addressmsg");
		
		// 비밀번호 정규식 (5 ~ 20자 영어 숫자)
    	let pwReg = /^(?=.*[a-z])(?=.*\d).{5,20}$/
		// 휴대폰 번호 정규식 (- 포함하여 작성)
    	let phoneReg = /^(01[016789]{1})-[0-9]{3,4}-[0-9]{4}$/
		// 이메일 정규식 (@과 . 포함하여 작성)
		let emailReg = /^[A-Za-z0-9_.\-]+@[A-Za-z0-9\-]+\.[A-Za-z]{2,}$/
		
		// 비밀번호 필수
		let pwre;
		// 비밀번호 확인 필수
		let pwcheckre;
		// 성명 필수
		let usernamere;
		// 전화번호 필수
		let phonere;
		// 이메일 필수
		let emailre;
		// 주소 필수
		let addressre;
			
			
			// 비밀번호 정규식 비교
			if (password.value.trim() !== "") {
			    if (password.value.match(pwReg)) {
			        pwmsg.innerHTML = "사용 가능한 비밀번호입니다.";
			        pwmsg.style.color = "blue";
			        pwre = true;
			    } else {
			        pwmsg.innerHTML = "비밀번호는 5 ~ 20자 영어 + 숫자만 사용 가능합니다.";
			        pwmsg.style.color = "red";
			        pwre = false;
			    }
			
			    // 비밀번호 일치 확인
			    if (password.value !== passwordcheck.value) {
			        pwcheckmsg.innerHTML = "비밀번호가 일치하지 않습니다.";
			        pwcheckmsg.style.color = "red";
			        pwcheckre = false;
			    } else {
			        pwcheckmsg.innerHTML = "일치합니다.";
			        pwcheckmsg.style.color = "blue";
			        pwcheckre = true;
			    }
			
			} else {
			    // 비밀번호 입력 안 한 경우: 검사 생략, 통과 처리
			    pwmsg.innerHTML = "";
			    pwre = true;
			    pwcheckmsg.innerHTML = "";
			    pwcheckre = true;
			}
			
			// 성명 
			if (username.value === ""){
				namemsg.style.display = "block";
				namemsg.innerHTML = "성명은 필수 정보입니다.";
				namemsg.style.color = "red";
				usernamere = false;
			} else {
				namemsg.style.display = "none";
				usernamere = true;
			}
			
			// 전화번호
			if (phone.value === "") {
			    phonemsg.style.display = "block";
			    phonemsg.innerHTML = "전화번호는 필수 정보입니다.";
			    phonemsg.style.color = "red";
			    phonere = false;
			} else if (!phone.value.match(phoneReg)) {
			    phonemsg.style.display = "block";
			    phonemsg.innerHTML = "전화번호가 정확한지 확인해주세요.";
			    phonemsg.style.color = "red";
			    phonere = false;
			} else {
			    phonemsg.style.display = "none";
			    phonere = true;
			}
			
			// 이메일
			if (email.value === "") {
			    emailmsg.style.display = "block";
			    emailmsg.innerHTML = "이메일은 필수 정보입니다.";
			    emailmsg.style.color = "red";
			    emailre = false;
			} else if (!email.value.match(emailReg)) {
			    emailmsg.style.display = "block";
			    emailmsg.innerHTML = "이메일이 정확한지 확인해주세요.";
			    emailmsg.style.color = "red";
			    emailre = false;
			} else {
			    emailmsg.style.display = "none";
			    emailre = true;
			}
			
			// 주소
			if (address.value === ""){
				addressmsg.style.display = "block";
				addressmsg.innerHTML = "주소는 필수 정보입니다.";
				addressmsg.style.color = "red";
				addressre = false;
			} else{
				addressmsg.style.display = "none";
				addressre = true;
			}
			
			
			
			if (pwre == true && usernamere == true && phonere == true && emailre == true && addressre == true && pwcheckre == true){
				return true;
				} else{
				return false;
				}
	}
</script>
</body>
</html>