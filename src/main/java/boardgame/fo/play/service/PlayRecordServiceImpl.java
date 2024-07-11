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
public class PlayRecordServiceImpl implements PlayRecordService {

    private final PlayDao playDao;

    /* 플레이 */
    @Override
    public Map<String, Object> selectPlayRecord(Map<String, Object> map) {
        return playDao.selectPlayRecord(map);
    }

    public List<Map<String, Object>> selectPlayRecordList(Map<String, Object> map) {
        return playDao.selectPlayRecordList(map);
    }

    @Override
    public Map<String, Object> selectPlayRecordByAllList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectPlayRecordByAllList(map));
        resultMap.put("cnt", playDao.selectPlayRecordByAllListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRecordByClubList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectPlayRecordByClubList(map));
        resultMap.put("cnt", playDao.selectPlayRecordByClubListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRecordByMmbrList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectPlayRecordByMmbrList(map));
        resultMap.put("cnt", playDao.selectPlayRecordByMmbrListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRecordByGameList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectPlayRecordByGameList(map));
        resultMap.put("cnt", playDao.selectPlayRecordByGameListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> readPlayRecordPage(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectGamePlayRecordList(map));
        resultMap.put("cnt", playDao.selectGamePlayRecordListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectPlayRecordListByGameId(Map<String, Object> map, long gameId) {
        map.put("gameNo", gameId);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", playDao.selectGamePlayRecordList(map));
        resultMap.put("cnt", playDao.selectGamePlayRecordListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectBocCustomPlayRecordList(Map<String, Object> map) {
        return this.selectPlayRecordListByGameId(map, Game.BOC_CUSTOM.getGameId());
    }

    @Override
    public Map<String, Object> selectBocTroubleBrewingPlayRecordList(Map<String, Object> map) {
        return this.selectPlayRecordListByGameId(map, Game.BOC_TROUBLE_BREWING.getGameId());
    }

    @Override
    public Map<String, Object> selectFruitShopPlayRecordList(Map<String, Object> map) {
        return this.selectPlayRecordListByGameId(map, Game.FRUIT_SHOP.getGameId());
    }

    @Override
    public Map<String, Object> selectCatchAThiefPlayRecordList(Map<String, Object> map) {
        return this.selectPlayRecordListByGameId(map, Game.CATCH_A_THIEF.getGameId());
    }

    @Override
    public Map<String, Object> selectBecomingADictatorPlayRecordList(Map<String, Object> map) {
        return this.selectPlayRecordListByGameId(map, Game.BECOMING_A_DICTATOR.getGameId());
    }

    public List<Map<String, Object>> selectMainPlayRecordList(Map<String, Object> map) {
        return playDao.selectMainPlayRecordList(map);
    }

}
