<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>버스 노선 정보</title>
<c:if test="${not empty message}">
    <script>
        alert('${message}');
    </script>
</c:if>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/header.css" rel="stylesheet">
<style>
html, body {
  height: 100%;
  margin: 0;
}
.container { 
	display: flex; 
	flex-direction: column;
	gap: 30px; 
	padding: 20px;
	width:90%;
	max-width: 1200px; 
	margin: 0 auto;
	padding-bottom:100px;
}

#BusSearch {
    padding: 16px 12px 16px 36px; 
    font-size: 14px;
    border: 2px solid rgb(59, 80, 122);
    border-radius: 4px;
    margin-bottom:10px;
    background: url('/resources/image/search-icon.png') no-repeat 10px center;
    background-size: 18px 18px; 
    background-color:#fff;
}

.bus-list-container,
.route-info {
  display: flex;
  flex-direction: column;
}

.bus-list-container {
    width: 50%;
    gap: 10px;
}

.bus-list {
  	max-height: 600px;
    overflow-y: auto;
    border: 2px solid rgb(59, 80, 122);
    background-color:#fff;
    border-radius: 4px;
    color:#444444;
    font-size:13.5px;
}
.route-info {
	width : 50%;
	max-height: 675px;
    overflow-y: auto;
    border: 2px solid rgb(59, 80, 122);
    background-color:#fff;
    border-radius: 4px;
    color:#444444;
    font-size:13.5px;
}
.bus-list::-webkit-scrollbar {
    width: 8px;
}

.bus-list::-webkit-scrollbar-track {
    background: #e0e0e0;
    border-radius: 4px;
}

.bus-list::-webkit-scrollbar-thumb {
    background-color: rgb(59, 80, 122);
    border-radius: 4px;
}

.bus-list::-webkit-scrollbar-thumb:hover {
    background-color: rgba(59, 80, 122, 0.85);
}
.bus-list h5, .route-info h5 {
  margin-top: 0;
  margin-bottom: 15px;
  color: rgb(59, 80, 122);
  font-weight: 700;
}
.bus-item {
  padding: 12px 16px;
  border-bottom: 1px solid #eee;
  cursor: pointer;
  transition: background-color 0.25s ease;
  font-size: 14px;
  border-radius: 4px;
}
.bus-item:hover {
  background-color: rgb(78 84 200 / 0.1);
  color: rgb(78, 84, 200);
}
.bus-item.selected {
  background-color: rgba(78, 84, 200, 0.2);
  color: rgb(78, 84, 200);
  font-weight: bold;
  border-left: 4px solid #4e54c8;
}

.route-info ul {
  margin: 0;
  list-style: none;
}

.route-info li {
  padding: 10px 12px;
  border-bottom: 1px solid #ddd;
  font-size: 14px;
}
#loadingOverlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  backdrop-filter: blur(4px);
  z-index: 9999;

  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  font-weight: bold;
  font-size: 1.5rem;
  text-align: center;
  
  height: 100vh; /* 화면 전체 높이 */
  min-height: 400px; 
  
  padding-top:400px;
}
.loadingSpinner {
  margin: 0 auto 15px auto;
  border: 5px solid rgba(255, 255, 255, 0.3);
  border-top: 5px solid white;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;
  margin-bottom: 15px;
  display:block;
}
.loadingText {
  text-align: center;
  width: 100%;
  margin-top: -5px; /* 위쪽 마진 조절해서 텍스트 올리기 */
}
.city-selector-card {
  position: sticky;
  top: 20px;
  z-index: 1000;
  background-color: #fff;
  padding: 15px 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgb(0 0 0 / 0.1);
  max-width: 1200px;
  margin: 0 auto 15px auto;

  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 12px;
  width: 100%;
}
#cityFilterButtons {
	margin: 10px 0; 
	display: flex; 
	justify-content: center; 
	gap: 10px; 
	flex-wrap: wrap;
}
.btn-city {
    background-color: white;
    color: #4e54c8;
    border: 2px solid #4e54c8;
    font-weight: 500;
    transition: all 0.3s ease;
}
.btn-city:hover,
.btn-city.active {
    background-color: #4e54c8;
    color: white;
    border-color: #4e54c8;
}

