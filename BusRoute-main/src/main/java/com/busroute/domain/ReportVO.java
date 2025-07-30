package com.busroute.domain;

import java.util.Date;

import lombok.Data;

@Data
public class ReportVO {
	
	private int report_id;
	private String user_id;
	private String category;
	private String title;
	private String content;
	private String attachmentPath;
	private String status;
	private String admin_reply;
	private Date replied_at;
	private Date created_at;
	
	private String username;
	
	
    private int displayNo;  // 화면 출력용 번호

    public int getDisplayNo() {
        return displayNo;
    }

    public void setDisplayNo(int displayNo) {
        this.displayNo = displayNo;
    }
} 
