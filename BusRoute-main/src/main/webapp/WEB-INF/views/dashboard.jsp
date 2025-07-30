<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<c:if test="${not empty error or not empty sessionScope.error}">
  <script>
    alert("${error != null ? error : sessionScope.error}");
  </script>
  <c:remove var="error" scope="session" />
</c:if>
  <meta charset="UTF-8" />
  <title>버스노선 사용자 예측 & 불편 신고 시스템</title>
  <style>
   @import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css");
   * {
	 	font-family: 'Pretendard', sans-serif;
      	box-sizing: border-box;
   	}

    html, body {
      margin: 0;
      padding: 0;
      font-family: 'Arial', sans-serif;
      background-color: #DFF1FF;
      height: 100%;
      overflow: hidden;
    }
    
    header {
	  position: fixed;
	  top: 0;
	  width: 100%;
	  display: flex;
  	  justify-content: center;
	  background-color: #fff;
	  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
	  z-index: 100;
	  padding: 12px 40px;
	  font-size: 20px;
	  align-items: center;
	}

    header nav a {
      margin: 0 15px;
      text-decoration: none;
      color: #002744;
      font-weight: bold;
      vertical-align: middle;
    }
  
  .btn1{
        padding: 10px 20px;
        border-radius: 10px;
        font-size: 18px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        border: 2px solid #002744;
        box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
        background-color: white;
        color: #002744;
        margin:0px;
    }
    
   #login{
      	margin-left: 70px;
    }
    
    #mypage{
    	margin-left: 70px;
    }
    
    #main{
    	display:inline-block;
    	margin-right:500px;
    	margin-left:200px;
    }

	.hero {
	  position: relative;
	  width: 100%;
	  min-height: calc(100vh - 45px); /* 화면 전체 높이 - header 높이 */
	  margin-top: 90px; /* header 높이만큼 띄우기 */
	  background: url("${pageContext.request.contextPath}/resources/image/bus_illustration.png") no-repeat center center;
	  background-size: cover;
	  background-position: center bottom;
	  display: flex;
	  flex-direction: column;
	  justify-content: flex-end;
	  align-items: center;
	  text-align: center;
	  padding-bottom: 80px;
	}


    .hero h1 {
      font-size: 36px;
      color: #002744;
      margin-bottom: 30px;
      padding: 10px 20px;
      border-radius: 10px;
    }

    .button-container {
        display: flex;
        gap: 60px;
        margin-top:230px;
    }

    .btn {
      padding: 30px 50px;
      border-radius: 15px;
      font-size: 30px;
      font-weight: bold;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      border: 2px solid #002744;
      box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
      background-color: white;
      color: #002744;
    }

    .btn-predict {
      background-color: #E1ECFF;
    }

    .btn-report {
      background-color: #FFF5C7;
    }

    footer {
      position: absolute;
      bottom: 20px;
      left: 50%;
      transform: translateX(-50%);
      font-size: 14px;
      color: #444;
      background-color: rgba(255, 255, 255, 0.7);
      padding: 5px 15px;
      border-radius: 10px;
    }

    #title {
        margin-top:350px;
        font-size:70px;
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
  <div class="hero">
    <!-- <h1 id="title">오늘의 버스 정보 한눈에 보기!</h1> -->
    <br>
    <br>
    <br>
    <br>
    <br>
    <div class="button-container">
      <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-predict">📈 노선별 사용자 예측 보기</a>
      <a href="${pageContext.request.contextPath}/report/user/list" class="btn btn-report">✉️ 불편 신고하기</a>
    </div>
  </div>
</body>
</html>
