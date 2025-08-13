package boardgame.fo.game.presentation;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.OK)
@Controller
@RequiredArgsConstructor
public class PokerController {

    @GetMapping("/game/poker/timer")
    public String openFoodChainMagnateCalculator() {
        return "/game/poker/timer";
    }

}
