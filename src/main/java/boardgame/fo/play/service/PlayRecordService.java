package boardgame.fo.play.service;

import java.util.List;
import java.util.Map;

public interface PlayRecordService {

    Map<String, Object> selectPlayRecord(Map<String, Object> map);

    List<Map<String, Object>> selectPlayRecordList(Map<String, Object> map);

    Map<String, Object> selectPlayRecordByAllList(Map<String, Object> map);

    Map<String, Object> selectPlayRecordByClubList(Map<String, Object> map);

    Map<String, Object> selectPlayRecordByMmbrList(Map<String, Object> map);

    Map<String, Object> selectPlayRecordByGameList(Map<String, Object> map);

    Map<String, Object> readPlayRecordPage(Map<String, Object> map);

    Map<String, Object> selectPlayRecordListByGameId(Map<String, Object> map, long gameId);

    Map<String, Object> selectBocCustomPlayRecordList(Map<String, Object> map);

    Map<String, Object> selectBocTroubleBrewingPlayRecordList(Map<String, Object> map);

    Map<String, Object> selectFruitShopPlayRecordList(Map<String, Object> map);

    Map<String, Object> selectCatchAThiefPlayRecordList(Map<String, Object> map);

    Map<String, Object> selectBecomingADictatorPlayRecordList(Map<String, Object> map);

    List<Map<String, Object>> selectMainPlayRecordList(Map<String, Object> map);

}
