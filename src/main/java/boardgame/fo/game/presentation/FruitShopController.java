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
public class FruitShopController {

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

}
