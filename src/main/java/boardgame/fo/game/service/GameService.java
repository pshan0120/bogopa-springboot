package boardgame.fo.game.service;

import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.ReadPlayMemberListResponseDto;
import boardgame.fo.game.dto.SavePlayRequestDto;

import java.util.List;
import java.util.Map;

public interface GameService {

    Map<String, Object> readGamePlayById(long playNo);

    ReadPlayMemberListResponseDto readPlayMemberList(long playNo);

    void savePlay(SavePlayRequestDto dto);

    Map<String, Object> readLastPlayLog(long playNo);

    void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto dto);

    List<Map<String, Object>> readGameList(String map);

    List<Map<String, Object>> readGameSettingList(String groupCode, long gameNo);

}
