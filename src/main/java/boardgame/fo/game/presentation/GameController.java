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
public class GameController {

    private final ComService comService;

    private final LoginService loginService;

    @GetMapping("/game")
    public String openGame() {
        return "/game/game";
    }

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
    
    @GetMapping("/game/fruit-shop/play")
    public String openFruitShopPlayList() {
        return "/game/fruitShop/playList";
    }

    @GetMapping("/game/fruit-shop/play/{playId}")
    public ModelAndView openFruitShopPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("playId", playId);

        if (isAdminMemberLoggedIn()) {
            mv.setViewName("/game/fruitShop/hostPlay");
        } else {
            mv.setViewName("/game/fruitShop/clientPlay");
        }
        return mv;
    }

    @GetMapping("/game/fruit-shop/play/host/{playId}")
    public ModelAndView openFruitShopHostPlayByPlayNo(@PathVariable("playId") long playId) {
        ModelAndView mv = new ModelAndView("/game/fruitShop/hostPlay");
        mv.addObject("playId", playId);
        return mv;
    }


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


    @GetMapping("/game/food-chain-magnate/calculator")
    public String openFoodChainMagnateCalculator() {
        return "/game/footChainMagnate/calculator";
    }


}
