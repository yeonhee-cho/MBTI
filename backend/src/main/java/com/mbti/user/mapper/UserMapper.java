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

    // 회원가입용 메서드 추가
    // 힌트: insert와 유사하지만 중복 체크가 필요
    // 메서드명: insertUser
    // 반환타입: int (영향받은 행 수)
    // 매개변수: User user
    int insertUser(User user);
}