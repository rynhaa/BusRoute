package com.busroute.domain;

import lombok.Data;

@Data
public class StationVO {
	private String sttn_id;
	private String bims_id;
	private String sttn_nm;
	private String sttn_arsno;
	private Double latitude;
	private Double longitude;
	private int city_code;
	
	/* 노선 */
	private int station_order;
	private String direction;
	private Double distance_km;
	private int estimated_time_min;
	private String route_id;
	
	/* 즐겨찾기 용 */
	private int is_favorite;
}
