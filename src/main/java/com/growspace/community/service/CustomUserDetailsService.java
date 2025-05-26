package com.growspace.community.service;

import com.growspace.community.mapper.MemberMapper;
import com.growspace.community.model.MemberModel;
import com.growspace.community.model.RoleModel;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberMapper memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberModel member = memberMapper.selectByLoginIdMemberWithJoins(username)
                .orElseThrow(() -> new UsernameNotFoundException("사용자 없음"));
        RoleModel role = member.getRole();

        return User.builder()
                .username(member.getLoginId())
                .password(member.getLoginPwHash())
                .authorities("ROLE_" + role.getRoleName().toUpperCase()) // ROLE_ADMIN 등
                .build();
    }
}
