package com.mbti.result.dto;

import com.mbti.answer.dto.TestAnswer;
import lombok.*;

import java.util.List;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TestRequest {
    private String userName;
    private List<TestAnswer> answers;
}