/* 노선 스타일용 클래스 */
.station-placeholder {
	padding : 20px;
}
.station-line {
  padding: 0;
  display: flex;
  flex-direction: column;
  position: relative;
}

.station-node {
  position: relative;
  padding: 15px 0 15px 35px;
  font-size: 15px;
  font-weight: 500;
  display: flex;
  align-items: center;
}

.circle {
  width: 14px;
  height: 14px;
  background-color: #4e54c8;
  border-radius: 50%;
  position: absolute;
  left: 10px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 2;
}

.line {
  position: absolute;
  left: 16px;
  top: 0;
  bottom: 0;
  width: 2px;
  background-color: #ccc;
  z-index: 1;
}

.station-info {
  color: #333;
}

.station-node.hover-target:hover {
  background-color: rgba(78, 84, 200, 0.08);
  cursor: pointer;
}

.station-node.hover-target:hover .circle {
  background-color: #99cc66;
}

.station-node.hover-target:hover .station-info {
  font-weight: bold;
  color: #222;
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

@media (max-width: 768px) {
  #cityFilterButtons {
    flex-direction: column;
    align-items: center;
  }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@media (max-width: 768px) {
  .bus-route-container {
    flex-direction: column;
    height: auto;
  }
  .bus-list, .route-info {
    height: auto;
  }
  .city-selector-card {
    position: static;
    margin-bottom: 15px;
  }
}
.bus-icon {
  position: absolute;
  width: 30px;
  height: 30px;
  left: 2px;  /* circle 기준 왼쪽 살짝 이동 */
  top: 50%;
  transform: translateY(-50%);
  z-index: 999; /* circle 위에 표시 */
}

@keyframes blink {
    0% { opacity: 1; }
    50% { opacity: 0.5; }
    100% { opacity: 1; }
}
#routeHeader {
	border-bottom: 1px solid #ccc;
	padding : 15px !important;
}
#map {
    width: 100%;
    height: 400px;
    display: block;
    margin-top: 10px;
    position: relative; 
}
.marker-tooltip {
    background-color: rgba(0, 0, 0, 0.7) !important;
    color: #fff !important;
    padding: 5px !important;
    margin-left : 45px !important;
    border-radius: 3px !important;
    font-size: 12px !important;
    pointer-events: none !important; /* 툴팁이 마커 클릭에 영향을 주지 않도록 */
    z-index: 9999 !important; /* 다른 요소들보다 위에 보이게 설정 */
}
.arr-time {
    color: #e74c3c; /* 빨간색 */
    font-weight: bold;
    font-size:14px;
}

.favorite-btn {
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
    margin-left: 5px;
    color: gold;
}

#routeStationList {
    max-height: 600px; /* 원하는 높이 */
    overflow-y: auto;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<div id="loadingOverlay" style="display:block;">
  <div class="loadingSpinner"></div>
  <div class="loadingText">데이터 불러오는 중...</div>
</div>
<div id="wrapper">
	<h3>버스노선 검색</h3>
	
	<!-- 지역선택 -->
     <div id="cityFilterButtons">
        <button type="button" class="btn btn-city active" data-city="26">울산</button>
	    <button type="button" class="btn btn-city" data-city="24">광주</button>
	    <button type="button" class="btn btn-city" data-city="21">부산</button>
	    <button type="button" class="btn btn-city" data-city="22">대구</button>
     </div>
	
	<div class="container">
		<div style="display: flex; gap: 20px;">
			<div class="bus-list-container">
				<input type="text" id="BusSearch" placeholder="버스정보 검색" />
			    <div class="bus-list">
			        <div id="busList"></div>
			    </div>
		    </div>
		
		    <div class="route-info">
		    	<div id="routeHeader" style="padding:10px 0; font-weight:bold; color:#4e54c8;"></div>
		    	<div id="routeStationList" class="station-line">
			    	<div class="station-placeholder">버스를 선택하면 노선이 표시됩니다.</div>
			  	</div>
		    </div>
	    </div>
	    
	    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5c8fdb069b91970ac2772cc7de370f6a"></script>
	    <div id="map" style="width:100%; height:400px; margin-top:20px;"></div>
	</div>
	
