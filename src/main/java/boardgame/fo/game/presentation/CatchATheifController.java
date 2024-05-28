package boardgame.fo.game.presentation;

import boardgame.com.service.ComService;
import boardgame.fo.login.service.LoginService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

import static boardgame.com.util.SessionUtils.isAdminMemberLoggedIn;

@ResponseStatus(HttpStatus.OK)
@Controller
@RequiredArgsConstructor
public class CatchATheifController {

    private final ComService comService;

    private final LoginService loginService;

    @GetMapping("/game/catch-a-thief/play")
    public String openCatchAThiefPlayList() {
        return "/game/catchAThief/playList";
    }

    @GetMapping("/game/catch-a-thief/play/{playId}")
    public ModelAndView openCatchAThiefPlayByPlayNo(@PathVariable("playId") long playId, HttpServletRequest request) {
        if (request.getParameterMap().containsKey("hashKey")) {
            String hashKey = String.valueOf(request.getParameter("hashKey"));
            System.out.println("hashKey : " + hashKey);

            String memberId = comService.decrypted(hashKey);
            System.out.println("memberId : " + memberId);

            loginService.setLogin(Long.parseLong(memberId), request);
        }

        ModelAndView mv = new ModelAndView();
        mv.addObject("playId", playId);

        if (isAdminMemberLoggedIn()) {
            mv.setViewName("/game/catchAThief/hostPlay");
        } else {
            mv.setViewName("/game/catchAThief/clientPlay");
        }
        return mv;
    }

    @GetMapping("/game/catch-a-thief/play/host/{playId}")
    public ModelAndView openCatchAThiefHostPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/catchAThief/hostPlay");
        mv.addObject("playId", playId);
        return mv;
    }

}
