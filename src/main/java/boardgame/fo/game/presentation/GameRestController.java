package boardgame.fo.game.presentation;

import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/game")
@RestController
@RequiredArgsConstructor
public class GameRestController {

    private final GameService gameService;

    @GetMapping("")
    public Map<String, Object> readById(@RequestParam long gameId) {
        return gameService.readById(gameId);
    }

    @GetMapping("/list")
    public List<Map<String, Object>> readGameList(@RequestParam String gameName) {
        return gameService.readGameList(gameName);
    }

    @GetMapping("/setting/list")
    public List<Map<String, Object>> readGameSettingList(@RequestParam String groupCode, @RequestParam long gameNo) {
        return gameService.readGameSettingList(groupCode, gameNo);
    }

}
