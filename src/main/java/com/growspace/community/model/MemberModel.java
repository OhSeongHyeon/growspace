package com.growspace.community.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
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
    private RoleModel role = new RoleModel(); // gs_role 테이블과의 관계
    private ProfileImageModel profileImage = new ProfileImageModel(); // gs_profile_image 테이블과의 관계

}
