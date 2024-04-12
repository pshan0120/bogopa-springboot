package boardgame.fo.game.service;

import boardgame.fo.game.dao.GameDao;
import boardgame.fo.game.dto.DeletePlayLogByPlayNoRequestDto;
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
    public List<Map<String, Object>> readPlayMemberList(long playNo)  {
        return gameDao.selectPlayMemberList(playNo);
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
    public void deletePlayLogByPlayNo(DeletePlayLogByPlayNoRequestDto dto) {
        gameDao.deletePlayLogByPlayNo(dto);
    }
}
