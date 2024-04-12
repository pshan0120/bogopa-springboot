package boardgame.fo.game.dao;

import boardgame.com.dao.AbstractDao;
import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.SavePlayRequestDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GameDao extends AbstractDao {

    public List<Map<String, Object>> selectPlayMemberList(long playNo) {
        return selectList("game.selectPlayMemberList", playNo);
    }

    public void insertPlayLog(SavePlayRequestDto dto) {
        insert("game.insertPlayLog", dto);
    }

    public Map<String, Object> selectLastPlayLog(long playNo) {
        return selectOne("game.selectLastPlayLog", playNo);
    }

    public void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto playNo) {
        insert("game.deletePlayLogByPlayNo", playNo);
    }

}
