package com.growspace.community.mapper;

import com.growspace.community.model.MemberModel;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Optional;

@Mapper
public interface MemberMapper {

    Optional<MemberModel> findByLoginId(String loginId);

    Optional<MemberModel> selectByLoginIdMemberWithJoins(String loginId);

}
