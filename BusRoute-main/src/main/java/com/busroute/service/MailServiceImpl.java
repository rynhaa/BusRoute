package com.busroute.service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.jsoup.Jsoup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.busroute.domain.EmailLogVO;
import com.busroute.mapper.EmailLogMapper;

@Service
public class MailServiceImpl implements MailService {
	@Autowired
    private JavaMailSender mailSender;

    @Autowired
    private EmailLogMapper emailLogMapper;

    @Async
    public void sendEmail(String to, String subject, String content) throws MessagingException {
        System.out.println("비동기 메일 전송 스레드 이름: " + Thread.currentThread().getName());

        EmailLogVO log = new EmailLogVO();
        log.setRecipient_email(to);
        log.setSubject(subject);

        // ✅ HTML 제거 후 텍스트만 content_preview 에 저장
        String previewText = Jsoup.parse(content).text();
        if (previewText.length() > 50) {
            previewText = previewText.substring(0, 50);
        }
        log.setContent_preview(previewText);

        log.setSent_by(getCurrentUserId());

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(content, true);  // HTML 메일 본문 그대로 전송

            mailSender.send(message);

            log.setSend_status("SUCCESS");
            emailLogMapper.insertEmailLog(log);
        } catch (MessagingException e) {
            log.setSend_status("FAIL");
            log.setFail_reason(e.getMessage());
            emailLogMapper.insertEmailLog(log);

            throw e;
        }
    }

    // 로그인 사용자 ID 추출 (세션 또는 Security 연동 필요)
    private Integer getCurrentUserId() {
        return 1; // 예시: 시스템 전송이면 고정값 or null
    }
}
