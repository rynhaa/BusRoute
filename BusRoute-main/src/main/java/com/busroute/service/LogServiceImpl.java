package com.busroute.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.busroute.domain.RoleLogVO;
import com.busroute.mapper.LogMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class LogServiceImpl implements LogService {
	
	@Autowired
	private LogMapper mapper;

	@Override
	public List<RoleLogVO> selectRoleChangeLogList(Map<String, Object> params) {
		return mapper.selectRoleChangeLogList(params);
	}

	@Override
	public int countRoleChangeLog(Map<String, Object> params) {
		return mapper.countRoleChangeLog(params);
	}

	@Override
	public void insertRoleChangeLog(int unum, String beforeRole, String newRole, int adminUnum, String reason, String changeType) {
		mapper.insertRoleChangeLog(unum, beforeRole, newRole, adminUnum, reason, changeType);
	}

}
