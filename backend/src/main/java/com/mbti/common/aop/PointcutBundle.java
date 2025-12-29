package com.mbti.common.aop;

import org.aspectj.lang.annotation.Pointcut;

public class PointcutBundle {
    @Pointcut("execution(* com.mbti..*Controller*.*(..))")
    public void controllerPointCut(){}

    @Pointcut("execution(* com.mbti..*ServiceImpl*.*(..))")
    public void serviceImplPointCut(){}
}

