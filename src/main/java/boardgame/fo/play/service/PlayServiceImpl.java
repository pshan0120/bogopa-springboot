package boardgame.fo.play.service;

import boardgame.com.constant.Game;
import boardgame.fo.play.dao.PlayDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlayServiceImpl implements PlayService {

    private final PlayDao playDao;

    /* 플레이 */
    @Override
    public Map<String, Object> selectPlayRcrd(Map<String, Object> map) {
        return playDao.selectPlayRcrd(map);
    }

    public List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map) {
        return playDao.selectPlayRcrdList(map);
    }

    @Override
    public Map<String, Object> selectPlayRcrdByAllList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectPlayRcrdByAllList(map));
        resultMap.put("cnt", playDao.selectPlayRcrdByAllListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRcrdByClubList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selecPlayRcrdByClubList(map));
        resultMap.put("cnt", playDao.selecPlayRcrdByClubListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRcrdByMmbrList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selecPlayRcrdByMmbrList(map));
        resultMap.put("cnt", playDao.selecPlayRcrdByMmbrListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRcrdByGameList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selecPlayRcrdByGameList(map));
        resultMap.put("cnt", playDao.selecPlayRcrdByGameListCnt(map).get("cnt"));
        return resultMap;
    }

    public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) {
        return playDao.selectPlayJoinMmbrList(map);
    }

    @Override
    public void insertPlay(Map<String, Object> map) {
        playDao.insertPlay(map);
    }

    @Override
    public void updatePlay(Map<String, Object> map) {
        playDao.updatePlay(map);
    }

    @Override
    public void deletePlay(Map<String, Object> map) {
        playDao.deletePlay(map);
    }

    @Override
    public void insertPlayMmbr(Map<String, Object> map) {
        playDao.insertPlayMmbr(map);
    }

    @Override
    public void updatePlayMmbr(Map<String, Object> map) {
        playDao.updatePlayMmbr(map);
    }

    @Override
    public Map<String, Object> selectBocPlayRcrdList(Map<String, Object> map) {
        map.put("gameNo", Game.BOC_TROUBLE_BREWING.getGameId());

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectGamePlayRcrdList(map));
        resultMap.put("cnt", playDao.selectGamePlayRcrdListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectFruitShopPlayRcrdList(Map<String, Object> map) {
        map.put("gameNo", Game.FRUIT_SHOP.getGameId());

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectGamePlayRcrdList(map));
        resultMap.put("cnt", playDao.selectGamePlayRcrdListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectCatchAThiefPlayRcrdList(Map<String, Object> map) {
        map.put("gameNo", Game.CATCH_A_THIEF.getGameId());

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectGamePlayRcrdList(map));
        resultMap.put("cnt", playDao.selectGamePlayRcrdListCnt(map).get("cnt"));
        return resultMap;
    }

    public List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map) {
        return playDao.selectMainPlayRcrdList(map);
    }

}
