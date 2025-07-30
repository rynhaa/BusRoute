<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>버스 정류장 목록</title>
<c:if test="${not empty message}">
    <script>
        alert('${message}');
    </script>
</c:if>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/header.css" rel="stylesheet">
<script>
	let currentCityFilter = "26";
	const contextPath = "${pageContext.request.contextPath}";
	
	// 버스정류장 즐겨찾기
	function toggleFavorite(sttnId, btnElement) {
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
	                $(btnElement).find("img").attr("src", contextPath + "/resources/image/star_on.png");
	                alert("즐겨찾기에 저장되었습니다.");
	            } else if (response.status === "removed") {
	                $(btnElement).find("img").attr("src", contextPath + "/resources/image/star_off.png");
	                alert("즐겨찾기에 삭제되었습니다.");
	            }
	        },
	        error: function() {
	            alert("즐겨찾기 처리 중 오류가 발생했습니다.");
	        }
	    });
	}
	
	// 버스도착정보 즐겨찾기
	function toggleFavoriteRoute(routeId, imgElement) {
	    $.ajax({
	        url: "/api/toggle-favorite", // 기존 즐겨찾기 URL 사용
	        type: "POST",
	        data: { routeId: routeId },
	        dataType : "json",
	        success: function(response) {
	            if (response.status === "added") {
	                $(imgElement).attr("src", contextPath + "/resources/image/star_on.png");
	                alert("즐겨찾기에 저장되었습니다.");
	            } else if (response.status === "removed") {
	                $(imgElement).attr("src", contextPath + "/resources/image/star_off.png");
	                alert("즐겨찾기에 삭제되었습니다.");
	            }
	        },
	        error: function() {
	            alert("즐겨찾기 처리 중 오류가 발생했습니다.");
	        }
	    });
	}

	
	$(document).ready(function() {
		$("#loadingOverlay").show();
		
		$("#cityFilterButtons").on("click", ".btn-city", function() {
			$("#loadingOverlay").show();
			$("#stationList").html(""); 
			$("#stationSearch").val(""); // 검색어 초기화
			
	        $(".btn-city").removeClass("active");
	        $(this).addClass("active");
	        currentCityFilter = $(this).data("city");
	        console.log("지역클릭 시 cityCode", currentCityFilter);
	        searchStations(); // 지역 버튼 클릭 시 검색 실행
	        filterStations();
	        
			setTimeout(() => {
		        const firstVisibleStation = $("#stationList li:visible:first");
		        if (firstVisibleStation.length) {
		            const nodeId = firstVisibleStation.data("nodeid");
		            const name = firstVisibleStation.data("name");
		            const lat = firstVisibleStation.data("lat");
		            const lng = firstVisibleStation.data("lng");
	
		            // 도착 정보 불러오기 함수 안에 성공, 실패 콜백에 로딩 숨기기 넣어야 함
		            onStationClick(nodeId, name, lat, lng);
		        } else {
		            $("#arrivalInfo").html("<h4 class='no-info'>정류장을 선택해주세요.</h4>");
		            $("#loadingOverlay").hide();
		        }
			}, 550);
	    });
	    
	    // 페이지 로드시 첫 번째 정류장 자동 선택
	    const firstStation = $("#stationList li:first");
	    if (firstStation.length) {
	        const nodeId = firstStation.data("nodeid");
	        const name = firstStation.data("name");
	        const lat = firstStation.data("lat");
	        const lng = firstStation.data("lng");
	        onStationClick(nodeId, name, lat, lng);
	    }
	    
	 	// 검색 필터 기능(기존꺼)
	    /* $("#stationSearch").on("input", function() {
	        const keyword = $(this).val().toLowerCase();
	        $("#stationList li").each(function() {
	            const text = $(this).text().toLowerCase();
	            $(this).toggle(text.includes(keyword));
	        });
	    }); */
	    
	    $("#stationSearch").on("input", function() {
            const keyword = $(this).val().toLowerCase();
            searchStations(keyword); // 검색어에 맞게 검색 실행
        });
	    
	 	// 정류장 검색 함수
        function searchStations(keyword = '') {
            // 서버에 검색어를 전달하여 필터링된 결과를 가져옴
            $.ajax({
                url: '/api/station-list', // 서버에서 정류장 검색을 처리하는 API
                type: 'GET',
                dataType: 'json',
                data: { 
                    keyword: keyword,
                    cityCode: currentCityFilter  // 갱신된 currentCityFilter 값을 넘김
                },
                success: function(data) {
                    const stationList = $('#stationList');
                    stationList.empty(); // 기존 목록을 비움
                    if (data && Array.isArray(data)) {
                        if (data.length === 0) {
                            stationList.html("<div class='no-search-info'>정류장 정보가 없습니다.</div>");
                            return;
                        } else {
                            data.forEach(function(station) {
                            	let isFavorited = station.is_favorite;
                            	const contextPath = "${pageContext.request.contextPath}";
                                const stationItem = '<li style="cursor:pointer;" data-nodeid="' + station.sttn_id + '" data-name="' + station.sttn_nm + '" ' +
                                                    'data-lat="' + station.latitude + '" data-lng="' + station.longitude + '" data-city="' + station.city_code + '" ' +
                                                    'onclick="onStationClick(\'' + station.sttn_id + '\', \'' + station.sttn_nm + '\', ' + station.latitude + ', ' + station.longitude + ')">' +
                                                    station.sttn_nm + ' (' + (station.sttn_arsno ? station.sttn_arsno : '정보없음') + ')' +
                                                    " <button type='button' class='favorite-btn' onclick='event.stopPropagation(); toggleFavorite(\"" + station.sttn_id + "\", this)'>" +
                                                    (isFavorited ? "<img src='" + contextPath + "/resources/image/star_on.png' style='width:15px;height:15px;' />" : "<img src='" + contextPath + "/resources/image/star_off.png' style='width:15px;height:15px;'/>") +
                                                     "</button>" +
                                                    '</li>';
                                stationList.append(stationItem);
                            });
                        }
                    } else {
                        console.error("잘못된 데이터 형식:", data);
                        stationList.html("<div class='no-search-info'>정류장 정보가 없습니다.</div>");
                    }
                    filterStations();
                    $("#loadingOverlay").hide();
                },
                error: function(xhr, status, error) {
                    console.error("정류장 검색 실패:", error);
                    $("#stationList").html("<div class='no-search-info'>정류장 정보가 없습니다.</div>");
                    $("#loadingOverlay").hide();
                }
            });
        }
	    
		// 지역 필터링
		function filterStations() {
	        const keyword = $("#stationSearch").val().toLowerCase();
	        $("#stationList li").each(function() {
	            const text = $(this).text().toLowerCase();
	            const city = $(this).data("city");
	
	            const matchCity = (String(city) === String(currentCityFilter));
	            const matchKeyword = text.includes(keyword);
	
	            $(this).toggle(matchCity && matchKeyword);
	        });
	        
	        // 필터 후 첫 번째 보이는 정류장 자동 선택
	        const firstVisibleStation = $("#stationList li:visible:first");
	        if (firstVisibleStation.length) {
	            const nodeId = firstVisibleStation.data("nodeid");
	            const name = firstVisibleStation.data("name");
	            const lat = firstVisibleStation.data("lat");
	            const lng = firstVisibleStation.data("lng");
	            
	            setTimeout(() => {
	            	onStationClick(nodeId, name, lat, lng);
	            }, 0);
	        } else {
	            // 정류장 없으면 초기 메시지 표시 등 처리
	            $("#arrivalInfo").html("<h4 class='no-info'>정류장을 선택해주세요.</h4>");
	        }
	    }
		filterStations();
	});
	

	let selectedStation = null; // 현재 선택된 정류장 정보 저장용
	// 타이머 갱신 새로고침
	let autoRefreshTimer = null;
	let countdownTimer = null;
	let countdown = 15;
	const refreshInterval = 15;
	
	function startTimers(nodeId, stationName, lat, lng) {
	    clearInterval(autoRefreshTimer);
	    clearInterval(countdownTimer);

	    countdown = refreshInterval;
	    updateCountdownBar();

	    countdownTimer = setInterval(() => {
	        if (countdown > 0) {
	            countdown--;
	            updateCountdownBar();
	        }
	    }, 1000);

	    autoRefreshTimer = setInterval(() => {
	    	// api 호출 때매 임시 주석처리
	        //getArrivalInfo(nodeId, stationName, lat, lng);
	        countdown = refreshInterval;
	        updateCountdownBar();
	    }, refreshInterval * 1000);
	}
	
	// 정류장 선택 시 갱신 새로고침
	function onStationClick(nodeId, stationName, lat, lng) {
		let cityCode = currentCityFilter;
		
	    getArrivalInfo(nodeId, stationName, lat, lng, cityCode);
	    startTimers(nodeId, stationName, lat, lng);
	}

    function getArrivalInfo(nodeId, stationName, lat, lng) {
    	// 선택 시 정보 저장
    	selectedStation = { nodeId, stationName, lat, lng };
        let cityCode = currentCityFilter;

        $.ajax({
            url: "/api/arrival-info",
            type: "GET",
            data: {
                nodeId: nodeId,
                stationName: stationName,
                lat: lat,
                lng: lng,
                cityCode: cityCode
            },
            success: function(data) {
            	const items = data.arrivalInfo?.response?.body?.items?.item;

            	if (!items || (Array.isArray(items) && items.length === 0)) {
            	    $("#arrivalInfo").html("<div class='no-info'>도착 정보가 없습니다.</div>");
            	    loadMap(lat, lng);
            	    return;
            	}
            	const busInfoList = data.busInfoList || [];

            	function isValidItems(items) {
            	    if (items == null) return false;  // null 또는 undefined
            	    if (typeof items === "string" && items.trim() === "") return false;
            	    if (Array.isArray(items) && items.length > 0) return true;
            	    if (typeof items === "object" && !Array.isArray(items) && Object.keys(items).length > 0) return true;
            	    return false;
            	}
            	console.log("busInfoList: ", busInfoList);

                let result = "<h4 class='station-name'>" + stationName + " 도착 예정 정보</h4>";

                if (isValidItems(items)) {
                	if(Array.isArray(items)) {
	                    items.forEach(function(item) {
	                        let routeLabel = getRouteLabel(item);
	                        let badgeClass = getRouteTypeClass(routeLabel);
	
	                        // route_id 기준으로 매칭되는 bus 정보 찾기
	                        let matchedBus = busInfoList.find(bus => bus.route_id === item.routeid);
	
	                        let startStation = matchedBus ? matchedBus.start_station_name : "정보없음";
	                        let endStation = matchedBus ? matchedBus.end_station_name : "정보없음";
	                        
	                        let isFavorite = matchedBus ? matchedBus.is_favorite : 0;
	                        let starImg = isFavorite == 1 ? contextPath + "/resources/image/star_on.png" : contextPath + "/resources/image/star_off.png";
	
	                        result += "<div style='margin-bottom: 10px;'>" +
			                        "<span class='badge " + badgeClass + "'>" + routeLabel + "</span> " +
			                        "<strong style='font-size:15px;'>" + item.routeno + "</strong>" +
			                        "<img src='" + starImg + "' style='width:15px;height:15px;cursor:pointer; vertical-align: -2px; margin-left:5px;' onclick='toggleFavoriteRoute(\"" + item.routeid + "\", this)' />" +
			                        "<br />" +
			                        "<span style='font-size:13.5px'>(" + startStation + " → " + endStation + ")</span> " +
			                        "&nbsp;&nbsp;<span class='arr-time'>" + Math.round(item.arrtime / 60) + "분</span>" +
			                        "</div>";
	                    });
                	} else {
                         let routeLabel = getRouteLabel(items);
                         let badgeClass = getRouteTypeClass(routeLabel);

                         let matchedBus = data.busInfoList.find(function(bus) {
                             return bus.route_id === items.routeid;
                         });
                         let startStation = matchedBus ? matchedBus.start_station_name : "정보없음";
                         let endStation = matchedBus ? matchedBus.end_station_name : "정보없음";
                         
                         let isFavorite = matchedBus ? matchedBus.is_favorite : 0;
	                        let starImg = isFavorite == 1 ? contextPath + "/resources/image/star_on.png" : contextPath + "/resources/image/star_off.png";

                         result += "<div style='margin-bottom: 10px;'>" +
                         "<span class='badge " + badgeClass + "'>" + routeLabel + "</span> " +
                         "<strong style='font-size:15px;'>" + items.routeno + "</strong>" +
                         "<img src='" + starImg + "' style='width:15px;height:15px;cursor:pointer; vertical-align: -2px; margin-left:5px;' onclick='toggleFavoriteRoute(\"" + items.routeid + "\", this)' />" +
                         "<br /><span style='font-size:13.5px'>(" + (matchedBus ? matchedBus.start_station_name : "정보없음") +
                         " → " + (matchedBus ? matchedBus.end_station_name : "정보없음") + ")</span> " +
                         "&nbsp;&nbsp;<span class='arr-time'>" + Math.round(items.arrtime / 60) + "분</span>" +
                         "</div>";
                	}
                } else {
                    result += "<div class='no-info'>도착 정보가 없습니다.</div>";
                }

                $("#arrivalInfo").html(result);
                loadMap(lat, lng);
                $("#loadingOverlay").hide();
            },
            error: function(xhr, status, error) {
                console.error("API 호출 실패:", error);
                $("#arrivalInfo").html("<div class='no-info'>도착 정보가 없습니다.</div>");
                loadMap(lat, lng);
                $("#loadingOverlay").hide();
            }
        });
    }
	
	function updateCountdownBar() {
	    $("#countText").text(countdown + "초");
	
	    const percentage = (countdown / refreshInterval) * 100;
	    $("#countProgressBar")
	        .css("width", percentage + "%")
	        .attr("aria-valuenow", countdown);
	    
	    if (countdown < 5) {
	        $("#countProgressBar").removeClass("bg-success bg-warning").addClass("bg-danger");
	    } else if (countdown < 10) {
	        $("#countProgressBar").removeClass("bg-success bg-danger").addClass("bg-warning");
	    } else {
	        $("#countProgressBar").removeClass("bg-warning bg-danger").addClass("bg-success");
	    }
	}
    
    function getRouteLabel(item) {
        const routeno = String(item.routeno);
        const type = item.routetp;

        if (/^순환/.test(item.routeno)) return "순환버스";
        if (/^\d{4}$/.test(routeno)) return "직행버스";
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
</script>
<style>
html, body {
  height: 100%;
  margin: 0;
}
.container {
    display: flex;
    flex-direction: row;
    padding: 20px;
    gap: 30px;
    width:90%;
    max-width: 1200px;
  	margin: 0 auto; /* 중앙 정렬 핵심 */
}

.station-list-container,
.arrival-info {
  display: flex;
  flex-direction: column;
}


.station-list-container {
    width: 30%;
    gap: 10px;
}

.station-list {
    max-height: 600px;
    overflow-y: auto;
    border: 2px solid rgb(59, 80, 122);
    background-color:#fff;
    border-radius: 4px;
    color:#444444;
    font-size:13.5px;
}

#stationSearch {
    padding: 16px 12px 16px 36px; 
    font-size: 14px;
    border: 2px solid rgb(59, 80, 122);
    border-radius: 4px;
    margin-bottom:10px;
    background: url('/resources/image/search-icon.png') no-repeat 10px center;
    background-size: 18px 18px; 
    background-color:#fff;
}

