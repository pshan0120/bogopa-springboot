package boardgame.bo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import boardgame.com.dao.AbstractDao;

@Repository("boDAO")
public class BoDao extends AbstractDao {

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectMmbrList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMmbrListCnt(Map<String, Object> map) {
        return selectOne("bo.selectMmbrListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMmbr(Map<String, Object> map) {
        return selectOne("bo.selectMmbr", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMmbrLogList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectMmbrLogList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMmbrLogListCnt(Map<String, Object> map) {
        return selectOne("bo.selectMmbrLogListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMmbrCmmrcList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectMmbrCmmrcList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMmbrCmmrcListCnt(Map<String, Object> map) {
        return selectOne("bo.selectMmbrCmmrcListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMmbrRepayList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectMmbrRepayList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectMmbrRepayListCnt(Map<String, Object> map) {
        return selectOne("bo.selectMmbrRepayListCnt", map);
    }

    public void updateMmbr(Map<String, Object> map) {
        update("bo.updateMmbr", map);
    }


    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectMarketinfoList(Map<String, Object> map) {
        return selectList("bo.selectMarketinfoList", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectCryptoCandleList(Map<String, Object> map) {
        return selectList("bo.selectCryptoCandleList", map);
    }


    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCryptoCandleInfo(Map<String, Object> map) {
        return selectOne("bo.selectCryptoCandleInfo", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectCandleDtKstList(Map<String, Object> map) {
        return selectList("bo.selectCandleDtKstList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCryptoCandleMoveLine(Map<String, Object> map) {
        return selectOne("bo.selectCryptoCandleMoveLine", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCryptoTradeHisTest(Map<String, Object> map) {
        return selectOne("bo.selectCryptoTradeHisTest", map);
    }

    public void insertCryptoTradeHisTest(Map<String, Object> map) {
        insert("bo.insertCryptoTradeHisTest", map);
    }

    public void deleteCryptoTradeHisTest(Map<String, Object> map) {
        delete("bo.deleteCryptoTradeHisTest", map);
    }


    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectCmmrcList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectCmmrcList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCmmrcListCnt(Map<String, Object> map) {
        return selectOne("bo.selectCmmrcListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCmmrc(Map<String, Object> map) {
        return selectOne("bo.selectCmmrc", map);
    }

    public void insertCmmrc(Map<String, Object> map) {
        update("bo.insertCmmrc", map);
    }

    public void updateCmmrc(Map<String, Object> map) {
        update("bo.updateCmmrc", map);
    }

    public void deleteCmmrc(Map<String, Object> map) {
        delete("bo.deleteCmmrc", map);
    }


    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectReqList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectReqList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectReqListCnt(Map<String, Object> map) {
        return selectOne("bo.selectReqListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectReq(Map<String, Object> map) {
        return selectOne("bo.selectReq", map);
    }

    public void insertReq(Map<String, Object> map) {
        update("bo.insertReq", map);
    }

    public void updateReq(Map<String, Object> map) {
        update("bo.updateReq", map);
    }

    public void deleteReq(Map<String, Object> map) {
        delete("bo.deleteReq", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectRepayList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectRepayList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectRepayListCnt(Map<String, Object> map) {
        return selectOne("bo.selectRepayListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectRepay(Map<String, Object> map) {
        return selectOne("bo.selectRepay", map);
    }

    public void insertNewRepay(Map<String, Object> map) {
        update("bo.insertNewRepay", map);
    }

    public void insertRepay(Map<String, Object> map) {
        update("bo.insertRepay", map);
    }

    public void updateRepay(Map<String, Object> map) {
        update("bo.updateRepay", map);
    }

    public void deleteRepay(Map<String, Object> map) {
        delete("bo.deleteRepay", map);
    }


    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectUserList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectUserList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectUserListCnt(Map<String, Object> map) {
        return selectOne("bo.selectUserListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectUserPswrdYn(Map<String, Object> map) {
        return selectOne("bo.selectUserPswrdYn", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectUser(Map<String, Object> map) {
        return selectOne("bo.selectUser", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectUserIdExistYn(Map<String, Object> map) {
        return selectOne("bo.selectUserIdExistYn", map);
    }

    public void insertUserLog(Map<String, Object> map) {
        insert("bo.insertUserLog", map);
    }

    public void insertUser(Map<String, Object> map) {
        update("bo.insertUser", map);
    }

    public void updateUser(Map<String, Object> map) {
        update("bo.updateUser", map);
    }

    public void deleteUser(Map<String, Object> map) {
        delete("bo.deleteUser", map);
    }


    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectCdList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectCdList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCdListCnt(Map<String, Object> map) {
        return selectOne("bo.selectCdListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectCd(Map<String, Object> map) {
        return selectOne("bo.selectCd", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectInsertCdYn(Map<String, Object> map) {
        return selectOne("bo.selectInsertCdYn", map);
    }

    public void insertCd(Map<String, Object> map) {
        insert("bo.insertCd", map);
    }

    public void updateCd(Map<String, Object> map) {
        update("bo.updateCd", map);
    }

    public void deleteCd(Map<String, Object> map) {
        delete("bo.deleteCd", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectEmailHisList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectEmailHisList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectEmailHisListCnt(Map<String, Object> map) {
        return selectOne("bo.selectEmailHisListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectEmail(Map<String, Object> map) {
        return selectOne("bo.selectEmail", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> selectEmailTmpltList(Map<String, Object> map) {
        return selectPagingListAjax("bo.selectEmailTmpltList", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectEmailTmpltListCnt(Map<String, Object> map) {
        return selectOne("bo.selectEmailTmpltListCnt", map);
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> selectEmailTmplt(Map<String, Object> map) {
        return selectOne("bo.selectEmailTmplt", map);
    }

    public void insertEmailTmplt(Map<String, Object> map) {
        insert("bo.insertEmailTmplt", map);
    }

    public void updateEmailTmplt(Map<String, Object> map) {
        update("bo.updateEmailTmplt", map);
    }

    public void deleteEmailTmplt(Map<String, Object> map) {
        delete("bo.deleteEmailTmplt", map);
    }


    @SuppressWarnings("unchecked")
    public Map<String, Object> selectGameExistYn(Map<String, Object> map) {
        return selectOne("bo.selectGameExistYn", map);
    }

    public void insertGame(Map<String, Object> map) {
        insert("bo.insertGame", map);
    }
}
