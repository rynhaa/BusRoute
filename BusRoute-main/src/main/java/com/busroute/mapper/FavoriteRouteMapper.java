package com.busroute.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.FavoriteRouteVO;

public interface FavoriteRouteMapper {
	
	FavoriteRouteVO findFavorite(@Param("userNum") int userNum, @Param("routeId") String routeId);

    void insertFavorite(@Param("userNum") int userNum, @Param("routeId") String routeId);

    void deleteFavorite(@Param("userNum") int userNum, @Param("routeId") String routeId);
    
    FavoriteRouteVO findFavoriteStation(@Param("userNum") int userNum, @Param("sttnId") String sttnId);
    
    void insertFavoriteStation(@Param("userNum") int userNum, @Param("sttnId") String sttnId);
    
    void deleteFavoriteStation(@Param("userNum") int userNum, @Param("sttnId") String sttnId);
    
    List<FavoriteRouteVO> selectFavoriteBusList(@Param("userNum") int userNum);
    
    List<FavoriteRouteVO> selectFavoriteStationList(@Param("userNum") int userNum);
}
