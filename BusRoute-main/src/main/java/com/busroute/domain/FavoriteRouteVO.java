package com.busroute.domain;

import java.util.Date;

import lombok.Data;

@Data
public class FavoriteRouteVO {
	private int favoriteId;
    private int userNum;
    private String routeId;
    private Date createdAt;
    private String sttnId;
    
    // 마이페이지 출력 용
    private String busNumber;
    private String busType;
    private String sttnNm;
    private int cityCode;
    private String sttnArsno;
}
