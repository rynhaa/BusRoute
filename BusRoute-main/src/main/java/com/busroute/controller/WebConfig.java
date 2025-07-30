package com.busroute.controller;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        resolver.setMaxUploadSize(52428800); // 50MB
        return resolver;
    }

	/*
	 * @Override public void addResourceHandlers(ResourceHandlerRegistry registry) {
	 * // 외부 업로드 파일 경로를 웹에서 /upload/**로 접근 가능하게 설정
	 * registry.addResourceHandler("/upload/**")
	 * .addResourceLocations("file:///C:/upload/"); // 슬래시 3개 주의! }
	 */
}
