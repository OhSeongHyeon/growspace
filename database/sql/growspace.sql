CREATE TABLE AttachmentFile
(
  id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '첨부파일번호',
  boardThreadId BIGINT       NOT NULL COMMENT '글번호',
  fileName      VARCHAR(255) NOT NULL COMMENT '실제 파일명',
  filePath      VARCHAR(255) NOT NULL COMMENT '저장경로',
  fileUUID      VARCHAR(255) NOT NULL COMMENT 'UUID',
  fileSize      BIGINT       NOT NULL COMMENT '파일 크기 byte',
  fileType      VARCHAR(64)  NOT NULL COMMENT 'MIME Type - img, png, etc...',
  createdAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
  updatedAt     DATETIME     NULL     COMMENT '수정일',
  deletedAt     DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제된 파일)',
  PRIMARY KEY (id)
) COMMENT '첨부파일';

CREATE TABLE BoardThread
(
  id               BIGINT       NOT NULL AUTO_INCREMENT COMMENT '글번호',
  forumId          INT          NOT NULL COMMENT '포럼번호',
  memberId         BIGINT       NOT NULL COMMENT '작성자 - FK(Member.id)',
  roleId           INT          NOT NULL COMMENT '권한번호 - 해당 글을 볼 수 있는 권한',
  threadCategoryId INT          NOT NULL COMMENT '게시글 유형 번호',
  title            VARCHAR(255) NOT NULL COMMENT '글제목',
  content          TEXT         NOT NULL COMMENT '글내용',
  tag              VARCHAR(100) NULL     COMMENT '태그',
  isPublish        TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '임시저장 or 글노출 여부 - 1 노출, 0 숨기기',
  hit              BIGINT       NOT NULL DEFAULT 0 COMMENT '조회수',
  isNotice         TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '공지글 여부',
  createdAt        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
  updatedAt        DATETIME     NULL     COMMENT '수정일',
  deletedAt        DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제한 글)',
  PRIMARY KEY (id)
) COMMENT '게시글';

CREATE TABLE Forum
(
  id        INT          NOT NULL AUTO_INCREMENT COMMENT '포럼번호',
  forumName VARCHAR(255) NOT NULL COMMENT '포럼명',
  createdAt DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
  updatedAt DATETIME     NULL     COMMENT '수정일',
  deletedAt DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제된 포럼)',
  PRIMARY KEY (id)
) COMMENT '포럼 - 게시판 주제 or 커뮤니티';

CREATE TABLE ForumManager
(
  id        BIGINT      NOT NULL AUTO_INCREMENT COMMENT '포럼관리자번호',
  memberId  BIGINT      NOT NULL COMMENT '회원번호',
  forumId   INT         NOT NULL COMMENT '포럼번호',
  role      VARCHAR(20) NOT NULL COMMENT '관리자등급 - manager > leader',
  createdAt DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '임명일',
  updatedAt DATETIME    NULL     COMMENT '수정일',
  deletedAt DATETIME    NULL     COMMENT '삭제일 (NULL 이 아닌 경우 관리자 아님)',
  PRIMARY KEY (id)
) COMMENT '포럼 관리자';

CREATE TABLE Member
(
  id             BIGINT              NOT NULL AUTO_INCREMENT COMMENT '회원번호',
  roleId         INT                 NOT NULL COMMENT '권한번호',
  profileImageId BIGINT              NULL     COMMENT '프로필이미지번호',
  loginId        VARCHAR(64) UNIQUE  NOT NULL COMMENT '회원 아이디',
  loginPwHash    VARCHAR(60)         NOT NULL COMMENT '회원 비밀번호 (bcrypt 해쉬 사용)',
  userName       VARCHAR(128)        NOT NULL COMMENT '이름(실명)',
  nickName       VARCHAR(64)         NOT NULL COMMENT '닉네임 - 중복허용, 식별은 해쉬코드로 구분',
  hashCode       VARCHAR(4)          NOT NULL COMMENT '해쉬코드 - ex) 홍길동#e4a8',
  email          VARCHAR(128) UNIQUE NOT NULL COMMENT '이메일',
  growPoint      INT                 NOT NULL DEFAULT 0 COMMENT '포인트',
  createdAt      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
  updatedAt      DATETIME            NULL     COMMENT '수정일',
  deletedAt      DATETIME            NULL     COMMENT '회원탈퇴 일자 (NULL이 아닌 경우 회원탈퇴자)',
  PRIMARY KEY (id)
) COMMENT '회원';

