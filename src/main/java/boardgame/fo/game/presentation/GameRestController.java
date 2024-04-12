package boardgame.fo.game.presentation;

import boardgame.fo.game.dto.DeletePlayLogByPlayNoRequestDto;
import boardgame.fo.game.dto.SavePlayRequestDto;
import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

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

    @PostMapping("/play/save")
    public void savePlay(@Validated @RequestBody SavePlayRequestDto dto) {
        gameService.savePlay(dto);
    }

    @GetMapping("/play/log/last")
    public Map<String, Object> readLastPlayLog(@RequestParam long playNo) {
        return gameService.readLastPlayLog(playNo);
    }

    @DeleteMapping("/play/log/all")
    public void deletePlayLogAll(@Validated @RequestBody DeletePlayLogByPlayNoRequestDto dto) {
        gameService.deletePlayLogByPlayNo(dto);
    }


}
