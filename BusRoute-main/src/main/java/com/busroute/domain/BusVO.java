package com.busroute.domain;

import lombok.Data;

@Data
public class BusVO {
	private String bus_id;
	private String route_id;
	private String bus_number;
	private String bus_type;
	private String start_station_name;
	private String end_station_name;
	private String start_time;
	private String end_time;
	private int interval_weekday;
	private int intinterval_saturday;
	private int interval_sunday;
	private int city_code;
	
	private int is_favorite;
}
