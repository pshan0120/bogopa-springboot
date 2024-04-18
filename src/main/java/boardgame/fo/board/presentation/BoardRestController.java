package boardgame.fo.board.presentation;

import boardgame.com.service.CustomPageResponse;
import boardgame.fo.board.dto.ReadPageRequestDto;
import boardgame.fo.board.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RestController
@RequiredArgsConstructor
public class BoardRestController {

    private final BoardService boardService;

    @GetMapping("/api/board/page")
    public CustomPageResponse<Map<String, Object>> readPage(ReadPageRequestDto dto) {
        return boardService.readPage(dto);
    }

}
