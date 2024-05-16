package boardgame.fo.play.dao;

import boardgame.com.dao.AbstractDao;
import boardgame.fo.play.dto.SavePlayRequestDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PlayDao extends AbstractDao {

    public void insertPlay(Map<String, Object> map) {
        insert("play.insertPlay", map);
    }

    public void updatePlay(Map<String, Object> map) {
        update("play.updatePlay", map);
    }

    public void deletePlay(long playId) {
        delete("play.deletePlay", playId);
    }

    public Map<String, Object> selectPlayById(long playId) {
        return selectOne("play.selectPlayById", playId);
    }

    public List<Map<String, Object>> selectClientPlayMemberList(long playId) {
        return selectList("play.selectClientPlayMemberList", playId);
    }

    public Map<String, Object> selectHostPlayMember(long playId) {
        return selectOne("play.selectHostPlayMember", playId);
    }

    public void insertPlayLog(SavePlayRequestDto dto) {
        insert("play.insertPlayLog", dto);
    }

    public Map<String, Object> selectLastPlayLog(long playId) {
        return selectOne("play.selectLastPlayLog", playId);
    }

    public void deletePlayLogByPlayNo(long playId) {
        delete("play.deletePlayLogByPlayNo", playId);
    }

    public void insertPlayMember(Map<String, Object> map) {
        insert("play.insertPlayMember", map);
    }

    public void updatePlayMember(Map<String, Object> map) {
        update("play.updatePlayMember", map);
    }

    public void deletePlayMember(long playId) {
        delete("play.deletePlayMember", playId);
    }




    /* 플레이 */
    public Map<String, Object> selectPlayRcrd(Map<String, Object> map) {
        return selectOne("play.selectPlayRcrd", map);
    }

    public List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map) {
        return selectList("play.selectPlayRcrdList", map);
    }

    public List<Map<String, Object>> selectPlayRcrdByAllList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRcrdByAllList", map);
    }

    public Map<String, Object> selectPlayRcrdByAllListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRcrdByAllListCnt", map);
    }

    public List<Map<String, Object>> selecPlayRcrdByClubList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRcrdByClubList", map);
    }

    public Map<String, Object> selecPlayRcrdByClubListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRcrdByClubListCnt", map);
    }

    public List<Map<String, Object>> selecPlayRcrdByMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRcrdByMmbrList", map);
    }

    public Map<String, Object> selecPlayRcrdByMmbrListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRcrdByMmbrListCnt", map);
    }

    public List<Map<String, Object>> selecPlayRcrdByGameList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRcrdByGameList", map);
    }

    public Map<String, Object> selecPlayRcrdByGameListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRcrdByGameListCnt", map);
    }

    public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) {
        return selectList("play.selectPlayJoinMmbrList", map);
    }






    public List<Map<String, Object>> selectGamePlayRcrdList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectGamePlayRcrdList", map);
    }

    public Map<String, Object> selectGamePlayRcrdListCnt(Map<String, Object> map) {
        return selectOne("play.selectGamePlayRcrdListCnt", map);
    }

    public List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map) {
        return selectList("play.selectMainPlayRcrdList", map);
    }

}
