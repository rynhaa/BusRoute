package com.busroute.service;

import javax.mail.MessagingException;

public interface MailService {
	public void sendEmail(String to, String subject, String content) throws MessagingException;
}
