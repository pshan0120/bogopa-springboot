package boardgame.fo.login.presentation;

import boardgame.com.session.SessionListener;
import boardgame.com.util.SessionUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;

import static boardgame.com.util.SessionUtils.getUserIpFromRequest;
import static boardgame.com.util.SessionUtils.isMemberLoggedIn;

@Slf4j
@Controller
@RequiredArgsConstructor
public class LoginController {

    private static void setFromUriOnSession(String ids, HashMap<String, Object> paramMap) {
        String fromUri = ids.replaceAll("[^a-zA-Z0-9/:.-]", "");
        if (StringUtils.equals("/login", fromUri)) {
            SessionUtils.setSessionAttribute("fromUri", "/");
            return;
        }

        if (paramMap.isEmpty()) {
            SessionUtils.setSessionAttribute("fromUri", "/" + fromUri);
            return;
        }

        SessionUtils.setSessionAttribute("fromUri", "/" + fromUri + createRequestParamsString(paramMap));
    }

    private static AtomicReference<String> createRequestParamsString(HashMap<String, Object> paramMap) {
        AtomicReference<String> paramsString = new AtomicReference<>("?");
        paramMap.entrySet().stream()
                .map(param -> param.getKey() + "=" + URLEncoder.encode(String.valueOf(param.getValue())))
                .forEach(keyValue -> {
                    if (paramsString.get().equals("?")) {
                        paramsString.set(paramsString.get() + keyValue);
                        return;
                    }
                    paramsString.set(paramsString.get() + "&" + keyValue);
                });
        return paramsString;
    }

    public final Optional<ModelAndView> redirectIfLoggedIn() {
        if (isMemberLoggedIn()) {
            return Optional.of(new ModelAndView("redirect:/main"));
        }
        return Optional.empty();
    }

    // 로그인 from URI
    @GetMapping("/login")
    public ModelAndView openLoginId(
            @RequestParam HashMap<String, Object> paramMap,
            HttpServletRequest request
    ) {
        return this.redirectIfLoggedIn()
                .orElseGet(() -> {
                    ModelAndView mv = new ModelAndView("/fo/login");

                    String fromUri = String.valueOf(request.getHeader("REFERER"))
                            .replace(request.getRequestURI(), "")
                            // .replaceAll("[^a-zA-Z0-9/:.-?=&]", "")
                            .replace("/login", "/");

                    SessionUtils.setSessionAttribute("fromUri", fromUri);

                    mv.addObject("userIp", getUserIpFromRequest(request));
                    return mv;
                });
    }

    /* 로그아웃 */
    @RequestMapping(value = "/logout")
    public ModelAndView logout(HttpServletRequest request) {
        // 동시접속자 접속(대기)를 위한 Listener 생성
        SessionListener sessionListener = new SessionListener();
        HttpSession session = request.getSession();
        sessionListener.setLogoutSession(session);
        session.invalidate();

        return new ModelAndView("redirect:/");
    }

}
