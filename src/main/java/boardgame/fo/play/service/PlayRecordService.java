package boardgame.fo.play.service;

import java.util.List;
import java.util.Map;

public interface PlayRecordService {

    Map<String, Object> selectPlayRcrd(Map<String, Object> map);

    List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByAllList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByClubList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByMmbrList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByGameList(Map<String, Object> map);

    Map<String, Object> selectBocPlayRcrdList(Map<String, Object> map);

    Object selectFruitShopPlayRcrdList(Map<String, Object> map);

    Object selectCatchAThiefPlayRcrdList(Map<String, Object> map);

    List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map);

}
