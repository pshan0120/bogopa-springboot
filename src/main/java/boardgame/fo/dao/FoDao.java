package boardgame.fo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import boardgame.com.dao.AbstractDao;

@Repository("foDAO")
public class FoDao extends AbstractDao {
	
	/* 메인 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectMainPlayRcrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectMainClubBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBrdListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectBrdListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBrd(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectBrd", map);
	}
	
	
	/* 회원 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMmbrPswrdYn", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMmbr(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMmbr", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMmbrPrfl(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMmbrPrfl", map);
	}
	
	public void insertMmbrLog(Map<String, Object> map) throws Exception{
		insert("fo.insertMmbrLog", map);
	}
	
	public void insertMmbr(Map<String, Object> map) throws Exception{
		insert("fo.insertMmbr", map);
	}
	
	public void updateMmbr(Map<String, Object> map) throws Exception{
		update("fo.updateMmbr", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectEmailExistYn(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectEmailExistYn", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectNickNmExistYn(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectNickNmExistYn", map);
	}
	
	/* 마이페이지 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyPage(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyPage", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyPlayRcrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyPlayRcrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyPlayRcrdListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyPlayRcrdListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubMmbrList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyClubMmbrList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClubMmbrListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClubMmbrListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubBrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyClubBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClubBrdListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClubBrdListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubPlayImgList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyClubPlayImgList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClubPlayImgListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClubPlayImgListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubGameHasList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectClubGameHasList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubGameHasListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubGameHasListCnt", map);
	}
	
	
	public void insertClubGame(Map<String, Object> map) throws Exception{
		insert("fo.insertClubGame", map);
	}
	
	public void deleteClubGame(Map<String, Object> map) throws Exception{
		delete("fo.deleteClubGame", map);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubAttndList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectClubAttndList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubAttndListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubAttndListCnt", map);
	}
	
	public void insertClubAttndAll(Map<String, Object> map) throws Exception{
		insert("fo.insertClubAttndAll", map);
	}
	
	public void updateClubAttnd(Map<String, Object> map) throws Exception{
		update("fo.updateClubAttnd", map);
	}
	
	public void deleteClubAttnd(Map<String, Object> map) throws Exception{
		delete("fo.deleteClubAttnd", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubFee(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubFee", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubFeePay(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubFeePay", map);
	}
	
	public void insertClubFee(Map<String, Object> map) throws Exception{
		insert("fo.insertClubFee", map);
	}
	
	public void updateClubFee(Map<String, Object> map) throws Exception{
		update("fo.updateClubFee", map);
	}
	
	public void deleteClubFee(Map<String, Object> map) throws Exception{
		delete("fo.deleteClubFee", map);
	}
	
	
	/* 플레이 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectPlayRcrd(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectPlayRcrd", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectPlayRcrdList", map);
	}
	
	/* 모임 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectClubList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubListCnt", map);
	}
	
	public void insertClub(Map<String, Object> map) throws Exception{
		insert("fo.insertClub", map);
	}
	
	public void updateClub(Map<String, Object> map) throws Exception{
		update("fo.updateClub", map);
	}
	
	public void deleteClub(Map<String, Object> map) throws Exception{
		delete("fo.deleteClub", map);
	}
	
	public void insertClubMmbr(Map<String, Object> map) throws Exception{
		insert("fo.insertClubMmbr", map);
	}
	
	public void updateClubMmbr(Map<String, Object> map) throws Exception{
		update("fo.updateClubMmbr", map);
	}
	
	public void deleteClubMmbr(Map<String, Object> map) throws Exception{
		delete("fo.deleteClubMmbr", map);
	}
	
	public void insertClubJoin(Map<String, Object> map) throws Exception{
		insert("fo.insertClubJoin", map);
	}
	
	public void updateClubJoin(Map<String, Object> map) throws Exception{
		update("fo.updateClubJoin", map);
	}
	
	public void deleteClubJoin(Map<String, Object> map) throws Exception{
		delete("fo.deleteClubJoin", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubPrfl(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubPrfl", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubMmbrList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectClubMmbrList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubMmbrListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubMmbrListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubGameList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectClubGameList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubGameListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubGameListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubMapList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectClubMapList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectClubBrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectClubBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubBrdListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubBrdListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectClubBrd(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectClubBrd", map);
	}
	
	public void insertClubBrd(Map<String, Object> map) throws Exception{
		insert("fo.insertClubBrd", map);
	}
	
	public void updateClubBrd(Map<String, Object> map) throws Exception{
		update("fo.updateClubBrd", map);
	}
	
	public void deleteClubBrd(Map<String, Object> map) throws Exception{
		delete("fo.deleteClubBrd", map);
	}
	
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClub(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClub", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubPlayRcrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyClubPlayRcrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClubPlayRcrdListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClubPlayRcrdListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectMyClubJoinList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectMyClubAttndNotCnfrmList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubFeePayList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyClubFeePayList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClubFeePayListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClubFeePayListCnt", map);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectMyClubFeeList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectMyClubFeeList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectMyClubFeeListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectMyClubFeeListCnt", map);
	}
	
	
	/* 플레이 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPlayRcrdByAllList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectPlayRcrdByAllList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectPlayRcrdByAllListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectPlayRcrdByAllListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selecPlayRcrdByClubList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectPlayRcrdByClubList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selecPlayRcrdByClubListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectPlayRcrdByClubListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selecPlayRcrdByMmbrList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectPlayRcrdByMmbrList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selecPlayRcrdByMmbrListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectPlayRcrdByMmbrListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selecPlayRcrdByGameList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectPlayRcrdByGameList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selecPlayRcrdByGameListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectPlayRcrdByGameListCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectPlayJoinMmbrList", map);
	}
	public void insertPlay(Map<String, Object> map) throws Exception{
		insert("fo.insertPlay", map);
	}
	
	public void updatePlay(Map<String, Object> map) throws Exception{
		update("fo.updatePlay", map);
	}
	
	public void deletePlay(Map<String, Object> map) throws Exception{
		delete("fo.deletePlay", map);
	}
	
	public void insertPlayMmbr(Map<String, Object> map) throws Exception{
		insert("fo.insertPlayMmbr", map);
	}
	
	public void updatePlayMmbr(Map<String, Object> map) throws Exception{
		update("fo.updatePlayMmbr", map);
	}
	
	
	/* 게임 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectGameNoList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectGameNoList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectGameSttngList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectList("fo.selectGameSttngList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectBocPlayRcrdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>) selectPagingListAjax("fo.selectBocPlayRcrdList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> selectBocPlayRcrdListCnt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) selectOne("fo.selectBocPlayRcrdListCnt", map);
	}
	
}
