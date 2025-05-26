package com.growspace.community.model;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class MemberModel {
    private Long memberId;
    private Long roleId;
    private Long profileImageId;
    private String loginId;
    private String loginPwHash;
    private String memberName;
    private String nickName;
    private String email;
    private Integer growPoint;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Boolean deletedFlag;
    private RoleModel role; // gs_role 테이블과의 관계
    private ProfileImageModel profileImage; // gs_profile_image 테이블과의 관계

}
