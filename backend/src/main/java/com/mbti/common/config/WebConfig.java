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
                        /*
                        .allowedOriginPatterns("*") + .allowCredentials(true)
                        -> 가능

                        .allowedOrigin + .allowCredentials(true)
                        -> 사용 불가
                        -> 함께 사용하면 .allowedOrigin 주소 문자열 내부에 * 사용 불가

                        .allowedOrigin + .allowCredentials(false)
                        -> ok

                        .allowedOrigin("특정 주소: 특정 포트", "특정 주소: 특정 포트") + .allowCredentials(true)
                        -> * 가 없으므로 사용 가능

                        .allowCredentials(true)
                        -> 프론트 엔드와 백엔드 사이에서 다음 정보들이 오고 갈 수 있다.
                            쿠키(로그인 세션 ID), 인증 헤거 Bearer <토큰> 같은 헤더, 클라이언트 보안 인증서
                            -> 만약 false 로 하면
                                -> 어라? 보안 설정 때문에 쿠키 못 보내네 유감이야 매번 로그인 다시해
                                    -> 로그인이 풀리는 현상 발생

                       .allowedOrigins("*") -> 내 친군데 아무나 다 와!! (무책임함 -> 브라우저가 차단)

                       .allowedOriginPatterns("*") -> 제가 허용한 접속해도 되는 리스트 들이에요 -> 네 이쪽 사람들만 들어오세요.
                       
                       배포시 치명적인 사유가 되므로, 반드시 개발 단계에서만 사용
                        */
                        .allowedOriginPatterns(
                                "http://localhost:*", // 윈도우 / 웹 / ios 모든 포트 허용 개발모드!!
                                "http://10.0.2.2:*" // 안드로이드 애뮬레이터 모든 포트 허용
                        )
                        .allowCredentials(true) // 이걸 쓸 때 Patterns 해주기
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");
            };
        };
    }
}
