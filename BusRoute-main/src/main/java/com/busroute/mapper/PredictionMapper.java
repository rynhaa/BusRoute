package com.busroute.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.busroute.domain.PredictionVO;

@Mapper
public interface PredictionMapper {

	List<PredictionVO> predict(@Param("startDate") String startDate, @Param("interval") String interval,
			@Param("region") String region, @Param("routeId") String routeId, @Param("model") String model);

}
