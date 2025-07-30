package com.busroute.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.util.UUID;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;


@RestController

public class UploadController {

	
    /** 물리 저장 위치(UNC) */
    private static final Path UPLOAD_DIR = Paths.get("\\\\192.168.30.231\\upload");

    /**
     * 이미지 또는 첨부파일 보여주기
     *  예)  /display?fileName=uuid_img.jpg
     */
    @GetMapping("/display")
    public ResponseEntity<?> display(String fileName) {
        try {
            // 1) 파일명 URL 디코딩 (한글·공백 대비)
            String decoded = URLDecoder.decode(fileName, "UTF-8");

            // 2) 경로 가로채기 방지 (`..` 등) ‑‑ 업로드 폴더 기준으로만 해석
            Path filePath = UPLOAD_DIR.resolve(decoded).normalize();
            if (!filePath.startsWith(UPLOAD_DIR)) {
                return ResponseEntity.badRequest().body("잘못된 파일 경로");
            }

            // 3) 파일 존재 여부
            if (!Files.exists(filePath)) {
                return ResponseEntity.notFound().build();
            }

            // 4) MIME 타입
            String mimeType = Files.probeContentType(filePath);
            if (mimeType == null) mimeType = MediaType.APPLICATION_OCTET_STREAM_VALUE;

            // 5) 브라우저에 직접 표시(inline) — 다운로드로 바꾸려면 attachment
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(mimeType));
            headers.setCacheControl("public, max-age=3600"); // 1시간 캐시 (선택)

            InputStreamResource resource = new InputStreamResource(Files.newInputStream(filePath));
            return ResponseEntity.ok()
                                 .headers(headers)
                                 .body(resource);

        } catch (IOException e) {
        	 return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("파일 읽기 오류");
        }
    }

    @PostMapping("/save")
    public String saveImage(@RequestParam("filename") String filename) {
        // ���� ���ε� ���� (��: �ӽ� ��� -> ���� ��� �� �̵� ó��)
        return "redirect:/report/user/list";
    }
}
