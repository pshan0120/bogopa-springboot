package boardgame.fo.game.presentation;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.OK)
@Controller
@RequiredArgsConstructor
public class FoodChainMagnateController {

    @GetMapping("/game/food-chain-magnate/calculator")
    public String openFoodChainMagnateCalculator() {
        return "/game/footChainMagnate/calculator";
    }

}
