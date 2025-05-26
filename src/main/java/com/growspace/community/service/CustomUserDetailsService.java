package com.growspace.community.service;

import com.growspace.community.mapper.MemberMapper;
import com.growspace.community.model.MemberModel;
import com.growspace.community.model.RoleModel;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String loginId) throws UsernameNotFoundException {
        MemberModel member = memberMapper.selectByLoginIdMemberWithJoins(loginId)
                .orElseThrow(() -> new UsernameNotFoundException("없는 회원입니다."));
        RoleModel role = member.getRole();
        log.info("member: {}, role: {}", member, role);

        return User.builder()
                .username(member.getLoginId())
                .password(member.getLoginPwHash())
                .authorities("ROLE_" + role.getRoleName().toUpperCase()) // ROLE_ADMIN 등
                .build();
    }
}
