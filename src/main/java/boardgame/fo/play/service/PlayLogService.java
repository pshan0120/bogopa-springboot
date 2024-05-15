package boardgame.fo.play.service;

import boardgame.fo.play.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.play.dto.SavePlayRequestDto;

import java.util.Map;

public interface PlayLogService {

    void savePlay(SavePlayRequestDto dto);

    Map<String, Object> readLastPlayLog(long playNo);

    void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto dto);

}
