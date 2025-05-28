package com.growspace.community.web;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/test")
public class TestController {

    @GetMapping("/test")
    public String test() {
        return "test/test";
    }

    @GetMapping("/role")
    public String showRoles(HttpSession session, Model model, Authentication authentication) {
        // 세션 전체 Attribute 맵
        Map<String, Object> sessionMap = new HashMap<>();
        Enumeration<String> names = session.getAttributeNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            Object value = session.getAttribute(name);
            sessionMap.put(name, value);
        }
        model.addAttribute("sessionAttributes", sessionMap);

        // principal이 있다면, UserDetails 타입으로 전달
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails user) {
            model.addAttribute("principalDetails", user);
        }
        return "test/role-check";
    }

}
