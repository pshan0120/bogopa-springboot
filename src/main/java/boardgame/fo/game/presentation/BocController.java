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
public class BocController {

    private final ComService comService;

    private final LoginService loginService;

    @GetMapping("/game/trouble-brewing/play")
    public String openTroubleBrewingPlayList() {
        return "/game/boc/troubleBrewing/playList";
    }

    @GetMapping("/game/trouble-brewing/play/{playId}")
    public ModelAndView openTroubleBrewingPlayByPlayNo(@PathVariable("playId") long playId, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("playId", playId);

        // TODO: 나중에 호스트 적용
        /*ReadPlayMemberListResponseDto readPlayMemberList = gameService.readPlayMemberList(playId);
        readPlayMemberList.getHostPlayMember();*/

        if (isAdminMemberLoggedIn()) {
            mv.setViewName("/game/boc/troubleBrewing/hostPlay");
        } else {
            if (request.getParameterMap().containsKey("hashKey")) {
                String hashKey = String.valueOf(request.getParameter("hashKey"));
                System.out.println("hashKey : " + hashKey);

                String memberId = comService.decrypted(hashKey);
                System.out.println("memberId : " + memberId);

                loginService.setLogin(Long.parseLong(memberId), request);
            }

            mv.setViewName("/game/boc/troubleBrewing/clientPlay");
        }
        return mv;
    }

    @GetMapping("/game/trouble-brewing/play/host/{playId}")
    public ModelAndView openTroubleBrewingHostPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/hostPlay");
        mv.addObject("playId", playId);
        return mv;
    }

    @GetMapping("/game/trouble-brewing/play/client/{playId}")
    public ModelAndView openTroubleBrewingClientPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/clientPlay");
        mv.addObject("playId", playId);
        return mv;
    }

    @GetMapping("/game/trouble-brewing/town/{playId}")
    public ModelAndView openTroubleBrewingTown(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/town");
        mv.addObject("playId", playId);
        return mv;
    }



    @GetMapping("/game/boc-custom/play")
    public String openBocCustomPlayList() {
        return "/game/boc/custom/playList";
    }

    @GetMapping("/game/boc-custom/play/{playId}")
    public ModelAndView openBocCustomPlayByPlayNo(@PathVariable("playId") long playId, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("playId", playId);

        // TODO: 나중에 호스트 적용
        /*ReadPlayMemberListResponseDto readPlayMemberList = gameService.readPlayMemberList(playId);
        readPlayMemberList.getHostPlayMember();*/

        if (isAdminMemberLoggedIn()) {
            mv.setViewName("/game/boc/custom/hostPlay");
        } else {
            if (request.getParameterMap().containsKey("hashKey")) {
                String hashKey = String.valueOf(request.getParameter("hashKey"));
                System.out.println("hashKey : " + hashKey);

                String memberId = comService.decrypted(hashKey);
                System.out.println("memberId : " + memberId);

                loginService.setLogin(Long.parseLong(memberId), request);
            }

            mv.setViewName("/game/boc/custom/clientPlay");
        }
        return mv;
    }

    @GetMapping("/game/boc-custom/play/host/{playId}")
    public ModelAndView openBocCustomHostPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/boc/custom/hostPlay");
        mv.addObject("playId", playId);
        return mv;
    }

    @GetMapping("/game/boc-custom/play/client/{playId}")
    public ModelAndView openBocCustomClientPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/boc/custom/clientPlay");
        mv.addObject("playId", playId);
        return mv;
    }

    @GetMapping("/game/boc-custom/play/live/{playId}")
    public ModelAndView openBocCustomLiveByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/boc/custom/live");
        mv.addObject("playId", playId);
        return mv;
    }

}
