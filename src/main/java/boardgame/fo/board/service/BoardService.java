package boardgame.fo.board.service;

import java.util.List;
import java.util.Map;

public interface BoardService {

    Map<String, Object> selectBrdList(Map<String, Object> map);

    Map<String, Object> selectBrd(Map<String, Object> map);

    List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map);


}
