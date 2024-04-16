package boardgame.bo.service;

import boardgame.bo.dao.BoDao;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service("boService")
public class BoServiceImpl implements BoService{
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="boDAO")
	private BoDao boDAO;
	
	@Override
	public Map<String, Object> selectMmbrList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectMmbrListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectMmbrList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMmbr(Map<String, Object> map) {
		return boDAO.selectMmbr(map);
	}
	
	@Override
	public Map<String, Object> selectMmbrLogList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectMmbrLogListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectMmbrLogList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMmbrCmmrcList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectMmbrCmmrcListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectMmbrCmmrcList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMmbrRepayList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectMmbrRepayListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectMmbrRepayList(map));
		return resultMap;
	}
	
	@Override
	public void updateMmbr(Map<String, Object> map) {
		boDAO.updateMmbr(map);
	}
	
	
	@Override
	public List<Map<String,Object>> selectMarketinfoList(Map<String, Object> map) {
		return boDAO.selectMarketinfoList(map);
	}
	
	@Override
	public List<Map<String,Object>> selectCryptoCandleList(Map<String, Object> map) {
		return boDAO.selectCryptoCandleList(map);
	}
	
	
	@Override
	public Map<String, Object> selectCryptoCandleInfo(Map<String, Object> map) {
		return boDAO.selectCryptoCandleInfo(map);
	}
	
	@Override
	public List<Map<String,Object>> selectCandleDtKstList(Map<String, Object> map) {
		return boDAO.selectCandleDtKstList(map);
	}
	
	@Override
	public Map<String, Object> selectCryptoCandleMoveLine(Map<String, Object> map) {
		return boDAO.selectCryptoCandleMoveLine(map);
	}
	
	@Override
	public Map<String, Object> selectCryptoTradeHisTest(Map<String, Object> map) {
		return boDAO.selectCryptoTradeHisTest(map);
	}
	
	@Override
	public void insertCryptoTradeHisTest(Map<String, Object> map) {
		boDAO.insertCryptoTradeHisTest(map);
	}
	
	@Override
	public void deleteCryptoTradeHisTest(Map<String, Object> map) {
		boDAO.deleteCryptoTradeHisTest(map);
	}
	
	
	
	@Override
	public Map<String, Object> selectCmmrcList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectCmmrcListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectCmmrcList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectCmmrc(Map<String, Object> map) {
		return boDAO.selectCmmrc(map);
	}
	
	@Override
	public void insertCmmrc(Map<String, Object> map) {
		boDAO.insertCmmrc(map);
	}
	
	@Override
	public void updateCmmrc(Map<String, Object> map) {
		boDAO.updateCmmrc(map);
	}
	
	@Override
	public void deleteCmmrc(Map<String, Object> map) {
		boDAO.deleteCmmrc(map);
	}
	
	
	@Override
	public Map<String, Object> selectReqList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectReqListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectReqList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectReq(Map<String, Object> map) {
		return boDAO.selectReq(map);
	}
	
	@Override
	public void insertReq(Map<String, Object> map) {
		boDAO.insertReq(map);
	}
	
	@Override
	public void updateReq(Map<String, Object> map) {
		boDAO.updateReq(map);
	}
	
	@Override
	public void deleteReq(Map<String, Object> map) {
		boDAO.deleteReq(map);
	}
	
	@Override
	public Map<String, Object> selectRepayList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectRepayListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectRepayList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectRepay(Map<String, Object> map) {
		return boDAO.selectRepay(map);
	}
	
	@Override
	public void insertNewRepay(Map<String, Object> map) {
		boDAO.insertNewRepay(map);
	}
	
	@Override
	public void insertRepay(Map<String, Object> map) {
		boDAO.insertRepay(map);
	}
	
	@Override
	public void updateRepay(Map<String, Object> map) {
		boDAO.updateRepay(map);
	}
	
	@Override
	public void deleteRepay(Map<String, Object> map) {
		boDAO.deleteRepay(map);
	}
	
	
	@Override
	public Map<String, Object> selectUserList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectUserListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectUserList(map));
		return resultMap;
	}

	@Override
	public Map<String, Object> selectUser(Map<String, Object> map) {
		return boDAO.selectUser(map);
	}
	
	@Override
	public Map<String, Object> selectUserPswrdYn(Map<String, Object> map) {
		return boDAO.selectUserPswrdYn(map);
	}
	
	@Override
	public Map<String, Object> selectUserIdExistYn(Map<String, Object> map) {
		return boDAO.selectUserIdExistYn(map);
	}
	
	@Override
	public void insertUserLog(Map<String, Object> map) {
		boDAO.insertUserLog(map);
	}
	
	@Override
	public void insertUser(Map<String, Object> map) {
		boDAO.insertUser(map);
	}
	
	@Override
	public void updateUser(Map<String, Object> map) {
		boDAO.updateUser(map);
	}
	
	@Override
	public void deleteUser(Map<String, Object> map) {
		boDAO.deleteUser(map);
	}
	
	
	@Override
	public Map<String, Object> selectCdList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectCdListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectCdList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectCd(Map<String, Object> map) {
		return boDAO.selectCd(map);
	}
	
	@Override
	public Map<String, Object> selectInsertCdYn(Map<String, Object> map) {
		return boDAO.selectInsertCdYn(map);
	}
	
	@Override
	public void insertCd(Map<String, Object> map) {
		boDAO.insertCd(map);
	}
	
	@Override
	public void updateCd(Map<String, Object> map) {
		boDAO.updateCd(map);
	}
	
	@Override
	public void deleteCd(Map<String, Object> map) {
		boDAO.deleteCd(map);
	}
	
	@Override
	public Map<String, Object> selectEmailHisList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectEmailHisListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectEmailHisList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectEmail(Map<String, Object> map) {
		return boDAO.selectEmail(map);
	}
	
	@Override
	public Map<String, Object> selectEmailTmpltList(Map<String, Object> map) {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("cnt", boDAO.selectEmailTmpltListCnt(map).get("cnt"));
		resultMap.put("list", boDAO.selectEmailTmpltList(map));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectEmailTmplt(Map<String, Object> map) {
		return boDAO.selectEmailTmplt(map);
	}
	
	@Override
	public void insertEmailTmplt(Map<String, Object> map) {
		boDAO.insertEmailTmplt(map);
	}
	
	@Override
	public void updateEmailTmplt(Map<String, Object> map) {
		boDAO.updateEmailTmplt(map);
	}
	
	@Override
	public void deleteEmailTmplt(Map<String, Object> map) {
		boDAO.deleteEmailTmplt(map);
	}
}
