package com.mbti.user.service;

import com.mbti.user.dto.User;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


public interface  UserService {

    /**
     * 로그인 (사용자 등록 또는 마지막 로그인 시간 업데이트)
     */
    public User login(String userName);
    /**
     * ID로 사용자 조회
     */

    public User getUserById(int id);

    /**
     * 사용자명으로 조회
     */
    public User getUserByUserName(String userName);

    /**
     * 모든 사용자 조회
     */
    public List<User> getAllUsers();

    /**
     * 사용자 삭제
     */
    public void deleteUser(int id);
}