package com.busroute.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.busroute.domain.FavoriteRouteVO;
import com.busroute.mapper.FavoriteRouteMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class FavoriteRouteServiceImpl implements FavoriteRouteService {
	
	@Autowired
    private FavoriteRouteMapper mapper;
	
	public boolean toggleFavorite(int userNum, String routeId) {
        FavoriteRouteVO existing = mapper.findFavorite(userNum, routeId);
        System.out.println("userNum? : " + userNum + " routeId? : " + routeId);
        System.out.println("존재함? : " + existing);
        if (existing == null) {
        	mapper.insertFavorite(userNum, routeId);
            return true;  // added
        } else {
        	mapper.deleteFavorite(userNum, routeId);
            return false; // removed
        }
    }

	@Override
	public boolean toggleFavoriteStation(int userNum, String sttnId) {
		FavoriteRouteVO existing = mapper.findFavoriteStation(userNum, sttnId);
		System.out.println("존재함? : " + existing);
        if (existing == null) {
        	mapper.insertFavoriteStation(userNum, sttnId);
            return true;  // added
        } else {
        	mapper.deleteFavoriteStation(userNum, sttnId);
            return false; // removed
        }
	}

	@Override
	public List<FavoriteRouteVO> selectFavoriteBusList(int unum) {
		return mapper.selectFavoriteBusList(unum);
	}

	@Override
	public List<FavoriteRouteVO> selectFavoriteStationList(int unum) {
		return mapper.selectFavoriteStationList(unum);
	}
	
	
}
