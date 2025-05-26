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
public class RoleModel {
    private Long roleId;
    private String roleName;
    private Integer authLv;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Boolean deletedFlag;
}
