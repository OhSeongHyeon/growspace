DROP DATABASE IF EXISTS growspace;
CREATE DATABASE growspace;
USE growspace;

-- =================================
-- growspace project: table ddl
-- growspace_schema.sql
-- 테이블 스키마
-- =================================


CREATE TABLE AttachmentFile (
    id            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '첨부파일번호',
    boardThreadId BIGINT        NOT NULL COMMENT '글번호, ON DELETE CASCADE',
    fileName      VARCHAR(255)  NOT NULL COMMENT '실제 파일명',
    filePath      VARCHAR(1024) NOT NULL COMMENT '저장경로',
    fileUUID      VARCHAR(36)   NOT NULL COMMENT 'UUID',
    fileSize      BIGINT        NOT NULL COMMENT '파일 크기 byte',
    fileType      VARCHAR(96)   NOT NULL COMMENT 'MIME Type - img, png, etc...',
    createdAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag   TINYINT(1)    NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '첨부파일';

ALTER TABLE AttachmentFile ADD CONSTRAINT UQ_fileName UNIQUE (fileName);
ALTER TABLE AttachmentFile ADD CONSTRAINT UQ_fileUUID UNIQUE (fileUUID);


CREATE TABLE BoardThread (
    id          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '글번호',
    forumId     BIGINT       NOT NULL COMMENT '포럼번호, ON DELETE CASCADE',
    memberId    BIGINT       NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    roleId      BIGINT       NOT NULL COMMENT '권한번호 (해당 글을 볼 수 있는 권한), ON DELETE RESTRICT',
    categoryId  BIGINT       NULL     COMMENT '게시글 분류 번호, NULL 일 경우 일반, ON DELETE CASCADE',
    title       VARCHAR(255) NOT NULL COMMENT '글제목',
    content     TEXT         NOT NULL COMMENT '글내용',
    isPublish   TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '임시저장 or 글노출 여부 - 1 노출, 0 숨기기',
    hit         BIGINT       NOT NULL DEFAULT 0 COMMENT '조회수',
    isNotice    TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '공지글 여부',
    createdAt   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '게시글';


CREATE TABLE Forum (
    id          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '포럼번호',
    forumName   VARCHAR(255) NOT NULL COMMENT '포럼명',
    forumCode   VARCHAR(255) NOT NULL COMMENT '포럼코드, 포럼핸들',
    createdAt   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '포럼 - 게시판 주제 or 커뮤니티';

ALTER TABLE Forum ADD CONSTRAINT UQ_forumName UNIQUE (forumName);
ALTER TABLE Forum ADD CONSTRAINT UQ_forumCode UNIQUE (forumCode);


CREATE TABLE ForumManager (
    id          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '포럼 관리자 번호',
    memberId    BIGINT      NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    forumId     BIGINT      NOT NULL COMMENT '포럼번호, ON DELETE CASCADE',
    fmRole      VARCHAR(20) NOT NULL COMMENT '관리자등급 - 권한 비교 크기 manager > leader',
    createdAt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1)  NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '포럼 관리자';


CREATE TABLE GSMember (
    id             BIGINT       NOT NULL AUTO_INCREMENT COMMENT '회원번호',
    roleId         BIGINT       NOT NULL COMMENT '권한번호, ON DELETE RESTRICT',
    profileImageId BIGINT       NULL     COMMENT '프로필이미지번호, ON DELETE SET NULL',
    loginId        VARCHAR(64)  NOT NULL COMMENT '회원 아이디',
    loginPwHash    VARCHAR(60)  NOT NULL COMMENT '회원 비밀번호 (bcrypt 해쉬 사용)',
    memberName     VARCHAR(32)  NOT NULL COMMENT '이름(실명)',
    nickName       VARCHAR(16)  NOT NULL COMMENT '닉네임 - 중복허용, 식별은 해쉬코드로 구분, 16자까지 허용',
    hashCode       VARCHAR(5)   NOT NULL COMMENT '닉네임 해쉬코드 ex) 홍길동#e8kj',
    email          VARCHAR(128) NOT NULL COMMENT '이메일',
    growPoint      INT          NOT NULL DEFAULT 0 COMMENT '포인트',
    createdAt      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일자',
    updatedAt      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag    TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '탈퇴여부',
    PRIMARY KEY (id)
) COMMENT '회원';

ALTER TABLE GSMember ADD CONSTRAINT UQ_loginId UNIQUE (loginId);
ALTER TABLE GSMember ADD CONSTRAINT UQ_email UNIQUE (email);


CREATE TABLE GSRole (
    id          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '권한번호',
    roleName    VARCHAR(16) NOT NULL COMMENT '권한 또는 역할명',
    authLv      INT         NOT NULL DEFAULT 0 COMMENT '높을 수록 강한 권한',
    createdAt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1)  NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '권한 또는 역할 - admin, teacher, mentor, student, member';

ALTER TABLE GSRole ADD CONSTRAINT UQ_roleName UNIQUE (roleName);
ALTER TABLE GSRole ADD CONSTRAINT UQ_authLv UNIQUE (authLv);


CREATE TABLE MemberForumSubscribe (
    id          BIGINT     NOT NULL AUTO_INCREMENT COMMENT '구독목록번호',
    memberId    BIGINT     NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    forumId     BIGINT     NOT NULL COMMENT '포럼번호, ON DELETE CASCADE',
    createdAt   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '구독일시',
    updatedAt   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    deletedFlag TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '커뮤니티 구독 목록';


CREATE TABLE MemberHateReply (
    id          BIGINT     NOT NULL AUTO_INCREMENT COMMENT '댓글 싫어요 번호',
    memberId    BIGINT     NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    replyId     BIGINT     NOT NULL COMMENT '댓글번호, ON DELETE CASCADE',
    createdAt   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '댓글 싫어요';


CREATE TABLE MemberHateThread (
    id            BIGINT     NOT NULL AUTO_INCREMENT COMMENT '싫어요번호',
    memberId      BIGINT     NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    boardThreadId BIGINT     NOT NULL COMMENT '글번호, ON DELETE CASCADE',
    createdAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updatedAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    deletedFlag   TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '게시글 싫어요';


CREATE TABLE MemberLikeReply (
    id          BIGINT     NOT NULL AUTO_INCREMENT COMMENT '댓글 좋아요 번호',
    memberId    BIGINT     NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    replyId     BIGINT     NOT NULL COMMENT '댓글번호, ON DELETE CASCADE',
    createdAt   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '댓글 좋아요';


CREATE TABLE MemberLikeThread (
    id            BIGINT     NOT NULL AUTO_INCREMENT COMMENT '좋아요번호',
    memberId      BIGINT     NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    boardThreadId BIGINT     NOT NULL COMMENT '글번호, ON DELETE CASCADE',
    createdAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updatedAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    deletedFlag   TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '게시글 좋아요';


CREATE TABLE MemberThreadBookmark (
    id            BIGINT     NOT NULL AUTO_INCREMENT COMMENT '북마크번호',
    memberId      BIGINT     NOT NULL COMMENT '회원번호, ON DELETE CASCADE',
    boardThreadId BIGINT     NOT NULL COMMENT '글번호, ON DELETE CASCADE',
    createdAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
    updatedAt     DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    deletedFlag   TINYINT(1) NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '게시글 북마크';


CREATE TABLE Notification (
    id            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '알림번호',
    memberId      BIGINT        NOT NULL COMMENT '회원번호 - 알림 수신자, ON DELETE CASCADE',
    senderId      BIGINT        NULL     COMMENT '발신자, ON DELETE CASCADE',
    notiType      VARCHAR(20)   NULL     COMMENT '알림유형 like, mention, board, reply, notice (CHECK 제약조건)',
    redirectUrl   VARCHAR(1024) NULL     COMMENT '바로가기',
    referenceType VARCHAR(5)    NOT NULL COMMENT '참조 구분 board, reply (CHECK 제약조건)',
    referenceId   BIGINT        NOT NULL COMMENT '참조 id - FK(BoardThread.id, Reply.id)',
    isRead        TINYINT(1)    NOT NULL DEFAULT 0 COMMENT '읽음 여부',
    createdAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag   TINYINT(1)    NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '알림 - 게시글 or 댓글 푸쉬 알림';


CREATE TABLE ProfileImage (
    id          BIGINT        NOT NULL AUTO_INCREMENT COMMENT '프로필이미지번호',
    fileName    VARCHAR(255)  NOT NULL COMMENT '원본 파일명',
    filePath    VARCHAR(1024) NOT NULL COMMENT '저장경로',
    fileUUID    VARCHAR(36)   NOT NULL COMMENT 'UUID, 디스크 저장된 파일명',
    fileSize    BIGINT        NOT NULL COMMENT '파일 크기 byte',
    fileType    VARCHAR(96)   NOT NULL COMMENT 'MIME Type - img, png, etc...',
    createdAt   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1)    NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '프로필이미지';

ALTER TABLE ProfileImage ADD CONSTRAINT UQ_fileName UNIQUE (fileName);
ALTER TABLE ProfileImage ADD CONSTRAINT UQ_fileUUID UNIQUE (fileUUID);


CREATE TABLE Reply (
    id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '댓글번호',
    memberId      BIGINT       NULL     COMMENT '댓글 작성자, ON DELETE CASCADE',
    boardThreadId BIGINT       NOT NULL COMMENT '게시글번호, ON DELETE CASCADE',
    parentId      BIGINT       NULL     COMMENT '댓글 계층 (부모id - Reply.id), ON DELETE CASCADE',
    content       VARCHAR(500) NOT NULL COMMENT '댓글내용 (500자 제한)',
    createdAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일자',
    updatedAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag   TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '댓글';


CREATE TABLE ThreadCategory (
    id          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '게시글 분류 번호',
    forumId     BIGINT      NOT NULL COMMENT '포럼번호, ON DELETE CASCADE',
    category    VARCHAR(32) NULL     DEFAULT '일반' COMMENT '게시글분류 - ex) NULL 일 경우 일반, 질문, etc...',
    createdAt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일자',
    updatedAt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일자',
    deletedFlag TINYINT(1)  NOT NULL DEFAULT 0 COMMENT '삭제여부',
    PRIMARY KEY (id)
) COMMENT '게시글 분류';


-- FK CONSTRAINT =================================================
ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_GSRole
FOREIGN KEY (roleId) REFERENCES GSRole (id) ON DELETE RESTRICT;

ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_Forum
FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE CASCADE;

ALTER TABLE BoardThread ADD CONSTRAINT FK_BoardThread_ThreadCategory
FOREIGN KEY (categoryId) REFERENCES ThreadCategory (id) ON DELETE CASCADE;

ALTER TABLE Reply ADD CONSTRAINT FK_Reply_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE Reply ADD CONSTRAINT FK_Reply_BoardThread
FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE Reply ADD CONSTRAINT FK_Reply_Reply
FOREIGN KEY (parentId) REFERENCES Reply (id) ON DELETE CASCADE;

ALTER TABLE ForumManager ADD CONSTRAINT FK_ForumManager_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE ForumManager ADD CONSTRAINT FK_ForumManager_Forum
FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE CASCADE;

ALTER TABLE GSMember ADD CONSTRAINT FK_GSMember_GSRole
FOREIGN KEY (roleId) REFERENCES GSRole (id) ON DELETE RESTRICT;

ALTER TABLE GSMember ADD CONSTRAINT FK_GSMember_ProfileImage
FOREIGN KEY (profileImageId) REFERENCES ProfileImage (id) ON DELETE SET NULL;

ALTER TABLE MemberLikeThread ADD CONSTRAINT FK_MemberLikeThread_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberLikeThread ADD CONSTRAINT FK_MemberLikeThread_BoardThread
FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE MemberHateThread ADD CONSTRAINT FK_MemberHateThread_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberHateThread ADD CONSTRAINT FK_MemberHateThread_BoardThread
FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE AttachmentFile ADD CONSTRAINT FK_AttachmentFile_BoardThread
FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE MemberForumSubscribe ADD CONSTRAINT FK_MemberForumSubscribe_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberForumSubscribe ADD CONSTRAINT FK_MemberForumSubscribe_Forum
FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE CASCADE;

ALTER TABLE MemberThreadBookmark ADD CONSTRAINT FK_MemberThreadBookmark_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberThreadBookmark ADD CONSTRAINT FK_MemberThreadBookmark_BoardThread
FOREIGN KEY (boardThreadId) REFERENCES BoardThread (id) ON DELETE CASCADE;

ALTER TABLE ThreadCategory ADD CONSTRAINT FK_ThreadCategory_Forum
FOREIGN KEY (forumId) REFERENCES Forum (id) ON DELETE CASCADE;

ALTER TABLE Notification ADD CONSTRAINT FK_Notification_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE Notification ADD CONSTRAINT FK_Notification1_GSMember
FOREIGN KEY (senderId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberLikeReply ADD CONSTRAINT FK_MemberLikeReply_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberLikeReply ADD CONSTRAINT FK_MemberLikeReply_Reply
FOREIGN KEY (replyId) REFERENCES Reply (id) ON DELETE CASCADE;

ALTER TABLE MemberHateReply ADD CONSTRAINT FK_MemberHateReply_GSMember
FOREIGN KEY (memberId) REFERENCES GSMember (id) ON DELETE CASCADE;

ALTER TABLE MemberHateReply ADD CONSTRAINT FK_MemberHateReply_Reply
FOREIGN KEY (replyId) REFERENCES Reply (id) ON DELETE CASCADE;


-- UNIQUE INDEX CONSTRAINT =================================================
CREATE UNIQUE INDEX UQ_ForumManager_memberId_forumId
ON ForumManager (memberId ASC, forumId ASC);

CREATE UNIQUE INDEX UQ_GSMember_nickName_hashCode
ON GSMember (nickName ASC, hashCode ASC);

CREATE UNIQUE INDEX UQ_MemberForumSubscribe_memberId_forumId
ON MemberForumSubscribe (memberId ASC, forumId ASC);

CREATE UNIQUE INDEX UQ_MemberThreadBookmark_memberId_boardThreadId
ON MemberThreadBookmark (memberId ASC, boardThreadId ASC);

CREATE UNIQUE INDEX UQ_ThreadCategory_forumId_category
ON ThreadCategory (forumId ASC, category ASC);

CREATE UNIQUE INDEX UQ_MemberHateThread_memberId_boardThreadId
ON MemberHateThread (memberId ASC, boardThreadId ASC);

CREATE UNIQUE INDEX UQ_MemberLikeThread_memberId_boardThreadId
ON MemberLikeThread (memberId ASC, boardThreadId ASC);

CREATE UNIQUE INDEX UQ_MemberLikeReply_memberId_replyId
ON MemberLikeReply (memberId ASC, replyId ASC);

CREATE UNIQUE INDEX UQ_MemberHateReply_memberId_replyId
ON MemberHateReply (memberId ASC, replyId ASC);


-- CHECK CONSTRAINT =================================================
ALTER TABLE Notification
ADD CONSTRAINT CHK_Notification_notiType
    CHECK (notiType IN ('like', 'mention', 'board', 'reply', 'notice')),
ADD CONSTRAINT CHK_Notification_referenceType
    CHECK (referenceType IN ('board', 'reply'));