CREATE TABLE MemberForumSubscribe
(
  memberId  BIGINT   NOT NULL COMMENT '회원번호',
  forumId   INT      NOT NULL COMMENT '포럼번호',
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '구독 일시',
  PRIMARY KEY (memberId, forumId)
) COMMENT '구독목록';

CREATE TABLE MemberHateReply
(
  memberId  BIGINT   NOT NULL COMMENT '회원번호',
  replyId   BIGINT   NOT NULL COMMENT '댓글번호',
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '싫어요 일시',
  PRIMARY KEY (memberId, replyId)
) COMMENT '댓글 싫어요';

CREATE TABLE MemberHateThread
(
  memberId      BIGINT   NOT NULL COMMENT '회원번호',
  boardThreadId BIGINT   NOT NULL COMMENT '글번호',
  createdAt     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '싫어요 일시',
  PRIMARY KEY (memberId, boardThreadId)
) COMMENT '게시글 싫어요';

CREATE TABLE MemberLikeReply
(
  memberId  BIGINT   NOT NULL COMMENT '회원번호',
  replyId   BIGINT   NOT NULL COMMENT '댓글번호',
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '좋아요 일시',
  PRIMARY KEY (memberId, replyId)
) COMMENT '댓글 좋아요';

CREATE TABLE MemberLikeThread
(
  memberId      BIGINT   NOT NULL COMMENT '회원번호',
  boardThreadId BIGINT   NOT NULL COMMENT '글번호',
  createdAt     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '좋아요 일시',
  PRIMARY KEY (memberId, boardThreadId)
) COMMENT '게시글 좋아요';

CREATE TABLE MemberThreadBookmark
(
  memberId      BIGINT   NOT NULL COMMENT '회원번호',
  boardThreadId BIGINT   NOT NULL COMMENT '글번호',
  createdAt     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '북마크 일시',
  PRIMARY KEY (memberId, boardThreadId)
) COMMENT '게시글 북마크';

CREATE TABLE ProfileImage
(
  id        BIGINT       NOT NULL AUTO_INCREMENT COMMENT '프로필이미지번호',
  fileName  VARCHAR(255) NOT NULL COMMENT '실제 파일명',
  filePath  VARCHAR(255) NOT NULL COMMENT '저장경로',
  fileUUID  VARCHAR(255) NOT NULL COMMENT 'UUID',
  fileSize  BIGINT       NOT NULL COMMENT '파일 크기 byte',
  fileType  VARCHAR(64)  NOT NULL COMMENT 'MIME Type - img, png, etc...',
  createdAt DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
  updatedAt DATETIME     NULL     COMMENT '수정일',
  deletedAt DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제된 파일)',
  PRIMARY KEY (id)
) COMMENT '프로필이미지';

CREATE TABLE Reply
(
  id            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '댓글번호',
  memberId      BIGINT       NOT NULL COMMENT '댓글 작성자',
  boardThreadId BIGINT       NOT NULL COMMENT '게시글번호',
  parentId      BIGINT       NULL     COMMENT '댓글 계층 (부모id - Reply.id)',
  comment       VARCHAR(500) NOT NULL COMMENT '댓글내용',
  createdAt     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
  updatedAt     DATETIME     NULL     COMMENT '수정일',
  deletedAt     DATETIME     NULL     COMMENT '삭제일 (NULL 이 아닌 경우 삭제한 글)',
  PRIMARY KEY (id)
) COMMENT '댓글';

CREATE TABLE Role
(
  id       INT          NOT NULL AUTO_INCREMENT COMMENT '권한번호',
  roleName VARCHAR(32)  NOT NULL COMMENT '권한 또는 역할명',
  authLv   INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '높을 수록 강한 권한',
  PRIMARY KEY (id)
) COMMENT '권한 또는 역할 - admin, teacher, mentor, student, member';

CREATE TABLE ThreadCategory
(
  id       INT         NOT NULL AUTO_INCREMENT COMMENT '게시글 유형 번호',
  forumId  INT         NOT NULL COMMENT '포럼번호',
  category VARCHAR(30) NOT NULL DEFAULT '일반' COMMENT '게시글 유형이름',
  PRIMARY KEY (id)
) COMMENT '게시글 유형 - 일반, 질문, 기술, 상담';

