package boardgame.com.aop;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class DaoAspect {

    @Before(value = "@annotation(boardgame.com.aop.PrintQueryId)")
    public void printQueryId(JoinPoint joinPoint) {
        Arrays.stream(joinPoint.getArgs()).forEach(System.out::println);
        log.debug("\t QueryId  \t:  " + "");
    }

}
