package com.growspace.community.security.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import java.io.IOException;

@RequiredArgsConstructor
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    private final String defaultUrl;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        String redirectUrl = (String) request.getSession().getAttribute("redirectURL");

        if (redirectUrl != null) {
            request.getSession().removeAttribute("redirectURL");
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(defaultUrl);
        }
    }

}

