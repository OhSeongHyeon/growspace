package com.growspace.community.web;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
public class LoginController {

    @GetMapping("/login")
    public String loginForm(HttpServletRequest request, HttpSession session) {
        log.info("loginForm");
        String referrer = request.getHeader("Referer");
        if (referrer != null && !referrer.contains("/login")) {
            session.setAttribute("redirectURL", referrer);
        }
        return "sign/login";
    }



}
