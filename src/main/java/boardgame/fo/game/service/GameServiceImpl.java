package boardgame.fo.game.service;

import boardgame.fo.game.dao.GameDao;
import boardgame.fo.game.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.game.dto.ReadPlayMemberListResponseDto;
import boardgame.fo.game.dto.SavePlayRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class GameServiceImpl implements GameService {

    private final GameDao gameDao;

    @Override
    public Map<String, Object> readGamePlayById(long playNo) {
        return gameDao.selectGamePlayById(playNo);
    }

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
    public void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto dto) {
        gameDao.deletePlayLogByPlayNo(dto.getPlayNo());
    }

    public List<Map<String, Object>> readGameList(String gameName) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("gameName", gameName);
        return gameDao.selectGameList(requestMap);
    }

    public List<Map<String, Object>> readGameSettingList(String groupCode, long gameNo) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("groupCode", groupCode);
        requestMap.put("gameNo", gameNo);
        return gameDao.selectGameSettingList(requestMap);
    }
    
}
