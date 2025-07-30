package com.busroute.domain;

import lombok.Data;

@Data
// 노선별 버스 실시간 위치정보 API
public class BusLocationVO {
    private String nodeid;      // 정류장 ID
    private String nodenm;      // 정류장 이름
    private int nodeord;        // 정류장 순서
    private Double gpslati;     // 위도
    private Double gpslong;     // 경도
    private String vehicleno;   // 차량 번호
    private String routenm;     // 노선 번호
    private String routetp;     // 버스 종류
}

