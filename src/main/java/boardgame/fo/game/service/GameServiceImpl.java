package boardgame.fo.game.service;

import boardgame.fo.game.dao.GameDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class GameServiceImpl implements GameService {

    private final GameDao gameDao;

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> readById(long gameId) {
        return gameDao.selectGameById(gameId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> readGameList(String gameName) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("gameName", gameName);
        return gameDao.selectGameList(requestMap);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> readGameSettingList(String groupCode, long gameNo) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("groupCode", groupCode);
        requestMap.put("gameNo", gameNo);
        return gameDao.selectGameSettingList(requestMap);
    }

}
