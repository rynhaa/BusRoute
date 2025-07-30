package com.busroute.service;

import java.util.List;
import java.util.Map;

import com.busroute.domain.UserVO;

public interface UserService {

	UserVO findById(String userid);

	void join(UserVO vo);

	int idCheck(String userid);

	void updateLastLogin(String userid);

	void edit(UserVO vo);

	int eamilCheck(String email);

	void save(UserVO user);

	List<UserVO> getAllUsers(Map<String, Object> params);

	int countAllUsers(Map<String, Object> params);

	UserVO getUserByUnum(int unum);

	void updateUserInfo(UserVO userInfo);

	void resetPassword(int unum, String encoded);

	int isEmailExistsExcludeSelf(String email, int unum);
	
	List<UserVO> selectAllUsersForRoleChange(Map<String, Object> params);
	
	void updateUserRole(int unum, String newRole);
	
	List<UserVO> selectAdminForRoleChange(Map<String, Object> params);
	
	void insertNewAdminCreate(UserVO user);
	
	void updateAdminNotAtive(int unum);
	
	void updateAdminActivate(int unum);
	
	void updateAdmininfo(UserVO user);
	
	List<UserVO> getSuspendedUsers(Map<String, Object> params);
	
	int countSuspendedUsers(Map<String, Object> params);
	
	// 사용자 통계
	int getTotalUserCount();

	int getDeletedUserCount();

	int getRecentLoginUserCount(int days);

	List<UserVO> getMonthlySignups();
	
	List<UserVO> getRecentLoginUsers(int limit);
	
	List<UserVO> getUserRegionDistribution();
	
	List<UserVO> getUserRoleCount();
	
	// 사용자 ID로 이메일 조회
	String getEmailByUserId(String userId);
}
