package com.mbti.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

//    @Value("${file.profile.upload.path}")
//    private String profileUploadPath;
//
//    @Value("${file.story.upload.path}")
//    private String storyUploadPath;
//
//    @Value("${file.post.upload.path}")
//    private String postUploadPath;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // REST API CORS 설정
                registry.addMapping("/api/**")
                        .allowedOrigins(
                                "http://localhost:3001",
                                "http://localhost:3000", // IOS 테스트에서는 8080
                                "http://localhost:53302",
                                "http://10.0.2.2:8080" // 안드로이드 핸드폰 테스트
                        )
                        .allowCredentials(true)
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");
            };
        };
    }
}
