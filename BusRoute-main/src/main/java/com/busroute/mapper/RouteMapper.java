package com.busroute.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.BusVO;
import com.busroute.domain.StationVO;

public interface RouteMapper {
	List<StationVO> selectAllStations();

	List<StationVO> selectAllStationsWithFavorite(int unum);
	
	BusVO selectBusByRouteId(@Param("routeId") String routeId);

	List<BusVO> selectBusListByNodeNo(@Param("list") List<String> nodeNoList, @Param("cityCode") int cityCode);

	List<BusVO> selectBusListByNodeNoWithFavorite(@Param("list") List<String> nodeNoList, @Param("cityCode") int cityCode, @Param("unum") int unum);
	
	List<BusVO> selectBusListByCity(@Param("cityCode") int cityCodeInt, @Param("keyword") String keyword);
	
	List<BusVO> getBusListByCityWithFavorite(@Param("cityCode") int cityCodeInt, @Param("keyword") String keyword, @Param("unum") int unum);

	List<StationVO> selectStationByRouteId(@Param("routeId") String routeId);
	
	List<StationVO> getStationsByRouteId(@Param("routeId") String routeId);

	List<StationVO> searchStations(@Param("keyword") String keyword, @Param("cityCode") int cityCode);

	List<StationVO> searchStationsWithFavorite(@Param("cityCode") int cityCodeInt, @Param("keyword") String keyword, @Param("unum") int unum);

	List<BusVO> getRouteListByCityCode(int cityCode);
	

}