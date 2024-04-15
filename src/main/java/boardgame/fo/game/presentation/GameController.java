package boardgame.fo.game.presentation;

import boardgame.fo.game.dto.ReadPlayMemberListResponseDto;
import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import static boardgame.com.util.SessionUtils.isAdminMemberLogin;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/game")
@Controller
@RequiredArgsConstructor
public class GameController {

    private final GameService gameService;

    @GetMapping("/trouble-brewing/play")
    // @GetMapping({"", "/"})
    public String openPlayList() {
        return "/game/boc/troubleBrewing/playList";
    }

    @GetMapping("/trouble-brewing/play/{playNo}")
    public ModelAndView openPlayByPlayNo(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("playNo", playNo);

        // TODO: 나중에 호스트 적용
        /*ReadPlayMemberListResponseDto readPlayMemberList = gameService.readPlayMemberList(playNo);
        readPlayMemberList.getHostPlayMember();*/

        if (isAdminMemberLogin()) {
            mv.setViewName("/game/boc/troubleBrewing/hostPlay");
        } else {
            mv.setViewName("/game/boc/troubleBrewing/clientPlay");
        }
        return mv;
    }

    @GetMapping("/trouble-brewing/play/host/{playNo}")
    public ModelAndView openHostPlayByPlayNo(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/hostPlay");
        mv.addObject("playNo", playNo);
        return mv;
    }

    @GetMapping("/trouble-brewing/play/client/{playNo}")
    public ModelAndView openClientPlayByPlayNo(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/clientPlay");
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
