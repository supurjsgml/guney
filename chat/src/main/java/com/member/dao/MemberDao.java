package com.member.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberDao {

	public List<Map<String, Object>> selectMemberInfo();
	
}
