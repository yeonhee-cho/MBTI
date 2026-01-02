package com.mbti.user.mapper;

import com.mbti.user.dto.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UserMapper {
    List<User> selectAll();
    User selectById(int id);
    User selectByUserName(String userName);
    int insert(User user);
    int updateLastLogin(int id);
    int delete(int id);
}