package boardgame.fo.game.service;

import java.util.List;
import java.util.Map;

public interface GameService {

    Map<String, Object> readById(long gameId);

    List<Map<String, Object>> readGameList(String map);

    List<Map<String, Object>> readGameSettingList(String groupCode, long gameNo);

}