ALTER TABLE BoardThread
  ADD CONSTRAINT FK_Member_TO_BoardThread
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE Reply
  ADD CONSTRAINT FK_Member_TO_Reply
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE Reply
  ADD CONSTRAINT FK_BoardThread_TO_Reply
    FOREIGN KEY (boardThreadId)
    REFERENCES BoardThread (id);

ALTER TABLE ForumManager
  ADD CONSTRAINT FK_Member_TO_ForumManager
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE Member
  ADD CONSTRAINT FK_Role_TO_Member
    FOREIGN KEY (roleId)
    REFERENCES Role (id);

ALTER TABLE BoardThread
  ADD CONSTRAINT FK_Role_TO_BoardThread
    FOREIGN KEY (roleId)
    REFERENCES Role (id);

ALTER TABLE MemberLikeThread
  ADD CONSTRAINT FK_Member_TO_MemberLikeThread
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE MemberLikeThread
  ADD CONSTRAINT FK_BoardThread_TO_MemberLikeThread
    FOREIGN KEY (boardThreadId)
    REFERENCES BoardThread (id);

ALTER TABLE AttachmentFile
  ADD CONSTRAINT FK_BoardThread_TO_AttachmentFile
    FOREIGN KEY (boardThreadId)
    REFERENCES BoardThread (id);

ALTER TABLE MemberHateThread
  ADD CONSTRAINT FK_Member_TO_MemberHateThread
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE MemberHateThread
  ADD CONSTRAINT FK_BoardThread_TO_MemberHateThread
    FOREIGN KEY (boardThreadId)
    REFERENCES BoardThread (id);

ALTER TABLE BoardThread
  ADD CONSTRAINT FK_Forum_TO_BoardThread
    FOREIGN KEY (forumId)
    REFERENCES Forum (id);

ALTER TABLE ForumManager
  ADD CONSTRAINT FK_Forum_TO_ForumManager
    FOREIGN KEY (forumId)
    REFERENCES Forum (id);

ALTER TABLE MemberForumSubscribe
  ADD CONSTRAINT FK_Member_TO_MemberForumSubscribe
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE MemberForumSubscribe
  ADD CONSTRAINT FK_Forum_TO_MemberForumSubscribe
    FOREIGN KEY (forumId)
    REFERENCES Forum (id);

ALTER TABLE MemberThreadBookmark
  ADD CONSTRAINT FK_Member_TO_MemberThreadBookmark
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE MemberThreadBookmark
  ADD CONSTRAINT FK_BoardThread_TO_MemberThreadBookmark
    FOREIGN KEY (boardThreadId)
    REFERENCES BoardThread (id);

ALTER TABLE Member
  ADD CONSTRAINT FK_ProfileImage_TO_Member
    FOREIGN KEY (profileImageId)
    REFERENCES ProfileImage (id);

ALTER TABLE MemberHateReply
  ADD CONSTRAINT FK_Member_TO_MemberHateReply
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE MemberHateReply
  ADD CONSTRAINT FK_Reply_TO_MemberHateReply
    FOREIGN KEY (replyId)
    REFERENCES Reply (id);

ALTER TABLE MemberLikeReply
  ADD CONSTRAINT FK_Member_TO_MemberLikeReply
    FOREIGN KEY (memberId)
    REFERENCES Member (id);

ALTER TABLE MemberLikeReply
  ADD CONSTRAINT FK_Reply_TO_MemberLikeReply
    FOREIGN KEY (replyId)
    REFERENCES Reply (id);

ALTER TABLE ThreadCategory
  ADD CONSTRAINT FK_Forum_TO_ThreadCategory
    FOREIGN KEY (forumId)
    REFERENCES Forum (id);

ALTER TABLE BoardThread
  ADD CONSTRAINT FK_ThreadCategory_TO_BoardThread
    FOREIGN KEY (threadCategoryId)
    REFERENCES ThreadCategory (id);

ALTER TABLE Reply
  ADD CONSTRAINT FK_Reply_TO_Reply
    FOREIGN KEY (parentId)
    REFERENCES Reply (id);