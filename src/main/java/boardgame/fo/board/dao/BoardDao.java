package boardgame.fo.board.dao;

import boardgame.com.dao.AbstractDao;
import boardgame.com.service.CustomPageResponse;
import boardgame.fo.board.dto.ReadPageRequestDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BoardDao extends AbstractDao {

    public CustomPageResponse<Map<String, Object>> selectBoardPage(ReadPageRequestDto dto) {
        return selectPage("board.selectBoardList", "board.selectBoardCount", dto);
    }

    public Map<String, Object> selectBoard(long boardId) {
        return selectOne("board.selectBoard", boardId);
    }

    public List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) {
        return selectList("board.selectMainClubBrdList", map);
    }

}
