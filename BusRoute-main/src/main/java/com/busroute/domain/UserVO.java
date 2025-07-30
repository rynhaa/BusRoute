package com.busroute.domain;

import java.util.Date;

import lombok.Data;

@Data
public class UserVO {

	private int unum;
	private String userid;
	private String username;
	private String phone;
	private String password;
	private String email;
	private String address;
	private String role;
	private Date create_at;
	private Date password_updated_at;
	private Boolean is_deleted;
	private Date last_login_at;
	
	// 사용자 통계 시 사용
	private String region;
    private int count;
    private String month;
    
    // 권한변경 시 사용
    private String newRole;
    private Date applied_at;
    
    // 제한관리 시 사용
    private String current_role;
    private String before_role;
    private String after_role;
    private Date changed_at;
    private String change_reason;
    private int changed_by;
}
