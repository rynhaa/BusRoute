<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("activeMenu", "auth_log");

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
<title>권한 변경 로그</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<!-- daterangepicker.css -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
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
  
/* daterangepicker 내 table에 기존 table 스타일 무효화 */
.daterangepicker table {
  width: auto !important;
  margin: 0 !important;
  border-collapse: separate !important;
  box-shadow: none !important;
  border-radius: 0 !important;
}

.daterangepicker th, .daterangepicker td {
  padding: 6px 8px !important;
  border: none !important;
  background-color: transparent !important;
  font-weight: normal !important;
  color: #333 !important;
}

.daterangepicker td.active, 
.daterangepicker td.active:hover {
  background-color: #2e6da4 !important;
  color: #fff !important;
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
		
		<h3>권한 변경 로그</h3>
		
		<form action="/admin/auth/roleChangeLog" method="get">
	      	<select name="type">
	        	<option value="target_userid" ${type == 'target_userid' ? 'selected' : ''}>대상 아이디</option>
        		<option value="target_username" ${type == 'target_username' ? 'selected' : ''}>대상 이름</option>
	        	<option value="admin_userid" ${type == 'admin_userid' ? 'selected' : ''}>변경자 아이디</option>
        		<option value="admin_username" ${type == 'admin_username' ? 'selected' : ''}>변경자 이름</option>
	      	</select>
	      	<select id="sortOrder" name="sort">
			    <option value="desc" ${sort == 'desc' ? 'selected' : ''} >최신순</option>
			    <option value="asc" ${sort == 'asc' ? 'selected' : ''}>오래된순</option>
			</select>
	      	<select name="change_type">
	      		<option value="">사유 종류</option>
			    <option value="USER_REQUEST" ${change_type eq 'USER_REQUEST' ? 'selected' : ''}>사용자 요청</option>
	      		<option value="REPORT_LIMIT" ${change_type eq 'REPORT_LIMIT' ? 'selected' : ''}>불편신고 제한</option>
	      		<option value="POLICY_VIOLATION" ${change_type eq 'POLICY_VIOLATION' ? 'selected' : ''}>정책 위반</option>
	      		<option value="TEMP_SUSPEND" ${change_type eq 'TEMP_SUSPEND' ? 'selected' : ''}>임시 제한</option>
	      		<option value="ETC" ${change_type eq 'ETC' ? 'selected' : ''}>기타</option>
			</select>
	      	<input type="text" name="daterange" style="width:250px;" placeholder="날짜 범위 선택" value="${dateRange}" readonly />
	      	<input type="text" name="keyword"  style="width:400px;" value="${keyword != null ? keyword : ''}">
	      	<input type="submit" value="검색">
	    </form>
	    
		<table>
  			<thead>
  				<tr>
	            	<th width="14%">변경일</th>
	            	<th width="15%">대상</th>
	            	<th width="13%">변경자</th>
	            	<th width="10%">이전</th>
	            	<th width="10%">이후</th>
	            	<th width="*">사유종류</th>
	            	<th width="*">상세내용</th>
	          	</tr>
  			</thead>
  			<tbody>
  				<c:if test="${empty logList}">
		            <tr>
		              <td colspan="7" style="text-align: center; padding: 20px; color: #777;">로그 정보가 없습니다.</td>
		            </tr>
	          	</c:if>
	          	<c:forEach items="${logList}" var="log">
					<tr>
				    	<td><fmt:formatDate value="${log.changed_at}" pattern="yyyy-MM-dd HH:mm" /></td>
				    	<td>${log.target_userid}</td>
				    	<td>${log.admin_userid}</td>
				    	<td>${log.before_role}</td>
				    	<td>${log.after_role}</td>
				    	<td>
				    		<c:choose>
							    <c:when test="${log.change_type == 'USER_REQUEST'}">사용자 요청</c:when>
							    <c:when test="${log.change_type == 'REPORT_LIMIT'}">불편신고 제한</c:when>
							    <c:when test="${log.change_type == 'POLICY_VIOLATION'}">정책 위반</c:when>
							    <c:when test="${log.change_type == 'TEMP_SUSPEND'}">임시 제한</c:when>
							    <c:when test="${log.change_type == 'ETC'}">기타</c:when>
							</c:choose>
				    	</td>
				    	<td>${log.change_reason}</td>
				  	</tr>
	          	</c:forEach>
  			</tbody>
  		</table>
  		<div class="board-controls">
  			<div class="pagination-wrapper">
	          	<ul class="pagination">
				    <c:if test="${prev}">
				        <li><a href="/admin/auth/roleChangeLog?page=${startPage - 1}&pageSize=${pageSize}">◁ Pre</a></li>
				    </c:if>
				    <c:forEach var="num" begin="${startPage}" end="${endPage}">
				        <li><a href="/admin/auth/roleChangeLog?page=${num}&pageSize=${pageSize}" class="${num == page ? 'active' : ''}">${num}</a></li>
				    </c:forEach>
				    <c:if test="${next}">
				        <li><a href="/admin/auth/roleChangeLog?page=${endPage + 1}&pageSize=${pageSize}">Next ▷</a></li>
				    </c:if>
				</ul>
	        </div>
	        <!-- <div class="btn-wrapper">
	          	<a class="btn btn-primary" href="/admin/auth/adminCreate">엑셀 다운로드</a>
	        </div> -->
        </div>
  	</main>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<!-- moment.js (필수) -->
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<!-- daterangepicker.js -->
<script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<script>
$(function() {
	 $('input[name="daterange"]').daterangepicker({
		autoUpdateInput: false, // 기본값 자동 입력 막기
		locale: {
		   "separator": " ~ ",
           "format": 'YYYY-MM-DD',     				// 일시 노출 포맷
           "applyLabel": "확인",                    // 확인 버튼 텍스트
           "cancelLabel": "취소",                   // 취소 버튼 텍스트
           "daysOfWeek": ["일", "월", "화", "수", "목", "금", "토"],
           "monthNames": ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
        },
        maxDate: moment(),
	   	opens: 'right'
	 }, function(start, end, label) {
	   console.log("선택한 날짜: " + start.format('YYYY-MM-DD') + ' ~ ' + end.format('YYYY-MM-DD'));
	 });
});
</script>