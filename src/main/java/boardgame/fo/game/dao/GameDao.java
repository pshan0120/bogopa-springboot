package boardgame.fo.game.dao;

import boardgame.com.dao.AbstractDao;
import boardgame.fo.game.dto.SavePlayRequestDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GameDao extends AbstractDao {

    public Map<String, Object> selectGamePlayById(long playNo) {
        return selectOne("game.selectGamePlayById", playNo);
    }

    public List<Map<String, Object>> selectClientPlayMemberList(long playNo) {
        return selectList("game.selectClientPlayMemberList", playNo);
    }

    public Map<String, Object> selectHostPlayMember(long playNo) {
        return selectOne("game.selectHostPlayMember", playNo);
    }

    public void insertPlayLog(SavePlayRequestDto dto) {
        insert("game.insertPlayLog", dto);
    }

    public Map<String, Object> selectLastPlayLog(long playNo) {
        return selectOne("game.selectLastPlayLog", playNo);
    }

    public void deletePlayLogByPlayNo(long playNo) {
        delete("game.deletePlayLogByPlayNo", playNo);
    }

    /* 게임 */
    public List<Map<String, Object>> selectGameList(Map<String, Object> map) {
        return selectList("game.selectGameList", map);
    }

    public List<Map<String, Object>> selectGameSettingList(Map<String, Object> map) {
        return selectList("game.selectGameSettingList", map);
    }

}
