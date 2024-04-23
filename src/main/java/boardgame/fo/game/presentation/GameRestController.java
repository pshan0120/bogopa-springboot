package boardgame.fo.game.presentation;

import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.ReadPlayMemberListResponseDto;
import boardgame.fo.game.dto.SavePlayRequestDto;
import boardgame.fo.game.service.GameService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/game")
@RestController
@RequiredArgsConstructor
public class GameRestController {

    private final GameService gameService;

    @GetMapping("/play")
    public Map<String, Object> readGamePlayById(@RequestParam long playNo) {
        return gameService.readGamePlayById(playNo);
    }

    @GetMapping("/play/member/list")
    public ReadPlayMemberListResponseDto readPlayMemberList(@RequestParam long playNo) {
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
    public void deletePlayLogAll(@Validated @RequestBody DeletePlayLogAllRequestDto dto) {
        gameService.deletePlayLogByPlayNo(dto);
    }



}
