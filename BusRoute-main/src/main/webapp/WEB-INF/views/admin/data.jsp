<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setAttribute("activeMenu", "bus");

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

java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm");
String now = sdf.format(new java.util.Date());
%>

<c:set var="gwangjuJson">[</c:set>
<c:forEach var="route" items="${routeListGwangju}" varStatus="status">
	<c:set var="gwangjuJson"
		value="${gwangjuJson}'${route}'${!status.last ? ',' : ''}" />
</c:forEach>
<c:set var="gwangjuJson" value="${gwangjuJson}]" />

<c:set var="busanJson">[</c:set>
<c:forEach var="route" items="${routeListBusan}" varStatus="status">
	<c:set var="busanJson"
		value="${busanJson}'${route}'${!status.last ? ',' : ''}" />
</c:forEach>
<c:set var="busanJson" value="${busanJson}]" />

<c:set var="daeguJson">[</c:set>
<c:forEach var="route" items="${routeListDaegu}" varStatus="status">
	<c:set var="daeguJson"
		value="${daeguJson}'${route}'${!status.last ? ',' : ''}" />
</c:forEach>
<c:set var="daeguJson" value="${daeguJson}]" />

<c:set var="ulsanJson">[</c:set>
<c:forEach var="route" items="${routeListUlsan}" varStatus="status">
	<c:set var="ulsanJson"
		value="${ulsanJson}'${route}'${!status.last ? ',' : ''}" />
</c:forEach>
<c:set var="ulsanJson" value="${ulsanJson}]" />

<html>
<head>
<title>데이터관리</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/admin.css"
	rel="stylesheet">
<style>
body, html {
	margin: 0;
	padding: 0;
	height: 100%;
	background-color: #f8f9fa;
	font-family: 'Noto Sans KR', sans-serif;
}

h3 {
	font-weight: 700 !important;
	color: #222;
	margin-bottom: 20px;
	user-select: none;
}

.form-container {
	max-width: 1200px;
	margin: 0 auto;
}

.form-row {
	display: flex;
	gap: 1.5rem;
	align-items: center;
	flex-wrap: nowrap;
	width: 100%;
}

.form-group {
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.form-group label {
	font-weight: 600;
	white-space: nowrap;
}

.form-group input, .form-group select {
	min-width: 120px;
	flex-grow: 1;
}

button.btn-primary {
	min-width: 80px;
	height: 38px;
}

#loading-spinner {
	display: none;
	z-index: 9999;
	background: white;
}

.spinner {
	margin: 0 auto 10px;
	border: 6px solid #f3f3f3; /* 바깥 원 */
	border-top: 6px solid #3498db; /* 회전 부분 */
	border-radius: 50%;
	width: 40px;
	height: 40px;
	animation: spin 1s linear infinite;
}

@
keyframes spin { 0% {
	transform: rotate(0deg);
}
100


%
{
transform


:


rotate
(


360deg


)
;


}
}
</style>
</head>
<body>
	<%@ include file="include/nav.jsp"%>
	<div class="d-flex">
		<main class="flex-grow-1 p-4">
			<div id="session-timer">
				<div class="session-box">
					<strong>자동 로그아웃까지 남은 시간 : <span id="countdown">30:00</span></strong>
				</div>
			</div>

			<div class="card shadow-sm p-3 mt-4 form-container">
				<h3 class="text-center">예측 모델 파라미터 설정</h3>
				<form method="get"
					action="${pageContext.request.contextPath}/admin/data"
					onsubmit="showLoading()">
					<div class="form-row">
						<div class="form-group">
							<label for="startDate" class="col-form-label">예측 시작일</label>
							<%
							java.util.Calendar cal = java.util.Calendar.getInstance();
							cal.add(java.util.Calendar.DATE, 1); // 내일
							String tomorrow = new java.text.SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
							request.setAttribute("tomorrow", tomorrow);
							%>
							<input type="date" id="startDate" name="startDate"
								class="form-control"
								value="${param.startDate != null ? param.startDate : tomorrow}"
								min="${tomorrow}" />
						</div>

						<div class="form-group">
							<label for="interval" class="col-form-label">샘플링 간격</label> <select
								name="interval" id="interval" class="form-select">
								<option value="hour"
									${param.interval == 'hour' || param.interval == null ? 'selected' : ''}>1시간</option>
								<option value="day" ${param.interval == 'day' ? 'selected' : ''}>1일</option>
								<option value="week"
									${param.interval == 'week' ? 'selected' : ''}>1주</option>
							</select>
						</div>

						<div class="form-group">
							<label for="region" class="col-form-label">지역</label> <select
								name="region" id="region" class="form-select">
								<option value="">지역 선택</option>
								<option value="24" ${param.region == '24' ? 'selected' : ''}>광주</option>
								<option value="21" ${param.region == '21' ? 'selected' : ''}>부산</option>
								<option value="22" ${param.region == '22' ? 'selected' : ''}>대구</option>
								<option value="26"
									${param.region == '26' || param.region == null ? 'selected' : ''}>울산</option>
							</select>
						</div>

						<div class="form-group" style="flex: 0 0 150px;">
							<label for="routeId" class="form-label">노선</label> <select
								id="routeId" name="routeId" class="form-select">
								<option value="">노선 선택</option>
								<c:forEach var="route" items="${routeList}">
									<option value="${route.route_id}"
										${route.route_id == param.routeId ? "selected" : ""}>
										${route.bus_number}번</option>
								</c:forEach>
							</select>
						</div>

						<div class="form-group">
							<label for="model" class="col-form-label">모델</label> <select
								name="model" id="model" class="form-select">
								<option value="">모델 선택</option>
								<option value="Prophet"
									${param.model == 'Prophet' || param.model == null ? 'selected' : ''}>Prophet</option>
								<option value="XGBoost"
									<c:if test="${param.model == 'XGBoost' }">selected</c:if>>XGBoost</option>
								<option value="LSTM"
									<c:if test="${param.model == 'LSTM' }">selected</c:if>>LSTM</option>
							</select>
						</div>

						<div class="form-group" style="margin-bottom: 0;">
							<button type="submit" class="btn btn-primary">조회</button>
						</div>
					</div>
				</form>
				<div id="loading-spinner"
					style="display: none; text-align: center; margin: 30px 0;">
					<div class="spinner"></div>
					<p>예측 데이터를 불러오는 중입니다...</p>
				</div>
				<canvas id="stationChart" height="300"></canvas>
				<div id="no-data-message"
					style="display: none; text-align: center; margin: 30px 0; color: #888;">
					<p>예측 데이터가 없습니다.</p>
				</div>
				<div id="predictionTableContainer" class="table-responsive mt-4"
					style="display: none;">
					<table class="table table-bordered table-hover">
						<thead class="table-light">
							<tr>
								<th>예측일시</th>
								<th>노선 ID</th>
								<th>모델명</th>
								<th>예측 탑승객 수</th>
								<th>예측 하차객 수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${predictionList}">
								<tr>
									<td>${item.intervalTime}</td>
									<td>${item.route_id}</td>
									<td>${item.model_name}</td>
									<td>${item.totalBoarding}</td>
									<td>${item.totalAlighting}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

			</div>
		</main>
	</div>

	<%@ include file="include/footer.jsp"%>

	<script>
	const routeListGwangju = ${gwangjuJson};
	const routeListBusan = ${busanJson};
	const routeListDaegu = ${daeguJson};
	const routeListUlsan = ${ulsanJson};

	function setRouteOptions(routeList, selectedRouteId = '') {
		const routeSelect = document.getElementById('routeId');
		routeSelect.innerHTML = '<option value="">노선 선택</option>';

		routeList.forEach(routeStr => {
			const routeIdMatch = routeStr.match(/route_id=([^,]+)/);
			const busNumberMatch = routeStr.match(/bus_number=([^,]+)/);

			if (routeIdMatch && busNumberMatch) {
				const routeId = routeIdMatch[1].trim();
				const busNumber = busNumberMatch[1].trim();
				const option = document.createElement('option');
				option.value = routeId;
				option.text = busNumber + '번';
				if (routeId === selectedRouteId) {
					option.selected = true;
				}
				routeSelect.appendChild(option);
			}
		});
	}

	
	function showLoading() {
	    document.getElementById("loading-spinner").style.display = "block";
	    document.getElementById("stationChart").style.display = "none";
	    document.getElementById("no-data-message").style.display = "none";
	}

	document.getElementById('region').addEventListener('change', function () {
		const selectedRegion = this.value;
		if (selectedRegion === '24') {
			setRouteOptions(routeListGwangju);
		} else if (selectedRegion === '21') {
			setRouteOptions(routeListBusan);
		} else if (selectedRegion === '22') {
			setRouteOptions(routeListDaegu);
		} else if (selectedRegion === '26') {
			setRouteOptions(routeListUlsan);
		} else {
			setRouteOptions([]);
		}
	});

	window.addEventListener('DOMContentLoaded', function () {
		const selectedRegion = document.getElementById('region').value;
		const currentRouteId = '${param.routeId}';

		if (selectedRegion === '24') {
			setRouteOptions(routeListGwangju, currentRouteId);
		} else if (selectedRegion === '21') {
			setRouteOptions(routeListBusan, currentRouteId);
		} else if (selectedRegion === '22') {
			setRouteOptions(routeListDaegu, currentRouteId);
		} else if (selectedRegion === '26') {
			setRouteOptions(routeListUlsan, currentRouteId);
		}
	});
	</script>

	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script>
	  const predictionData = [
	    <c:forEach var="item" items="${predictionList}" varStatus="status">
	      {
	        intervalTime: '${item.intervalTime}',
	        routeId: '${item.route_id}',
	        modelName: '${item.model_name}',
	        totalBoarding: ${item.totalBoarding},
	        totalAlighting: ${item.totalAlighting}
	      }${!status.last ? ',' : ''}
	    </c:forEach>
	  ];
	  
	  console.log("predictionData:", predictionData);
	
	  const loadingSpinner = document.getElementById("loading-spinner");
	  const chartCanvas = document.getElementById("stationChart");
	  const noDataMessage = document.getElementById("no-data-message");
	
	  // 초기 상태
	  loadingSpinner.style.display = "block";
	  chartCanvas.style.display = "none";
	  noDataMessage.style.display = "none";
	
	  if (predictionData.length > 0) {
		  const labels = predictionData.map(function(d) {
			  try {
			    var timePart = d.intervalTime ? d.intervalTime.split(" ")[1] : null; // "13:00:00"
			    var hour = timePart ? parseInt(timePart.split(":")[0], 10) : NaN;
			    return isNaN(hour) ? '시간없음' : hour + '시';
			  } catch (e) {
			    return '오류';
			  }
			});
	    const boardingData = predictionData.map(d => d.totalBoarding);
	
	    const data = {
	      labels: labels,
	      datasets: [{
	        label: '예측 탑승객 수',
	        data: boardingData,
	        fill: false,
	        borderColor: 'rgb(75, 192, 192)',
	        tension: 0.1
	      }]
	    };
	
	    const config = {
	      type: 'line',
	      data: data,
	      options: {
	        responsive: true,
	        plugins: {
	          legend: { position: 'top' },
	          title: {
	            display: true,
	            text: '시간별 예측 탑승객 수'
	          }
	        },
	        scales: {
	        	x: {
	                title: { display: true, text: '시간 (시)' },
	                ticks: {
	                  maxRotation: 0,
	                  minRotation: 0
	                }
	              },
	          y: {
	            title: { display: true, text: '탑승객 수' },
	            beginAtZero: true
	          }
	        }
	      }
	    };
	
	    setTimeout(() => {
	      const ctx = chartCanvas.getContext('2d');
	      new Chart(ctx, config);
	
	      loadingSpinner.style.display = "none";
	      chartCanvas.style.display = "block";
	    }, 300);
	
	  } else {
	    // 예측 데이터 없을 경우
	    setTimeout(() => {
	      loadingSpinner.style.display = "none";
	      noDataMessage.style.display = "block";
	    }, 300);
	  }
	  
	  // 리스트
	  const predictionTable = document.getElementById('predictionTableContainer');

if (predictionData.length > 0) {
  // 차트 보여주고
  loadingSpinner.style.display = "none";
  chartCanvas.style.display = "block";
  noDataMessage.style.display = "none";
  predictionTable.style.display = "block";  // 표 보이기
} else {
  // 데이터 없으면
  loadingSpinner.style.display = "none";
  chartCanvas.style.display = "none";
  noDataMessage.style.display = "block";
  predictionTable.style.display = "none";  // 표 숨기기
}

	  
	  
	</script>