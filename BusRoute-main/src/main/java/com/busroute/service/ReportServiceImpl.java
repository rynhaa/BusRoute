package com.busroute.service;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import com.busroute.domain.Criteria;
import com.busroute.domain.ReportVO;
import com.busroute.mapper.BoardMapper;
import com.busroute.mapper.ReportMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class ReportServiceImpl implements ReportService {
	private ReportMapper mapper;
	

	public List<ReportVO> list() {
		
		return mapper.list();
		
	}
	


	@Override
	public List<ReportVO> getListWithPaging(Map<String, Object> paramMap) {
	    return mapper.getListWithPaging(paramMap);
	}

	@Override
	public int getTotalCount(Map<String, Object> paramMap) {
	    return mapper.getTotalCount(paramMap);
	}
	

	@Transactional
	public ReportVO get(int report_id) {


		return mapper.read(report_id);
	}
	

	public void modify(ReportVO report) {
		
		mapper.update(report);
	}
	

	public void remove(int report_id) {
		
		mapper.delete(report_id);
	}
	
	public void register(ReportVO report) {
		
		mapper.insertSelectKey(report);
	}
	
	// 마이페이지 접수내역
	@Override
	public List<ReportVO> findReportByUser(String userid) {
		return mapper.findReportByUser(userid);
	}
	
	
    @Override
    public void updateStatus(int reportId, String status) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("report_id", reportId);
        paramMap.put("status", status);
        mapper.updateStatus(paramMap);
    }
    
    @Override
    public List<Map<String, Object>> getDailyReportStats(Map<String, Object> param) {
        return mapper.getDailyReportStats(param);
    }
    
    @Override
    public List<Map<String, Object>> getCategoryStats() {
        return mapper.getCategoryStats();
    }
    
    @Override
    public int getTotalCountWithFilter(Map<String, Object> params) {
        return mapper.getTotalCountWithFilter(params);
    }

    @Override
    public List<Map<String, Object>> getStatusStats(Map<String, Object> params) {
        return mapper.getStatusStats(params);
    }
    
    
    @Override
    public Integer getAverageProcessSeconds() {
        return mapper.getAverageProcessSeconds();
    }
    
    
    @Override
    public Map<String, int[]> getHourlyCreatedAndReplied() {

        int[] created = new int[24];
        int[] replied = new int[24];

        List<Map<String, Object>> createdList = mapper.selectHourlyCreatedCounts();
        List<Map<String, Object>> repliedList = mapper.selectHourlyRepliedCounts();

        for (Map<String, Object> row : createdList) {
            int hour = ((Number) row.get("hour")).intValue();
            int cnt = ((Number) row.get("cnt")).intValue();
            created[hour] = cnt;
        }

        for (Map<String, Object> row : repliedList) {
            int hour = ((Number) row.get("hour")).intValue();
            int cnt = ((Number) row.get("cnt")).intValue();
            replied[hour] = cnt;
        }

        Map<String, int[]> result = new HashMap<>();
        result.put("created", created);
        result.put("replied", replied);

        return result;
    }



	@Override
	public List<Map<String, Object>> countReportsByUser(String userid) {
		return mapper.countReportsByUser(userid);
	}
	
	@Override
	public Double getCompletionRate() {
	    return mapper.getCompletionRate();
	}
	
}
