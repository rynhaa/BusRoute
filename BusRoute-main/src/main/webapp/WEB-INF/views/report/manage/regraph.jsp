<%@ page contentType="text/html; charset=UTF-8" %>
<%
    request.setAttribute("activeMenu", "report");

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
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>불편접수 통계 관리</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body, html {
      margin: 0; padding: 0; height: 100%;
      background-color: #f8f9fa;
      font-family: 'Noto Sans KR', sans-serif;
    }

    header, nav, .navbar, .topbar {
      margin-bottom: 0 !important;
      padding-bottom: 0 !important;
    }

    .main-container {
      padding: 20px 30px;
      max-width: 1200px;
      margin: 0px 0px 0px 460px;
      min-height: calc(100vh - 70px);
      display: flex;
      flex-direction: column;
      gap: 15px;
    }

    .top-filters {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }

    .filter-box {
	  display: flex;
	  flex-wrap: wrap;
	  gap: 12px 12px;
	  color: #333;
	  justify-content: space-between; /* 요소들을 양 끝으로 배치 */
	}
	
	.filter-box label {
	  display: flex;
	  align-items: center;
	  gap: 6px;
	  font-size: 1rem;
	}
	
	.filter-box select,
	.filter-box input[type="date"] {
	  padding: 1px 10px;
	  border-radius: 5px;
	  border: 1px solid #ccc;
	  height: 34px;
	  font-size: 1rem;
	  min-width: 120px;
	}
	
	.filter-box .btn-box {
	  display: flex;
	  justify-content: flex-end; /* 버튼을 우측으로 정렬 */
	  gap: 8px;
	  width: 100%; /* 버튼이 부모 요소 전체 너비를 차지하도록 */
	}
	
	.filter-box button {
	  min-width: 50px;
	  font-weight: 600;
	  font-size: 0.9rem;
	}

    .avg-process-time-card {
      min-width: 180px;
      background-color: #e7f1ff;
      border-radius: 12px;
      padding: 14px 18px;
      color: #0d6efd;
      font-weight: 600;
      box-shadow: 0 4px 10px rgba(13,110,253,0.3);
      user-select: none;
      text-align: center;
      font-size: 0.95rem;
      flex-shrink: 0;
    }
    .avg-process-time-card h5 {
      font-weight: 700;
      margin-bottom: 6px;
      font-size: 1.1rem;
    }
    .avg-process-time-card p {
      margin: 0;
      font-size: 1.2rem;
      letter-spacing: 0.5px;
    }

     #totalCountBox {
      margin-top : 20px;
      font-weight: 500;
      font-size: 1.0rem;
      color: #212529;
      text-align: center;
    } 

    .charts-row {
      display: flex;
      gap: 25px;
      flex-wrap: wrap;
      justify-content: center;
    }

    .chart-container {
      flex: 1 1 48%;
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 6px 12px rgba(0,0,0,0.12);
      padding: 30px 20px 20px;
      text-align: center;
      max-width: 550px;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
    }

    .chart-container h3 {
      font-weight: 700;
      color: #222;
      margin-bottom: 12px;
      user-select: none;
    }

    #top3Label {
      margin-top: 12px;
      font-size: 0.95rem;
    }

    #top3Label h6 {
      margin-bottom: 6px;
      color: #0d6efd;
      font-weight: 700;
    }

    #top3Label ul {
      list-style: none;
      padding-left: 0;
      margin: 0;
    }

    #top3Label li {
      margin: 4px 0;
      font-weight: 600;
      color: #333;
    }

    .rank {
      font-weight: 700;
      margin-right: 8px;
    }

    .rank-1 { color: #e74c3c; }
    .rank-2 { color: #f39c12; }
    .rank-3 { color: #3498db; }

	canvas {
	  max-width: 100% !important;
	}
	
	.stats-row {
	  display: flex;
	  margin-left : 10px;
	  flex-direction: row;
	  gap: 12px;
	  align-items: flex-start;
	  justify-content: flex-start;
	  max-width: 500px; /* ✅ 너비 제한 */
	}

	.top-filters {
	  display: flex;
	  flex-direction: row;  /* 가로 정렬 */
	  align-items: flex-start;
	  gap: 16px;
	  padding: 5px 0;
	  max-width: 100%;
	  flex-wrap: wrap;
	}
	
	.avg-process-time-card {
	  background: #eef5ff;
	  padding: 12px 20px;
	  border-radius: 12px;
	  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
	  min-width: 180px;
	  max-width: 240px;
	  width: auto;
	  text-align: center;
	}
	
	.avg-process-time-card h4,
	.avg-process-time-card h5 {
	  margin: 0 0 4px 0;
	  font-weight: bold;
	  color: #267eff;
	}
	
	.avg-process-time-card p {
	  font-size: 1.2rem;
	  margin: 0;
	  color: #111;
	}

  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/include/nav.jsp" %>

<main class="main-container" role="main" aria-label="불편접수 통계 관리">

  <section class="top-filters" aria-label="검색 필터 및 평균 처리시간">

	  <div class="stats-row">
	    <div class="avg-process-time-card">
	      <h5>평균 처리 시간</h5>
	      <p>${avgProcessTime}</p>
	    </div>
	
	    <div class="avg-process-time-card">
	      <h5>처리율</h5>
	      <p>${completionRate}%</p>
	    </div>
	  </div>
    
  </section>

  

  <section class="charts-row">
    <article class="chart-container">
      <h3>📅 일별 접수 건수</h3>
	      <div class="filter-box">
	      <label for="category">유형:
	        <select id="category">
	          <option value="">전체</option>
	          <option value="노선 문제">노선 문제</option>
	          <option value="운행 시간 문제">운행 시간 문제</option>
	          <option value="정류장 문제">정류장 문제</option>
	          <option value="정보 문제">정보 문제</option>
	          <option value="서비스 문제">서비스 문제</option>
	          <option value="요금 문제">요금 문제</option>
	          <option value="기타">기타</option>
	        </select>
	      </label>
	      <br>
	
	      <label for="fromDate">날짜:
	        <input type="date" id="fromDate" /> ~
	        <input type="date" id="toDate" />
	      </label>
			<div class="btn-box">
		      <button type="button" class="btn btn-primary btn-sm" onclick="handleSearch()">검색</button>
		      <button type="button" class="btn btn-secondary btn-sm" onclick="resetFilters()">초기화</button>
		    </div>
	    </div>
	    <div id="totalCountBox">전체 접수 건수: <span id="totalCount">0</span> 건</div>
      <canvas id="dailyChart"></canvas>
    </article>
    
	<article class="chart-container">
	  <h3>⏰ 시간대별 접수/처리 분석</h3>
	  <canvas id="hourlyChart"></canvas>
	</article>

    <article class="chart-container">
      <h3>🥧 유형별 비율</h3>
      <canvas id="categoryPieChart"></canvas>
      <div id="top3Label"></div>
    </article>

    <article class="chart-container">
      <h3>📊 상태별 접수 통계</h3>
      <canvas id="statusChart"></canvas>
    </article>
  </section>

</main>

<script>
let dailyChart, pieChart, statusChart;

//오늘 날짜를 yyyy-mm-dd 형식으로 반환
function getTodayDate() {
return new Date().toISOString().split("T")[0]; // ISO 형식에서 날짜 부분만 추출
}

//날짜 필드에 최대값 설정 (오늘 날짜)
function setMaxDate() {
const today = getTodayDate();
document.getElementById("fromDate").max = today; // fromDate의 최대값을 오늘로 설정
document.getElementById("toDate").max = today;   // toDate의 최대값을 오늘로 설정
}

//필터 파라미터를 가져오는 함수 (카테고리, 시작일, 종료일)
function getFilterParams() {
const from = document.getElementById("fromDate").value;
const to = document.getElementById("toDate").value;
const category = document.getElementById("category")?.value || ""; // category 값 가져오기 (없으면 빈 문자열)

const params = { category };

if (from) params.from = from; // 시작일이 있으면 추가
if (to) params.to = to;     // 종료일이 있으면 추가

return params;
}

//검색 실행 함수 (검색 버튼 클릭 시 호출)
function handleSearch() {
const params = getFilterParams(); // 필터 파라미터 가져오기

// fromDate와 toDate가 있을 경우 날짜 비교
if (params.from && params.to) {
 const fromDate = new Date(params.from); // 시작일
 const toDate = new Date(params.to);     // 종료일
 
 fromDate.setHours(0, 0, 0, 0);  // 시작일의 시간을 00:00:00으로 설정
 toDate.setHours(23, 59, 59, 999); // 종료일의 시간을 23:59:59으로 설정

 if (fromDate > toDate) {
   alert("시작 날짜는 종료 날짜보다 이전이어야 합니다.");
   return; // 날짜 범위가 잘못되었을 경우 경고하고 함수 종료
 }

 // 날짜 범위를 포함한 새로운 필터 파라미터
 params.from = fromDate.toISOString();
 params.to = toDate.toISOString();
}

// 날짜가 유효하면 나머지 데이터 로딩 함수 호출
loadTotalCount(params);
loadDailyChart(params);
loadCategoryPie(params);
loadStatusChart(params);
loadHourlyChart();
}

//검색 필터 초기화 함수 (초기화 버튼 클릭 시 호출)
function resetFilters() {
document.getElementById("category").value = "";  // 카테고리 초기화
document.getElementById("fromDate").value = "";  // 시작일 초기화
document.getElementById("toDate").value = "";    // 종료일 초기화
handleSearch();  // 초기화 후 다시 검색 실행
}

//전체 접수 건수 로드 함수
function loadTotalCount(params) {
const query = new URLSearchParams(params).toString(); // params를 URL 쿼리 문자열로 변환
fetch('/report/manage/totalCount?' + query)
 .then(res => res.json())
 .then(data => {
   document.getElementById('totalCount').textContent = data.total || 0; // 총 접수 건수 표시
 })
 .catch(console.error); // 에러 처리
}

//일별 접수 건수 차트 로드 함수
function loadDailyChart(params) {
const query = new URLSearchParams(params).toString(); // params를 URL 쿼리 문자열로 변환
fetch('/report/manage/dailyStats?' + query)
 .then(res => res.json())
 .then(data => {
   const labels = data.map(item => item.day);  // 날짜
   const values = data.map(item => item.count); // 접수 건수

   if (dailyChart) dailyChart.destroy(); // 기존 차트가 있으면 제거

   const ctx = document.getElementById('dailyChart').getContext('2d'); // 차트 캔버스 컨텍스트 얻기
   dailyChart = new Chart(ctx, {
     type: 'bar', // 막대 차트
     data: {
       labels: labels, // X축 데이터: 날짜
       datasets: [{
         label: '일별 접수 건수', // 데이터셋 라벨
         data: values,          // Y축 데이터: 접수 건수
         backgroundColor: 'rgba(75, 192, 192, 0.5)', // 배경색
         borderColor: 'rgba(75, 192, 192, 1)', // 테두리 색
         borderWidth: 1 // 테두리 두께
       }]
     },
     options: {
       responsive: true,
       layout: { padding: { top: 30 } }, // 차트 레이아웃 패딩 설정
       scales: {
         x: { ticks: { autoSkip: true, maxTicksLimit: 15 } }, // X축 설정 (자동 건너뛰기, 최대 15개)
         y: { beginAtZero: true, precision: 0 } // Y축 설정 (0부터 시작, 정수 표시)
       },
       plugins: {
         title: { display: true, text: '일별 불편접수 현황' } // 차트 제목
       }
     }
   });
 })
 .catch(console.error); // 에러 처리
}

//초기화 시 날짜 제한 설정
document.addEventListener("DOMContentLoaded", setMaxDate); // 페이지 로딩 후 최대 날짜 설정

  
  
  function loadCategoryPie(params) {
    const query = new URLSearchParams(params).toString();
    fetch('/report/manage/categoryStats?' + query)
      .then(res => res.json())
      .then(data => {
		  if (pieChart) pieChart.destroy();
		  if (!data || data.length === 0) {
		    document.getElementById("top3Label").innerHTML = "";
		    return;
		  }
		
		  const labels = data.map(item => item.category);
		  const values = data.map(item => item.count);
		
		  // 🔧 count 기준 내림차순 정렬
		  const sorted = [...data].sort((a, b) => b.count - a.count);
		  const top3 = sorted.slice(0, 3);
		
		  let html = '<h6>TOP 3 유형</h6><ul>';
		  top3.forEach(function(item, i) {
		    html += '<li><span class="rank rank-' + (i + 1) + '">' + (i + 1) + '위</span> ' + item.category + '</li>';
		  });
		  html += '</ul>';
		  document.getElementById("top3Label").innerHTML = html;
		
		  const ctx = document.getElementById('categoryPieChart').getContext('2d');
		  pieChart = new Chart(ctx, {
		    type: 'pie',
		    data: {
		      labels: labels,
		      datasets: [{
		        data: values,
		        backgroundColor: [
		          '#ff6384', '#36a2eb', '#ffcd56',
		          '#4bc0c0', '#9966ff', '#ff9f40', '#ccc'
		        ]
		      }]
		    },
		    options: {
		      responsive: true,
		      maintainAspectRatio: true,
		      plugins: {
		        title: { display: true, text: '유형별 불편접수 비율' },
		        legend: { position: 'bottom' }
		      }
		    }
		  });
		})

      .catch(console.error);
  }

  function loadStatusChart(params) {
    const query = new URLSearchParams(params).toString();
    fetch('/report/manage/statusStats?' + query)
      .then(res => res.json())
      .then(data => {
        if (statusChart) statusChart.destroy();
        if (!data || data.length === 0) return;

        const labels = data.map(item => item.status);
        const values = data.map(item => item.count);

        const ctx = document.getElementById('statusChart').getContext('2d');
        statusChart = new Chart(ctx, {
          type: 'doughnut',
          data: {
            labels: labels,
            datasets: [{
              data: values,
              backgroundColor: ['#36a2eb', '#ffcd56', '#4bc0c0']
            }]
          },
          options: {
            responsive: true,
            plugins: {
              title: { display: true, text: '상태별 불편접수 통계' },
              legend: { position: 'bottom' }
            }
          }
        });
      })
      .catch(console.error);
  }
  
  function loadHourlyChart() {
	  fetch('/report/manage/hourly-stats')
	    .then(res => res.json())
	    .then(data => {
		  const ctx = document.getElementById('hourlyChart').getContext('2d');
		
		  if (window.hourlyChart instanceof Chart) {
		    window.hourlyChart.destroy();
		  }
		
		  // 2시간 단위 (12개)
		  const labels = [];
		  for (let h = 0; h < 24; h += 2) {
		    labels.push(String(h).padStart(2, '0') + '시');
		  }
		
		  const createdHourly = data.created ?? new Array(24).fill(0);
		  const repliedHourly = data.replied ?? new Array(24).fill(0);
		
		  const created2h = [];
		  const replied2h = [];
		
		  for (let i = 0; i < 24; i += 2) {
		    created2h.push(createdHourly[i] + createdHourly[i + 1]);
		    replied2h.push(repliedHourly[i] + repliedHourly[i + 1]);
		  }
		
		  // ▶ 최대값 계산 후 +5 여유 주기
		  const maxCount = Math.max(...created2h, ...replied2h);
		  const yMax = maxCount + 2;
		
		  window.hourlyChart = new Chart(ctx, {
		    type: 'bar',
		    data: {
		      labels,
		      datasets: [
		        {
		          label: '접수 건수',
		          data: created2h,
		          backgroundColor: 'rgba(255, 99, 132, 0.5)',
		          borderColor: 'rgba(255, 99, 132, 1)',
		          borderWidth: 1
		        },
		        {
		          label: '처리 건수',
		          data: replied2h,
		          backgroundColor: 'rgba(54, 162, 235, 0.5)',
		          borderColor: 'rgba(54, 162, 235, 1)',
		          borderWidth: 1
		        }
		      ]
		    },
		    options: {
		      responsive: true,
		      plugins: {
		        title: {
		          display: true,
		          text: '2시간 단위 접수 및 처리 건수'
		        },
		        legend: {
		          position: 'bottom'
		        }
		      },
		      scales: {
		        x: {
		          type: 'category',
		          ticks: {
		            autoSkip: false
		          }
		        },
		        y: {
		          beginAtZero: true,
		          max: yMax, // ← 여유 포함한 최대값 지정
		          title: {
		            display: true
		          }
		        }
		      }
		    }
		  });
		})

	    .catch(console.error);
	}

  document.addEventListener("DOMContentLoaded", () => {
    handleSearch();
  });
</script>
</body>
</html>
