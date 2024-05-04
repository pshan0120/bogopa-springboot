package boardgame.fo.play.service;

import java.util.List;
import java.util.Map;

public interface PlayService {

    /* 플레이 */
    Map<String, Object> selectPlayRcrd(Map<String, Object> map);

    List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByAllList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByClubList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByMmbrList(Map<String, Object> map);

    Map<String, Object> selectPlayRcrdByGameList(Map<String, Object> map);

    List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map);

    void insertPlay(Map<String, Object> map);

    void updatePlay(Map<String, Object> map);

    void deletePlay(Map<String, Object> map);

    void insertPlayMmbr(Map<String, Object> map);

    void updatePlayMmbr(Map<String, Object> map);

    Map<String, Object> selectBocPlayRcrdList(Map<String, Object> map);

    Object selectFruitShopPlayRcrdList(Map<String, Object> map);

    Object selectCatchAThiefPlayRcrdList(Map<String, Object> map);

    List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map);

}
