package boardgame.fo.board.service;

import boardgame.com.service.CustomPageResponse;
import boardgame.fo.board.dto.ReadPageRequestDto;

import java.util.List;
import java.util.Map;

public interface BoardService {


    CustomPageResponse<Map<String, Object>> readPage(ReadPageRequestDto dto);

    Map<String, Object> selectBrdList(Map<String, Object> map);

    Map<String, Object> selectBrd(Map<String, Object> map);

    List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map);


}
