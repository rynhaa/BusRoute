<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<style>

  table {
    width: 90%;
    margin: 0 auto;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
  } 
  
  table a{
  	text-decoration: none;
  	color: black;
  }

  th, td {
    padding: 14px 18px;
    text-align: center;
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
    
    font-weight: bold;
    cursor: pointer;
    
  }
  

  .write-btn {
    float: right;
    margin: 20px 5% 0 0;
    padding: 10px 18px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 10px;
    text-decoration: none;
    font-weight: bold;
    transition: background-color 0.3s;
  }

  .write-btn:hover {
    background-color: rgb(127, 152, 202);
  }

  form {
    width: 90%;
    margin: 0 auto 20px;
    text-align: left;
  }

  select, input[type="text"] {
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 10px;
    margin-right: 4px;
  }

  input[type="text"] {
    width: 400px;
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
    text-align: center;
    margin-top: 30px;
  }

  .pagination li {
    display: inline-block;
    margin: 0 2px;
  }

  .pagination a {
    padding: 8px 12px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 8px;
    text-decoration: none;
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

  .btn {
    padding: 6px 12px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: bold;
    font-size: 14px;
    color: white;
  }

  .btn-edit {
    background-color: #4caf50;
  }

  .btn-delete {
    background-color: #e74c3c;
  }

  .btn:hover {
    opacity: 0.85;
  }
</style>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/header.jsp" %>


  <div id="wrapper">
  <h3>접수 상황</h3>

  <form action="/report/user/list" method="get">
    <input type="hidden" name="pageNum" value="1">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
	<select name="type">
	  <option value="T" <c:if test='${pageMaker.cri.type == "T"}'>selected</c:if>>제목</option>
	  <option value="C" <c:if test='${pageMaker.cri.type == "C"}'>selected</c:if>>내용</option>
	  <option value="W" <c:if test='${pageMaker.cri.type == "W"}'>selected</c:if>>작성자</option>
	  <option value="G" <c:if test='${pageMaker.cri.type == "G"}'>selected</c:if>>유형</option>
	</select>
	<select name="statusFilter">
		<option value="">전체</option>
		<option value="접수" <c:if test='${pageMaker.cri.statusFilter == "접수"}'>selected</c:if>>접수</option>
		<option value="처리중" <c:if test='${pageMaker.cri.statusFilter == "처리중"}'>selected</c:if>>처리중</option>
		<option value="완료" <c:if test='${pageMaker.cri.statusFilter == "완료"}'>selected</c:if>>완료</option>
	</select>
    <input type="text" name="keyword" value="${pageMaker.cri.keyword}">
    <input type="submit" value="검색">
  </form>

  <table>
    <tr>
      <th>번호</th>
      <th>유형</th>
      <th>제목</th>
      <th>작성자</th>
      <th>작성일자</th>
      <th>상태</th>
    </tr>

    <c:if test="${empty list}">
      <tr>
        <td colspan="6" style="text-align: center; padding: 20px; color: #777;">게시글이 없습니다.</td>
      </tr>
    </c:if>
<c:forEach items="${list}" var="report" varStatus="status">
  <c:set var="index" value="${(pageMaker.total - ((pageMaker.cri.pageNum - 1) * pageMaker.cri.amount)) - status.index}" />
	  <tr>
	    <td width="10%"><a href="/report/user/read?report_id=${report.report_id}">${index}</a></td>
	    <td width="10%"><a href="/report/user/read?report_id=${report.report_id}">${report.category}</a></td>
	    <td width="40%"><a href="/report/user/read?report_id=${report.report_id}">${report.title}</a></td>
	    <td width="15%"><a href="/report/user/read?report_id=${report.report_id}">${report.username}</a></td>
	    <td width="15%"><a href="/report/user/read?report_id=${report.report_id}"><fmt:formatDate pattern="yyyy-MM-dd" value="${report.created_at}" /></a></td>
	    <td width="10%">
		  <a href="/report/user/read?report_id=${report.report_id}" 
		     style="color:
		       <c:choose>
		         <c:when test='${report.status == "접수"}'>blue</c:when>
		         <c:when test='${report.status == "처리중"}'>red</c:when>
		         <c:when test='${report.status == "완료"}'>gray</c:when>
		         <c:otherwise>black</c:otherwise>
		       </c:choose>;">
		    ${report.status}
		  </a>
		</td>
	  </tr>
	</c:forEach>
  </table>

  <a class="write-btn" href="/report/user/write">글쓰기</a>

  <div class="pagination">
    <ul class="pull-right">
      <c:if test="${pageMaker.prev}">
        <li><a href="/report/user/list?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">◁ Pre</a></li>
      </c:if>
      <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
        <li><a href="/report/user/list?pageNum=${num}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">${num}</a></li>
      </c:forEach>
      <c:if test="${pageMaker.next}">
        <li><a href="/report/user/list?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">Next ▷</a></li>
      </c:if>
    </ul>
  </div>
</div>
</body>
</html>
