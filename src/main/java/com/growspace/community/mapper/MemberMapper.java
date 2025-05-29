package com.growspace.community.mapper;

import com.growspace.community.model.MemberModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Optional;

@Mapper
public interface MemberMapper {

    Optional<MemberModel> findByLoginId(@Param("loginId") String loginId);

    Optional<MemberModel> selectByLoginIdMemberWithJoins(@Param("loginId") String loginId);

}
