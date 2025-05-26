package com.growspace.community.security;


import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;

public class PasswordEncoderTest {

    @Test
    public void generateHash() {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

        String rawPassword = "1111";

        // 비밀번호 해시화
        String encodedPassword = passwordEncoder.encode(rawPassword);

        // 해시 출력
        System.out.println("원본: " + rawPassword);
        System.out.println("BCrypt 해시 결과: " + encodedPassword);

        // 검증
        boolean matches = passwordEncoder.matches(rawPassword, encodedPassword);

        System.out.println("일치 여부: " + matches);

        // 실제 테스트로는 assert 사용
        //assert matches : "비밀번호 일치 실패";
        assertTrue(matches, "비밀번호가 일치하지 않습니다");
    }
}
