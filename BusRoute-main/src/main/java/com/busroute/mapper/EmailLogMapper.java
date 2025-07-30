package com.busroute.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.EmailLogVO;

public interface EmailLogMapper {
	
    void insertEmailLog(EmailLogVO emailLog);
    List<EmailLogVO> findAll();

    int getTotalCount(@Param("keyword") String keyword, @Param("send_status") String sendStatus);
    List<EmailLogVO> findWithPagingAndFilter(@Param("keyword") String keyword,
                                             @Param("send_status") String sendStatus,
                                             @Param("offset") int offset,
                                             @Param("limit") int limit);
}
