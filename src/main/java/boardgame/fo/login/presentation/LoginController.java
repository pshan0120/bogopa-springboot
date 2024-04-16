package boardgame.fo.login.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.session.SessionListener;
import boardgame.fo.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class LoginController {

    private final MemberService memberService;

    /* 로그인 */
    @RequestMapping(value = "/login")
    public ModelAndView openLogin(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("/fo/login");
        HttpSession session = request.getSession();
        String fromUri = (String) session.getAttribute("fromUri");
        if (StringUtils.equals("/login", fromUri)) {
            session.setAttribute("fromUri", "/");
        }

        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        mv.addObject("userIp", ip);
        return mv;
    }

    // 로그인 from URI
    @RequestMapping(value = "/login/{id}")
    public ModelAndView openLoginId(
            @PathVariable("id") String id,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("/fo/login");
        HttpSession session = request.getSession();
        String fromUri = id;
        if (StringUtils.equals("/login", fromUri)) {
            session.setAttribute("fromUri", "/");
        } else {
            session.setAttribute("fromUri", "/" + fromUri);
        }

        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        mv.addObject("userIp", ip);
        return mv;
    }

    @RequestMapping(value = "/login/{id}/{id2}")
    public ModelAndView openLoginId(
            @PathVariable("id") String id,
            @PathVariable("id2") String id2,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("/fo/login");
        HttpSession session = request.getSession();
        String fromUri = id + "/" + id2;
        if (StringUtils.equals("/login", fromUri)) {
            session.setAttribute("fromUri", "/");
        } else {
            session.setAttribute("fromUri", "/" + fromUri);
        }

        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        mv.addObject("userIp", ip);
        return mv;
    }

    @RequestMapping(value = "/login/{id}/{id2}/{id3}")
    public ModelAndView openLoginId(
            @PathVariable("id") String id,
            @PathVariable("id2") String id2,
            @PathVariable("id3") String id3,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("/fo/login");
        HttpSession session = request.getSession();
        String fromUri = id + "/" + id2 + "/" + id3;
        if (StringUtils.equals("/login", fromUri)) {
            session.setAttribute("fromUri", "/");
        } else {
            session.setAttribute("fromUri", "/" + fromUri);
        }

        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        mv.addObject("userIp", ip);
        return mv;
    }

    @RequestMapping(value = "/login/{id}/{id2}/{id3}/{id4}")
    public ModelAndView openLoginId(
            @PathVariable("id") String id,
            @PathVariable("id2") String id2,
            @PathVariable("id3") String id3,
            @PathVariable("id4") String id4,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("/fo/login");
        HttpSession session = request.getSession();
        String fromUri = id + "/" + id2 + "/" + id3 + "/" + id4;
        if (StringUtils.equals("/login", fromUri)) {
            session.setAttribute("fromUri", "/");
        } else {
            session.setAttribute("fromUri", "/" + fromUri);
        }

        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        mv.addObject("userIp", ip);
        return mv;
    }

    @RequestMapping(value = "/login/{id}/{id2}/{id3}/{id4}/{id5}")
    public ModelAndView openLoginId(
            @PathVariable("id") String id,
            @PathVariable("id2") String id2,
            @PathVariable("id3") String id3,
            @PathVariable("id4") String id4,
            @PathVariable("id5") String id5,
            HttpServletRequest request
    ) {
        ModelAndView mv = new ModelAndView("/fo/login");
        HttpSession session = request.getSession();
        String fromUri = id + "/" + id2 + "/" + id3 + "/" + id4 + "/" + id5;
        if (StringUtils.equals("/login", fromUri)) {
            session.setAttribute("fromUri", "/");
        } else {
            session.setAttribute("fromUri", "/" + fromUri);
        }

        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        mv.addObject("userIp", ip);
        return mv;
    }

    @RequestMapping(value = "/doLogin")
    public ModelAndView doLogin(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        Map<String, Object> checkMap = memberService.selectMmbrPswrdYn(commandMap.getMap());
        if (MapUtils.isEmpty(checkMap)) {
            resultMsg = "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.";
        } else {
            Integer pswrdErrCnt = (Integer) checkMap.get("pswrdErrCnt");
            String pswrdYn = (String) checkMap.get("pswrdYn");

            if (pswrdErrCnt > 4) {
                resultMsg = "비밀번호 5회 이상 입력 오류 상태입니다.";
                checkMap.put("useYn", "N");
            } else {
                if (StringUtils.equals("N", pswrdYn)) {
                    resultMsg = "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.";
                    // 비밀번호 오류 건수 증가
                    checkMap.put("mode", "pswrdErr");
                } else {
                    // 비밀번호 오류 건수 초기화
                    checkMap.put("mode", "pswrdErrReset");
                    this.setLogin(commandMap.getMap(), request);
                    result = true;
                }
            }
            memberService.updateMmbr(checkMap);
        }
        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    public void setLogin(Map<String, Object> map, HttpServletRequest request) {
        SessionListener sessionListener = new SessionListener();
        // IP 정보 입력
        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }

        // 로그인 세션정보 Listener에 전달
        HttpSession session = request.getSession();
        sessionListener.setLoginSession(session);

        Map<String, Object> mmbrMap = memberService.selectMmbr(map);
        String mmbrNo = (String) mmbrMap.get("mmbrNo");
        String nickNm = (String) mmbrMap.get("nickNm");
        String email = (String) mmbrMap.get("email");
        String mmbrTypeCd = (String) mmbrMap.get("mmbrTypeCd");
        String clubNo = (String) mmbrMap.get("clubNo");

        // 세션 사용자 정보 세팅
        session.setAttribute("mmbrNo", mmbrNo);
        session.setAttribute("nickNm", nickNm);
        session.setAttribute("email", email);
        session.setAttribute("mmbrTypeCd", mmbrTypeCd);
        session.setAttribute("clubNo", clubNo);
        session.setAttribute("mmbrIp", ip);
        session.setAttribute("loginTime", Long.valueOf((System.currentTimeMillis())));

        mmbrMap.put("mmbrIp", ip);
        // 로그인 이력 등록
        memberService.insertMmbrLog(mmbrMap);
    }

    /* 로그아웃 */
    @RequestMapping(value = "/logout")
    public ModelAndView logout(CommandMap commandMap, HttpServletRequest request) {
        // 동시접속자 접속(대기)를 위한 Listener 생성
        SessionListener sessionListener = new SessionListener();
        HttpSession session = request.getSession();
        sessionListener.setLogoutSession(session);
        String mmbrNo = (String) session.getAttribute("mmbrNo");
        boolean logout = mmbrNo == null ? false : true;
        if (logout) {
            session.invalidate();
        }
        ModelAndView mv = new ModelAndView("redirect:/");
        return mv;
    }

}
