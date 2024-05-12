package boardgame.fo.club.presentation;

import boardgame.com.util.SessionUtils;
import boardgame.fo.club.dto.ReadPageRequestDto;
import boardgame.fo.club.service.ClubService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/club")
@RestController
@RequiredArgsConstructor
public class ClubRestController {

    private final ClubService clubService;

    @GetMapping("/info")
    public Map<String, Object> readInfoById(@RequestParam long clubId) {
        return clubService.readInfoById(clubId, SessionUtils.getCurrentMemberIdOrNull());
    }

    @GetMapping("/member/page")
    public Page<Map<String, Object>> readClubMemberPageById(ReadPageRequestDto requestDto) {
        return clubService.readClubMemberPageById(requestDto);
    }

    @GetMapping("/game/page")
    public Page<Map<String, Object>> readClubGamePageById(ReadPageRequestDto requestDto) {
        return clubService.readClubGamePageById(requestDto);
    }

    @GetMapping("/activity/page")
    public Page<Map<String, Object>> readClubActivityPageById(ReadPageRequestDto requestDto) {
        return clubService.readClubActivityPageById(requestDto);
    }

    @GetMapping("/play/image/page")
    public Page<Map<String, Object>> readPlayImagePageById(ReadPageRequestDto requestDto) {
        return clubService.readPlayImagePageById(requestDto);
    }

}
