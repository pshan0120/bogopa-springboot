package boardgame.fo.game.service;

import java.util.List;
import java.util.Map;

public interface GameService {

    List<Map<String, Object>> readPlayMemberList(long playNo);

}
