package com.mbti.answer.dto;

import lombok.*;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TestAnswer {
    private Long questionId;
    private String selectedOption; // 'A' or 'B'
}