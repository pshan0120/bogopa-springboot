package boardgame.fo.game.presentation;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/game")
@Controller
public class GameController {

    @GetMapping("/trouble-brewing/play")
    // @GetMapping({"", "/"})
    public String openPlayList() {
        return "/game/boc/troubleBrewing/playList";
    }

    @GetMapping("/trouble-brewing/play/{playNo}")
    public ModelAndView openPlayByPlayNo(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/play");
        mv.addObject("playNo", playNo);
        return mv;
    }

    @GetMapping("/trouble-brewing/town/{playNo}")
    public ModelAndView openTown(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/town");
        mv.addObject("playNo", playNo);
        return mv;
    }

}
