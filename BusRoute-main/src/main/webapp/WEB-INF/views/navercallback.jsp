<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Naver Callback</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<body>

<script>
// URL fragment (# 뒤)에서 access_token 추출 함수
function getAccessTokenFromHash() {
  const hash = window.location.hash.substr(1); // # 제거
  const params = new URLSearchParams(hash);
  return params.get('access_token');
}

const accessToken = getAccessTokenFromHash();

if (!accessToken) {
  alert("엑세스 토큰이 없습니다. 로그인에 실패했습니다.");
} else {
  // 네이버 프로필 API 호출 제거!
  
  // 토큰만 부모창에 보냄
  if (window.opener) {
    window.opener.postMessage({ accessToken: accessToken }, "http://localhost:8080");
    window.close();  // 팝업 닫기
  } else {
    alert("부모창이 없습니다.");
  }
}
</script>

</body>
</html>
