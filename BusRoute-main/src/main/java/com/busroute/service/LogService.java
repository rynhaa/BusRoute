package com.busroute.service;

import java.util.List;
import java.util.Map;

import com.busroute.domain.RoleLogVO;

public interface LogService {

	List<RoleLogVO> selectRoleChangeLogList(Map<String, Object> params);

	int countRoleChangeLog(Map<String, Object> params);

	void insertRoleChangeLog(int unum, String beforeRole, String newRole, int adminUnum, String reason, String changeType);
	
}
