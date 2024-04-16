package boardgame.fo.game.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

import static boardgame.com.util.SessionUtils.isAdminMemberLogin;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/game")
@Controller
@RequiredArgsConstructor
public class GameController {

    private final GameService gameService;

    /* 게임 */
    @RequestMapping(value = "/selectGameNoList")
    public ModelAndView selectGameNoList(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("list", gameService.selectGameNoList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectGameSttngList")
    public ModelAndView selectGameSttngList(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("grpCd", "1");
        mv.addObject("sttng1List", gameService.selectGameSttngList(commandMap.getMap()));
        commandMap.put("grpCd", "2");
        mv.addObject("sttng2List", gameService.selectGameSttngList(commandMap.getMap()));
        commandMap.put("grpCd", "3");
        mv.addObject("sttng3List", gameService.selectGameSttngList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

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
