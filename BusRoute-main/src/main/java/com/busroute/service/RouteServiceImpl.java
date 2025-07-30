package com.busroute.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.busroute.domain.BusVO;
import com.busroute.domain.StationVO;
import com.busroute.mapper.RouteMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class RouteServiceImpl implements RouteService {
	
	@Autowired
	private RouteMapper mapper;

	@Override
	public List<StationVO> getAllStations() {
		return mapper.selectAllStations();
	}
	
	@Override
	public List<StationVO> getAllStationsWithFavorite(int unum) {
		return mapper.selectAllStationsWithFavorite(unum);
	}

	@Override
	public BusVO getBusByRouteId(String routeId) {
		return mapper.selectBusByRouteId(routeId);
	}

	@Override
	public List<BusVO> getBusListByNodeNo(List<String> nodeNoList, int cityCode) {
		if (nodeNoList == null || nodeNoList.isEmpty()) {
            return new ArrayList<>();
        }
		return mapper.selectBusListByNodeNo(nodeNoList, cityCode);
	}
	
	@Override
	public List<BusVO> getBusListByNodeNoWithFavorite(List<String> nodeNoList, int cityCode, int unum) {
		if (nodeNoList == null || nodeNoList.isEmpty()) {
            return new ArrayList<>();
        }
		return mapper.selectBusListByNodeNoWithFavorite(nodeNoList, cityCode, unum);
	}

	@Override
	public List<BusVO> getBusListByCity(int cityCodeInt, String keyword) {
		return mapper.selectBusListByCity(cityCodeInt, keyword);
	}
	
	@Override
	public List<BusVO> getBusListByCityWithFavorite(int cityCodeInt, String keyword, int unum) {
		return mapper.getBusListByCityWithFavorite(cityCodeInt, keyword, unum);
	}

	@Override
	public List<StationVO> getStationListByRoute(String routeId) {
		return mapper.selectStationByRouteId(routeId);
	}

	@Override
	public List<StationVO> getStationsByRouteId(String routeId) {
		return mapper.getStationsByRouteId(routeId);
	}

	@Override
	public List<StationVO> searchStations(String keyword, String cityCode) {
		int cityCodeInt = Integer.parseInt(cityCode);
		System.out.println("RouteServiceImpl의 cityCode : " + cityCodeInt);
		return mapper.searchStations(keyword, cityCodeInt);
	}
	
	@Override
	public List<StationVO> searchStationsWithFavorite(String cityCode, String keyword, int unum) {
		int cityCodeInt = Integer.parseInt(cityCode);
		System.out.println("RouteServiceImpl의 cityCode : " + cityCodeInt);
		return mapper.searchStationsWithFavorite(cityCodeInt, keyword, unum);
	}


}
