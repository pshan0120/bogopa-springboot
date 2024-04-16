package boardgame.fo.mypage.dao;

import boardgame.com.dao.AbstractDao;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MypageDao extends AbstractDao {

    /* 마이페이지 */
    public Map<String, Object> selectMyPage(Map<String, Object> map) {
        return selectOne("mypage.selectMyPage", map);
    }

    public List<Map<String, Object>> selectMyPlayRcrdList(Map<String, Object> map) {
        return selectPagingListAjax("mypage.selectMyPlayRcrdList", map);
    }

    public Map<String, Object> selectMyPlayRcrdListCnt(Map<String, Object> map) {
        return selectOne("mypage.selectMyPlayRcrdListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("mypage.selectMyClubMmbrList", map);
    }

    public Map<String, Object> selectMyClubMmbrListCnt(Map<String, Object> map) {
        return selectOne("mypage.selectMyClubMmbrListCnt", map);
    }

}
