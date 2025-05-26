package com.growspace.community.model;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class RoleModel {
    private Long roleId;
    private String roleName;
    private Integer authLv;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Boolean deletedFlag;
}
