package com.busroute.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.BoardingDTO;

public interface BoardingService {
	
	List<BoardingDTO> getDailyBoardingStats(@Param("routeId") String routeId, @Param("region") String region, @Param("startDate") String startDate, @Param("endDate") String endDate);

    // bus_number → route_id 변환용 메서드 (필요시)
    String getRouteIdByBusNumber(String busNumber);

    // 지역별 노선 리스트 조회 메서드 (필요시)
    List<String> getRouteList(String cityCode);
}
