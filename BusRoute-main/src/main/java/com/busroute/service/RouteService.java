package com.busroute.service;

import java.util.List;

import com.busroute.domain.BusVO;
import com.busroute.domain.StationVO;

public interface RouteService {
	
	public List<StationVO> getAllStations();
	
	public List<StationVO> getAllStationsWithFavorite(int unum);
	
	public BusVO getBusByRouteId(String routeId);

	public List<BusVO> getBusListByNodeNo(List<String> nodeNoList, int cityCodeInt);
	
	public List<BusVO> getBusListByNodeNoWithFavorite(List<String> nodeNoList, int cityCodeInt, int unum);
	
	public List<BusVO> getBusListByCity(int cityCodeInt, String keyword);
	
	public List<BusVO> getBusListByCityWithFavorite(int cityCodeInt, String keyword, int unum);
	
	public List<StationVO> getStationListByRoute(String routeId);

	public List<StationVO> getStationsByRouteId(String routeId);

	public List<StationVO> searchStations(String keyword, String cityCode);

	public List<StationVO> searchStationsWithFavorite(String cityCode, String keyword, int unum);



}
