package boardgame.fo.game.dao;

import boardgame.com.dao.AbstractDao;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GameDao extends AbstractDao {

    public List<Map<String, Object>> selectPlayMemberList(long playNo) {
        return (List<Map<String, Object>>) selectList("game.selectPlayMemberList", playNo);
    }

}
