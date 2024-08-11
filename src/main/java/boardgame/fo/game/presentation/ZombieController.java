package boardgame.fo.game.presentation;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import static boardgame.com.util.SessionUtils.isAdminMemberLoggedIn;

@ResponseStatus(HttpStatus.OK)
@Controller
@RequiredArgsConstructor
public class ZombieController {

    @GetMapping("/game/zombie/play")
    public String openZombiePlayList() {
        return "/game/zombie/playList";
    }

    @GetMapping("/game/zombie/play/{playId}")
    public ModelAndView openZombiePlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("playId", playId);

        if (isAdminMemberLoggedIn()) {
            mv.setViewName("/game/zombie/hostPlay");
        } else {
            mv.setViewName("/game/zombie/clientPlay");
        }
        return mv;
    }

    @GetMapping("/game/zombie/play/host/{playId}")
    public ModelAndView openZombieHostPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/zombie/hostPlay");
        mv.addObject("playId", playId);
        return mv;
    }

}
