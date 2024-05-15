package boardgame.fo.game.dao;

import boardgame.com.dao.AbstractDao;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GameDao extends AbstractDao {

    public Map<String, Object> selectGameById(long gameId) {
        return selectOne("game.selectGameById", gameId);
    }

    public List<Map<String, Object>> selectGameList(Map<String, Object> map) {
        return selectList("game.selectGameList", map);
    }

    public List<Map<String, Object>> selectGameSettingList(Map<String, Object> map) {
        return selectList("game.selectGameSettingList", map);
    }

}
