package boardgame.fo.play.presentation;

import boardgame.fo.play.dto.*;
import boardgame.fo.play.service.PlayLogService;
import boardgame.fo.play.service.PlayMemberService;
import boardgame.fo.play.service.PlayService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/play")
@RestController
@RequiredArgsConstructor
public class PlayRestController {

    private final PlayService playService;

    private final PlayMemberService playMemberService;

    private final PlayLogService playLogService;


    @GetMapping("")
    public Map<String, Object> readById(@RequestParam long playId) {
        return playService.readById(playId);
    }

    @GetMapping("/member/list")
    public ReadPlayMemberListResponseDto readPlayMemberList(@RequestParam long playId) {
        return playMemberService.readPlayMemberList(playId);
    }

    @PostMapping("")
    public long createPlay(@Validated @RequestBody CreatePlayRequestDto requestDto) {
        return playService.createPlay(requestDto);
    }

    @PostMapping("/member/join")
    public void joinPlay(@Validated @RequestBody JoinPlayRequestDto requestDto) {
        playService.joinPlay(requestDto);
    }

    @PatchMapping("/begin")
    public void beginPlay(@Validated @RequestBody BeginPlayRequestDto requestDto) {
        playService.beginPlay(requestDto);
    }

    @PatchMapping("/cancel")
    public void cancelPlay(@Validated @RequestBody JoinPlayRequestDto requestDto) {
        playService.cancelPlay(requestDto);
    }

    @PostMapping("/save")
    public void savePlay(@Validated @RequestBody SavePlayRequestDto requestDto) {
        playLogService.savePlay(requestDto);
    }

    @GetMapping("/log/last")
    public Map<String, Object> readLastPlayLog(@RequestParam long playId) {
        return playLogService.readLastPlayLog(playId);
    }

    @DeleteMapping("/log/all")
    public void deletePlayLogAll(@Validated @RequestBody DeletePlayLogAllRequestDto requestDto) {
        playLogService.deletePlayLogByPlayNo(requestDto);
    }

}
