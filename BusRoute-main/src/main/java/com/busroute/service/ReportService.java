package com.busroute.service;

import java.util.List;
import java.util.Map;

import com.busroute.domain.Criteria;
import com.busroute.domain.ReportVO;

public interface ReportService {
	
	public List<ReportVO> list();
	
	List<ReportVO> getListWithPaging(Map<String, Object> paramMap);
	
	int getTotalCount(Map<String, Object> paramMap);
	
	public ReportVO get(int report_id);
	
	public void modify(ReportVO report);
	
	public void remove(int report_id);
	
	public void register(ReportVO report);

	// 마이페이지 접수내역
	public List<ReportVO> findReportByUser(String userid);
	
	void updateStatus(int reportId, String status);
	
	List<Map<String, Object>> getDailyReportStats(Map<String, Object> param);
	
	List<Map<String, Object>> getCategoryStats();
	
    // 전체 건수 조회 (필터 적용)
    int getTotalCountWithFilter(Map<String, Object> params);

    // 상태별 접수 건수 조회 (필터 적용)
    List<Map<String, Object>> getStatusStats(Map<String, Object> params);
    
    Integer getAverageProcessSeconds();
    
    Map<String, int[]> getHourlyCreatedAndReplied();

    List<Map<String, Object>> countReportsByUser(String userid);
    
    public Double getCompletionRate();
}
