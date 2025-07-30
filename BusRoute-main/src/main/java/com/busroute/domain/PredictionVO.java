package com.busroute.domain;

import java.util.Date;

import lombok.Data;

@Data
public class PredictionVO {

	private int prediction_id;
	private String route_id;
	private Date  date_time;
	private int predicted_boarding;
	private int predicted_alighting;
	private String region;
	private String model_name;
	private int weather_id;
	
	private String intervalTime;
	private int totalBoarding;
	private int totalAlighting;
}
