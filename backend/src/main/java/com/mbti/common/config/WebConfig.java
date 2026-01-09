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
                // edge chrome 의 경우 개발자가 개발을 하기 위해 테스트모드
                // 1. debug print 를 사용해서 개발자가 작성한 데이터나 기능 결과를 확인
                // 2. 테스트가 종료되고 나면 웹사이트를 필요로 하지 않으나,
                // 3. 상황에 따라 테스트 모드 웹 사이트를 배포용 웹 사이트
                // 4. 다시 시작할 때마다 변경되는 port 번호를 고정적으로 변경할 수 있다.
                registry.addMapping("/api/**")
                        .allowedOrigins(
                                "http://localhost:3001",
                                "http://localhost:3000", // IOS 테스트에서는 8080
                                "http://localhost:59079",
                                "http://localhost:8080",
                                "http://10.0.2.2:8080" // 안드로이드 핸드폰 테스트
                        )
                        .allowCredentials(true)
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");
            };
        };
    }
}
