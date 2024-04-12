package boardgame.fo.game.service;

import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.SavePlayRequestDto;

import java.util.List;
import java.util.Map;

public interface GameService {

    List<Map<String, Object>> readPlayMemberList(long playNo);

    void savePlay(SavePlayRequestDto dto);

    Map<String, Object> readLastPlayLog(long playNo);

    void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto playNo);

}
