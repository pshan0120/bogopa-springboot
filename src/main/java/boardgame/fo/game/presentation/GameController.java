package boardgame.fo.game.presentation;

import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import static boardgame.com.util.SessionUtils.isAdminMemberLogin;

@ResponseStatus(HttpStatus.OK)
@Controller
@RequiredArgsConstructor
public class GameController {

    private final GameService gameService;

    @GetMapping("/game")
    public String openGame() {
        return "/game/game";
    }

    @GetMapping("/game/trouble-brewing/play")
    public String openTroubleBrewingPlayList() {
        return "/game/boc/troubleBrewing/playList";
    }

    @GetMapping("/game/trouble-brewing/play/{playNo}")
    public ModelAndView openTroubleBrewingPlayByPlayNo(@PathVariable("playNo") long playNo) {
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

    @GetMapping("/game/trouble-brewing/play/host/{playNo}")
    public ModelAndView openTroubleBrewingHostPlayByPlayNo(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/hostPlay");
        mv.addObject("playNo", playNo);
        return mv;
    }

    @GetMapping("/game/trouble-brewing/play/client/{playNo}")
    public ModelAndView openTroubleBrewingClientPlayByPlayNo(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/clientPlay");
        mv.addObject("playNo", playNo);
        return mv;
    }

    @GetMapping("/game/trouble-brewing/town/{playNo}")
    public ModelAndView openTroubleBrewingTown(@PathVariable("playNo") long playNo) {
        ModelAndView mv = new ModelAndView("/game/boc/troubleBrewing/town");
        mv.addObject("playNo", playNo);
        return mv;
    }



    @GetMapping("/game/fruit-shop/play")
    public String openFruitShop() {
        return "/game/fruitShop/play";
    }

    @GetMapping("/game/food-chain-magnate/calculator")
    public String openFoodChainMagnateCalculator() {
        return "/game/footChainMagnate/calculator";
    }



}
