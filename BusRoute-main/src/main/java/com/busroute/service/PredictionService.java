package com.busroute.service;

import java.util.List;

import com.busroute.domain.PredictionVO;

public interface PredictionService {

	List<PredictionVO> predict(String startDate, String interval, String region, String routeId, String model);
}