.station-list::-webkit-scrollbar {
    width: 8px;
}

.station-list::-webkit-scrollbar-track {
    background: #e0e0e0;
    border-radius: 4px;
}

.station-list::-webkit-scrollbar-thumb {
    background-color: rgb(59, 80, 122);
    border-radius: 4px;
}

.station-list::-webkit-scrollbar-thumb:hover {
    background-color: rgba(59, 80, 122, 0.85);
}

.arrival-info {
    width: 70%;
    padding-left: 10px;
}

.arrival-info > div {
}

/* 목록 스타일 */
.station-list ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.station-list li {
	padding: 15px 20px;
    border-bottom: 1px solid #eee;
    cursor: pointer;
}

.station-list li:hover {
    /* background-color: #f5f5f5; */
    background-color : rgb(59, 80, 122, 0.5);
    color:#fff;
}

/* 도착 정보 스타일 */
.arrival-info {
  width: 70%;
  padding-left: 10px;
  height: 670px;
}

.arrival-info h3 {
  margin-top: 0;
}

#arrivalInfo {
  flex: 1;
  height: 100%; 
  overflow-y: auto;
  padding: 10px 20px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  background-color: #fff;
}

#map {
  height: 350px;
  margin-top: 10px;
}


@media (max-width: 768px) {
    .container {
        flex-direction: column;
    }
    .station-list, .arrival-info {
        width: 100%;
    }
}

