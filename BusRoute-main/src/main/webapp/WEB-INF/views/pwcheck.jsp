<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>pwcheck</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
	#check-form {
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
  
  input[type="submit"]{
    padding: 12px 18px;
    width: 100px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
    margin-left:40px;
    float:right;
  }
  
  input[type="password"]{
    padding: 10px 15px;
    width: 70%;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-sizing: border-box;
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
	<h3>비밀번호 확인</h3>
	<div id="check-form">
		<form action="/pwcheck" method="post" onsubmit="return PwCheck()">
			 <table>
	            <tr>
	                <td>현재 비밀번호</td>
	                <td><input type="password" name="password" id="password" placeholder="현재 비밀번호를 입력해주세요.">
	                <label id="pwmsg" class="msg"></label></td>  
	            </tr>   
	            <tr>       
	                <td colspan="2"><input type="submit" value="확인"></td>
	            </tr>
	                
	            
	          </table>
		</form>
	</div>
</div>

</body>
</html>