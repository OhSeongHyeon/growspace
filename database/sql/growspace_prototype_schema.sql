DROP DATABASE IF EXISTS `growspace`;
CREATE DATABASE `growspace`;
USE `growspace`;

-- =================================
-- growspace project: table ddl
-- growspace_prototype_schema.sql
-- 최초 테이블 스키마 - 2025-05-19 16:22:00
-- =================================


CREATE TABLE AttachmentFile (
    id            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '첨부파일번호',
    boardThreadId BIGINT        NOT NULL COMMENT '글번호',
    fileName      VARCHAR(255)  NOT NULL COMMENT '실제 파일명',
    filePath      VARCHAR(1024) NOT NULL COMMENT '저장경로',
    fileUUID      VARCHAR(36)   NOT NULL COMMENT 'UUID',
    fileSize      BIGINT        NOT NULL COMMENT '파일 크기 byte',
    fileType      VARCHAR(96)   NOT NULL COMMENT 'MIME Type - img, png, etc...',
    createdAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updatedAt     DATETIME      NULL     COMMENT '수정일',
    deletedAt     DATETIME      NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제된 파일)',
    PRIMARY KEY (id)
) COMMENT '첨부파일';

ALTER TABLE AttachmentFile ADD CONSTRAINT UQ_fileName UNIQUE (fileName);
ALTER TABLE AttachmentFile ADD CONSTRAINT UQ_fileUUID UNIQUE (fileUUID);



CREATE TABLE BoardThread (
    id         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '글번호',
    forumId    INT          NOT NULL COMMENT '포럼번호',
    memberId   BIGINT       NOT NULL COMMENT '작성자 - FK(Member.id)',
    roleId     INT          NOT NULL COMMENT '권한번호 - 해당 글을 볼 수 있는 권한',
    categoryId INT          NOT NULL COMMENT '게시글 분류 번호',
    title      VARCHAR(255) NOT NULL COMMENT '글제목',
    content    TEXT         NOT NULL COMMENT '글내용',
    isPublish  TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '임시저장 or 글노출 여부 - 1 노출, 0 숨기기',
    hit        BIGINT       NOT NULL DEFAULT 0 COMMENT '조회수',
    isNotice   TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '공지글 여부',
    createdAt  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updatedAt  DATETIME     NULL     COMMENT '수정일',
    deletedAt  DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제한 글)',
    PRIMARY KEY (id)
) COMMENT '게시글';



CREATE TABLE Forum (
    id        INT          NOT NULL AUTO_INCREMENT COMMENT '포럼번호',
    forumName VARCHAR(255) NOT NULL COMMENT '포럼명',
    createdAt DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updatedAt DATETIME     NULL     COMMENT '수정일',
    deletedAt DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제된 포럼)',
    PRIMARY KEY (id)
) COMMENT '포럼 - 게시판 주제 or 커뮤니티';

ALTER TABLE Forum ADD CONSTRAINT UQ_forumName UNIQUE (forumName);



CREATE TABLE ForumManager (
    memberId  BIGINT      NOT NULL COMMENT '회원번호',
    forumId   INT         NOT NULL COMMENT '포럼번호',
    `role`    VARCHAR(20) NOT NULL COMMENT '관리자등급 - manager > leader',
    createdAt DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '임명일',
    updatedAt DATETIME    NULL     COMMENT '수정일',
    deletedAt DATETIME    NULL     COMMENT '삭제일 (NULL 이 아닌 경우 관리자 아님)',
    PRIMARY KEY (memberId, forumId)
) COMMENT '포럼 관리자';



CREATE TABLE `Member` (
    id             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '회원번호',
    roleId         INT          NOT NULL COMMENT '권한번호',
    profileImageId BIGINT       NULL     COMMENT '프로필이미지번호',
    loginId        VARCHAR(64)  NOT NULL COMMENT '회원 아이디',
    loginPwHash    VARCHAR(60)  NOT NULL COMMENT '회원 비밀번호 (bcrypt 해쉬 사용)',
    userName       VARCHAR(128) NOT NULL COMMENT '이름(실명)',
    nickName       VARCHAR(64)  NOT NULL COMMENT '닉네임 - 중복허용, 식별은 해쉬코드로 구분',
    hashCode       VARCHAR(6)   NOT NULL COMMENT '닉네임 해쉬코드 ex) 홍길동#e8kj',
    email          VARCHAR(128) NOT NULL COMMENT '이메일',
    growPoint      INT          NOT NULL DEFAULT 0 COMMENT '포인트',
    createdAt      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    updatedAt      DATETIME     NULL     COMMENT '수정일',
    deletedAt      DATETIME     NULL     COMMENT '회원탈퇴 일자 (NULL이 아닌 경우 회원탈퇴자)',
    PRIMARY KEY (id)
) COMMENT '회원';

