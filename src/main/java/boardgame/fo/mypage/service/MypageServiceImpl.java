package boardgame.fo.mypage.service;

import boardgame.fo.mypage.dao.MypageDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

    private final MypageDao mypageDao;

    /* 마이페이지 */
    @Override
    public Map<String, Object> selectMyPage(Map<String, Object> map) {
        return mypageDao.selectMyPage(map);
    }

    @Override
    public Map<String, Object> selectMyPlayRcrdList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", mypageDao.selectMyPlayRcrdList(map));
        resultMap.put("cnt", mypageDao.selectMyPlayRcrdListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectMyClubMmbrList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", mypageDao.selectMyClubMmbrList(map));
        resultMap.put("cnt", mypageDao.selectMyClubMmbrListCnt(map).get("cnt"));
        return resultMap;
    }


}
