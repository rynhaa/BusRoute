package com.busroute.domain;

import java.util.Date;
import java.util.List;


import lombok.Data;

@Data
public class BoardVO {
	private int board_id;
	private String type;
	private String title;
	private String content;
	private String writer_id;
	private int view_count;
	private boolean pinned;   
	private Date created_at;
	private Date updated_at;
	
	private String username; 
	
}