.badge {
    display: inline-block;
    color: white;
    padding: 4px 10px;
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
.badge-default { background-color: #999; }     /* 기타 */

.arr-time {
    color: #e74c3c; /* 빨간색 */
    font-weight: bold;
    font-size:14px;
}
.bus-type {
    color: #555;
    font-size: 13px;
    margin-left: 4px;
}
.no-info {
    color: #888;
    font-size: 14px;
    font-style: italic;
    margin-top: 10px;
}
.no-search-info {
    color: #888;
    font-size: 14px;
    font-style: italic;
	padding : 20px;
}
.station-name {
	padding : 10px 0px;
	font-size:16px;
	font-weight: bold;
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
@media (max-width: 768px) {
  #cityFilterButtons {
    flex-direction: column;
    align-items: center;
  }
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

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
.favorite-btn {
    background: none;
    border: none;
    font-size: 18px;
    cursor: pointer;
    margin-left: 5px;
    color: gold;
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
		<h3>버스정류장 검색</h3>
		
		<!-- 지역 선택 버튼 -->
		<div id="cityFilterButtons">
		    <button type="button" class="btn btn-city active" data-city="26">울산</button>
		    <button type="button" class="btn btn-city" data-city="24">광주</button>
		    <button type="button" class="btn btn-city" data-city="21">부산</button>
		    <button type="button" class="btn btn-city" data-city="22">대구</button>
		</div>
		
		<div class="container">
			<div class="station-list-container">
	            <input type="text" id="stationSearch" placeholder="정류장명 또는 정류장번호 검색" />
		        <div class="station-list">
		            <ul id="stationList">
		                <c:forEach var="station" items="${stations}">
		                    <li style="cursor:pointer;" data-nodeid="${station.sttn_id}"  data-name="${station.sttn_nm}" data-lat="${station.latitude}" 
        						data-lng="${station.longitude}"  data-city="${station.city_code}" onclick="onStationClick('${station.sttn_id}', '${station.sttn_nm}', ${station.latitude}, ${station.longitude})">
		                        ${station.sttn_nm} (${station.sttn_arsno ? '정보없음' : station.sttn_arsno})
		                        <button type='button' class='favorite-btn' onclick='event.stopPropagation(); toggleFavorite("${station.sttn_id}", this)'>
		                        <c:if test="${station.is_favorite == 1}">
		                        	<img src='${pageContext.request.contextPath}/resources/image/star_on.png' style='width:15px;height:15px;' />
		                        </c:if>
		                        <c:if test="${station.is_favorite != 1}">
		                        	<img src='${pageContext.request.contextPath}/resources/image/star_off.png' style='width:15px;height:15px;' />
		                        </c:if>
                                </button>
		                    </li>
		                </c:forEach>
		            </ul>
		        </div>
	        </div>
	
	        <div class="arrival-info">
			    <div id="arrivalInfo">
			        <h4 class="no-info">정류장을 선택해주세요.</h4>
			    </div>
			    
			    <div id="countdownWrapper" style="margin-top:10px;">
				    <div style="font-size:13px; color:gray; margin-bottom: 4px;">
				        다음 갱신까지: <span id="countText">15초</span>
				    </div>
				    <div class="progress" style="height: 20px;">
				        <div id="countProgressBar" class="progress-bar bg-success" role="progressbar" 
				             style="width: 100%;" aria-valuenow="15" aria-valuemin="0" aria-valuemax="15">
				        </div>
				    </div>
				</div>
			    
			    <div id="map" style="width:100%; height:300px; margin-top:20px;"></div>
			</div>
	        
			<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5c8fdb069b91970ac2772cc7de370f6a"></script>
			<!-- 지도 함수 정의 및 초기화 -->
			<script>
			    function loadMap(lat, lng) {
		    	    try {
		    	        if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
		    	            return; // 지도 호출하지 않음
		    	        }
		    	        const container = document.getElementById('map');
		    	        const options = {
		    	            center: new kakao.maps.LatLng(lat, lng),
		    	            level: 3
		    	        };
		    	        const map = new kakao.maps.Map(container, options);

		    	        const marker = new kakao.maps.Marker({
		    	            position: new kakao.maps.LatLng(lat, lng)
		    	        });
		    	        marker.setMap(map);
		    	    } catch (err) {
		    	        console.error("loadMap 실패:", err);
		    	    }
			    }
			</script>
	    </div>
	</div>
</body>
</html>