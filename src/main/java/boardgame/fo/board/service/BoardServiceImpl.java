package boardgame.fo.board.service;

import boardgame.com.service.CustomPageResponse;
import boardgame.fo.board.dao.BoardDao;
import boardgame.fo.board.dto.ReadPageRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
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
    public Map<String, Object> selectBrdList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", boardDao.selectBrdList(map));
        resultMap.put("cnt", boardDao.selectBrdListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectBrd(Map<String, Object> map) {
        return boardDao.selectBrd(map);
    }

    public List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) {
        return boardDao.selectMainClubBrdList(map);
    }

}
