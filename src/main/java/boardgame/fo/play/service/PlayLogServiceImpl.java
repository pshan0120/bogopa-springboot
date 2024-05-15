package boardgame.fo.play.service;

import boardgame.fo.play.dao.PlayDao;
import boardgame.fo.play.dto.DeletePlayLogAllRequestDto;
import boardgame.fo.play.dto.SavePlayRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlayLogServiceImpl implements PlayLogService {

    private final PlayDao playDao;

    @Override
    public void savePlay(SavePlayRequestDto dto) {
        playDao.insertPlayLog(dto);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> readLastPlayLog(long playNo) {
        return playDao.selectLastPlayLog(playNo);
    }

    @Override
    public void deletePlayLogByPlayNo(DeletePlayLogAllRequestDto dto) {
        playDao.deletePlayLogByPlayNo(dto.getPlayId());
    }

}
