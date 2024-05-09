package boardgame.fo.board.presentation;

import boardgame.fo.board.dto.ReadPageRequestDto;
import boardgame.fo.board.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/board")
@RestController
@RequiredArgsConstructor
public class BoardRestController {

    private final BoardService boardService;

    @GetMapping("/page")
    public Page<Map<String, Object>> readPage(ReadPageRequestDto dto) {
        return boardService.readPage(dto);
    }

    @GetMapping("")
    public Map<String, Object> readById(@RequestParam long id) {
        return boardService.readById(id);
    }

}
