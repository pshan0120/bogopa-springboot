package boardgame.fo.board.service;

import boardgame.com.service.CustomPageResponse;
import boardgame.fo.board.dao.BoardDao;
import boardgame.fo.board.dto.ReadPageRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final BoardDao boardDao;

    @Override
    @Transactional(readOnly = true)
    public CustomPageResponse<Map<String, Object>> readPage(ReadPageRequestDto dto) {
        return boardDao.selectBoardPage(dto);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> readById(long boardId) {
        return boardDao.selectBoard(boardId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) {
        return boardDao.selectMainClubBrdList(map);
    }

}
