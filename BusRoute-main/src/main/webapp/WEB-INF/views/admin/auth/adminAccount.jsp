<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("activeMenu", "auth_admin");

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
<c:if test="${not empty plainPassword}">
  <div id="pw-alert" class="alert alert-info pw-popup" role="alert">
    ${passwordMessage}<br />
    로그인 후 반드시 비밀번호를 변경해주세요.<br />
    <strong>임시 비밀번호 :  <span id="pw-text">${plainPassword}</span></strong><br />
    <button onclick="copyText()" style="margin-top:5px;" class="btn btn-sm btn-success">복사</button>
    <button onclick="closePwAlert()" style="margin-top:5px;" class="btn btn-sm btn-dark">닫기</button>
  </div>
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 계정 관리</title>
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
    margin-top : 30px;
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
  
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0,0,0,0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10000;
}

.modal-box {
  background: white;
  padding: 30px 40px;
  border-radius: 10px;
  text-align: center;
  width: 360px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}

.modal-buttons {
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.modal-buttons .btn {
  width: 100%;
  font-size: 15px;
}

.pw-popup {
  position: fixed;
  top: 40%;  /* 화면 상단에서 25% 정도 아래 */
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 9999;
  width: 60%;
  max-width: 750px;
  text-align: center;
  font-size: 16px;
  padding: 20px 30px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.2);
  border-radius: 3px;
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
		
		<h3>관리자 계정 관리</h3>
		
		<form action="/admin/auth/adminAccount" method="get">
	      	<select name="type">
	        	<option value="username" ${type == 'username' ? 'selected' : ''}>이름</option>
        		<option value="userid" ${type == 'userid' ? 'selected' : ''}>아이디</option>
	      	</select>
	      	<select name="is_deleted">
	      		<option value="">활성화여부</option>
	      		<option value="0" ${is_deleted == '0' ? 'selected' : ''}>정상</option>
	      		<option value="1" ${is_deleted == '1' ? 'selected' : ''}>비활성화</option>
	      	</select>
	      	<input type="text" name="keyword" value="${keyword != null ? keyword : ''}">
	      	<input type="submit" value="검색">
	    </form>
	    
		<table>
  			<thead>
  				<tr>
	            	<th width="15%">아이디</th>
	            	<th width="10%">이름</th>
	            	<th width="*">생성일</th>
	            	<th width="20%">마지막 로그인</th>
	            	<th width="10%">권한</th>
	            	<th width="10%">상태</th>
	            	<th width="10%">비고</th>
	          	</tr>
  			</thead>
  			<tbody>
  				<c:if test="${empty adminList}">
		            <tr>
		              <td colspan="7" style="text-align: center; padding: 20px; color: #777;">사용자 정보가 없습니다.</td>
		            </tr>
	          	</c:if>
	          	<c:forEach items="${adminList}" var="admins">
					<tr>
				    	<td>${admins.userid}</td>
				    	<td>${admins.username}</td>
				    	<td>
				    		<fmt:formatDate value="${admins.create_at}" pattern="yyyy-MM-dd HH:mm"/>
				    	</td>
				    	<td>
				    		<c:choose>
						    	<c:when test="${not empty admins.last_login_at}">
						      		<fmt:formatDate value="${admins.last_login_at}" pattern="yyyy-MM-dd HH:mm" />
					    		</c:when>
						    	<c:otherwise>
						      		최근 로그인 정보 없음
						    	</c:otherwise>
						  	</c:choose>
				    	</td>
				    	<td>${admins.role}</td>
				    	<td>
				    		<c:choose>
						    	<c:when test="${admins.is_deleted}">
						      		<span style="color:red;">비활성화</span>
						    	</c:when>
						    	<c:otherwise>
						      		<span>정상</span>
						    	</c:otherwise>
						  	</c:choose>
				    	</td>
				    	<td>
				    		<div class="dropdown">
							    <button class="btn btn-secondary" type="button" onclick="openModal(${admins.unum}, '${admins.userid}', ${admins.is_deleted})">
							      관리
							    </button>
							 </div>
				    	</td>
				  	</tr>
	          	</c:forEach>
  			</tbody>
  		</table>
  		<div class="board-controls">
	        <div class="btn-wrapper">
	          	<a class="btn btn-danger" href="/admin/auth/adminCreate">관리자 생성</a>
	        </div>
        </div>
  	</main>
</div>
<form id="deleteForm" action="/admin/auth/adminDelete" method="post">
  <input type="hidden" name="unum" id="deleteUnum">
</form>
<form id="resetForm" action="/admin/auth/reset-password" method="post">
  <input type="hidden" name="unum" id="resetUnum">
</form>
<form id="activateForm" action="/admin/auth/adminActivate" method="post">
  <input type="hidden" name="unum" id="activateUnum">
</form>
<div id="actionModal" class="modal-overlay" style="display:none;">
  <div class="modal-box">
    <h5>관리자 계정 작업</h5>
    <p><span id="modal-userid" style="font-weight:bold;"></span> 계정에 대해 어떤 작업을 하시겠습니까?</p>
    <div class="modal-buttons">
      <button class="btn btn-danger" id="deactivateBtn" onclick="handleDelete()">계정 비활성화(삭제)</button>
      <button class="btn btn-primary" onclick="handleUpdate()">수정</button>
      <button class="btn btn-warning" onclick="handleReset()">비밀번호 초기화</button>
      <button class="btn btn-secondary" onclick="closeModal()">닫기</button>
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<script>
let selectedUnum = null;
let selectedUserid = '';

function openModal(unum, userid, isDeleted) {
	selectedUnum = unum;
  	selectedUserid = userid;
  	document.getElementById('modal-userid').textContent = userid;
  	document.getElementById('actionModal').style.display = 'flex';
  	
 	// 버튼 토글 처리
  	if (isDeleted) {
  	    // 비활성화 상태라면 "비활성화 버튼" 숨기고 "활성화 버튼" 보여주기
  	    document.getElementById('deactivateBtn').style.display = 'none';

  	    if (!document.getElementById('activateBtn')) {
  	        const activateBtn = document.createElement('button');
  	        activateBtn.id = 'activateBtn';
  	        activateBtn.className = 'btn btn-success';
  	        activateBtn.innerText = '계정 활성화(복구)';
  	        activateBtn.onclick = handleActivate;
  	        document.querySelector('.modal-buttons').prepend(activateBtn);
  	    } else {
  	        document.getElementById('activateBtn').style.display = 'block';
  	    }
  	} else {
  	    // 정상 계정일 경우
  	    document.getElementById('deactivateBtn').style.display = 'block';
  	    const activateBtn = document.getElementById('activateBtn');
  	    if (activateBtn) activateBtn.style.display = 'none';
  	}
}

function closeModal() {
  	document.getElementById('actionModal').style.display = 'none';
}

function handleUpdate() {
  	location.href = "/admin/auth/adminUpdate?unum=" + selectedUnum;
}

function handleReset() {
  	if (confirm('정말 비밀번호를 초기화하시겠습니까?')) {
    	document.getElementById("resetUnum").value = selectedUnum;
		document.getElementById("resetForm").submit();
  	}
}
function handleActivate() {
  	if (confirm('정말 계정을 활성화하시겠습니까?')) {
    	document.getElementById("activateUnum").value = selectedUnum;
    	document.getElementById("activateForm").submit();
  	}
}
function handleDelete() {
	if (confirm('정말 삭제하시겠습니까?')) {
		document.getElementById("deleteUnum").value = selectedUnum;
		document.getElementById("deleteForm").submit();
	}
}
</script>