package com.growspace.community.security.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import java.io.IOException;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

    private final String defaultUrl;

    public CustomLogoutSuccessHandler(String defaultUrl) {
        this.defaultUrl = defaultUrl;
    }

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.contains("/login")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(defaultUrl);
        }
    }

}

