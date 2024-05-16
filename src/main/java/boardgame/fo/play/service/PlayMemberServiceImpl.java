package boardgame.fo.play.service;

import boardgame.fo.play.dao.PlayDao;
import boardgame.fo.play.dto.ReadPlayMemberListResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlayMemberServiceImpl implements PlayMemberService {

    private final PlayDao playDao;

    @Override
    @Transactional(readOnly = true)
    public ReadPlayMemberListResponseDto readPlayMemberList(long playId) {
        List<Map<String, Object>> clientPlayMemberList = playDao.selectClientPlayMemberList(playId);
        Map<String, Object> hostPlayMember = playDao.selectHostPlayMember(playId);
        return ReadPlayMemberListResponseDto.builder()
                .clientPlayMemberList(clientPlayMemberList)
                .hostPlayMember(hostPlayMember)
                .build();
    }

    public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) {
        return playDao.selectPlayJoinMmbrList(map);
    }

    @Override
    public void insertPlayMmbr(Map<String, Object> map) {
        playDao.insertPlayMember(map);
    }

    @Override
    public void updatePlayMmbr(Map<String, Object> map) {
        playDao.updatePlayMember(map);
    }

}
