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
public class BecomingADictatorController {

    private final ComService comService;

    private final LoginService loginService;

    @GetMapping("/game/becoming-a-dictator/play")
    public String openBecomingADictatorPlayList() {
        return "/game/becomingADictator/playList";
    }

    @GetMapping("/game/becoming-a-dictator/play/{playId}")
    public ModelAndView openBecomingADictatorPlayByPlayNo(@PathVariable("playId") long playId, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("playId", playId);

        // TODO: 나중에 호스트 적용
        /*ReadPlayMemberListResponseDto readPlayMemberList = gameService.readPlayMemberList(playId);
        readPlayMemberList.getHostPlayMember();*/

        if (isAdminMemberLoggedIn()) {
            mv.setViewName("/game/becomingADictator/hostPlay");
        } else {
            if (request.getParameterMap().containsKey("hashKey")) {
                String hashKey = String.valueOf(request.getParameter("hashKey"));
                System.out.println("hashKey : " + hashKey);

                String memberId = comService.decrypted(hashKey);
                System.out.println("memberId : " + memberId);

                loginService.setLogin(Long.parseLong(memberId), request);
            }

            mv.setViewName("/game/becomingADictator/clientPlay");
        }
        return mv;
    }

    @GetMapping("/game/becoming-a-dictator/play/host/{playId}")
    public ModelAndView openBecomingADictatorHostPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/becomingADictator/hostPlay");
        mv.addObject("playId", playId);
        return mv;
    }

    @GetMapping("/game/becoming-a-dictator/play/client/{playId}")
    public ModelAndView openBecomingADictatorClientPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/becomingADictator/clientPlay");
        mv.addObject("playId", playId);
        return mv;
    }

}
