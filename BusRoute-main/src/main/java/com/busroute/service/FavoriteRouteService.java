package com.busroute.service;

import java.util.List;

import com.busroute.domain.FavoriteRouteVO;

public interface FavoriteRouteService {
	boolean toggleFavorite(int userNum, String routeId);

	boolean toggleFavoriteStation(int userNum, String sttnId);

	List<FavoriteRouteVO> selectFavoriteBusList(int unum);

	List<FavoriteRouteVO> selectFavoriteStationList(int unum);
}
