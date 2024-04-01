package boardgame.fo.game.presentation;

import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/game")
@RestController
@RequiredArgsConstructor
public class GameRestController {

    private final GameService gameService;

    @GetMapping("/play/member/list")
    public List<Map<String, Object>> readPlayMemberList(@RequestParam long playNo) {
        return gameService.readPlayMemberList(playNo);
    }

}
