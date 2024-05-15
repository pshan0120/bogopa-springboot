package boardgame.fo.play.service;

import boardgame.fo.play.dto.ReadPlayMemberListResponseDto;

import java.util.List;
import java.util.Map;

public interface PlayMemberService {

    ReadPlayMemberListResponseDto readPlayMemberList(long playNo);

    List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map);

    void insertPlayMmbr(Map<String, Object> map);

    void updatePlayMmbr(Map<String, Object> map);

}
