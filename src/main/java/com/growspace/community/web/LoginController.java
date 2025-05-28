package com.growspace.community.web;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.io.IOException;
import java.util.Objects;

@Slf4j
@Controller
public class LoginController {

    @GetMapping("/login")
    public String showLoginForm(HttpServletRequest request, HttpSession session) {
        String referrer = request.getHeader("Referer");
        log.info("loginForm - referrer: {}", referrer);
        if (referrer != null && !referrer.contains("/login")) {
            session.setAttribute("redirectURL", referrer);
        }
        return "sign/login";
    }

    /**
     * Get Method logout 기능 작동안함 미완성
     */
    @GetMapping("/logout")
    public void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        new SecurityContextLogoutHandler().logout(request, response, authentication);
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        String referrer = request.getHeader("Referer");
        log.info("logoutForm - referrer: {}", referrer);
        response.sendRedirect(Objects.requireNonNullElse(referrer, "/"));
    }

    @GetMapping("/register")
    public String register() {
        return "sign/register";
    }

    @GetMapping("/register2")
    public String register2() {
        return "sign/register2";
    }

}
