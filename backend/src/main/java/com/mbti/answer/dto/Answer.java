package com.mbti.answer.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class Answer {
    private Long id;
    private Long resultId;
    private Long questionId;
    private String selectedOption; // 'A' or 'B'
    private String selectedType; // E, I, S, N, T, F, J, P
    private String createdAt;
}
