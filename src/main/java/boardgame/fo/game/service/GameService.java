package boardgame.fo.game.service;

import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.ReadPlayMemberListResponseDto;
import boardgame.fo.game.dto.SavePlayRequestDto;

import java.util.Map;

public interface GameService {

    ReadPlayMemberListResponseDto readPlayMemberList(long playNo);

    void savePlay(SavePlayRequestDto dto);

    Map<String, Object> readLastPlayLog(long playNo);

    void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto playNo);

}
