package boardgame.fo.game.service;

import boardgame.fo.dao.FoDAO;
import boardgame.fo.game.dao.GameDao;
import lombok.RequiredArgsConstructor;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
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

}
