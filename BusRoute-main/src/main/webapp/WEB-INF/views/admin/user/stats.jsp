<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    request.setAttribute("activeMenu", "user");

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
<title>사용자 통계</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>
h3 {
    width: 90%;
    margin: 0 auto 20px;
    margin-bottom: 10px;
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

.board-controls {
   width: 90%;
   margin: 20px auto 40px;
   display: flex;
   align-items: center;
   justify-content: space-between;
}

.btn-wrapper {
   display: flex;
   gap: 10px;
 }
 
 /* 표 테두리 선명하게 */
table.table {
    border: 1px solid #dee2e6;
}

/* 헤더 배경 색상과 글자 색상 */
table.table thead th {
    background-color: #3b507a; /* 짙은 파랑 */
    color: white;
    font-weight: 600;
    text-align: center;
    vertical-align: middle;
}

/* 표 본문 행 높이와 정렬 */
table.table tbody td {
    vertical-align: middle;
    text-align: center;
}

/* 홀수, 짝수 행 배경색 차이 */
table.table-striped tbody tr:nth-of-type(odd) {
    background-color: #f8f9fa; /* 연한 회색 */
}

/* 호버 시 행 강조 */
table.table-hover tbody tr:hover {
    background-color: #d6e4ff; /* 연한 하늘색 */
    cursor: pointer;
}

/* 표 테두리 각 셀에 구분선 */
table.table td, table.table th {
    border: 1px solid #dee2e6;
}

/* 표 제목(h5) 마진 */
h5 {
    margin-top: 2rem;
    margin-bottom: 1rem;
    color: #2c3e50;
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
  		<h3>사용자 통계</h3>
  		
  		<div class="board-controls">
	        <div class="btn-wrapper">
	          	<a class="write-btn" href="/admin/user/list">사용자 목록</a>
	        </div>
        </div>
	        
  		<!-- 통계 시작 -->
		<div class="container mt-4" style="width:90%; padding:0px;">
		    <!-- 1. 기본 통계 / 지역별 사용자 수 -->
		    <div class="row">
		        <!-- 기본 통계 -->
		        <div class="col-md-6 mb-4">
		            <h5>기본 통계</h5>
		            <table class="table table-bordered">
		                <tbody>
		                    <tr>
		                        <th>총 가입자 수</th>
		                        <td>${totalUsers}</td>
		                    </tr>
		                    <tr>
		                        <th>탈퇴한 사용자 수</th>
		                        <td>${deletedUsers}</td>
		                    </tr>
		                    <tr>
		                        <th>최근 7일 내 로그인 사용자 수</th>
		                        <td>${recentLogins}</td>
		                    </tr>
		                </tbody>
		            </table>
		        </div>
		        
		        <!-- 월별 가입자 수 -->
		        <div class="col-md-6 mb-4">
		            <h5>월별 가입자 수</h5>
		            <table class="table table-striped">
		                <thead>
		                    <tr>
		                        <th>월</th>
		                        <th>가입자 수</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <c:forEach var="item" items="${monthlySignups}">
		                        <tr>
		                            <td>${item.month}</td>
		                            <td>${item.count}</td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		        </div>
		    </div>
		
		    <!-- 2. 월별 가입자 수 / 지역별 사용자 분포 차트 -->
		    <div class="row">
		    
		    	<!-- 지역별 사용자 분포 차트 -->
		        <div class="col-md-6 mb-4">
		            <h5>지역별 사용자 분포 차트</h5>
		            <canvas id="regionChart" width="500" height="350"></canvas>
		        </div>
		        
		        <!-- 지역별 사용자 수 -->
		        <div class="col-md-6 mb-4">
		            <h5>지역별 사용자 수</h5>
		            <table class="table table-hover">
		                <thead>
		                    <tr>
		                        <th>지역</th>
		                        <th>인원 수</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <c:forEach var="item" items="${regionDistribution}">
		                        <tr>
		                            <td>${item.region}</td>
		                            <td>${item.count}</td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		        </div>
		    </div>
		    
		    <div class="row">
		    	<div class="col-md-12">
		    		<h5>권한별 사용자 통계</h5>
					<table class="table table-bordered">
					  <thead>
					    <tr>
					      <th>권한</th>
					      <th>인원 수</th>
					    </tr>
					  </thead>
					  <tbody>
					    <c:forEach var="r" items="${roleDistribution}">
					      <tr>
					        <td>
					          <c:choose>
					            <c:when test="${r.role == 'USER'}">일반 사용자</c:when>
					            <c:when test="${r.role == 'SUSPENDED'}">정지 사용자</c:when>
					            <c:otherwise>${r.role}</c:otherwise>
					          </c:choose>
					        </td>
					        <td>${r.count}</td>
					      </tr>
					    </c:forEach>
					  </tbody>
					</table>
		    	</div>
		    </div>
		
		    <!-- 최근 로그인 사용자 TOP 10 -->
		    <div class="row">
		        <div class="col-md-12">
		            <h5>최근 로그인 사용자 TOP 10</h5>
		            <table class="table table-sm table-bordered">
		                <thead>
		                    <tr>
		                        <th>회원번호</th>
		                        <th>아이디</th>
		                        <th>이름</th>
		                        <th>최근 로그인</th>
		                    </tr>
		                </thead>
		                <tbody>
		                    <c:forEach var="user" items="${topLoginUsers}">
		                        <tr>
		                            <td>${user.unum}</td>
		                            <td>${user.userid}</td>
		                            <td>${user.username}</td>
		                            <td>
		                            	<c:choose>
									    	<c:when test="${not empty user.last_login_at}">
									      		<fmt:formatDate value="${user.last_login_at}" pattern="yyyy-MM-dd HH:mm" />
								    		</c:when>
									    	<c:otherwise>
									      		최근 로그인 정보 없음
									    	</c:otherwise>
									  	</c:choose>
		                            </td>
		                        </tr>
		                    </c:forEach>
		                </tbody>
		            </table>
		        </div>
		    </div>
		
		</div>
		
		<!-- Chart.js 라이브러리 -->
		<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
		
		<script>
		    const regionLabels = [
		        <c:forEach var="item" items="${regionDistribution}" varStatus="loop">
		            "${item.region}"<c:if test="${!loop.last}">,</c:if>
		        </c:forEach>
		    ];
		
		    const regionData = [
		        <c:forEach var="item" items="${regionDistribution}" varStatus="loop">
		            ${item.count}<c:if test="${!loop.last}">,</c:if>
		        </c:forEach>
		    ];
		
		    const ctx = document.getElementById('regionChart').getContext('2d');
		    const regionChart = new Chart(ctx, {
		        type: 'bar',
		        data: {
		            labels: regionLabels,
		            datasets: [{
		                label: '지역별 사용자 수',
		                data: regionData,
		                backgroundColor: 'rgba(54, 162, 235, 0.6)',
		                borderColor: 'rgba(54, 162, 235, 1)',
		                borderWidth: 1
		            }]
		        },
		        options: {
		            responsive: true,
		            scales: {
		                y: {
		                    beginAtZero: true,
		                    ticks: {
		                        stepSize: 1
		                    }
		                }
		            }
		        }
		    });
		</script>
		<!-- 사용자 통계 끝 -->
	</main>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>