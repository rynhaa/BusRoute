package com.busroute.controller;

import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.busroute.domain.StationVO;
import com.busroute.service.RouteService;

@Controller
@RequestMapping("/route")
public class RouteController {
	@Autowired
    private RouteService routeService;
	
	@Autowired
    private ServletContext servletContext;
	
	// 정류장 목록
	@GetMapping("/station/view")
    public String showRouteStationView(Model model, HttpSession session) {
		// 서비스키 전달
		String tagoKey = servletContext.getInitParameter("tago.serviceKey");
        model.addAttribute("tagoKey", tagoKey);
        
        Integer unum = (Integer) session.getAttribute("unum"); 
        List<StationVO> stationList = null;
    	if (unum != null) {
            // 로그인 상태용 쿼리 호출 (즐겨찾기 포함)
    		stationList = routeService.getAllStationsWithFavorite(unum);
        } else {
            // 비로그인 상태용 쿼리 호출 (즐겨찾기 없음)
            stationList = routeService.getAllStations();
        }
        
        model.addAttribute("stations", stationList);
        return "route/station/view";
    }
	
	// 버스목록, 노선
	@GetMapping("/bus/view")
    public String showRouteBusView(Model model) {
        return "route/bus/view";
    }
}
