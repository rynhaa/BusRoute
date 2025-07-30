package com.busroute.domain;

import java.sql.Timestamp;

public class EmailLogVO {
    private int email_log_id;
    private String recipient_email;
    private String subject;
    private String content_preview;
    private String send_status;
    private String fail_reason;
    private Integer sent_by;
    private Timestamp sent_at;

    public int getEmail_log_id() {
        return email_log_id;
    }

    public void setEmail_log_id(int email_log_id) {
        this.email_log_id = email_log_id;
    }

    public String getRecipient_email() {
        return recipient_email;
    }

    public void setRecipient_email(String recipient_email) {
        this.recipient_email = recipient_email;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent_preview() {
        return content_preview;
    }

    public void setContent_preview(String content_preview) {
        this.content_preview = content_preview;
    }

    public String getSend_status() {
        return send_status;
    }

    public void setSend_status(String send_status) {
        this.send_status = send_status;
    }

    public String getFail_reason() {
        return fail_reason;
    }

    public void setFail_reason(String fail_reason) {
        this.fail_reason = fail_reason;
    }

    public Integer getSent_by() {
        return sent_by;
    }

    public void setSent_by(Integer sent_by) {
        this.sent_by = sent_by;
    }

    public Timestamp getSent_at() {
        return sent_at;
    }

    public void setSent_at(Timestamp sent_at) {
        this.sent_at = sent_at;
    }
}
