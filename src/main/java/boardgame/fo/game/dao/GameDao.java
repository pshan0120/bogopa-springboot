package boardgame.fo.game.dao;

import boardgame.com.dao.AbstractDAO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GameDao extends AbstractDAO {

    public List<Map<String, Object>> selectPlayMemberList(long playNo) {
        return (List<Map<String, Object>>) selectList("game.selectPlayMemberList", playNo);
    }

}
