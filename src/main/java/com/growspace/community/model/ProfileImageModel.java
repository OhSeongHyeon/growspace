package com.growspace.community.model;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class ProfileImageModel {
    private Long profileImageId;
    private String fileName;
    private String filePath;
    private String fileUuid;
    private Long fileSize;
    private String fileType;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Boolean deletedFlag;
}
