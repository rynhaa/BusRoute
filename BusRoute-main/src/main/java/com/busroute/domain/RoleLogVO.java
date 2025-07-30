package com.busroute.domain;

import java.util.Date;

import lombok.Data;

@Data
public class RoleLogVO {
	private int log_id;
	private int target_unum;
	private int changed_by;
	private String before_role;
	private String after_role;
	private String change_reason;
	private Date changed_at;
	private String change_type;
	
	private String target_userid;
	private String target_username;
	private String admin_userid;
	private String admin_username;
}
