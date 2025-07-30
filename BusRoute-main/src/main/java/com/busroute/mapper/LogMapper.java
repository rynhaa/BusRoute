package com.busroute.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.RoleLogVO;

public interface LogMapper {

	List<RoleLogVO> selectRoleChangeLogList(Map<String, Object> params);

	int countRoleChangeLog(Map<String, Object> params);

	void insertRoleChangeLog(@Param("unum") int unum, @Param("beforeRole") String beforeRole, @Param("newRole") String newRole, 
			@Param("adminUnum") int adminUnum, @Param("reason") String reason, @Param("changeType") String changeType);

}
