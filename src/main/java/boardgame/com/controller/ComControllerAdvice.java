package boardgame.com.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.InitBinder;

@Slf4j
@ControllerAdvice
public class ComControllerAdvice {

    /**
     * 로그인 세션 만료시 로그인 페이지로 이동한다.
     *
     * @param e
     * @param request
     * @return
     */
    /*@ExceptionHandler(AtLoginException.class)
    public ModelAndView loginExpire(AtLoginException e, HttpServletRequest request) {
        ModelAndView result = new ModelAndView("/fo/common/login");
        result.addObject("result", false);
        result.addObject("resultMsg", e.getMessage());
        request.getSession().setAttribute("fromUri", String.valueOf(request.getRequestURL()));
        log.debug(e.getMessage() + " fromUri=" + (String) request.getSession().getAttribute("fromUri"));
        return result;
    }

    @ExceptionHandler(AtInvalidParamException.class)
    public ResponseEntity<?> invalidParam(AtInvalidParamException e) {
        e.printStackTrace();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }*/

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.initDirectFieldAccess();
    }

}
