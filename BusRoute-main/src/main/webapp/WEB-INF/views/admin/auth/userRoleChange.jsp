<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("activeMenu", "auth_user");

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
<title>사용자 권한 변경</title>
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
    margin-top : 40px;
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
		
  		<h3>사용자 권한 변경</h3>
  		
  		<form action="/admin/auth/userRoleChange" method="get">
	      	<select name="type">
	        	<option value="username" ${type == 'username' ? 'selected' : ''}>이름</option>
        		<option value="userid" ${type == 'userid' ? 'selected' : ''}>아이디</option>
	      	</select>
	      	<select name="search_role">
	      		<option value="">권한</option>
	      		<option value="USER" ${search_role eq 'USER' ? 'selected' : ''}>일반</option>
	      		<option value="SUSPENDED" ${search_role eq 'SUSPENDED' ? 'selected' : ''}>중지</option>
	      	</select>
	      	<input type="text" name="keyword" value="${keyword != null ? keyword : ''}">
	      	<input type="submit" value="검색">
	    </form>
  		
  		<table>
  			<thead>
  				<tr>
	            	<th width="10%">회원번호</th>
	            	<th width="20%">이름</th>
	            	<th width="*">아이디</th>
	            	<th width="15%">권한</th>
	            	<th width="15%">적용일시</th>
	            	<th width="15%">관리</th>
	          	</tr>
  			</thead>
  			<tbody>
  				<c:if test="${empty userList}">
		            <tr>
		              <td colspan="6" style="text-align: center; padding: 20px; color: #777;">사용자 정보가 없습니다.</td>
		            </tr>
	          	</c:if>
	          	<c:forEach items="${userList}" var="users">
					<tr>
				    	<td>${users.unum}</td>
				    	<td>${users.username}</td>
				    	<td>${users.userid}</td>
				    	<td>
				    		<select id="role-select-${users.unum}" name="role">
				    			<option value="USER" <c:if test="${users.role eq 'USER'}">selected</c:if>>일반</option>
				    			<option value="SUSPENDED" <c:if test="${users.role eq 'SUSPENDED'}">selected</c:if>>중지</option>
				    		</select>
				    	</td>
				    	<td>
					    	<c:choose>
								<c:when test="${users.applied_at == null}">
									<span>-</span>
								</c:when>
								<c:otherwise>
									<fmt:formatDate value="${users.applied_at}" pattern="yyyy-MM-dd" />
								</c:otherwise>
							</c:choose>
				    	</td>
				    	<td>
				    		<button class="btn btn-danger" onclick="changeRole(${users.unum})">권한변경</button><br />
				    		<span id="role-msg-${users.unum}" class="role-msg" style="display:none; font-size:13px;"></span>
				    	</td>
				  	</tr>
	          	</c:forEach>
  			</tbody>
  		</table>
  		<div class="board-controls">
  			<div class="pagination-wrapper">
	          	<ul class="pagination">
				    <c:if test="${prev}">
				        <li><a href="/admin/auth/userRoleChange?page=${startPage - 1}&pageSize=${pageSize}">◁ Pre</a></li>
				    </c:if>
				    <c:forEach var="num" begin="${startPage}" end="${endPage}">
				        <li><a href="/admin/auth/userRoleChange?page=${num}&pageSize=${pageSize}" class="${num == page ? 'active' : ''}">${num}</a></li>
				    </c:forEach>
				    <c:if test="${next}">
				        <li><a href="/admin/auth/userRoleChange?page=${endPage + 1}&pageSize=${pageSize}">Next ▷</a></li>
				    </c:if>
				</ul>
	        </div>
        </div>
  	</main>
</div>
<!-- 권한 변경 모달 -->
<div class="modal fade" id="changeRoleModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog" style="margin-top: 280px;">
		<div class="modal-content">
	    	<div class="modal-header">
		      	<h5 class="modal-title">권한 변경 사유 입력</h5>
		      	<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	    	</div>
	    	<div class="modal-body">
		      	<p><strong>대상 : </strong> <span id="modal-username"></span> (<span id="modal-userid"></span>)</p>
		      	<p><strong>변경 권한 : </strong> <span id="modal-newrole"></span></p>
		      	<p><strong>사유 종류 : </strong></p>
		      	<select id="changeType" name="change_type" style="margin-bottom:10px;">
		      		<option value="USER_REQUEST">사용자 요청</option>
		      		<option value="REPORT_LIMIT">불편신고 제한</option>
		      		<option value="POLICY_VIOLATION">정책 위반</option>
		      		<option value="TEMP_SUSPEND">임시 제한</option>
		      		<option value="ETC">기타</option>
		      	</select>
		      	<textarea id="changeReason" class="form-control" rows="4" placeholder="변경 사유를 입력하세요"></textarea>
		      	<input type="hidden" id="modal-unum">
		      	<input type="hidden" id="modal-new-role-value">
	    	</div>
	    	<div class="modal-footer">
		      	<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
		      	<button type="button" class="btn btn-primary" onclick="submitRoleChange()">확인</button>
	    	</div>
	  	</div>
	</div>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<script>
function changeRole(unum) {
	const newRole = $("#role-select-" + unum).val();
	const username = $("#role-select-" + unum).closest('tr').find('td:nth-child(2)').text();
	const userid = $("#role-select-" + unum).closest('tr').find('td:nth-child(3)').text();

	// 모달 데이터 채우기
	$("#modal-unum").val(unum);
	$("#modal-new-role-value").val(newRole);
	$("#modal-username").text(username);
	$("#modal-userid").text(userid);
	$("#modal-newrole").text(newRole === "USER" ? "일반" : "중지");
	$("#changeReason").val(""); // 사유 초기화

	// 모달 띄우기 (Bootstrap 5 기준)
	const modal = new bootstrap.Modal(document.getElementById("changeRoleModal"));
	modal.show();
}
function submitRoleChange() {
	const unum = $("#modal-unum").val();
	const newRole = $("#modal-new-role-value").val();
	const reason = $("#changeReason").val();
	const changeType = $("#changeType").val();
	const $msg = $("#role-msg-" + unum);

	if (!reason.trim()) {
		alert("변경 사유를 입력해주세요.");
		return;
	}

	$.ajax({
    	url: "/admin/auth/change-role",
    	method: "POST",
	    contentType: "application/json",
	    data: JSON.stringify({ unum: unum, newRole: newRole, reason: reason, changeType:changeType }),
	    success: function(response) {
	        const modal = bootstrap.Modal.getInstance(document.getElementById("changeRoleModal"));
	        modal.hide();

	        if (response.success) {
	        	$msg.text("변경완료").css("color", "green").show();
	        } else {
	        	$msg.text("변경실패").css("color", "red").show();
	        }
	        setTimeout(() => $msg.fadeOut(200), 5000);
	    },
	    error: function() {
	    	alert("서버 오류가 발생했습니다.");
	    }
  	});
}
</script>