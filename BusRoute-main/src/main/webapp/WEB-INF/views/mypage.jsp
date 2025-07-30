<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyPage</title>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.min.js"></script>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<style>

strong{
	font-size:20px;
	padding-bottom:10px;
}

#lasttime{
	font-size:15px;
	padding-bottom:20px;
}

#mypage-form {
    width: 1000px;
    margin: 0 auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 20px 30px;
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
 
button{
	width: 100px;
    height:50px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
}
  
.report-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom:20px;
    border-radius: 10px;
  }

.report-table td {
    border-bottom: 1px solid #ccc;
    padding: 8px;
  }
  

.btn {
 	display:flex;
 	justify-content: flex-end;
 	align-items: center;
 	gap:10px;
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

.badge {
    display: inline-block;
    color: white;
    padding: 5px 9px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: bold;
    margin-right: 8px;
}
/* 버스 종류별 색상 */
.badge-express { background-color: #9e1c1c; }  /* 급행 - 진한 빨강 */
.badge-direct  { background-color: #a8a3ff; }  /* 직행 - 연보라 */
.badge-normal  { background-color: #ffcc00; }  /* 일반 - 노랑 */
.badge-loop    { background-color: #ff3fa4; }  /* 순환 - 핑크 */
.badge-branch  { background-color: #164e7a; }  /* 지선 - 네이비 */
.badge-town    { background-color: #99cc99; }  /* 마을 - 연초록 */
.badge-masil   { background-color: #f4c430; }  /* 마실 - 노랑+ */
.badge-tour    { background-color: #c00040; }  /* 투어 - 자주 */
.badge-gansun  { background-color: #3d5bab; }  /* 간선 -  */
.badge-seat    { background-color: #b82647; }  /* 좌석 -  */
.badge-default { background-color: #999; }     /* 기타 */
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
<h3>마이 페이지</h3>
	<div id="mypage-form">
	<strong>${username}님, 반갑습니다!</strong>
	<br>
	<p id="lasttime">마지막 로그인 시간 : <fmt:formatDate value="${last_login_at}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
	
	<div class="btn">
	<button id="report"> 접수내역<br>상세보기</button>
	<input type="button" id="edit" value="개인정보변경">
	<input type="button" id="logout" value="로그아웃">
	</div>
		
	<strong><p>[접수 내역]</p></strong>
	<table class="report-table">
		<tr>
			<th>유형</th>
			<th>제목</th>
			<th>작성일자</th>
			<th>상태</th>
		</tr>
			
		<!-- 게시물 없을 때  -->
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
	<br />
	<!-- 자주 타는 노선 -->
	<strong><p>[자주 타는 노선]</p></strong>
	<table class="report-table">
		<tr>
			<th>지역</th>
			<th>버스종류</th>
			<th>버스번호</th>
			<th>즐겨찾기</th>
		</tr>
			
		<!-- 게시물 없을 때  -->
		<c:if test="${empty busList}">
			<tr>
				<td colspan="4" style="text-align:center;">버스 즐겨찾기 내역이 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach var="buses" items="${busList}">
			<tr>
				<td width="10%">
					<c:choose>
						<c:when test="${buses.cityCode == 21}">
								<span>부산</span>	
						</c:when>
						<c:when test="${buses.cityCode == 22}">
								<span>대구</span>	
						</c:when>
						<c:when test="${buses.cityCode == 24}">
								<span>광주</span>	
						</c:when>
						<c:when test="${buses.cityCode == 26}">
								<span>울산</span>	
						</c:when>
						<c:otherwise>
				            <span>알수없음</span>
				        </c:otherwise>
					</c:choose>
				</td>
				<td width="25%">
					<c:choose>
					  <c:when test="${fn:startsWith(buses.busNumber, '순환')}">
					    <span class="badge badge-loop">순환버스</span>
					  </c:when>
					  <c:when test="${fn:length(buses.busNumber) == 4}">
					    <span class="badge badge-direct">직행버스</span>
					  </c:when>
					  <c:otherwise>
					    <c:choose>
					      <c:when test="${buses.busType == '일반버스'}"><span class="badge badge-normal">일반버스</span></c:when>
					      <c:when test="${buses.busType == '좌석버스'}"><span class="badge badge-seat">좌석버스</span></c:when>
					      <c:when test="${buses.busType == '저상버스'}"><span class="badge badge-low">저상버스</span></c:when>
					      <c:when test="${buses.busType == '급행버스'}"><span class="badge badge-express">급행버스</span></c:when>
					      <c:when test="${buses.busType == '마을버스'}"><span class="badge badge-town">마을버스</span></c:when>
					      <c:when test="${buses.busType == '마실버스'}"><span class="badge badge-masil">마실버스</span></c:when>
					      <c:when test="${buses.busType == '간선버스'}"><span class="badge badge-gansun">간선버스</span></c:when>
					      <c:when test="${buses.busType == '지선버스'}"><span class="badge badge-branch">지선버스</span></c:when>
					      <c:otherwise><span class="badge badge-default">기타</span></c:otherwise>
					    </c:choose>
					  </c:otherwise>
					</c:choose>
				</td>
				<td width="*">${buses.busNumber}</td>
				<td width="30%"><button onclick="removeFavoriteBus('${buses.routeId}', this)" style="cursor:pointer; padding: 3px 8px; font-size: 13px; width:50px; height:30px;">삭제</button></td>
		</c:forEach>
	</table>
	<br />
	<!-- 자주 보는 정류장 -->
	<strong><p>[자주 타는 정류장]</p></strong>
	<table class="report-table">
		<tr>
			<th>지역</th>
			<th>정류장번호</th>
			<th>정류장이름</th>
			<th>즐겨찾기</th>
		</tr>
			
		<!-- 게시물 없을 때  -->
		<c:if test="${empty stationList}">
			<tr>
				<td colspan="4" style="text-align:center;">정류장 즐겨찾기 내역이 없습니다.</td>
			</tr>
		</c:if>
		<c:forEach var="stations" items="${stationList}">
			<tr>
				<td width="10%">
					<c:choose>
						<c:when test="${stations.cityCode == 21}">
								<span>부산</span>	
						</c:when>
						<c:when test="${stations.cityCode == 22}">
								<span>대구</span>	
						</c:when>
						<c:when test="${stations.cityCode == 24}">
								<span>광주</span>	
						</c:when>
						<c:when test="${stations.cityCode == 26}">
								<span>울산</span>	
						</c:when>
						<c:otherwise>
				            <span>알수없음</span>
				        </c:otherwise>
					</c:choose>
				</td>
				<td width="25%">${stations.sttnArsno}</td>
				<td width="*">${stations.sttnNm}</td>
				<td width="25%"><button onclick="removeFavoriteStation('${stations.sttnId}', this)" style="cursor:pointer; padding: 3px 8px; font-size: 13px; width:50px; height:30px;">삭제</button></td>
		</c:forEach>
	</table>
	</div>
</div>
<script>

// 로그아웃
document.getElementById('logout').addEventListener('click',function(){
	window.location.href = "/logout";
});

// 개인정보 변경
document.getElementById('edit').addEventListener('click',function(){
	window.location.href = "/pwcheck";
});

// 접수 내역
document.getElementById('report').addEventListener('click',function(){
	window.location.href = "/myreport";
});

const contextPath = "${pageContext.request.contextPath}";
// 즐겨찾기 함수
function removeFavoriteBus(routeId, btnElement) {
	if(confirm("즐겨찾기에서 삭제하시겠습니까?")) {
	    $.ajax({
	        url: "/api/toggle-favorite",
	        type: "POST",
	        data: { routeId: routeId },
	        dataType : "json",
	        success: function(response) {
	        	if (response.status === "error") {
	                alert(response.message);
	                return;
	            }
	            if (response.status === "added") {
	                alert("즐겨찾기에 저장되었습니다.");
	            } else if (response.status === "removed") {
	                alert("삭제되었습니다.");
	            }
	            location.reload();
	        },
	        error: function() {
	            alert("즐겨찾기 처리 중 오류가 발생했습니다.");
	        }
	    });
	}
}

function removeFavoriteStation(sttnId, btnElement) {
	if(confirm("즐겨찾기에서 삭제하시겠습니까?")) {
	    $.ajax({
	        url: "/api/toggle-favorite-station",
	        type: "POST",
	        data: { sttnId: sttnId },
	        dataType : "json",
	        success: function(response) {
	        	if (response.status === "error") {
	                alert(response.message);
	                return;
	            }
	            if (response.status === "added") {
	                alert("즐겨찾기에 저장되었습니다.");
	            } else if (response.status === "removed") {
	                alert("삭제되었습니다.");
	            }
	            location.reload();
	        },
	        error: function() {
	            alert("즐겨찾기 처리 중 오류가 발생했습니다.");
	        }
	    });
	}
}

</script>
</body>
</html>