<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<style>
#login-form {
    width: 100%;
    max-width: 400px;
    margin: 40px auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 15px 25px;
  }

  .login-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 10px 15px;
  }

  .login-table td {
    vertical-align: middle;
  }

  .login-table input[type="text"],
  .login-table input[type="password"] {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #ccc;
    border-radius: 7px;
    box-sizing: border-box;
  }

  .sns-login {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    margin-top: 10px;
  }

  .sns-login img {
    width: 100%;
    max-width: 180px;
    max-height:44px;
    cursor: pointer;
  }

  #naver_id_login {
    width: 100%;
    max-width: 180px;
  }

  .btn-group {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
    gap: 10px;
  }

  .btn-group input[type="submit"],
  .btn-group button {
    flex: 1;
    padding: 10px;
    font-size: 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  .btn-group input[type="submit"] {
    background-color: #007bff;
    color: white;
  }

  .btn-group button {
    background-color: #6c757d;
    color: white;
  }
  
  input[type="submit"]:hover {
    background-color: rgb(127, 152, 202);
  }
  
  .btn-group button:hover {
    background-color: #868e96;
  }
</style>
</head>
<body>
<c:if test="${not empty message || not empty joinMessage}">
<script>
    <c:if test="${not empty joinMessage}">
        alert("${joinMessage}");
    </c:if>
    <c:if test="${not empty message}">
        alert("${message}");
    </c:if>
</script>
</c:if>


<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<div id="wrapper">
  <h3>로그인</h3><br>
  <div id="login-form">
    <form action="/login" method="post">
      <table class="login-table">
        <tr>
          <td>아이디</td>
          <td><input type="text" name="userid" required></td>
        </tr>
        <tr>
          <td>비밀번호</td>
          <td><input type="password" name="password" required></td>
        </tr>
        <tr>
        	<td colspan="2">
		      <div class="sns-login">
		        <a href="javascript:kakaoLogin()">
		          <img src="${pageContext.request.contextPath}/resources/image/kakao_login_medium_narrow.png" alt="카카오 로그인">
		        </a>
		        <div id="naver_id_login"></div>
		      </div>
		    </td>
        </tr>
      </table>
      <div class="btn-group">
        <input type="submit" value="로그인">
        <button type="button" onclick="location.href='/join'">회원가입</button>
      </div>
    </form>
  </div>
  
  </div>
  <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
// 카카오 소셜 로그인
Kakao.init('d33cb15147c32d8438d16eb294d746fb');
function kakaoLogin() {
    Kakao.Auth.login({
        success: function (response) {
            Kakao.API.request({
                url: '/v2/user/me',
                success: function (res) {
                    const data = {
                        id: "kakao_" + res.id,
                        nickname: res.kakao_account.profile.nickname,
                        email: res.kakao_account.email
                    };

                    fetch('/sociallogin', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(data)
                    })
                    .then(response => response.text())  // 서버에서 문자열로 응답 받음
                    .then(result => {
                        if (result === 'needAdditionalInfo') {
                        	alert("추가정보를 작성해주세요.");
                            location.href = "/socialjoin";  // 추가정보 입력 폼(회원가입창)으로 이동
                        } else if (result === 'success') {
                        	alert("로그인 되었습니다.");
                            location.href = "/dashboard";  // 바로 마이페이지로 이동
                        } else {
                            alert("카카오 로그인 실패");
                        }
                    });
                },
                fail: function (error) {
                    alert("카카오 사용자 정보 요청 실패\n" + JSON.stringify(error));
                },
            })
        },
        fail: function (error) {
            alert("카카오 로그인 실패\n" + JSON.stringify(error));
        },
    })
}


// 네이버 소셜 로그인
var naver_id_login = new naver_id_login("aVN6DwyCTr6_zWivZVNT", "http://localhost:8080/navercallback");
var state = naver_id_login.getUniqState();
naver_id_login.setButton("green", 3,48);
naver_id_login.setDomain("http://localhost:8080/");
naver_id_login.setState(state);
naver_id_login.setPopup();
naver_id_login.init_naver_id_login();

window.addEventListener("message", function(event) {
  if (event.origin !== "http://localhost:8080") return;

  const { accessToken } = event.data;

  if (!accessToken) {
    alert("네이버 로그인 토큰이 없습니다.");
    return;
  }

  fetch("/sociallogin/naver", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ accessToken })
  })
  .then(res => res.json())
  .then(data => {
    if (data.status === "success") {
      alert("로그인되었습니다.");
      location.href = "/dashboard";
    } else if (data.status === "needAdditionalInfo") {
      alert("추가정보를 작성해주세요.");
      location.href = "/socialjoin";
    } else {
      alert("로그인이 실패했습니다.");
    }
  })
  .catch(err => {
    console.error("서버 요청 중 오류:", err);
    alert("서버와 통신 중 오류가 발생했습니다.");
  });
});

    

</script>

</body>
</html>