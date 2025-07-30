package com.busroute.controller;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.busroute.domain.BusLocationVO;
import com.busroute.domain.BusVO;
import com.busroute.domain.StationVO;
import com.busroute.service.FavoriteRouteService;
import com.busroute.service.RouteService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api")
public class BusArrivalController {
	@Autowired
    private RouteService routeService;
	
	@Autowired
    private FavoriteRouteService favoriteRouteService;

    @Autowired
    private ServletContext servletContext;

    @GetMapping(value = "/arrival-info", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> getArrivalInfo(@RequestParam String nodeId, @RequestParam String stationName, @RequestParam double lat,
            @RequestParam double lng, @RequestParam String cityCode, HttpSession session) {
        String serviceKey = servletContext.getInitParameter("tago.serviceKey");
        String encodedKey = "";
        try {
			encodedKey = URLEncoder.encode(serviceKey, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("서비스키 인코딩 실패", e);
		}
        
        String url = "https://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList";
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
            .queryParam("serviceKey", encodedKey)  // 자동 인코딩
            .queryParam("_type", "json")
            .queryParam("pageNo", "1")
            .queryParam("numOfRows", "1000")
            .queryParam("cityCode", cityCode)
            .queryParam("nodeId", nodeId);
        URI apiUrl = builder.build(true).toUri();
        System.out.println("API 호출 URL: " + apiUrl.toString());
        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> publicApiResponse = restTemplate.getForObject(apiUrl, Map.class);
        System.out.println("Raw API response: " + publicApiResponse);
        
        Map<String, Object> response = (Map<String, Object>) publicApiResponse.get("response");
        if (response == null) throw new RuntimeException("response is null");

        Map<String, Object> body = (Map<String, Object>) response.get("body");
        if (body == null) throw new RuntimeException("body is null");
        System.out.println("1. cityCode : " + cityCode);

        Map<String, Object> items = (Map<String, Object>) body.get("items");
        if (items == null) throw new RuntimeException("items is null");

        System.out.println("2. cityCode : " + cityCode);
        Object itemObj = items.get("item");
        if (itemObj == null) throw new RuntimeException("item is null");

        System.out.println("API 결과에서 itemObj = " + itemObj.getClass().getName());
        
        List<String> nodeNoList = new ArrayList<>();
        
        if (itemObj instanceof List) {
            List<Map<String, Object>> itemList = (List<Map<String, Object>>) itemObj;
            for (Map<String, Object> busItem : itemList) {
                String nodeNo = (String) busItem.get("routeid");
                if (nodeNo != null) {
                    nodeNoList.add(nodeNo);
                }
            }
        } else if (itemObj instanceof Map) {
            Map<String, Object> singleItem = (Map<String, Object>) itemObj;
            String nodeNo = (String) singleItem.get("routeid");
            if (nodeNo != null) {
                nodeNoList.add(nodeNo);
            }
        }

        //BusVO bus = routeService.getBusByRouteId(nodeId);
        Integer unum = (Integer) session.getAttribute("unum"); 
        int cityCodeInt = Integer.parseInt(cityCode);
        System.out.println("cityCodeInt : " + cityCodeInt);
        
        List<BusVO> busInfoList = null;
        if (unum != null) {
        	busInfoList = routeService.getBusListByNodeNoWithFavorite(nodeNoList, cityCodeInt, unum);
        } else {
        	busInfoList = routeService.getBusListByNodeNo(nodeNoList, cityCodeInt);
        }
        System.out.println("getArrivalInfo() 호출됨, cityCodeInt : " + cityCodeInt);

        Map<String, Object> result = new HashMap<>();
        result.put("arrivalInfo", publicApiResponse);
        result.put("stationName", stationName);
        result.put("latitude", lat);
        result.put("longitude", lng);
        result.put("busInfoList", busInfoList);

        return result;
    }
    
    @GetMapping(value = "/bus-list", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<BusVO> getBusList(@RequestParam("cityCode") String cityCode, @RequestParam(value = "keyword", required = false) String keyword, HttpSession session) {
    	Integer unum = (Integer) session.getAttribute("unum"); 
    	int cityCodeInt = Integer.parseInt(cityCode);
    	if (unum != null) {
            // 로그인 상태용 쿼리 호출 (즐겨찾기 포함)
            return routeService.getBusListByCityWithFavorite(cityCodeInt, keyword, unum);
        } else {
            // 비로그인 상태용 쿼리 호출 (즐겨찾기 없음)
            return routeService.getBusListByCity(cityCodeInt, keyword);
        }
    }

    @GetMapping(value = "/bus-route", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<StationVO> getRouteStations(@RequestParam("routeId") String routeId) {
        return routeService.getStationListByRoute(routeId);
    }
    
    @GetMapping(value = "/bus-realtime-location", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public List<BusLocationVO> getBusLocation(@RequestParam String cityCode, @RequestParam("routeId") String routeId) {
    	// 서비스키
    	String serviceKey = servletContext.getInitParameter("tago.serviceKey");
    	String encodedKey = "";
        try {
			encodedKey = URLEncoder.encode(serviceKey, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("서비스키 인코딩 실패", e);
		}
        
        String url = "http://apis.data.go.kr/1613000/BusLcInfoInqireService/getRouteAcctoBusLcList";
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
            .queryParam("serviceKey", encodedKey)  // 자동 인코딩
            .queryParam("_type", "json")
            .queryParam("pageNo", "1")
            .queryParam("numOfRows", "1000")
            .queryParam("cityCode", cityCode)
            .queryParam("routeId", routeId);
        URI apiUrl = builder.build(true).toUri();
        System.out.println("API 호출 URL: " + apiUrl.toString());
        
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
        // JSON 전체를 JsonNode로 파싱
        ObjectMapper objectMapper = new ObjectMapper();
        String json = restTemplate.getForObject(apiUrl, String.class);
        System.out.println("실시간 위치 raw json : " + json);

        List<BusLocationVO> busList = new ArrayList<>();
        try {
            JsonNode root = objectMapper.readTree(json);
            JsonNode items = root.path("response").path("body").path("items").path("item");

            if (items.isArray()) {
                for (JsonNode item : items) {
                	BusLocationVO vo = new BusLocationVO();
                    vo.setNodeid(item.path("nodeid").asText());
                    vo.setNodenm(item.path("nodenm").asText());
                    vo.setNodeord(item.path("nodeord").asInt());
                    vo.setGpslati(item.path("gpslati").asDouble());
                    vo.setGpslong(item.path("gpslong").asDouble());
                    vo.setRoutenm(item.path("routenm").asText());
                    vo.setRoutetp(item.path("routetp").asText());
                    vo.setVehicleno(item.path("vehicleno").asText());

                    busList.add(vo);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("실시간 위치 JSON 파싱 오류", e);
        }
        return busList;
    }
    
    @GetMapping("/route-stations")
    public ResponseEntity<List<StationVO>> getAllRouteStations(@RequestParam String routeId) {
        List<StationVO> stations = routeService.getStationsByRouteId(routeId);
        if (stations.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(stations);
    }
    
    // 정류장 검색
 	@GetMapping(value = "/station-list", produces = "application/json; charset=UTF-8")
 	@ResponseBody
    public List<StationVO> searchStations(@RequestParam(value = "keyword", required = false) String keyword, @RequestParam String cityCode, HttpSession session) {
 		Integer unum = (Integer) session.getAttribute("unum"); 
    	if (unum != null) {
            // 로그인 상태용 쿼리 호출 (즐겨찾기 포함)
            return routeService.searchStationsWithFavorite(cityCode, keyword, unum);
        } else {
            // 비로그인 상태용 쿼리 호출 (즐겨찾기 없음)
            return routeService.searchStations(keyword, cityCode);
        }
    }
 	
 	// 버스 번호 즐겨찾기
 	@PostMapping("/toggle-favorite")
    public Map<String, String> toggleFavorite(@RequestParam("routeId") String routeId, HttpSession session) {
        Integer userNum = (Integer) session.getAttribute("unum");  // 세션에서 로그인 사용자 가져오기
        Map<String, String> result = new HashMap<>();

        if (userNum == null) {
            result.put("status", "error");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        boolean added = favoriteRouteService.toggleFavorite(userNum, routeId);
        result.put("status", added ? "added" : "removed");
        return result;
    }
 	
 	// 버스 정류장 즐겨찾기
 	@PostMapping("/toggle-favorite-station")
 	public Map<String, String> toggleFavoriteStation(@RequestParam("sttnId") String sttnId, HttpSession session) {
 		Integer userNum = (Integer) session.getAttribute("unum");  // 세션에서 로그인 사용자 가져오기
 		Map<String, String> result = new HashMap<>();
 		
 		if (userNum == null) {
 			result.put("status", "error");
 			result.put("message", "로그인이 필요합니다.");
 			return result;
 		}
 		
 		boolean added = favoriteRouteService.toggleFavoriteStation(userNum, sttnId);
 		result.put("status", added ? "added" : "removed");
 		return result;
 	}
}