ALTER TABLE `Member` ADD CONSTRAINT UQ_loginId UNIQUE (loginId);
ALTER TABLE `Member` ADD CONSTRAINT UQ_email UNIQUE (email);
ALTER TABLE `Member` ADD CONSTRAINT UQ_nickName_hashCode UNIQUE (nickName, hashCode);



CREATE TABLE MemberForumSubscribe (
    memberId  BIGINT   NOT NULL COMMENT '회원번호',
    forumId   INT      NOT NULL COMMENT '포럼번호',
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '구독 일시',
    PRIMARY KEY (memberId, forumId)
) COMMENT '구독목록';



CREATE TABLE MemberHateThread (
    memberId      BIGINT   NOT NULL COMMENT '회원번호',
    boardThreadId BIGINT   NOT NULL COMMENT '글번호',
    createdAt     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '싫어요 일시',
    PRIMARY KEY (memberId, boardThreadId)
) COMMENT '게시글 싫어요';



CREATE TABLE MemberLikeThread (
    memberId      BIGINT   NOT NULL COMMENT '회원번호',
    boardThreadId BIGINT   NOT NULL COMMENT '글번호',
    createdAt     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '좋아요 일시',
    PRIMARY KEY (memberId, boardThreadId)
) COMMENT '게시글 좋아요';



CREATE TABLE MemberThreadBookmark (
    memberId      BIGINT   NOT NULL COMMENT '회원번호',
    boardThreadId BIGINT   NOT NULL COMMENT '글번호',
    createdAt     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '북마크 일시',
    PRIMARY KEY (memberId, boardThreadId)
) COMMENT '게시글 북마크';



CREATE TABLE Notification (
    id            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '알림번호',
    memberId      BIGINT        NOT NULL COMMENT '회원번호 - 알림 수신자',
    senderId      BIGINT        NULL     COMMENT '발신자',
    notiType      VARCHAR(20)   NULL     COMMENT '알림유형 like, mention, board, reply, notice',
    `url`         VARCHAR(1024) NULL     COMMENT '바로가기',
    referenceType VARCHAR(5)    NOT NULL COMMENT '참조 구분 board, reply',
    referenceId   BIGINT        NOT NULL COMMENT '참조 id - FK(BoardThread.id, Reply.id)',
    isRead        TINYINT(1)    NOT NULL DEFAULT 0 COMMENT '읽음 여부',
    createdAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    PRIMARY KEY (id)
) COMMENT '알림 - 게시글 or 댓글 푸쉬 알림';

ALTER TABLE Notification ADD CONSTRAINT CHK_Notification_referenceType
    CHECK (referenceType IN ('board', 'reply'));
ALTER TABLE Notification ADD CONSTRAINT CHK_Notification_notiType
    CHECK (notiType IN ('like', 'mention', 'board', 'reply', 'notice'));



CREATE TABLE ProfileImage (
    id        BIGINT        NOT NULL AUTO_INCREMENT COMMENT '프로필이미지번호',
    fileName  VARCHAR(255)  NOT NULL COMMENT '실제 파일명',
    filePath  VARCHAR(1024) NOT NULL COMMENT '저장경로',
    fileUUID  VARCHAR(36)   NOT NULL COMMENT 'UUID',
    fileSize  BIGINT        NOT NULL COMMENT '파일 크기 byte',
    fileType  VARCHAR(64)   NOT NULL COMMENT 'MIME Type - img, png, etc...',
    createdAt DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updatedAt DATETIME      NULL     COMMENT '수정일',
    deletedAt DATETIME      NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제된 파일)',
    PRIMARY KEY (id)
) COMMENT '프로필이미지';

ALTER TABLE ProfileImage ADD CONSTRAINT UQ_fileName UNIQUE (fileName);
ALTER TABLE ProfileImage ADD CONSTRAINT UQ_fileUUID UNIQUE (fileUUID);



