package com.busroute.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.UserVO;

public interface UserMapper {

	UserVO findById(String userid);

	int idCheck(String userid);

	void join(UserVO vo);

	void updateLastLogin(String userid);

	void edit(UserVO vo);

	int emailCheck(String email);

	void insert(UserVO user);

	List<UserVO> selectAllUsers(Map<String, Object> params);

	int selectCountAllUsers(Map<String, Object> params);

	UserVO selectUserByUnum(@Param("unum") int unum);

	void updateUserInfo(UserVO userInfo);

	void resetPassword(@Param("unum") int unum, @Param("encoded") String encoded);

	int countByEmailExcludingUnum(@Param("email") String email, @Param("unum") int unum);
	
	List<UserVO> selectAllUsersForRoleChange(Map<String, Object> params);

	void updateUserRole(@Param("unum") int unum, @Param("newRole") String newRole);
	
	List<UserVO> selectAdminForRoleChange(Map<String, Object> params);
	
	void insertNewAdminCreate(UserVO user);
	
	void updateAdminNotAtive(@Param("unum") int unum);
	
	void updateAdminActivate(@Param("unum") int unum);
	
	void updateAdmininfo(UserVO user);
	
	List<UserVO> getSuspendedUsers(Map<String, Object> params);
	
	int countSuspendedUsers(Map<String, Object> params);
	
	// 사용자 통계
	int getTotalUserCount();

	int getDeletedUserCount();

	int getRecentLoginUserCount(@Param("days") int days);

	List<UserVO> getMonthlySignups();

	List<UserVO> getRecentLoginUsers(@Param("limit") int limit);

	List<UserVO> getUserRegionDistribution();
	
	List<UserVO> getUserRoleCount();
	
	String findEmailByUserId(String userId);
}
