package com.mbti.mbti.service;


import com.mbti.answer.dto.TestAnswer;
import com.mbti.mbtitype.dto.MbtiType;
import com.mbti.question.dto.Question;
import com.mbti.result.dto.Result;
import com.mbti.result.dto.TestRequest;

import java.util.List;
import java.util.Map;

public interface MbtiService {

    List<Question> getAllQuestions();

    Question getQuestionById(Long id);

    Result submitTest(TestRequest request);

    Map<String, Integer> calculateScores(List<TestAnswer> answers);

    String determineMbtiType(Map<String, Integer> scores);

    Result getResultById(Long id);

    List<Result> getResultsByUserName(String userName);

    List<MbtiType> getAllMbtiTypes();

    MbtiType getMbtiTypeByCode(String typeCode);

    void deleteResult(Long id);
}