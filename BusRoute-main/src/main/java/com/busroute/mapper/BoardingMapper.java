package com.busroute.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.busroute.domain.BoardingDTO;

import java.util.List;

@Mapper
public interface BoardingMapper {

    List<BoardingDTO> selectDailyBoardingStats(
        @Param("routeId") String routeId,
        @Param("region") String region,
        @Param("startDate") String startDate,  // "YYYY-MM-DD"
        @Param("endDate") String endDate       // "YYYY-MM-DD"
    );

	String selectRouteIdByBusNumber(String busNumber);

	List<String> selectRouteListByCityCode(String cityCode);
}
