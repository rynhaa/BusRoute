package com.busroute.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.busroute.domain.Criteria;
import com.busroute.domain.ReportVO;

public interface ReportMapper {
	
    public List<ReportVO> list();

    List<ReportVO> getListWithPaging(Map<String, Object> paramMap);
    
    int getTotalCount(Map<String, Object> paramMap);
        
    public ReportVO read(int report_id);

    public void update(ReportVO report);

    public void delete(int report_id);

    public void insert(ReportVO report);

    public void insertSelectKey(ReportVO report);

    public List<ReportVO> findReportByUser(String userid);
    
    void updateStatus(Map<String, Object> paramMap);
    
    List<Map<String, Object>> getDailyReportStats(Map<String, Object> param);
    
    List<Map<String, Object>> getCategoryStats();
    
    // 전체 건수 조회 (필터 적용)
    int getTotalCountWithFilter(Map<String, Object> params);

    // 상태별 접수 건수 조회 (필터 적용)
    List<Map<String, Object>> getStatusStats(Map<String, Object> params);
    
    Integer getAverageProcessSeconds();
    
    List<Map<String, Object>> selectHourlyCreatedCounts();

    List<Map<String, Object>> selectHourlyRepliedCounts();

    List<Map<String, Object>> countReportsByUser(@Param("userid") String userid);
    
    public Double getCompletionRate();
}

