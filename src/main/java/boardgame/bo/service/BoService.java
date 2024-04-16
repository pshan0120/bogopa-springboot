package boardgame.bo.service;

import java.util.List;
import java.util.Map;

public interface BoService {
	/* 회원관리 */
	Map<String, Object> selectMmbrList(Map<String, Object> map);
	Map<String, Object> selectMmbr(Map<String, Object> map);
	Map<String, Object> selectMmbrLogList(Map<String, Object> map);
	Map<String, Object> selectMmbrCmmrcList(Map<String, Object> map);
	Map<String, Object> selectMmbrRepayList(Map<String, Object> map);
	void updateMmbr(Map<String, Object> map);
	
	/* CRYPTO */
	List<Map<String,Object>> selectMarketinfoList(Map<String, Object> map);
	List<Map<String,Object>> selectCryptoCandleList(Map<String, Object> map);
	
	Map<String, Object> selectCryptoCandleInfo(Map<String, Object> map);
	List<Map<String,Object>> selectCandleDtKstList(Map<String, Object> map);
	Map<String, Object> selectCryptoCandleMoveLine(Map<String, Object> map);
	Map<String, Object> selectCryptoTradeHisTest(Map<String, Object> map);
	void insertCryptoTradeHisTest(Map<String, Object> map);
	void deleteCryptoTradeHisTest(Map<String, Object> map);
	
	
	
	
	
	
	/* 커머스관리 */
	Map<String, Object> selectCmmrcList(Map<String, Object> map);
	Map<String, Object> selectCmmrc(Map<String, Object> map);
	void insertCmmrc(Map<String, Object> map);
	void updateCmmrc(Map<String, Object> map);
	void deleteCmmrc(Map<String, Object> map);
	
	/* 정산관리 */
	Map<String, Object> selectReqList(Map<String, Object> map);
	Map<String, Object> selectReq(Map<String, Object> map);
	void insertReq(Map<String, Object> map);
	void updateReq(Map<String, Object> map);
	void deleteReq(Map<String, Object> map);
	
	/* 상환관리 */
	Map<String, Object> selectRepayList(Map<String, Object> map);
	Map<String, Object> selectRepay(Map<String, Object> map);
	void insertNewRepay(Map<String, Object> map);
	void insertRepay(Map<String, Object> map);
	void updateRepay(Map<String, Object> map);
	void deleteRepay(Map<String, Object> map);
	
	/* 사용자관리 */
	Map<String, Object> selectUserList(Map<String, Object> map);
	Map<String, Object> selectUser(Map<String, Object> map);
	Map<String, Object> selectUserPswrdYn(Map<String, Object> map);
	Map<String, Object> selectUserIdExistYn(Map<String, Object> map);
	void insertUserLog(Map<String, Object> map);
	void insertUser(Map<String, Object> map);
	void updateUser(Map<String, Object> map);
	void deleteUser(Map<String, Object> map);
	
	Map<String, Object> selectCdList(Map<String, Object> map);
	Map<String, Object> selectCd(Map<String, Object> map);
	Map<String, Object> selectInsertCdYn(Map<String, Object> map);
	void insertCd(Map<String, Object> map);
	void updateCd(Map<String, Object> map);
	void deleteCd(Map<String, Object> map);
	
	Map<String, Object> selectEmailHisList(Map<String, Object> map);
	Map<String, Object> selectEmail(Map<String, Object> map);
	
	Map<String, Object> selectEmailTmpltList(Map<String, Object> map);
	Map<String, Object> selectEmailTmplt(Map<String, Object> map);
	void insertEmailTmplt(Map<String, Object> map);
	void updateEmailTmplt(Map<String, Object> map);
	void deleteEmailTmplt(Map<String, Object> map);
}
