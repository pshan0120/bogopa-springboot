package boardgame.fo.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface FoService {
	
	/* 메인 */
	List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectBrdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectBrd(Map<String, Object> map) throws Exception;
	
	
	/* 회원 */
	Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMmbr(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMmbrPrfl(Map<String, Object> map) throws Exception;
	void insertMmbrLog(Map<String, Object> map) throws Exception;
	void insertMmbr(Map<String, Object> map) throws Exception;
	void updateMmbr(Map<String, Object> map) throws Exception;
	Map<String, Object> selectEmailExistYn(Map<String, Object> map) throws Exception;
	Map<String, Object> selectNickNmExistYn(Map<String, Object> map) throws Exception;
	
	
	/* 모임 */
	Map<String, Object> selectClubList(Map<String, Object> map) throws Exception;
	void insertClub(Map<String, Object> map) throws Exception;
	void updateClub(Map<String, Object> map) throws Exception;
	void deleteClub(Map<String, Object> map) throws Exception;
	void insertClubMmbr(Map<String, Object> map) throws Exception;
	void updateClubMmbr(Map<String, Object> map) throws Exception;
	void deleteClubMmbr(Map<String, Object> map) throws Exception;
	void insertClubJoin(Map<String, Object> map) throws Exception;
	void updateClubJoin(Map<String, Object> map) throws Exception;
	void deleteClubJoin(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectClubPrfl(Map<String, Object> map) throws Exception;
	Map<String, Object> selectClubMmbrList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectClubGameList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectClubMapList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectClubBrdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectClubBrd(Map<String, Object> map) throws Exception;
	void insertClubBrd(Map<String, Object> map) throws Exception;
	void updateClubBrd(Map<String, Object> map) throws Exception;
	void deleteClubBrd(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectMyClub(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyClubPlayRcrdList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyClubFeePayList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyClubFeeList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyClubBrdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyClubPlayImgList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectClubGameHasList(Map<String, Object> map) throws Exception;
	void insertClubGame(Map<String, Object> map) throws Exception;
	void deleteClubGame(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectClubAttndList(Map<String, Object> map) throws Exception;
	void insertClubAttndAll(Map<String, Object> map) throws Exception;
	void updateClubAttnd(Map<String, Object> map) throws Exception;
	void deleteClubAttnd(Map<String, Object> map) throws Exception;
	Map<String, Object> selectClubFee(Map<String, Object> map) throws Exception;
	Map<String, Object> selectClubFeePay(Map<String, Object> map) throws Exception;
	void insertClubFee(Map<String, Object> map) throws Exception;
	void updateClubFee(Map<String, Object> map) throws Exception;
	void deleteClubFee(Map<String, Object> map) throws Exception;
	
	
	/* 마이페이지 */
	Map<String, Object> selectMyPage(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyPlayRcrdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMyClubMmbrList(Map<String, Object> map) throws Exception;
	
	
	/* 플레이 */
	Map<String, Object> selectPlayRcrd(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selecPlayRcrdByAllList(Map<String, Object> map) throws Exception;
	Map<String, Object> selecPlayRcrdByClubList(Map<String, Object> map) throws Exception;
	Map<String, Object> selecPlayRcrdByMmbrList(Map<String, Object> map) throws Exception;
	Map<String, Object> selecPlayRcrdByGameList(Map<String, Object> map) throws Exception;
	
	List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) throws Exception;
	void insertPlay(Map<String, Object> map) throws Exception;
	void updatePlay(Map<String, Object> map) throws Exception;
	void deletePlay(Map<String, Object> map) throws Exception;
	
	void insertPlayMmbr(Map<String, Object> map) throws Exception;
	void updatePlayMmbr(Map<String, Object> map) throws Exception;
	
	/* 게임 */
	List<Map<String, Object>> selectGameNoList(Map<String, Object> map) throws Exception;
	List<Map<String, Object>> selectGameSttngList(Map<String, Object> map) throws Exception;
	
}
