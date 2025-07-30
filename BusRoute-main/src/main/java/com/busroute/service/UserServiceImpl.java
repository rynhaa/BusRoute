package com.busroute.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.busroute.domain.UserVO;
import com.busroute.mapper.UserMapper;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	private UserMapper mapper;

	@Override
	public UserVO findById(String userid) {
		return mapper.findById(userid);
	}

	@Override
	public void join(UserVO vo) {
		// TODO Auto-generated method stub
		mapper.join(vo);
		
	}

	@Override
	public int idCheck(String userid) {
		// TODO Auto-generated method stub
		return mapper.idCheck(userid);
	}

	@Override
	public void updateLastLogin(String userid) {
		// TODO Auto-generated method stub
		mapper.updateLastLogin(userid);
		
	}

	@Override
	public void edit(UserVO vo) {
		// TODO Auto-generated method stub
		mapper.edit(vo);
		
	}

	@Override
	public int eamilCheck(String email) {
		// TODO Auto-generated method stub
		return mapper.emailCheck(email);
	}
	
	
	@Override
	public void save(UserVO user) {
		mapper.insert(user);
		
	}

	@Override
	public List<UserVO> getAllUsers(Map<String, Object> params) {
		return mapper.selectAllUsers(params);
	}

	@Override
	public int countAllUsers(Map<String, Object> params) {
		return mapper.selectCountAllUsers(params);
	}

	@Override
	public UserVO getUserByUnum(int unum) {
		return mapper.selectUserByUnum(unum);
	}

	@Override
	public void updateUserInfo(UserVO userInfo) {
		mapper.updateUserInfo(userInfo);
	}

	@Override
	public void resetPassword(int unum, String encoded) {
		mapper.resetPassword(unum, encoded);
	}

	@Override
	public int isEmailExistsExcludeSelf(String email, int unum) {
		return mapper.countByEmailExcludingUnum(email, unum);
	}
	
	@Override
	public List<UserVO> selectAllUsersForRoleChange(Map<String, Object> params) {
		return mapper.selectAllUsersForRoleChange(params);
	}
	
	@Override
	public void updateUserRole(int unum, String newRole) {
		mapper.updateUserRole(unum, newRole);
	}
	
	@Override
	public List<UserVO> selectAdminForRoleChange(Map<String, Object> params) {
		return mapper.selectAdminForRoleChange(params);
	}
	
	@Override
	public void insertNewAdminCreate(UserVO user) {
		mapper.insertNewAdminCreate(user);
	}
	
	@Override
	public void updateAdminNotAtive(int unum) {
		mapper.updateAdminNotAtive(unum);
	}
	
	@Override
	public void updateAdminActivate(int unum) {
		mapper.updateAdminActivate(unum);
	}
	
	@Override
	public void updateAdmininfo(UserVO user) {
		mapper.updateAdmininfo(user);
	}
	
	@Override
	public List<UserVO> getSuspendedUsers(Map<String, Object> params) {
		return mapper.getSuspendedUsers(params);
	}

	@Override
	public int countSuspendedUsers(Map<String, Object> params) {
		return mapper.countSuspendedUsers(params);
	}

	// 사용자 통계
	@Override
	public int getTotalUserCount() {
		return mapper.getTotalUserCount();
	}

	@Override
	public int getDeletedUserCount() {
		return mapper.getDeletedUserCount();
	}

	@Override
	public int getRecentLoginUserCount(int days) {
		return mapper.getRecentLoginUserCount(days);
	}

	@Override
	public List<UserVO> getMonthlySignups() {
		return mapper.getMonthlySignups();
	}

	@Override
	public List<UserVO> getRecentLoginUsers(int limit) {
		return mapper.getRecentLoginUsers(limit);
	}

	@Override
	public List<UserVO> getUserRegionDistribution() {
		return mapper.getUserRegionDistribution();
	}
	
	@Override
	public List<UserVO> getUserRoleCount() {
		return mapper.getUserRoleCount();
	}
	
	@Override
	public String getEmailByUserId(String userId) {
	    return mapper.findEmailByUserId(userId);
	}
}
