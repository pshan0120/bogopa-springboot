package boardgame.fo.game.presentation;

import boardgame.com.mapping.CommandMap;
import org.apache.commons.collections.MapUtils;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

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
    public ModelAndView openPlayId(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/play");
        mv.addObject("playNo", playNo);
        return mv;
    }

}
