package boardgame.fo.club.dao;

import boardgame.com.dao.AbstractDao;
import boardgame.com.service.CustomPageResponse;
import boardgame.fo.club.dto.ReadPageRequestDto;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ClubDao extends AbstractDao {

    public Map<String, Object> selectClubInfo(Map<String, Object> map) {
        return selectOne("club.selectClubInfo", map);
    }

    public CustomPageResponse<Map<String, Object>> selectClubMemberPage(ReadPageRequestDto dto) {
        return selectPage("club.selectClubMemberList", "club.selectClubMemberCount", dto);
    }

    public CustomPageResponse<Map<String, Object>> selectClubGamePageById(ReadPageRequestDto dto) {
        return selectPage("club.selectClubGameList", "club.selectClubGameCount", dto);
    }

    public CustomPageResponse<Map<String, Object>> selectClubActivityPageById(ReadPageRequestDto dto) {
        return selectPage("club.selectClubActivityList", "club.selectClubActivityCount", dto);
    }

    public CustomPageResponse<Map<String, Object>> selectPlayImagePageById(ReadPageRequestDto dto) {
        return selectPage("club.selectPlayImageList", "club.selectPlayImageCount", dto);
    }



    public List<Map<String, Object>> selectClubMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectClubMmbrList", map);
    }

    public Map<String, Object> selectClubMmbrListCnt(Map<String, Object> map) {
        return selectOne("club.selectClubMmbrListCnt", map);
    }




    /* 모임 */
    public List<Map<String, Object>> selectClubList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectClubPagingList", map);
    }

    public Map<String, Object> selectClubListCnt(Map<String, Object> map) {
        return selectOne("club.selectClubListCnt", map);
    }

    public void insertClub(Map<String, Object> map) {
        insert("club.insertClub", map);
    }

    public void updateClub(Map<String, Object> map) {
        update("club.updateClub", map);
    }

    public void deleteClub(Map<String, Object> map) {
        delete("club.deleteClub", map);
    }

    public void insertClubMmbr(Map<String, Object> map) {
        insert("club.insertClubMmbr", map);
    }

    public void updateClubMmbr(Map<String, Object> map) {
        update("club.updateClubMmbr", map);
    }

    public void deleteClubMmbr(Map<String, Object> map) {
        delete("club.deleteClubMmbr", map);
    }

    public void insertClubJoin(Map<String, Object> map) {
        insert("club.insertClubJoin", map);
    }

    public void updateClubJoin(Map<String, Object> map) {
        update("club.updateClubJoin", map);
    }

    public void deleteClubJoin(Map<String, Object> map) {
        delete("club.deleteClubJoin", map);
    }


    
    // TODO: page 로 바꿀 것
    public List<Map<String, Object>> selectClubGameList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectClubGamePagingList", map);
    }

    public Map<String, Object> selectClubGameListCnt(Map<String, Object> map) {
        return selectOne("club.selectClubGameListCnt", map);
    }

    public List<Map<String, Object>> selectClubMapList(Map<String, Object> map) {
        return selectList("club.selectClubMapList", map);
    }

    public List<Map<String, Object>> selectClubBrdList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectClubBrdList", map);
    }

    public Map<String, Object> selectClubBrdListCnt(Map<String, Object> map) {
        return selectOne("club.selectClubBrdListCnt", map);
    }

    public Map<String, Object> selectClubBrd(Map<String, Object> map) {
        return selectOne("club.selectClubBrd", map);
    }

    public void insertClubBrd(Map<String, Object> map) {
        insert("club.insertClubBrd", map);
    }

    public void updateClubBrd(Map<String, Object> map) {
        update("club.updateClubBrd", map);
    }

    public void deleteClubBrd(Map<String, Object> map) {
        delete("club.deleteClubBrd", map);
    }

    public Map<String, Object> selectMyClub(Map<String, Object> map) {
        return selectOne("club.selectMyClub", map);
    }

    public List<Map<String, Object>> selectMyClubPlayRecordList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectMyClubPlayRecordList", map);
    }

    public Map<String, Object> selectMyClubPlayRecordListCnt(Map<String, Object> map) {
        return selectOne("club.selectMyClubPlayRecordListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map) {
        return selectList("club.selectMyClubJoinList", map);
    }

    public List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map) {
        return selectList("club.selectMyClubAttndNotCnfrmList", map);
    }

    public List<Map<String, Object>> selectMyClubFeePayList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectMyClubFeePayList", map);
    }

    public Map<String, Object> selectMyClubFeePayListCnt(Map<String, Object> map) {
        return selectOne("club.selectMyClubFeePayListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubFeeList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectMyClubFeeList", map);
    }

    public Map<String, Object> selectMyClubFeeListCnt(Map<String, Object> map) {
        return selectOne("club.selectMyClubFeeListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubBrdList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectMyClubBrdList", map);
    }

    public Map<String, Object> selectMyClubBrdListCnt(Map<String, Object> map) {
        return selectOne("club.selectMyClubBrdListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubPlayImgList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectMyClubPlayImgList", map);
    }

    public Map<String, Object> selectMyClubPlayImgListCnt(Map<String, Object> map) {
        return selectOne("club.selectMyClubPlayImgListCnt", map);
    }

    public List<Map<String, Object>> selectClubGameHasList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectClubGameHasList", map);
    }

    public Map<String, Object> selectClubGameHasListCnt(Map<String, Object> map) {
        return selectOne("club.selectClubGameHasListCnt", map);
    }

    public void insertClubGame(Map<String, Object> map) {
        insert("club.insertClubGame", map);
    }

    public void deleteClubGame(Map<String, Object> map) {
        delete("club.deleteClubGame", map);
    }


    public List<Map<String, Object>> selectClubAttndList(Map<String, Object> map) {
        return selectPagingListAjax("club.selectClubAttndList", map);
    }

    public Map<String, Object> selectClubAttndListCnt(Map<String, Object> map) {
        return selectOne("club.selectClubAttndListCnt", map);
    }

    public void insertClubAttndAll(Map<String, Object> map) {
        insert("club.insertClubAttndAll", map);
    }

    public void updateClubAttnd(Map<String, Object> map) {
        update("club.updateClubAttnd", map);
    }

    public void deleteClubAttnd(Map<String, Object> map) {
        delete("club.deleteClubAttnd", map);
    }

    public Map<String, Object> selectClubFee(Map<String, Object> map) {
        return selectOne("club.selectClubFee", map);
    }

    public Map<String, Object> selectClubFeePay(Map<String, Object> map) {
        return selectOne("club.selectClubFeePay", map);
    }

    public void insertClubFee(Map<String, Object> map) {
        insert("club.insertClubFee", map);
    }

    public void updateClubFee(Map<String, Object> map) {
        update("club.updateClubFee", map);
    }

    public void deleteClubFee(Map<String, Object> map) {
        delete("club.deleteClubFee", map);
    }

}
