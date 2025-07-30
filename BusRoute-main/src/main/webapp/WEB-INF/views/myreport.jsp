<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Report</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
#report-form {
    width: 1000px;
    margin: 0 auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 20px 30px;
  }
  
.report-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom:20px;
  }

.report-table td {
    border-bottom: 1px solid #ccc;
    padding: 8px;
  }
  
th, td {
    padding: 14px 18px;
    text-align: center;
    border-bottom: 1px solid #eee;   
  }
th {
    background-color: rgb(59, 80, 122);
    color: white;
  }

td {
    background-color: white;
    cursor: pointer;
    
  }
input[type="button"]{
    width: 100px;
    height:50px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
  }
.btn {
 	display:flex;
 	justify-content: flex-end;
 	align-items: center;
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
	<h3>나의 접수내역</h3>
<div id="report-form">
	<table class="report-table">
		<tr>
			<th>유형</th>
			<th>제목</th>
			<th>작성일자</th>
			<th>상태</th>
		</tr>
		
	<!-- 게시물 없을 때 -->
	<c:if test="${empty reports}">
		<tr>
			<td colspan="4" style="text-align:center;">접수된 내역이 없습니다.</td>
		</tr>
	</c:if>
	<c:forEach var="report" items="${reports}">
		<tr>
	        <td width="20%">${report.category}</td>
			<td width="50%">${report.title}</td>
			<td width="15%"><fmt:formatDate value="${report.created_at }" pattern="yyyy-MM-dd" /></td>
			<td width="15%"><c:choose>
								<c:when test = "${report.status == '접수'}">
										<span style="color:blue;">${report.status}</span>	
								</c:when>
								<c:when test = "${report.status == '처리중'}">
										<span style="color:red;">${report.status}</span>	
								</c:when>
								<c:when test = "${report.status == '완료'}">
										<span style="color:black;">${report.status}</span>	
								</c:when>
								<c:otherwise>
						            ${report.status}
						        </c:otherwise>
							</c:choose></td>
		</tr>
	</c:forEach>
	</table>
	<div class="btn">
	<input type="button" id="go" value="접수하기">
	</div>
</div>
</div>
<script>
document.getElementById('go').addEventListener('click',function(){
	window.location.href="report/user/list"
})
</script>
</body>
</html>