package boardgame.fo.game.service;

import boardgame.fo.game.dao.GameDao;
import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.ReadPlayMemberListResponseDto;
import boardgame.fo.game.dto.SavePlayRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class GameServiceImpl implements GameService {

    private final GameDao gameDao;

    @Override
    public ReadPlayMemberListResponseDto readPlayMemberList(long playNo)  {
        List<Map<String, Object>> clientPlayMemberList = gameDao.selectClientPlayMemberList(playNo);
        Map<String, Object> hostPlayMember = gameDao.selectHostPlayMember(playNo);
        return ReadPlayMemberListResponseDto.builder()
                .clientPlayMemberList(clientPlayMemberList)
                .hostPlayMember(hostPlayMember)
                .build();
    }

    @Override
    public void savePlay(SavePlayRequestDto dto) {
        gameDao.insertPlayLog(dto);
    }

    @Override
    public Map<String, Object> readLastPlayLog(long playNo) {
        return gameDao.selectLastPlayLog(playNo);
    }

    @Override
    public void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto playNo) {
        gameDao.deletePlayLogByPlayNo(playNo);
    }

    public List<Map<String, Object>> selectGameNoList(Map<String, Object> map) {
        return gameDao.selectGameNoList(map);
    }

    public List<Map<String, Object>> selectGameSttngList(Map<String, Object> map) {
        return gameDao.selectGameSttngList(map);
    }
    
}
