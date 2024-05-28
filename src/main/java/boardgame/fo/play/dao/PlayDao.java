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
    public Map<String, Object> selectPlayRecord(Map<String, Object> map) {
        return selectOne("play.selectPlayRecord", map);
    }

    public List<Map<String, Object>> selectPlayRecordList(Map<String, Object> map) {
        return selectList("play.selectPlayRecordList", map);
    }

    public List<Map<String, Object>> selectPlayRecordByAllList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRecordByAllList", map);
    }

    public Map<String, Object> selectPlayRecordByAllListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRecordByAllListCnt", map);
    }

    public List<Map<String, Object>> selectPlayRecordByClubList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRecordByClubList", map);
    }

    public Map<String, Object> selectPlayRecordByClubListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRecordByClubListCnt", map);
    }

    public List<Map<String, Object>> selectPlayRecordByMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRecordByMmbrList", map);
    }

    public Map<String, Object> selectPlayRecordByMmbrListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRecordByMmbrListCnt", map);
    }

    public List<Map<String, Object>> selectPlayRecordByGameList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectPlayRecordByGameList", map);
    }

    public Map<String, Object> selectPlayRecordByGameListCnt(Map<String, Object> map) {
        return selectOne("play.selectPlayRecordByGameListCnt", map);
    }

    public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) {
        return selectList("play.selectPlayJoinMmbrList", map);
    }






    public List<Map<String, Object>> selectGamePlayRecordList(Map<String, Object> map) {
        return selectPagingListAjax("play.selectGamePlayRecordList", map);
    }

    public Map<String, Object> selectGamePlayRecordListCnt(Map<String, Object> map) {
        return selectOne("play.selectGamePlayRecordListCnt", map);
    }

    public List<Map<String, Object>> selectMainPlayRecordList(Map<String, Object> map) {
        return selectList("play.selectMainPlayRecordList", map);
    }

}
