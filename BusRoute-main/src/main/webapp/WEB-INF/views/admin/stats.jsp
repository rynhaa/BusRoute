<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
request.setAttribute("activeMenu", "stat");

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
<html>
<head>
<title>통계</title>
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
	font-weight: 700;
	color: #222;
	margin-bottom: 12px;
	user-select: none;
}

.form-inline-flex {
	display: flex;
	flex-wrap: wrap;
	gap: 1rem;
	align-items: center;
}

.form-group {
	display: flex;
	flex-direction: row;
	align-items: center;
	gap: 0.5rem;
}

.form-group label {
	margin-bottom: 0;
	white-space: nowrap;
}

.card {
	min-width: 600px;
	/* 또는 width: 600px; */
}

.accuracy-table {
	width: 100%;
	border-collapse: collapse;
}

.accuracy-table th, .accuracy-table td {
	border: 1px solid #ccc;
	padding: 8px;
	text-align: center;
	vertical-align: middle;
}

.accuracy-table th {
	background-color: #f9f9f9;
}

#stationChart {
	width: 500px !important; /* 원하는 너비 */
	height: 300px !important; /* 원하는 높이 */
}

#accuracyChart {
	width: 1100px !important; /* 원하는 너비 */
	height: 500px !important; /* 원하는 높이 */
}
</style>
</head>
<body>
	<%@ include file="include/nav.jsp"%>

	<div class="d-flex">
		<main class="flex-grow-1 p-4">

			<!-- 30분 카운트다운 -->
			<div id="session-timer">
				<div class="session-box">
					<strong>자동 로그아웃까지 남은 시간 : <span id="countdown">30:00</span></strong>
				</div>
			</div>

			<!-- 상단 통계 카드 -->
			<div class="d-flex justify-content-center flex-wrap gap-4 mt-4">

				<!-- 노선별 사용자수 통계 -->
				<div class="card shadow-sm p-4"
					style="width: 600px; position: relative;">
					<h3 class="text-center">노선별 사용자수 통계</h3>


					<form class="form-inline-flex mb-3" method="get"
						action="${pageContext.request.contextPath}/admin/stats"
						style="gap: 1rem; align-items: center;"
						onsubmit="showRouteLoading()">

						<div class="form-group" style="flex: 0 0 150px;">
							<label for="region" class="form-label">지역</label> <select
								id="region" name="region" class="form-select"
								style="width: 100%;">
								<option value="">지역 선택</option>
								<option value="24" ${param.region == '24' ? 'selected' : ''}>광주</option>
								<option value="21" ${param.region == '21' ? 'selected' : ''}>부산</option>
								<option value="22" ${param.region == '22' ? 'selected' : ''}>대구</option>
								<option value="26" ${param.region == '26' ? 'selected' : ''}>울산</option>
							</select>
						</div>

						<div class="form-group" style="flex: 0 0 150px;">
							<label for="routeId" class="form-label">노선</label> <select
								id="routeId" name="routeId" class="form-select"
								style="width: 100%;">
								<option value="">노선 선택</option>
							</select>
						</div>

						<div class="form-group" style="flex: 0 0 100px;">
							<label for="month" class="form-label">월</label> <select
								id="month" name="month" class="form-select" style="width: 100%;">
								<option value="1" ${param.month == '1' ? 'selected' : ''}>1월</option>
								<option value="2" ${param.month == '2' ? 'selected' : ''}>2월</option>
								<option value="3" ${param.month == '3' ? 'selected' : ''}>3월</option>
								<option value="4" ${param.month == '4' ? 'selected' : ''}>4월</option>
								<option value="5" ${param.month == '5' ? 'selected' : ''}>5월</option>
								<option value="6" ${param.month == '6' ? 'selected' : ''}>6월</option>
								<option value="7" ${param.month == '7' ? 'selected' : ''}>7월</option>
							</select>
						</div>

						<div class="form-group" style="flex: 0 0 auto;">
							<button type="submit" class="btn btn-primary"
								style="min-width: 70px; height: 38px;">조회</button>
						</div>
						<div></div>
					</form>

					<canvas id="routeChart" width="500" height="300"
						style="width: 500px; height: 300px;"></canvas>

					<div id="routeLoading"
						style="display: none; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(255, 255, 255, 0.7); z-index: 10; align-items: center; justify-content: center;">
						<div class="spinner-border text-primary" role="status">
							<span class="visually-hidden">로딩 중...</span>
						</div>
					</div>

				</div>

				<!-- 정류장별 이용 통계 -->
				<div class="card shadow-sm p-4" style="width: 600px;">
					<h3 class="text-center">정류장별 이용 통계</h3>
					<div class="d-flex justify-content-center gap-3 mb-3">
						<select id="stationRegion" name="stationRegion"
							class="form-select mb-3"
							style="max-width: 200px; margin: 0 auto;">
							<option value="">지역 선택</option>
							<option value="대구">대구</option>
							<option value="부산">부산</option>
							<option value="광주">광주</option>
							<option value="울산">울산</option>
						</select> <select id="statType" class="form-select mb-3"
							style="max-width: 200px; margin: 0 auto;">
							<option value="승차">최다승차정류장</option>
							<option value="하차">최다하차정류장</option>
							<option value="환승">최다환승정류장</option>
						</select>
					</div>
					<canvas id="stationChart" width="500" height="300"></canvas>
				</div>
			</div>

			<!-- 예측 정확도 통계 -->
			<div class="d-flex justify-content-center mt-4">
				<div class="card shadow-sm p-4 w-100" style="max-width: 1200px;">
					<h3 class="text-center mb-4">예측 정확도 통계</h3>


					<div class="d-flex justify-content-center gap-3 mb-4">
						<select id="regionSelect" class="form-select"
							style="width: 150px;">
							<option value="">지역 선택</option>
							<option value="24">광주</option>
							<option value="21">부산</option>
							<option value="22">대구</option>
							<option value="26">울산</option>
						</select> <select id="modelSelect" class="form-select"
							style="width: 150px;">
							<option value="">모델 선택</option>
							<option value="prophet">Prophet</option>
							<option value="xgboost">XGBoost</option>
							<option value="lstm">LSTM</option>
						</select>

						<button id="btnFetchAccuracy" class="btn btn-primary">조회</button>
					</div>


					<canvas id="accuracyChart" style="display: none;"></canvas>
					<div id="accuracyTableContainer" style="margin-top: 20px;"></div>
				</div>
			</div>

		</main>
	</div>

	<%@ include file="include/footer.jsp"%>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

	<!-- 노선별 사용자수 통계 차트 -->
	<script>
	
	function showRouteLoading() {
		  document.getElementById('routeLoading').style.display = 'flex';
		}
		
		
		
    const routeListGwangju = [
        <c:forEach var="route" items="${routeListGwangju}" varStatus="status">
            '${route}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const routeListBusan = [
        <c:forEach var="route" items="${routeListBusan}" varStatus="status">
            '${route}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const routeListDaegu = [
        <c:forEach var="route" items="${routeListDaegu}" varStatus="status">
            '${route}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    
    const routeListUlsan = [
        <c:forEach var="route" items="${routeListUlsan}" varStatus="status">
            '${route}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    function setRouteOptions(routeList) {
        const routeSelect = document.getElementById('routeId');
        routeSelect.innerHTML = '<option value="">노선 선택</option>';
        routeList.forEach(route => {
            const option = document.createElement('option');
            option.value = route;
            option.text = route + '번';
            routeSelect.appendChild(option);
        });
    }

    document.getElementById('region').addEventListener('change', function() {
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

    window.addEventListener('DOMContentLoaded', function() {
        const selectedRegion = document.getElementById('region').value;
        if (selectedRegion === '24') {
            setRouteOptions(routeListGwangju);
        } else if (selectedRegion === '21') {
            setRouteOptions(routeListBusan);
        } else if (selectedRegion === '22') {
            setRouteOptions(routeListDaegu);
        } else if (selectedRegion === '26') {
            setRouteOptions(routeListUlsan);
        }
    });

    // 서버에서 전달받은 routeStats
    const routeStats = [
        <c:forEach var="stat" items="${routeStats}" varStatus="loop">
        {
          date: '<c:out value="${stat.date}" default="없음" />',
          boarding: ${stat.boarding != null ? stat.boarding : 0}
        }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];


    const selectedTerm = '<c:out value="${param.term}" default="1월" />';

    // term에 따라 labels 가공
    let labels;
    if (selectedTerm === '주간') {
    	  // '202406' → '2024-02' 처럼 주차를 월로 변환
    	  labels = routeStats.map(stat => {
    	    const year = stat.date.substring(0, 4);
    	    const week = parseInt(stat.date.substring(4), 10);
    	    const month = String(Math.min(12, Math.ceil(week / 4))).padStart(2, '0');
    	    return `${year}-${month}`;
    	  });
    	} else if (selectedTerm === '일간') {
    	  // 'YYYY-MM-DD' → 'YYYY-MM'
    	  labels = routeStats.map(stat => stat.date ? stat.date.slice(0, 7) : '');
    	} else {
    	  // 월간은 원본 그대로 ('YYYY-MM' 형식)
    	  labels = routeStats.map(stat => stat.date);
    	}

    const data = routeStats.map(stat => stat.boarding);

   
    const ctx = document.getElementById('routeChart').getContext('2d');
	
    
    
    
    	
    if(window.routeChartInstance) {
      window.routeChartInstance.destroy();
    }
    
    window.routeChartInstance = new Chart(ctx, {
    	
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: '탑승 인원',
          data: data,
          borderColor: 'rgba(54, 162, 235, 1)',
          backgroundColor: 'rgba(54, 162, 235, 0.2)',
          fill: true,
          tension: 0.3
        }]
      },
      options: {
        responsive: false,
        maintainAspectRatio: false,
        scales: {
          x: {
            title: { display: true, text: '날짜/기간' }
          },
          y: {
            beginAtZero: true,
            title: { display: true, text: '탑승 인원' },
            max: (() => {
            	  const maxData = Math.max(...data);
            	  if (maxData <= 1000) {
            	    return 1500; // 최대 1500으로 고정하거나,
            	  } else {
            	    // maxData보다 조금 여유 있게 (예: 20% 더)
            	    return Math.ceil(maxData * 1.2);
            	  }
            	})(),
            	ticks: {
            	  stepSize: 100 // 혹은 maxData 크기에 맞춰 동적으로 조절 가능
            	}
          }
        },
        plugins: {
          legend: { display: true }
        }
      },
      plugins: [{
    	    id: 'hideLoaderAfterDraw',
    	    afterDraw: (chart) => {
    	      // 📌 차트가 다 그려지면 로딩창 숨김
    	    }
    	  }]
    });
    
    
    // 정류장별 승차, 하차, 환승 이용 통계
    const stationStats = {
  대구: {
    승차: [
      { station: "약령시건너(동성로입구)", person: 5930 },
      { station: "2.28기념중앙공원앞", person: 3848 },
      { station: "약령시앞", person: 3794 },
      { station: "동대구역건너", person: 3294 },
      { station: "동대구역복합환승센터앞", person: 2949 },
    ],
    하차: [
      { station: "경상감영공원앞", person: 1778 },
      { station: "아양교역(1번출구)", person: 1347 },
      { station: "약령시앞", person: 1341 },
      { station: "동대구역건너", person: 1339 },
      { station: "진천역(2번출구)", person: 1093 },
    ],
    환승: [
      { station: "아양교역(2번출구)", person: 1446 },
      { station: "진천역(1번출구)", person: 1106 },
      { station: "상인현대맨션건너", person: 1061 },
      { station: "아양교역(1번출구)", person: 921 },
      { station: "서부정류장1", person: 813 },
    ],
  },
  부산: {
    승차: [
      { station: "서면역 [부산지하철1호선]", person: 37477 },
      { station: "서면역 [부산지하철2호선]", person: 27956 },
      { station: "사상역 [부산지하철2호선]", person: 23204 },
      { station: "부산역 [부산지하철1호선]", person: 22723 },
      { station: "센텀시티역 [부산지하철2호선]", person: 21540 },
    ],
    하차: [
      { station: "서면역 [부산지하철1호선]", person: 43972 },
      { station: "서면역 [부산지하철2호선]", person: 27546 },
      { station: "사상역 [부산지하철2호선]", person: 22915 },
      { station: "부산역 [부산지하철1호선]", person: 22637 },
      { station: "센텀시티역 [부산지하철2호선]", person: 21724 },
    ],
    환승: [
      { station: "서면역.롯데호텔백화점", person: 7533 },
      { station: "부산역", person: 7151 },
      { station: "사상역 [부산지하철2호선]", person: 6198 },
      { station: "사상역 [부산지하철2호선]", person: 5235 },
      { station: "대저역 [부산지하철3호선]", person: 4609 },
    ],
  },
  광주: {
    승차: [
      { station: "광주종합버스터미널", person: 6424 },
      { station: "광주송정 [광주1호선]", person: 4003 },
      { station: "국립아시아문화전당(구.도청)", person: 3674 },
      { station: "금남로4가 [광주1호선]", person: 3194 },
      { station: "경신여고", person: 2813 },
    ],
    하차: [
      { station: "광주송정 [광주1호선]", person: 3820 },
      { station: "금남로4가 [광주1호선]", person: 3166 },
      { station: "문화전당(구도청) [광주1호선]", person: 3115 },
      { station: "광주종합버스터미널", person: 2777 },
      { station: "상무 [광주1호선]", person: 2453 },
    ],
    환승: [
      { station: "광주종합버스터미널", person: 1839 },
      { station: "남광주역", person: 1600 },
      { station: "경신여고", person: 1531 },
      { station: "송정공원 [광주1호선]", person: 1156 },
      { station: "전남대사거리(동)", person: 907 },
    ],
  },
  울산: {
    승차: [
      { station: "공업탑", person: 5417 },
      { station: "시외고속버스터미널.서울삼성정형외과의원", person: 4635 },
      { station: "KTX울산역", person: 3338 },
      { station: "신정시장", person: 3325 },
      { station: "남목1동", person: 3085 },
    ],
    하차: [
      { station: "공업탑", person: 3435 },
      { station: "태화강역", person: 1540 },
      { station: "신정시장", person: 1483 },
      { station: "시외고속버스터미널", person: 1322 },
      { station: "신복교차로", person: 1217 },
    ],
    환승: [
      { station: "공업탑", person: 2398 },
      { station: "신정시장", person: 710 },
      { station: "농소공영차고지", person: 628 },
      { station: "울산공항", person: 619 },
      { station: "학성공원", person: 548 },
    ],
  }
};

    

    		const regionSelect = document.getElementById('stationRegion');
    		const statTypeSelect = document.getElementById('statType');
    		const stationCtx  = document.getElementById('stationChart').getContext('2d');
    		let stationChartInstance;

    		function updateChart() {
    		  const region = regionSelect.value;
    		  const statType = statTypeSelect.value;

    		  if (!region || !statType || !stationStats[region]) {
    		    if (stationChartInstance) stationChartInstance.destroy();
    		    return;
    		  }

    		  const data = stationStats[region][statType];
    		  const labels = data.map(item => item.station);
    		  const counts = data.map(item => item.person);

    		  if (stationChartInstance) stationChartInstance.destroy();

    		  stationChartInstance = new Chart(stationCtx, {
    		    type: 'bar',
    		    data: {
    		      labels: labels,
    		      datasets: [{
    		        label: statType + ' 인원수',
    		        data: counts,
    		        backgroundColor: 'rgba(54, 162, 235, 0.7)',
    		        borderColor: 'rgba(54, 162, 235, 1)',
    		        borderWidth: 1
    		      }]
    		    },
    		    options: {
    		      responsive: true,
    		      scales: {
    		        y: {
    		          beginAtZero: true,
    		          title: { display: true, text: '인원수 (person)' }
    		        },
    		        x: {
    		          title: { display: true, text: '정류장' }
    		        }
    		      },
    		      plugins: {
    		        legend: { display: true }
    		      }
    		    }
    		  });
    		}

    		// 이벤트 연결
    		regionSelect.addEventListener('change', updateChart);
    		statTypeSelect.addEventListener('change', updateChart);

    		// 페이지 로드 시 기본 차트 그리기
    		window.addEventListener('DOMContentLoaded', () => {
    		  updateChart();
    		});
    		
    		
    		
    		const accuracyLineData = {
    				  '24': { // 광주
    				    prophet: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [88, 90, 91, 92, 90, 89, 91, 93],
    				      predicted: [86, 91, 89, 90, 88, 87, 90, 92]
    				    },
    				    xgboost: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [88, 90, 91, 92, 90, 89, 91, 93],
    				      predicted: [93, 94, 95, 96, 94, 93, 95, 97]
    				    },
    				    lstm: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [88, 90, 91, 92, 90, 89, 91, 93],
    				      predicted: [85, 83, 82, 84, 83, 82, 84, 85]
    				    }
    				  },
    				  '21': { // 부산
    				    prophet: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [85, 87, 89, 90, 88, 87, 89, 91],
    				      predicted: [84, 86, 88, 89, 87, 86, 88, 90]
    				    },
    				    xgboost: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [85, 87, 89, 90, 88, 87, 89, 91],
    				      predicted: [92, 93, 91, 94, 92, 91, 93, 95]
    				    },
    				    lstm: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [85, 87, 89, 90, 88, 87, 89, 91],
    				      predicted: [80, 82, 81, 83, 82, 81, 83, 84]
    				    }
    				  },
    				  '22': { // 대구
    				    prophet: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [84, 86, 87, 89, 88, 87, 89, 90],
    				      predicted: [86, 88, 87, 89, 87, 88, 90, 91]
    				    },
    				    xgboost: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [84, 86, 87, 89, 88, 87, 89, 90],
    				      predicted: [91, 93, 92, 94, 93, 92, 94, 95]
    				    },
    				    lstm: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [84, 86, 87, 89, 88, 87, 89, 90],
    				      predicted: [79, 81, 80, 82, 81, 80, 82, 83]
    				    }
    				  },
    				  '26': { // 울산
    				    prophet: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [83, 85, 86, 88, 87, 86, 88, 89],
    				      predicted: [85, 87, 86, 88, 86, 87, 89, 90]
    				    },
    				    xgboost: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [83, 85, 86, 88, 87, 86, 88, 89],
    				      predicted: [90, 92, 91, 93, 92, 91, 93, 94]
    				    },
    				    lstm: {
    				      labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월'],
    				      actual:    [83, 85, 86, 88, 87, 86, 88, 89],
    				      predicted: [78, 79, 80, 81, 80, 79, 81, 82]
    				    }
    				  }
    				};


    		
    		document.getElementById('btnFetchAccuracy').addEventListener('click', function () {
    			  const region = document.getElementById('regionSelect').value;
    			  const model = document.getElementById('modelSelect').value;
    			  const tableContainer = document.getElementById('accuracyTableContainer');

    			  if (!region || !model) {
    			    alert('지역과 모델을 모두 선택하세요.');
    			    return;
    			  }

    			  const regionData = accuracyLineData[region];

    			  if (!regionData) {
    			    alert('데이터 없음');
    			    return;
    			  }

    			  // 그래프 숨기기
    			  const chartCanvas = document.getElementById('accuracyChart');
    			  chartCanvas.style.display = 'none';

    			  // 기존 테이블 제거
    			  tableContainer.innerHTML = '';

    			  // 모델별 데이터 테이블 생성
    			  if (model !== 'all') {
    			    const modelData = regionData[model];

    			    const table = document.createElement('table');
    			    table.classList.add('accuracy-table');
    			    table.style.borderCollapse = 'collapse';
    			    table.style.width = '100%';
    			    table.style.marginBottom = '20px';

    			    // 테이블 헤더
    			    const headerRow = document.createElement('tr');
    			    ['월', '실제 정확도 (%)', '예측 정확도 (%)', '오차 (%)'].forEach(text => {
    			      const th = document.createElement('th');
    			      th.innerText = text;
    			      th.style.border = '1px solid #ccc';
    			      th.style.padding = '8px';
    			      th.style.backgroundColor = '#f4f4f4';
    			      headerRow.appendChild(th);
    			    });
    			    table.appendChild(headerRow);

    			    // 데이터 행
    			    modelData.labels.forEach((label, i) => {
    			      const actual = modelData.actual[i];
    			      const predicted = modelData.predicted[i];
    			      const errorPercent = (((predicted - actual) / actual) * 100).toFixed(2);
    			      const diffFormatted = (errorPercent > 0 ? '+' : '') + errorPercent + '%';

    			      const row = document.createElement('tr');
    			      [label, actual, predicted, diffFormatted].forEach(val => {
    			        const td = document.createElement('td');
    			        td.innerText = val;
    			        td.style.border = '1px solid #ccc';
    			        td.style.padding = '8px';
    			        td.style.textAlign = 'center';
    			        row.appendChild(td);
    			      });

    			      table.appendChild(row);
    			    });

    			    tableContainer.appendChild(table);
    			  } else {
    			    // 전체일 경우 모델별로 나눠서 표시
    			    Object.entries(regionData).forEach(([modelKey, m]) => {
    			      const title = document.createElement('h4');
    			      title.innerText = `📌 ${modelKey.toUpperCase()}`;
    			      tableContainer.appendChild(title);

    			      const table = document.createElement('table');
    			      table.style.borderCollapse = 'collapse';
    			      table.style.width = '100%';
    			      table.style.marginBottom = '20px';

    			      // 헤더
    			      const headerRow = document.createElement('tr');
    			      ['월', '실제 정확도 (%)', '예측 정확도 (%)', '오차 (%)'].forEach(text => {
    			        const th = document.createElement('th');
    			        th.innerText = text;
    			        th.style.border = '1px solid #ccc';
    			        th.style.padding = '8px';
    			        th.style.backgroundColor = '#f9f9f9';
    			        th.style.textAlign = 'center';
    			        th.style.display = 'table-cell'; // ✅ 추가
    			        th.style.verticalAlign = 'middle'; // 수직 중앙 정렬까지 원하면 이 줄도 추가
    			        headerRow.appendChild(th);
    			      });
    			      table.appendChild(headerRow);

    			      // 데이터 행
    			      m.labels.forEach((label, i) => {
    			        const actual = m.actual[i];
    			        const predicted = m.predicted[i];
    			        const diff = predicted - actual;

    			        const row = document.createElement('tr');
    			        [label, actual, predicted, diff > 0 ? `+${diff}` : diff].forEach(val => {
    			          const td = document.createElement('td');
    			          td.innerText = val;
    			          td.style.border = '1px solid #ccc';
    			          td.style.padding = '8px';
    			          td.style.textAlign = 'center';
    			          row.appendChild(td);
    			        });

    			        table.appendChild(row);
    			      });

    			      tableContainer.appendChild(table);
    			    });
    			  }
    			});







    
</script>





</body>
</html>
