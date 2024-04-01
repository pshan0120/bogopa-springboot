package boardgame.bo.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface BoService {
	/* 회원관리 */
	Map<String, Object> selectMmbrList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMmbr(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMmbrLogList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMmbrCmmrcList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectMmbrRepayList(Map<String, Object> map) throws Exception;
	void updateMmbr(Map<String, Object> map) throws Exception;
	
	/* CRYPTO */
	List<Map<String,Object>> selectMarketinfoList(Map<String, Object> map) throws Exception;
	List<Map<String,Object>> selectCryptoCandleList(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectCryptoCandleInfo(Map<String, Object> map) throws Exception;
	List<Map<String,Object>> selectCandleDtKstList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectCryptoCandleMoveLine(Map<String, Object> map) throws Exception;
	Map<String, Object> selectCryptoTradeHisTest(Map<String, Object> map) throws Exception;
	void insertCryptoTradeHisTest(Map<String, Object> map) throws Exception;
	void deleteCryptoTradeHisTest(Map<String, Object> map) throws Exception;
	
	
	
	
	
	
	/* 커머스관리 */
	Map<String, Object> selectCmmrcList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectCmmrc(Map<String, Object> map) throws Exception;
	void insertCmmrc(Map<String, Object> map) throws Exception;
	void updateCmmrc(Map<String, Object> map) throws Exception;
	void deleteCmmrc(Map<String, Object> map) throws Exception;
	
	/* 정산관리 */
	Map<String, Object> selectReqList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectReq(Map<String, Object> map) throws Exception;
	void insertReq(Map<String, Object> map) throws Exception;
	void updateReq(Map<String, Object> map) throws Exception;
	void deleteReq(Map<String, Object> map) throws Exception;
	
	/* 상환관리 */
	Map<String, Object> selectRepayList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectRepay(Map<String, Object> map) throws Exception;
	void insertNewRepay(Map<String, Object> map) throws Exception;
	void insertRepay(Map<String, Object> map) throws Exception;
	void updateRepay(Map<String, Object> map) throws Exception;
	void deleteRepay(Map<String, Object> map) throws Exception;
	
	/* 사용자관리 */
	Map<String, Object> selectUserList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectUser(Map<String, Object> map) throws Exception;
	Map<String, Object> selectUserPswrdYn(Map<String, Object> map) throws Exception;
	Map<String, Object> selectUserIdExistYn(Map<String, Object> map) throws Exception;
	void insertUserLog(Map<String, Object> map) throws Exception;
	void insertUser(Map<String, Object> map) throws Exception;
	void updateUser(Map<String, Object> map) throws Exception;
	void deleteUser(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectCdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectCd(Map<String, Object> map) throws Exception;
	Map<String, Object> selectInsertCdYn(Map<String, Object> map) throws Exception;
	void insertCd(Map<String, Object> map) throws Exception;
	void updateCd(Map<String, Object> map) throws Exception;
	void deleteCd(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectEmailHisList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectEmail(Map<String, Object> map) throws Exception;
	
	Map<String, Object> selectEmailTmpltList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectEmailTmplt(Map<String, Object> map) throws Exception;
	void insertEmailTmplt(Map<String, Object> map) throws Exception;
	void updateEmailTmplt(Map<String, Object> map) throws Exception;
	void deleteEmailTmplt(Map<String, Object> map) throws Exception;
}
