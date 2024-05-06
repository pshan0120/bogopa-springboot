package boardgame.com.aop;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;

@Slf4j
@Aspect
@RequiredArgsConstructor
public class LoginAspect {

    private final HttpServletRequest request;
    private final HttpServletResponse response;

    //@Before(value = "@annotation(boardgame.com.aop.LoginByHashKey)")
    @AfterReturning(value = "@annotation(boardgame.com.aop.LoginByHashKey)")
    public void loginByHashKey(JoinPoint joinPoint) {
        Arrays.stream(joinPoint.getArgs()).forEach(System.out::println);
        log.debug("\t loginByHashKey  \t:  " + "");
    }

    // @Before("execution(* boardgame..controller.*Controller.*(..))")
    /*@Before("execution(* boardgame..*.presentation.*Controller.*(..))")
    public Object loginByHashKey(ProceedingJoinPoint joinPoint) throws Throwable {
        log.debug("\t loginByHashKey  \t:  " + "");
        Arrays.stream(joinPoint.getArgs()).forEach(System.out::println);
        log.debug(joinPoint.getSignature().getName());
        return joinPoint.proceed();
    }*/

}
