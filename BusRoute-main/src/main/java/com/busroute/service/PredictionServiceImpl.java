package com.busroute.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.busroute.domain.PredictionVO;
import com.busroute.mapper.PredictionMapper;

@Service
public class PredictionServiceImpl implements PredictionService {
	
	@Autowired
    private PredictionMapper mapper;

	@Override
	public List<PredictionVO> predict(String startDate, String interval, String region, String routeId, String model) {
		// TODO Auto-generated method stub
		if (region != null) {
		    Map<String, String> regionMap = Map.of(
		        "21", "부산",
		        "22", "대구",
		        "24", "광주",
		        "26", "울산"
		    );
		    if (region != null && regionMap.containsKey(region)) {
		        region = regionMap.get(region);
		    }
		}
		return mapper.predict(startDate, interval, region, routeId, model);
	}


}
