<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 로그인</title>
<c:if test="${not empty message}">
  <script>
    alert("${message}");
  </script>
</c:if>
<script>
 window.addEventListener('DOMContentLoaded', function() {
    const savedId = localStorage.getItem('savedAdminId');
    console.log(savedId + ": savedId");
    if (savedId) {
      document.getElementById('userid').value = savedId;
      document.getElementById('saveId').checked = true;
    }
  });
 
  function validateLogin() {
    const userid = document.querySelector('input[name="userid"]').value.trim();
    const password = document.querySelector('input[name="password"]').value.trim();
    const saveIdChecked = document.getElementById('saveId').checked;

    if (userid === "") {
      alert("아이디를 입력해주세요.");
      return false;
    }

    if (password === "") {
      alert("비밀번호를 입력해주세요.");
      return false;
    }
    
    if (saveIdChecked) {
        localStorage.setItem('savedAdminId', userid);
    } else {
        localStorage.removeItem('savedAdminId');
    }
    return true;
  }
</script>
<style>
@import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css");
* {
  box-sizing: border-box;
}

html, body {
  margin: 0;
  padding: 0;
  overflow-x: hidden;
}

body {
  background-color: rgb(33, 37, 41);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  height: 100vh;
}

.header {
  width: 100%;
  padding: 20px 40px;
  display: flex;
  justify-content: flex-end;
}

.header a {
  text-decoration: none;
  color: #fff;
  font-weight: bold;
  background-color: #4e54c8;
  padding: 10px 18px;
  border-radius: 6px;
  transition: background-color 0.3s;
}

.header a:hover {
  background-color: #3c40a0;
}

.wrapper {
  height: calc(100vh - 170px); /* 헤더 높이 제외 */
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 로그인 박스 스타일 */
.login-container {
/*   background: linear-gradient(90deg, #4e54c8, #8f94fb); */
  background: #4e54c8;
  padding: 60px;
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.4);
  width: 450px;
  box-sizing: border-box;  /* ★ 패딩 포함 계산 */
  color: #fff;
  display: flex;
  flex-direction: column;
  align-items: center;   
}

/* 제목 */
.login-container h2 {
  margin-bottom: 25px;
  text-align: center;
}

.login-container input[type="text"],
.login-container input[type="password"] {
  width: 100%;
  max-width: 310px;          /* 입력창 정렬 이슈 방지용 */
  margin-bottom: 15px;
  padding: 15px 12px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
}

.form-group {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.form-group input {
  width: 100%;
  padding: 14px;
  margin-bottom: 20px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
}

/* 로그인 버튼 */
.login-container button {
  background-color: #fff;
  color: #4e54c8;
  width: 310px;
  max-width: 100%;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease;
  margin-bottom: 15px;
  padding: 12px;
  border: none;
  border-radius: 6px;
  font-size: 14px;
}

.login-container button:hover {
  background-color: #e0e0e0;
}

.checkbox-wrapper {
  display: flex;
  align-items: center;  /* ★ 중요: 세로 정렬! */
  justify-content: flex-start;
  width: 100%;
  max-width: 310px;
  font-size: 14px;
  color: #fff;
}

/* 체크박스 */
.checkbox-wrapper input[type="checkbox"] {
  accent-color: #ffffff;
  width: 16px;
  height: 16px;
  margin-right: 8px;
  cursor: pointer;
  vertical-align: middle;
}

/* 라벨 미세 정렬 */
.checkbox-wrapper label {
  cursor: pointer;
  user-select: none;
  line-height: 1; 
  position: relative;
  top: -7px;
}
</style>
</head>
<body>
	<div class="header">
    	<a href="${pageContext.request.contextPath}/">메인화면</a>
  	</div>
  	<div class="wrapper">
		<div class="login-container">
		  <h2>관리자 로그인</h2>
		  <form action="/admin/login" method="post" class="form-group" onsubmit="return validateLogin()">
		    <input type="text" name="userid" id="userid" placeholder="아이디를 입력해주세요." required>
		    <input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요." required>
		    <div class="checkbox-wrapper">
			    <input type="checkbox" id="saveId" name="saveId">
			    <label for="saveId">아이디 저장</label>
			</div>
		    <button type="submit">로그인</button>
		  </form>
		</div>
	</div>
</body>
</html>