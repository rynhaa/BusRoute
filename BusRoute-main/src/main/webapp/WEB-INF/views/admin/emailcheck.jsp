<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    request.setAttribute("activeMenu", "mail");

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
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이메일 발송 로그</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>
table {
    width: 90%;
    margin: 20px auto;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
}
th, td {
    padding: 14px 18px;
    text-align: center !important;
    border-bottom: 1px solid #eee;
}
tr:hover td {
    background-color: rgb(232, 248, 255);
}
th {
    background-color: rgb(59, 80, 122);
    color: white;
}
td {
    background-color: white;
    color: #333;
    font-weight: bold;
    cursor: default;
}
td a {
    text-decoration: none;
    color:#333;
}
form {
    text-align: left;
    width: 90%;
    margin: 20px auto 20px;
}
select, input[type="text"] {
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 10px;
    margin-right: 8px;
}
input[type="text"] {
    width: 300px;
}
input[type="submit"] {
    padding: 14px 18px;
    width: 100px;
    border: none;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 10px;
    cursor: pointer;
}
input[type="submit"]:hover {
    background-color: rgb(127, 152, 202);
}
.pagination {
    display: flex;
    justify-content: center;
    list-style: none;
    padding: 0;
    margin: 20px 0;
}
.pagination li {
    margin: 0 4px;
}
.pagination a {
    padding: 8px 12px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 8px;
    text-decoration: none;
    display: inline-block;
}
.pagination a:hover {
    background-color: rgb(127, 152, 202);
    color: white;
}
.pagination a.active {
    background-color: rgb(127, 152, 202);
    color: white;
    font-weight: bold;
}
h3 {
    width: 90%;
    margin: 0 auto 20px;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/include/nav.jsp" %>
<div class="d-flex">
    <main class="flex-grow-1 p-4">
        <h3>이메일 발송 로그</h3>

        <form action="/admin/emailcheck" method="get">
            <input type="text" name="keyword" placeholder="이메일, 제목 검색" value="${param.keyword != null ? param.keyword : ''}" />
            <select name="send_status">
                <option value="">전체 상태</option>
                <option value="SUCCESS" ${param.send_status == 'SUCCESS' ? 'selected' : ''}>성공</option>
                <option value="FAIL" ${param.send_status == 'FAIL' ? 'selected' : ''}>실패</option>
            </select>
            <input type="submit" value="검색" />
        </form>

        <table>
            <thead>
                <tr>
                    <th width="5%">NO</th>
                    <th width="15%">이메일</th>
                    <th width="20%">제목</th>
                    <th width="40%">내용 미리보기</th>
                    <th width="10%">상태</th>
                    <!-- <th width="10%">관리번호</th> -->
                    <th width="10%">발송일시</th>
                    
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty emailList}">
                    <tr>
                        <td colspan="6" style="text-align:center; padding: 20px; color:#777;">이메일 발송 기록이 없습니다.</td>
                    </tr>
                </c:if>
                <c:forEach items="${emailList}" var="email" varStatus="status">
                    <tr>
                        <td>${totalCount - (page - 1) * pageSize - status.index}</td>
                        <td>${email.recipient_email}</td>
                        <td>${email.subject}</td>
                        <td>
						  <c:choose>
						    <c:when test="${fn:length(email.content_preview) > 40}">
						      <c:out value="${fn:substring(email.content_preview, 0, 40)}"/>...
						    </c:when>
						    <c:otherwise>
						      <c:out value="${email.content_preview}..." />
						    </c:otherwise>
						  </c:choose>
						</td>
                        <td>${email.send_status}</td>
                        <%-- <td>${email.sent_by}</td> --%>
                        <td><fmt:formatDate value="${email.sent_at}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                        
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <ul class="pagination">
            <c:if test="${prev}">
                <li><a href="?page=${startPage - 1}&pageSize=${pageSize}&keyword=${param.keyword}&send_status=${param.send_status}">◁ 이전</a></li>
            </c:if>
            <c:forEach var="num" begin="${startPage}" end="${endPage}">
                <li>
                    <a href="?page=${num}&pageSize=${pageSize}&keyword=${param.keyword}&send_status=${param.send_status}" class="${num == page ? 'active' : ''}">${num}</a>
                </li>
            </c:forEach>
            <c:if test="${next}">
                <li><a href="?page=${endPage + 1}&pageSize=${pageSize}&keyword=${param.keyword}&send_status=${param.send_status}">다음 ▷</a></li>
            </c:if>
        </ul>
    </main>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
</body>
</html>