CREATE TABLE Reply (
    id            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '댓글번호',
    memberId      BIGINT        NOT NULL COMMENT '댓글 작성자',
    boardThreadId BIGINT        NOT NULL COMMENT '게시글번호',
    parentId      BIGINT        NULL     COMMENT '댓글 계층 (부모id - Reply.id)',
    `comment`     TEXT          NOT NULL COMMENT '댓글내용',
    createdAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    updatedAt     DATETIME      NULL     COMMENT '수정일',
    deletedAt     DATETIME      NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제한 글)',
    PRIMARY KEY (id)
) COMMENT '댓글';



CREATE TABLE ROLE (
    id       INT          NOT NULL AUTO_INCREMENT COMMENT '권한번호',
    roleName VARCHAR(32)  NOT NULL COMMENT '권한 또는 역할명',
    authLv   INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '높을 수록 강한 권한',
    PRIMARY KEY (id)
) COMMENT '권한 또는 역할 - admin, teacher, mentor, student, member';



CREATE TABLE ThreadCategory (
    id       INT         NOT NULL AUTO_INCREMENT COMMENT '게시글 분류 번호',
    forumId  INT         NOT NULL COMMENT '포럼번호',
    category VARCHAR(30) NULL     DEFAULT '일반' COMMENT '게시글분류 - ex) NULL 일 경우 일반, 질문, etc...',
    PRIMARY KEY (id)
) COMMENT '게시글 분류';

ALTER TABLE ThreadCategory ADD CONSTRAINT UQ_forumId_category UNIQUE (forumId, category);


-- FK 설정
ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE Reply ADD CONSTRAINT FK_Reply_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE Reply ADD CONSTRAINT FK_Reply_BoardThread
    FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE ForumManager ADD CONSTRAINT FK_ForumManager_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE `Member` ADD CONSTRAINT FK_Member_Role
    FOREIGN KEY (roleId) REFERENCES ROLE (id) ON DELETE RESTRICT;

ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_Role
    FOREIGN KEY (roleId) REFERENCES ROLE (id) ON DELETE RESTRICT;

ALTER TABLE MemberLikeThread ADD CONSTRAINT FK_MemberLikeThread_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE MemberLikeThread ADD CONSTRAINT FK_MemberLikeThread_BoardThread
    FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE AttachmentFile ADD CONSTRAINT FK_AttachmentFile_BoardThread
    FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE MemberHateThread ADD CONSTRAINT FK_MemberHateThread_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE MemberHateThread ADD CONSTRAINT FK_MemberHateThread_BoardThread
    FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE RESTRICT;

ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_Forum
    FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE RESTRICT;

ALTER TABLE ForumManager ADD CONSTRAINT FK_ForumManager_Forum
    FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE RESTRICT;

ALTER TABLE MemberForumSubscribe ADD CONSTRAINT FK_MemberForumSubscribe_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE MemberForumSubscribe ADD CONSTRAINT FK_MemberForumSubscribe_Forum
    FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE RESTRICT;

ALTER TABLE MemberThreadBookmark ADD CONSTRAINT FK_MemberThreadBookmark_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE RESTRICT;

ALTER TABLE MemberThreadBookmark ADD CONSTRAINT FK_MemberThreadBookmark_BoardThread
    FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE RESTRICT;

ALTER TABLE `Member` ADD CONSTRAINT FK_Member_ProfileImage
    FOREIGN KEY (profileImageId) REFERENCES ProfileImage (id) ON DELETE SET NULL;

ALTER TABLE Reply ADD CONSTRAINT FK_Reply_Reply
    FOREIGN KEY (parentId) REFERENCES Reply (id) ON DELETE SET NULL;

ALTER TABLE ThreadCategory ADD CONSTRAINT FK_ThreadCategory_Forum
    FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE RESTRICT;

ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_ThreadCategory
    FOREIGN KEY (categoryId) REFERENCES ThreadCategory (id) ON DELETE RESTRICT;

ALTER TABLE Notification ADD CONSTRAINT FK_Notification_Member
    FOREIGN KEY (memberId) REFERENCES MEMBER (id) ON DELETE CASCADE;

ALTER TABLE Notification ADD CONSTRAINT FK_Notification_Sender
    FOREIGN KEY (senderId) REFERENCES Member (id) ON DELETE SET NULL;