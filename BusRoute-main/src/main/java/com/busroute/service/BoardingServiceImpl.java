package com.busroute.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.busroute.domain.BoardingDTO;
import com.busroute.mapper.BoardingMapper;

@Service
public class BoardingServiceImpl implements BoardingService {

    @Autowired
    private BoardingMapper mapper;

    @Autowired
    public BoardingServiceImpl(BoardingMapper boardingMapper) {
        this.mapper = boardingMapper;
    }

    @Override
    public List<BoardingDTO> getDailyBoardingStats(String routeId, String region, String startDate, String endDate) {
        return mapper.selectDailyBoardingStats(routeId, region, startDate, endDate);
    }

    @Override
    public String getRouteIdByBusNumber(String busNumber) {
        // 실제 구현은 Mapper에서 쿼리 작성 필요
        // 여기서는 예시로 null 리턴
        return mapper.selectRouteIdByBusNumber(busNumber);
    }

    @Override
    public List<String> getRouteList(String cityCode) {
        // 실제 구현은 Mapper에서 쿼리 작성 필요
        return mapper.selectRouteListByCityCode(cityCode);
    }



}
