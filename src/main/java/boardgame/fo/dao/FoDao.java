package boardgame.fo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import boardgame.com.dao.AbstractDao;

@Repository("foDAO")
public class FoDao extends AbstractDao {

    /* 메인 */

    public List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map) {
        return selectList("fo.selectMainPlayRcrdList", map);
    }

    public List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) {
        return selectList("fo.selectMainClubBrdList", map);
    }

    public List<Map<String, Object>> selectBrdList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectBrdList", map);
    }

    public Map<String, Object> selectBrdListCnt(Map<String, Object> map) {
        return selectOne("fo.selectBrdListCnt", map);
    }

    public Map<String, Object> selectBrd(Map<String, Object> map) {
        return selectOne("fo.selectBrd", map);
    }

    /* 회원 */
    public Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) {
        return selectOne("fo.selectMmbrPswrdYn", map);
    }

    public Map<String, Object> selectMmbr(Map<String, Object> map) {
        return selectOne("fo.selectMmbr", map);
    }

    public Map<String, Object> selectMmbrPrfl(Map<String, Object> map) {
        return selectOne("fo.selectMmbrPrfl", map);
    }

    public void insertMmbrLog(Map<String, Object> map) {
        insert("fo.insertMmbrLog", map);
    }

    public void insertMmbr(Map<String, Object> map) {
        insert("fo.insertMmbr", map);
    }

    public void updateMmbr(Map<String, Object> map) {
        update("fo.updateMmbr", map);
    }

    public Map<String, Object> selectEmailExistYn(Map<String, Object> map) {
        return selectOne("fo.selectEmailExistYn", map);
    }

    public Map<String, Object> selectNickNmExistYn(Map<String, Object> map) {
        return selectOne("fo.selectNickNmExistYn", map);
    }

    /* 마이페이지 */
    public Map<String, Object> selectMyPage(Map<String, Object> map) {
        return selectOne("fo.selectMyPage", map);
    }

    public List<Map<String, Object>> selectMyPlayRcrdList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyPlayRcrdList", map);
    }

    public Map<String, Object> selectMyPlayRcrdListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyPlayRcrdListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyClubMmbrList", map);
    }

    public Map<String, Object> selectMyClubMmbrListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyClubMmbrListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubBrdList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyClubBrdList", map);
    }

    public Map<String, Object> selectMyClubBrdListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyClubBrdListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubPlayImgList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyClubPlayImgList", map);
    }

    public Map<String, Object> selectMyClubPlayImgListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyClubPlayImgListCnt", map);
    }

    public List<Map<String, Object>> selectClubGameHasList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectClubGameHasList", map);
    }

    public Map<String, Object> selectClubGameHasListCnt(Map<String, Object> map) {
        return selectOne("fo.selectClubGameHasListCnt", map);
    }

    public void insertClubGame(Map<String, Object> map) {
        insert("fo.insertClubGame", map);
    }

    public void deleteClubGame(Map<String, Object> map) {
        delete("fo.deleteClubGame", map);
    }


    public List<Map<String, Object>> selectClubAttndList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectClubAttndList", map);
    }

    public Map<String, Object> selectClubAttndListCnt(Map<String, Object> map) {
        return selectOne("fo.selectClubAttndListCnt", map);
    }

    public void insertClubAttndAll(Map<String, Object> map) {
        insert("fo.insertClubAttndAll", map);
    }

    public void updateClubAttnd(Map<String, Object> map) {
        update("fo.updateClubAttnd", map);
    }

    public void deleteClubAttnd(Map<String, Object> map) {
        delete("fo.deleteClubAttnd", map);
    }

    public Map<String, Object> selectClubFee(Map<String, Object> map) {
        return selectOne("fo.selectClubFee", map);
    }

    public Map<String, Object> selectClubFeePay(Map<String, Object> map) {
        return selectOne("fo.selectClubFeePay", map);
    }

    public void insertClubFee(Map<String, Object> map) {
        insert("fo.insertClubFee", map);
    }

    public void updateClubFee(Map<String, Object> map) {
        update("fo.updateClubFee", map);
    }

    public void deleteClubFee(Map<String, Object> map) {
        delete("fo.deleteClubFee", map);
    }

    /* 플레이 */
    public Map<String, Object> selectPlayRcrd(Map<String, Object> map) {
        return selectOne("fo.selectPlayRcrd", map);
    }

    public List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map) {
        return selectList("fo.selectPlayRcrdList", map);
    }

    /* 모임 */
    public List<Map<String, Object>> selectClubList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectClubList", map);
    }

    public Map<String, Object> selectClubListCnt(Map<String, Object> map) {
        return selectOne("fo.selectClubListCnt", map);
    }

    public void insertClub(Map<String, Object> map) {
        insert("fo.insertClub", map);
    }

    public void updateClub(Map<String, Object> map) {
        update("fo.updateClub", map);
    }

    public void deleteClub(Map<String, Object> map) {
        delete("fo.deleteClub", map);
    }

    public void insertClubMmbr(Map<String, Object> map) {
        insert("fo.insertClubMmbr", map);
    }

    public void updateClubMmbr(Map<String, Object> map) {
        update("fo.updateClubMmbr", map);
    }

    public void deleteClubMmbr(Map<String, Object> map) {
        delete("fo.deleteClubMmbr", map);
    }

    public void insertClubJoin(Map<String, Object> map) {
        insert("fo.insertClubJoin", map);
    }

    public void updateClubJoin(Map<String, Object> map) {
        update("fo.updateClubJoin", map);
    }

    public void deleteClubJoin(Map<String, Object> map) {
        delete("fo.deleteClubJoin", map);
    }

    public Map<String, Object> selectClubPrfl(Map<String, Object> map) {
        return selectOne("fo.selectClubPrfl", map);
    }

    public List<Map<String, Object>> selectClubMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectClubMmbrList", map);
    }

    public Map<String, Object> selectClubMmbrListCnt(Map<String, Object> map) {
        return selectOne("fo.selectClubMmbrListCnt", map);
    }

    public List<Map<String, Object>> selectClubGameList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectClubGameList", map);
    }

    public Map<String, Object> selectClubGameListCnt(Map<String, Object> map) {
        return selectOne("fo.selectClubGameListCnt", map);
    }

    public List<Map<String, Object>> selectClubMapList(Map<String, Object> map) {
        return selectList("fo.selectClubMapList", map);
    }

    public List<Map<String, Object>> selectClubBrdList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectClubBrdList", map);
    }

    public Map<String, Object> selectClubBrdListCnt(Map<String, Object> map) {
        return selectOne("fo.selectClubBrdListCnt", map);
    }

    public Map<String, Object> selectClubBrd(Map<String, Object> map) {
        return selectOne("fo.selectClubBrd", map);
    }

    public void insertClubBrd(Map<String, Object> map) {
        insert("fo.insertClubBrd", map);
    }

    public void updateClubBrd(Map<String, Object> map) {
        update("fo.updateClubBrd", map);
    }

    public void deleteClubBrd(Map<String, Object> map) {
        delete("fo.deleteClubBrd", map);
    }

    public Map<String, Object> selectMyClub(Map<String, Object> map) {
        return selectOne("fo.selectMyClub", map);
    }

    public List<Map<String, Object>> selectMyClubPlayRcrdList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyClubPlayRcrdList", map);
    }

    public Map<String, Object> selectMyClubPlayRcrdListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyClubPlayRcrdListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map) {
        return selectList("fo.selectMyClubJoinList", map);
    }

    public List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map) {
        return selectList("fo.selectMyClubAttndNotCnfrmList", map);
    }

    public List<Map<String, Object>> selectMyClubFeePayList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyClubFeePayList", map);
    }

    public Map<String, Object> selectMyClubFeePayListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyClubFeePayListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubFeeList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectMyClubFeeList", map);
    }

    public Map<String, Object> selectMyClubFeeListCnt(Map<String, Object> map) {
        return selectOne("fo.selectMyClubFeeListCnt", map);
    }

    /* 플레이 */
    public List<Map<String, Object>> selectPlayRcrdByAllList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectPlayRcrdByAllList", map);
    }

    public Map<String, Object> selectPlayRcrdByAllListCnt(Map<String, Object> map) {
        return selectOne("fo.selectPlayRcrdByAllListCnt", map);
    }

    public List<Map<String, Object>> selecPlayRcrdByClubList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectPlayRcrdByClubList", map);
    }

    public Map<String, Object> selecPlayRcrdByClubListCnt(Map<String, Object> map) {
        return selectOne("fo.selectPlayRcrdByClubListCnt", map);
    }

    public List<Map<String, Object>> selecPlayRcrdByMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectPlayRcrdByMmbrList", map);
    }

    public Map<String, Object> selecPlayRcrdByMmbrListCnt(Map<String, Object> map) {
        return selectOne("fo.selectPlayRcrdByMmbrListCnt", map);
    }

    public List<Map<String, Object>> selecPlayRcrdByGameList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectPlayRcrdByGameList", map);
    }

    public Map<String, Object> selecPlayRcrdByGameListCnt(Map<String, Object> map) {
        return selectOne("fo.selectPlayRcrdByGameListCnt", map);
    }

    public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) {
        return selectList("fo.selectPlayJoinMmbrList", map);
    }

    public void insertPlay(Map<String, Object> map) {
        insert("fo.insertPlay", map);
    }

    public void updatePlay(Map<String, Object> map) {
        update("fo.updatePlay", map);
    }

    public void deletePlay(Map<String, Object> map) {
        delete("fo.deletePlay", map);
    }

    public void insertPlayMmbr(Map<String, Object> map) {
        insert("fo.insertPlayMmbr", map);
    }

    public void updatePlayMmbr(Map<String, Object> map) {
        update("fo.updatePlayMmbr", map);
    }

    /* 게임 */
    public List<Map<String, Object>> selectGameNoList(Map<String, Object> map) {
        return selectList("fo.selectGameNoList", map);
    }

    public List<Map<String, Object>> selectGameSttngList(Map<String, Object> map) {
        return selectList("fo.selectGameSttngList", map);
    }

    public List<Map<String, Object>> selectBocPlayRcrdList(Map<String, Object> map) {
        return selectPagingListAjax("fo.selectBocPlayRcrdList", map);
    }

    public Map<String, Object> selectBocPlayRcrdListCnt(Map<String, Object> map) {
        return selectOne("fo.selectBocPlayRcrdListCnt", map);
    }

}