</div>
<script>
let selectedCity = "26"; // 기본: 울산
let map; // 전역 지도 변수
const contextPath = "${pageContext.request.contextPath}";
const cityCoordinates = {
	    "26": { lat: 35.538377, lng: 129.311479 },  // 울산
	    "24": { lat: 35.1595, lng: 126.8526 },     // 광주
	    "21": { lat: 35.1796, lng: 129.0756 },     // 부산
	    "22": { lat: 35.8717, lng: 128.6014 },     // 대구
	};
	
// 즐겨찾기 함수
function toggleFavorite(routeId, btnElement) {
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
                $(btnElement).find("img").attr("src", contextPath + "/resources/image/star_on.png");
                alert("즐겨찾기에 저장되었습니다.");
            } else if (response.status === "removed") {
                $(btnElement).find("img").attr("src", contextPath + "/resources/image/star_off.png");
            }
        },
        error: function() {
            alert("즐겨찾기 처리 중 오류가 발생했습니다.");
        }
    });
}

$(document).ready(function() {
	
	console.log($('#map'));  // #map 요소가 정상적으로 존재하는지 확인

    if ($('#map').length > 0) {
        initMap(); // DOM에 #map 요소가 있을 때만 지도 초기화
    }
	
	$("#loadingOverlay").show();
    // 초기 로딩
    loadBusList(selectedCity);

    // 지역 버튼 클릭
    $(".btn-city").click(function() {
	    $("#loadingOverlay").show();
	    $(".btn-city").removeClass("active");
	    $(this).addClass("active");
	
	    selectedCity = $(this).data("city");
	    $("#BusSearch").val(""); // 검색어 초기화
	    $("#busList").empty();
	    $("#routeStationList").html("<div class='station-placeholder'>버스를 선택하면 노선이 표시됩니다.</div>");
	    
	 	// 지도 중심을 선택된 지역으로 변경
	    updateMapCenter(selectedCity);
	 
	    loadBusList(selectedCity, "");
	});
    
    $("#BusSearch").on("input", function () {
        const keyword = $(this).val();
        //$("#loadingOverlay").show();
        loadBusList(selectedCity, keyword);
    });

    // 버스 목록 가져오기
    function loadBusList(cityCode, keyword) {
        $.ajax({
            url: "/api/bus-list",
            type: "GET",
            data: { 
            	cityCode: cityCode,
            	keyword: keyword
            },
            success: function(data) {
            	console.log("받은 데이터:", data);
                if (data.length === 0) {
                    $("#busList").html("<div class='station-placeholder'>해당 지역에 버스 정보가 없습니다.</div>");
                    return;
                }
                
                let html = "";
                data.forEach(function(bus) {
	                let routeLabel = getRouteLabel(bus);
	                let badgeClass = getRouteTypeClass(routeLabel);
	                let isFavorited = bus.is_favorite;
	                
                	html += "<div class='bus-item' data-route-id='" + bus.route_id + "'>" +
                    "<span class='badge " + badgeClass + "'>" + routeLabel + "</span>" +
                    "<strong>" + bus.bus_number + "</strong> (" + bus.start_station_name + " → " + bus.end_station_name + ")" +
                    " <button type='button' class='favorite-btn' onclick='event.stopPropagation(); toggleFavorite(\"" + bus.route_id + "\", this)'>" +
                    (isFavorited ? "<img src='" + contextPath + "/resources/image/star_on.png' style='width:15px;height:15px;' />" : "<img src='" + contextPath + "/resources/image/star_off.png' style='width:15px;height:15px;'/>") +
                     "</button>" +
                     "</div>";
                });

                $("#busList").html(html);
                $("#loadingOverlay").hide();
            },
            error: function() {
                $("#busList").html("<div>버스 목록을 불러오지 못했습니다.</div>");
                $("#loadingOverlay").hide();
            }
        });
    }
    
    
 	// 랜덤 속도 계산 함수 (30~60 km/h 사이)
    const getRandomSpeed = () => {
        return Math.floor(Math.random() * (60 - 30 + 1)) + 30; // 30 ~ 60 사이의 정수 반환
    };
    
 	// 각 버스의 도착시간을 구할 함수
    /* const calculateArrivalTime = (currentStation, nextStation) => {
        const speed = getRandomSpeed(); // 랜덤 속도
        const distance = getDistance(currentStation, nextStation); // 두 정류장 사이의 거리 계산
        const timeInMinutes = (distance / speed) * 60; // 시간 계산 (분 단위)
        console.log("Speed: " + speed + " km/h, Distance: " + distance + "km, Time: " + Math.round(timeInMinutes) + " minutes");
        return Math.round(timeInMinutes); // 분 단위로 반환
    }; */
    
 	// 각 버스의 도착시간을 구할 함수
    const calculateArrivalTime = (currentStation, nextStation) => {
        const distance = getDistance(currentStation, nextStation); // 두 정류장 사이의 거리 계산 (getDistance는 위경도 거리 계산 함수)
        const timeInMinutes = (distance / averageSpeed) * 60; // 평균 속도 km/h, 결과는 분 단위
        return Math.round(timeInMinutes);
    };
    
    function renderRouteStationsWithBus(stations, busLocations, busNumber) {
        // 버스가 위치한 정류장 nodeid 목록 저장
        const locationMap = {};
        const arrivalMap = {};  // 각 정류장에 도착 예정 시간을 저장
        
        busLocations.forEach(bus => {
        	const nodeId = String(bus.nodeid);
        	console.log("bus.nodeid : ", nodeId);
        	const arrivalTime = bus.arrivalTime;  // 도착 예정 시간
        	
        	if (!locationMap[nodeId]) {
                locationMap[nodeId] = [];
                arrivalMap[nodeId] = [];
            }
            locationMap[nodeId].push(bus.vehicleno);
         	// 도착 정보 없으면 메시지 출력
            arrivalMap[nodeId].push(arrivalTime || "도착정보가 없습니다.");
        });

        stations.sort((a, b) => a.station_order - b.station_order);
        console.log("busLocations:", busLocations);
        
        let busFound = false; // 버스를 찾았는지 여부
        let busArrivalTimesMap = {};  // 각 버스별 도착 시간을 관리
        let listHtml = ""; 
        
        console.log("Stations Array Length: ", stations.length);
        let lastStationIndex = stations.length - 1;
     	// 각 정류장에 대한 도착 시간 계산 (버스를 한 번만 순회)
        stations.forEach(function(station, index) {
            const routeNumber = (station.city_code === 22 && station.station_order >= 1001) ? station.station_order - 1000 : station.station_order;
            const stationText = routeNumber + " . " + station.sttn_nm + (station.direction ? " (" + station.direction + ")" : "");
            const stationArsNo = station.sttn_arsno ? station.sttn_arsno : "정보없음";
            const isBusHere = locationMap[String(station.sttn_id)];
            
            let arrivalText = "도착정보가 없습니다.";
            
            // 각 버스별로 도착 시간을 계산
            busLocations.forEach((bus) => {
                const busNodeOrder = bus.nodeord; // 현재 버스의 노선 순서
             	// 각 버스별로 누적 시간 초기화
                if (!busArrivalTimesMap[bus.vehicleno]) {
                    busArrivalTimesMap[bus.vehicleno] = 0; // 해당 버스에 대해 누적 시간이 초기화됨
                }
                let cumulativeTime = busArrivalTimesMap[bus.vehicleno]; // 각 버스별 누적 시간
                
                // 버스가 해당 정류장에 있을 때
                if (isBusHere && locationMap[String(station.sttn_id)].includes(bus.vehicleno)) {
                    // 현재 버스가 있는 정류장에서는 "곧 도착 예정"을 표시
                    if (station.station_order === busNodeOrder) {
                        arrivalText = "도착정보가 없습니다.";
                    } 
                } else if (index === lastStationIndex) {
                	// 마지막 정류장은 이전 정류장과의 도착 예정 시간 계산
                    const prevStation = stations[index - 1]; // 이전 정류장
                	console.log("prevStation : " + prevStation);
                    if (prevStation) {
                        const distance = getDistance(prevStation, station); // 이전 정류장과 현재 정류장 사이의 거리 계산
                        const arrivalInMinutes = calculateArrivalTime(prevStation, station); // 도착 예정 시간 계산
                        cumulativeTime += arrivalInMinutes; // 누적 시간 계산
                        busArrivalTimesMap[bus.vehicleno] = cumulativeTime; // 해당 버스의 누적 시간 업데이트
                        arrivalText = cumulativeTime <= 1 ? "곧 도착 예정" : "<span style='color:#b82647'>" + cumulativeTime + "분 뒤 도착 예정</span>"; // 누적 시간에 맞춰 표시
                    }
                } else if (station.station_order > busNodeOrder) { // 그 이후의 정류장에서는 도착 예정 시간을 계산해서 "몇 분 뒤 도착 예정" 표시
                    const nextStation = stations[index + 1];
                    if (nextStation) {
                        const distance = getDistance(station, nextStation); // 두 정류장 사이의 거리 계산
                        const arrivalInMinutes = calculateArrivalTime(station, nextStation); // 도착 예정 시간 계산
                        console.log("distance : ", distance);
                        console.log("arrivalInMinutes : ", arrivalInMinutes);
                        cumulativeTime += arrivalInMinutes; // 누적 시간 계산
                        busArrivalTimesMap[bus.vehicleno] = cumulativeTime; // 해당 버스의 누적 시간 업데이트
                        console.log("cumulativeTime : ", cumulativeTime);
                        arrivalText = cumulativeTime <= 1 ? "곧 도착 예정" : "<span style='color:#b82647'>" + cumulativeTime + "분 뒤 도착 예정</span>"; // 누적 시간에 맞춰 표시
                    }
                } 
            });

            // 출력 HTML 생성
            //const contextPath = "${pageContext.request.contextPath}";
            const vehicleNumbers = isBusHere ? locationMap[String(station.sttn_id)].join(', ') : "정보없음";
            const tooltipText = vehicleNumbers ? vehicleNumbers : "정보없음";
            const busIconHtml = isBusHere 
                                ? " <img src='" + contextPath + "/resources/image/bus-icon.png' class='bus-icon scroll-target' " +
                                  "data-bs-toggle='tooltip' data-bs-placement='right' data-bs-html='true' data-bs-title='" + tooltipText + "' />" 
                                : "";

            listHtml += "<div class='station-node hover-target' data-node-id='" + station.sttn_id + "'>" +
                        "<div class='circle'></div>" +
                        busIconHtml +
                        "<div class='line'></div>" +
                        "<div class='station-info'>" +
                          stationText + " (" + stationArsNo + ")<br />" +
                          "<strong style='font-size:13px;'>" + arrivalText + "</strong>" +
                        "</div>" +
                      "</div>";
        });
     
        $("#routeHeader").html("[" + busNumber + "] 노선 정보");
        $("#routeStationList").html(listHtml);
        $("#loadingOverlay").hide();
        
     	// 버스 위치로 스크롤 이동
        setTimeout(() => {
            activateTooltips();

            const $container = $("#routeStationList"); // 스크롤 영역 div
            const $firstBus = $container.find(".station-node").filter(function() {
                return $(this).find(".bus-icon").length > 0;
            }).first();

            if ($firstBus.length) {
                // 컨테이너 기준 위치 계산
                const containerTop = $container.offset().top;
                const busTop = $firstBus.offset().top;
                const scrollTop = $container.scrollTop();
                const offset = busTop - containerTop;

                // 스크롤 이동
                $container.animate({ scrollTop: scrollTop + offset - 50 }, 400); // -50은 약간 위로 띄우기
            }
        }, 300);
    }
    
 	// 거리 계산 함수 (위경도 기반)
    const getDistance = (station1, station2) => {
    	if (!station1 || !station2) return 0;
    	
        const R = 6371; // 지구 반경 (단위: km)
        const lat1 = station1.latitude * Math.PI / 180;
        const lon1 = station1.longitude * Math.PI / 180;
        const lat2 = station2.latitude * Math.PI / 180;
        const lon2 = station2.longitude * Math.PI / 180;

        const dLat = lat2 - lat1;
        const dLon = lon2 - lon1;

        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        const distance = R * c; // 거리 계산
        return distance; // km 단위로 반환
    };

    // 평균 속도 설정 (km/h)
    const averageSpeed = 30; // 예: 평균 속도 30km/h
    
    function calculateArrivalTimeDifference(timeToArrive) {
    	return Math.round(timeToArrive); // 소수점 없이 정수로 표시
    }
    
 	// 거리 계산 (위도, 경도를 이용한 간단한 Haversine 공식을 사용)
    function calculateDistance(lat1, lon1, lat2, lon2) {
    	const R = 6371; // 지구 반지름 (단위: km)
        const dLat = (lat2 - lat1) * Math.PI / 180;
        const dLon = (lon2 - lon1) * Math.PI / 180;
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                  Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
                  Math.sin(dLon / 2) * Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c; // 결과는 km 단위
    }

    // 라디안 변환
    function toRadians(degrees) {
        return degrees * (Math.PI / 180);
    }

 	// 예상 도착 시간 계산 (거리 / 속도)
    function calculateTimeToArrive(distance) {
        return (distance / averageSpeed) * 60; // 분 단위
    }
    
    function activateTooltips() {
    	const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.forEach(function (el) {
            const existingTooltip = bootstrap.Tooltip.getInstance(el);
            if (existingTooltip) {
                existingTooltip.dispose(); // 기존 제거
            }
            new bootstrap.Tooltip(el, {
                html: true
            });
        });
   	}
    
    let currentRouteId = null;
    let refreshInterval = null;
    // 버스 클릭 시 노선 정류장 조회
    $("#busList").on("click", ".bus-item", function() {
        const routeId = $(this).data("route-id");
        const busNumber = $(this).find("strong").text();
        currentRouteId = routeId;
        
        $(".bus-item").removeClass("selected");
        $(this).addClass("selected");
        
        clearInterval(refreshInterval); // 이전 인터벌 제거
        fetchRouteAndBus(currentRouteId, busNumber); // 즉시 호출
        
        $("#map").show();  // 지도 보이기
        //window.scrollTo(0, document.body.scrollHeight);
        
     	// 이후 15초마다 호출
        refreshInterval = setInterval(() => {
        	// 임시로 주석처리(API 호출)
            //fetchRouteAndBus(currentRouteId, busNumber);
        }, 15000);
    });
    
    function fetchRouteAndBus(routeId, busNumber) {
        $.ajax({
            url: "/api/bus-route",
            type: "GET",
            data: { routeId: routeId },
            success: function(stations) {
                if (stations.length === 0) {
                    $("#routeStationList").html("<div class='station-placeholder'>노선 정보가 없습니다.</div>");
                    $("#loadingOverlay").hide();
                    return;
                }
                
                $.ajax({
                    url: "/api/bus-realtime-location",
                    type: "GET",
                    data: {
                        cityCode: selectedCity,
                        routeId: routeId
                    },
                    success: function(busLocations) {
                    	console.log("[API 응답] busLocations:", busLocations);
                        renderRouteStationsWithBus(stations, busLocations, busNumber);
                        $("#loadingOverlay").hide();
                    },
                    error: function() {
                        renderRouteStationsWithBus(stations, [], busNumber);
                        $("#loadingOverlay").hide();
                    }
                });
            },
            error: function() {
                $("#routeStationList").html("<div class='station-placeholder'>노선 정보를 불러오지 못했습니다.</div>");
                $("#loadingOverlay").hide();
            }
        });
        
     	// 위도, 경도를 포함한 stations 데이터 추가
        $.ajax({
            url: "/api/route-stations",
            type: "GET",
            data: { routeId: routeId },
            dataType: "json",
            success: function(stationsWithLocation) {
                console.log("위도, 경도 정보가 포함된 정류장 데이터:", stationsWithLocation);
                if (stationsWithLocation.length === 0) {
                    console.log("위도, 경도 정보가 없습니다.");
                    return;
                }
             	// 지도그리기
                drawRouteMap(stationsWithLocation);
                $("#loadingOverlay").hide();
            },
            error: function() {
                console.log("위도, 경도 데이터를 가져오지 못했습니다.");
                $("#loadingOverlay").hide();
            }
        });
    }
    
    function getRouteLabel(item) {
        const busNumber = String(item.bus_number);
        const type = item.bus_type;

        if (/^순환/.test(busNumber)) return "순환버스";
        if (/^\d{4}$/.test(busNumber)) return "직행버스";
        if (type) return type;

        return "기타";
    }
    
    function getRouteTypeClass(type) {
        switch (type) {
            case "일반버스": return "badge-normal";
            case "좌석버스": return "badge-seat";
            case "저상버스": return "badge-low";
            case "순환버스": return "badge-loop";
            case "급행버스": return "badge-express";
            case "직행버스": return "badge-direct";
            case "마을버스": return "badge-town";
            case "마실버스": return "badge-masil";
            case "간선버스": return "badge-gansun";
            case "지선버스": return "badge-branch";
            default: return "badge-default";
        }
    }
    
 	// Java에서 넘긴 stationList를 JS로 변환
    <c:choose>
	    <c:when test="${not empty stations}">
	        const stationList = [
	            <c:forEach var="station" items="${stations}" varStatus="loop">
	            {
	                name: "${station.sttn_nm}",
	                latitude: ${station.latitude},
	                longitude: ${station.longitude}
	            }<c:if test="${!loop.last}">,</c:if>
	            </c:forEach>
	        ];
	    </c:when>
	    <c:otherwise>
	        const stationList = [];
	    </c:otherwise>
	</c:choose>
	
    // 지도에 경로 그리기
    if (stationList.length > 0) {
	    drawRouteMap(stationList);
	} else {
	    // 지도에 표시할 데이터가 없음
	    // 필요하면 대체 처리
	    console.log("표시할 노선 데이터가 없습니다.");
	}
    

    function initMap() {
    	if (map) return;
    	
    	const mapContainer = document.getElementById('map');
        if (!map) {
            const initialCoordinates = cityCoordinates["26"]; // 울산 기본
            map = new kakao.maps.Map(mapContainer, {
                center: new kakao.maps.LatLng(initialCoordinates.lat, initialCoordinates.lng),
                level: 5
            });
        }
    }
    
    function updateMapCenter(cityCode) {
        const coordinates = cityCoordinates[cityCode];
        if (coordinates && map) {
            const newCenter = new kakao.maps.LatLng(coordinates.lat, coordinates.lng);
            map.setCenter(newCenter);  // 지도 중심 변경
        }
    }
    
    let markers = [];  // 전역 마커 배열
    let polylines = [];  // 전역 폴리라인 배열
    
    // 전체 노선 지도
    function drawRouteMap(stations) {
    	if (!Array.isArray(stations)) {
            console.error("stations is not an array:", stations);
            return;  // 배열이 아닐 경우 함수 종료
        }
    	
    	if (!map) initMap();
    	
    	console.log("stations data: ", stations);
    	
    	// 기존 마커 제거
        markers.forEach(marker => marker.setMap(null));
        markers = [];

        // 기존 폴리라인 제거
        polylines.forEach(polyline => polyline.setMap(null));
        polylines = [];
    	
    	if (stations.length === 0) {
            console.log("노선이 없음.");
            return;
        }

        // 지도 영역 초기화 (기존 마커, 선 제거 필요하면 여기에 처리)
        const bounds = new kakao.maps.LatLngBounds();

        const path = stations.map(s => {
            const latLng = new kakao.maps.LatLng(s.latitude, s.longitude);
            bounds.extend(latLng);
            return latLng;
        });

        // 마커 생성
        stations.forEach((s) => {
        	var marker = new kakao.maps.Marker({
                map: map,
                position: new kakao.maps.LatLng(s.latitude, s.longitude),
                image: new kakao.maps.MarkerImage(
                    "/resources/image/bus-marker01.png",  // 마커 이미지 경로
                    new kakao.maps.Size(20, 20)       // 마커 크기 조정
                )
            });
        	markers.push(marker);
        	
        	// customOverlay 생성
            var customOverlay = new kakao.maps.CustomOverlay({
                content: '<div style="margin-top: -25px; background-color: rgba(0, 0, 0, 0.7); color: #fff; padding: 5px; margin-left: 45px; border-radius: 3px; font-size: 12px; pointer-events: none; z-index: 9999;">' + s.sttn_nm + '</div>',
                position: new kakao.maps.LatLng(s.latitude - 0.0001, s.longitude)
            });

            // 마커에 mouseover 이벤트 리스너 추가
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                customOverlay.setMap(map); // mouseover 시 customOverlay 표시
            });

            // 마커에 mouseout 이벤트 리스너 추가
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                customOverlay.setMap(null); // mouseout 시 customOverlay 숨김
            });
        });
        

        // 폴리라인 생성
        const polyline = new kakao.maps.Polyline({
            path: path,
            strokeWeight: 5,
            strokeColor: '#FF0000',
            strokeOpacity: 0.7,
            strokeStyle: 'solid'
        });

        polyline.setMap(map);
        polylines.push(polyline);

        // 지도 범위 재설정
        map.setBounds(bounds);
    }

});
</script>
</body>
</html>