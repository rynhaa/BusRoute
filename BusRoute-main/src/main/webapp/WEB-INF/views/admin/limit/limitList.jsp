<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("activeMenu", "limit");

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
  <div class="alert alert-info m-popup" role="alert">
    ${message}
  </div>
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제한 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>
  table {
    width: 90%;
    margin: 0 auto;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
  } 
  
  th, td {
    padding: 14px 18px ;
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
    cursor: pointer;
  }
  
  td a {
  	text-decoration: none;
  	color:#333;
  }

  .write-btn {
    padding: 10px 18px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 10px;
    text-decoration: none;
    font-weight: bold;
    transition: background-color 0.3s;
    display: inline-block;
  }

  .write-btn:hover {
    background-color: rgb(127, 152, 202);
  }

  form {
    text-align: left;
    width: 90%;
    margin: 0 auto 20px;
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
    display: flex;
    justify-content: center;
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .pagination li {
    margin: 0 2px;
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

  .detail-row td {
    padding: 0;
  }

  .detail-content {
    height: 0;
    overflow: hidden;
    display: none;
    padding: 0;
    opacity: 0; /* 시각적으로 감춤 */
    transition: height 0.4s ease, padding 0.2s ease, opacity 0.2s ease;
  }

  .detail-content.open {
    display: block;
    opacity: 1;
    padding: 30px 200px;
  }

  .detail-wrapper {
    padding-bottom: 10px;
  }

  .detail-wrapper pre {
    text-align:left;
    white-space: pre-wrap;
    margin: 0;
    font-weight: normal;
    font-size:15px;
    color: #444;
    line-height: 1.6;
  }

  .detail-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
    gap: 8px;
  }

  .btn {
    padding: 6px 12px !important;
    border-radius: 6px !important;
    text-decoration: none !important;
    font-weight: bold !important;
    font-size: 14px !important;
    color: white !important;
    cursor: pointer;
  }

  .btn-edit {
    background-color: #4caf50 !important;
  }

  .btn-delete {
    background-color: #e74c3c !important; 
  }

  .btn:hover {
    opacity: 0.85 !important;
  }

  h3 {
    width: 90%;
    margin: 0 auto 20px;
    margin-bottom: 10px;
  }

  /* 페이징, 버튼 한 줄 배치 영역 */
  .board-controls {
    width: 90%;
    margin: 20px auto 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .pagination-wrapper {
    flex-grow: 1;
  }

  .btn-wrapper {
    display: flex;
    gap: 10px;
  }

  /* 선택 삭제 버튼 커스텀 */
  button.btn-delete {
    background-color: #e74c3c;
    border: none;
  }
  button.btn-delete:hover {
    background-color: #c0392b;
  }
  
/* 상단 고정 게시글 배경색, 글자 색상 차별화 */
tr.board-row.pinned {
  background-color: #fff8dc !important;  /* 연한 크림색 배경 */
  font-weight: bold !important;
}

/* 고정 아이콘 모양 */
.pin-icon {
  color: #ff5722;  /* 주황색 */
  margin-right: 6px;
  font-size: 16px;
  vertical-align: middle;
}

/* 상단 고정 버튼 스타일 개선 */
button.btn-pin {
  background-color: #007bff;  /* Bootstrap 기본 파랑 */
  border: none;
  padding: 10px 18px;
  border-radius: 10px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

button.btn-pin:hover {
  background-color: #0056b3;
}
.m-popup {
  position: fixed;
  top: 45%;  /* 화면 상단에서 25% 정도 아래 */
  left: 45%;
  transform: translate(-50%, -50%);
  z-index: 9999;
  width: 60%;
  max-width: 600px;
  text-align: center;
  font-size: 16px;
  padding: 20px 30px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.2);
  border-radius: 3px;
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
		
		<h3>제한 관리</h3>
		
		<form action="/admin/limit/limitList" method="get">
	    	<input type="hidden" name="pageNum" value="1">
	      	<input type="hidden" name="pageSize" value="${pageSize}">
	      	<select name="type">
	        	<option value="username" ${type == 'username' ? 'selected' : ''}>이름</option>
        		<option value="userid" ${type == 'userid' ? 'selected' : ''}>아이디</option>
        		<option value="userid" ${type == 'reason' ? 'selected' : ''}>제한사유</option>
	      	</select>
	      	<select name="role">
	      		<option value="">제한여부</option>
	      		<option value="USER" ${role eq 'USER' ? 'selected' : ''}>정상</option>
	      		<option value="SUSPENDED" ${role eq 'SUSPENDED' ? 'selected' : ''}>제한</option>
	      	</select>
	      	<input type="text" name="keyword" value="${keyword != null ? keyword : ''}">
	      	<input type="submit" value="검색">
	    </form>
		
		<table>
  			<thead>
  				<tr>
	            	<th width="10%">번호</th>
	            	<th width="10%">이름</th>
	            	<th width="*">아이디</th>
	            	<th width="15%">제한상태</th>
	            	<th width="20%">변경사유</th>
	            	<th width="15%">적용일시</th>
	            	<th width="15%">관리</th>
	          	</tr>
  			</thead>
  			<tbody>
  				<c:if test="${empty limitList}">
		            <tr>
		              <td colspan="7" style="text-align: center; padding: 20px; color: #777;">사용자 정보가 없습니다.</td>
		            </tr>
	          	</c:if>
	          	<c:forEach items="${limitList}" var="users" varStatus="loop">
					<tr>
				    	<td>${(page - 1) * pageSize + loop.index + 1}</td>
				    	<td>${users.username}</td>
				    	<td>${users.userid}</td>
				    	<td>
						  	<c:if test="${users.after_role eq 'SUSPENDED'}">
						    	<strong><span style="color:red;">제한중</span></strong>
						  	</c:if>
						  	<c:if test="${users.after_role ne 'SUSPENDED'}">
						    	<strong>정상</strong>
						  	</c:if>
						</td>
				    	<td>${users.change_reason}</td>
				    	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${users.changed_at}" /></td>
				    	<td>
				    		<c:if test="${users.after_role eq 'SUSPENDED' }">
							    <button class="btn btn-secondary" type="button" onclick="openLimitModal(${users.unum}, 'USER')">
							      해제하기
							    </button>
						    </c:if>
						    <c:if test="${users.after_role ne 'SUSPENDED' }">
							    <button class="btn btn-danger" type="button" onclick="openLimitModal(${users.unum}, 'SUSPENDED')">
							      제한하기
							    </button>
						    </c:if>
				    	</td>
				  	</tr>
	          	</c:forEach>
  			</tbody>
  		</table>
  		
  		<!-- 페이징 및 버튼 한 줄 배치 -->
      	<div class="board-controls">
	        <div class="pagination-wrapper">
	          	<ul class="pagination">
				    <c:if test="${prev}">
				        <li><a href="/admin/user/list?page=${startPage - 1}&pageSize=${pageSize}">◁ Pre</a></li>
				    </c:if>
				    <c:forEach var="num" begin="${startPage}" end="${endPage}">
				        <li><a href="/admin/user/list?page=${num}&pageSize=${pageSize}" class="${num == page ? 'active' : ''}">${num}</a></li>
				    </c:forEach>
				    <c:if test="${next}">
				        <li><a href="/admin/user/list?page=${endPage + 1}&pageSize=${pageSize}">Next ▷</a></li>
				    </c:if>
				</ul>
	        </div>
	        <!-- <div class="btn-wrapper">
	          	<a class="write-btn" href="/admin/user/stats">사용자 통계</a>
	        </div> -->
        </div>
  	</main>
</div>
<!-- Bootstrap 모달 -->
<div class="modal fade" id="limitModal" tabindex="-1" aria-labelledby="limitModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form method="post" action="/admin/limit/roleUpdate">
        <div class="modal-header">
          <h5 class="modal-title" id="limitModalLabel">사용자 제한/해제</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="unum" id="limitUserId">
          <input type="hidden" name="role" id="selectedRole" />
          <textarea name="reason" class="form-control" rows="4" placeholder="제한 또는 해제 사유 입력" required></textarea>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">적용</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        </div>
      </form>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<script>
	function openLimitModal(unum, role) {
		let msg = "";
		(role === 'USER') ? msg = "해제" : msg = "제한";
		if (confirm('해당 계정을 ' + msg + '하시겠습니까?')) {
		  	document.getElementById('limitUserId').value = unum;
	    	document.getElementById("selectedRole").value = role;
		  	const modal = new bootstrap.Modal(document.getElementById('limitModal'));
		  	modal.show();
		}
	}
</script>