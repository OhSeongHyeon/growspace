-- =================================
-- growspace project
-- growspace_dml_insert.sql
-- dml 쿼리는 이쪽에서 작성한다.
-- =================================

-- DROP DATABASE IF EXISTS growspace;
-- CREATE DATABASE growspace;
-- USE growspace;

-- admin 64, teacher 32, mentor 16, student 8, member 4
-- select * from gs_role;

INSERT INTO gs_role
    (role_name, auth_lv)
VALUES
    ('admin', 64),
    ('teacher', 32),
    ('mentor', 16),
    ('student', 8),
    ('member', 4)
;

-- select * from gs_member;
INSERT INTO gs_member
SET
    role_id = 1,
    profile_image_id = NULL,
    login_id = 'admin',
    login_pw_hash = '$2a$10$4oIZJpmCXgLw/eGB6ELtNO614Wp6N0c/5ehh511IDgQNE5ULrA/Y6', -- '1111'
    member_name = '어드민',
    nick_name = '주인장',
    email = 'admin@tmp.com',
    grow_point = 0
;


