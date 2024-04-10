package boardgame.fo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import boardgame.fo.dao.FoDao;


@Service("foService")
public class FoServiceImpl implements FoService {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="foDAO")
	private FoDao foDAO;
	
	/* 메인 */
	public List<Map<String, Object>> selectMainPlayRcrdList(Map<String, Object> map) throws Exception{
		return foDAO.selectMainPlayRcrdList(map);
	}
	
	public List<Map<String, Object>> selectMainClubBrdList(Map<String, Object> map) throws Exception{
		return foDAO.selectMainClubBrdList(map);
	}
	
	@Override
	public Map<String, Object> selectBrdList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectBrdList(map));
		resultMap.put("cnt", foDAO.selectBrdListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectBrd(Map<String, Object> map) throws Exception {
		return foDAO.selectBrd(map);
	}
	
	
	/* 회원 */
	@Override
	public Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) throws Exception {
		return foDAO.selectMmbrPswrdYn(map);
	}
	
	@Override
	public Map<String, Object> selectMmbr(Map<String, Object> map) throws Exception {
		return foDAO.selectMmbr(map);
	}
	
	@Override
	public Map<String, Object> selectMmbrPrfl(Map<String, Object> map) throws Exception {
		return foDAO.selectMmbrPrfl(map);
	}
	
	@Override
	public void insertMmbrLog(Map<String, Object> map) throws Exception {
		foDAO.insertMmbrLog(map);
	}
	
	@Override
	public void insertMmbr(Map<String, Object> map) throws Exception {
		foDAO.insertMmbr(map);
	}
	
	@Override
	public void updateMmbr(Map<String, Object> map) throws Exception {
		foDAO.updateMmbr(map);
	}
	
	@Override
	public Map<String, Object> selectEmailExistYn(Map<String, Object> map) throws Exception {
		return foDAO.selectEmailExistYn(map);
	}
	
	@Override
	public Map<String, Object> selectNickNmExistYn(Map<String, Object> map) throws Exception {
		return foDAO.selectNickNmExistYn(map);
	}
	
	/* 마이페이지 */
	@Override
	public Map<String, Object> selectMyPage(Map<String, Object> map) throws Exception {
		return foDAO.selectMyPage(map);
	}
	
	@Override
	public Map<String, Object> selectMyPlayRcrdList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyPlayRcrdList(map));
		resultMap.put("cnt", foDAO.selectMyPlayRcrdListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMyClubMmbrList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyClubMmbrList(map));
		resultMap.put("cnt", foDAO.selectMyClubMmbrListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMyClubBrdList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyClubBrdList(map));
		resultMap.put("cnt", foDAO.selectMyClubBrdListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMyClubPlayImgList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyClubPlayImgList(map));
		resultMap.put("cnt", foDAO.selectMyClubPlayImgListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectClubGameHasList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectClubGameHasList(map));
		resultMap.put("cnt", foDAO.selectClubGameHasListCnt(map).get("cnt"));
		return resultMap;
	}
	
	
	@Override
	public void insertClubGame(Map<String, Object> map) throws Exception {
		foDAO.insertClubGame(map);
	}
	
	@Override
	public void deleteClubGame(Map<String, Object> map) throws Exception {
		foDAO.deleteClubGame(map);
	}
	
	
	@Override
	public Map<String, Object> selectClubAttndList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectClubAttndList(map));
		resultMap.put("cnt", foDAO.selectClubAttndListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public void insertClubAttndAll(Map<String, Object> map) throws Exception {
		foDAO.insertClubAttndAll(map);
	}
	
	@Override
	public void updateClubAttnd(Map<String, Object> map) throws Exception {
		foDAO.updateClubAttnd(map);
	}
	
	@Override
	public void deleteClubAttnd(Map<String, Object> map) throws Exception {
		foDAO.deleteClubAttnd(map);
	}
	
	@Override
	public Map<String, Object> selectClubFee(Map<String, Object> map) throws Exception {
		return foDAO.selectClubFee(map);
	}
	
	@Override
	public Map<String, Object> selectClubFeePay(Map<String, Object> map) throws Exception {
		return foDAO.selectClubFeePay(map);
	}
	
	@Override
	public void insertClubFee(Map<String, Object> map) throws Exception {
		foDAO.insertClubFee(map);
	}
	
	@Override
	public void updateClubFee(Map<String, Object> map) throws Exception {
		foDAO.updateClubFee(map);
	}
	
	@Override
	public void deleteClubFee(Map<String, Object> map) throws Exception {
		foDAO.deleteClubFee(map);
	}
	
	
	/* 플레이 */
	@Override
	public Map<String, Object> selectPlayRcrd(Map<String, Object> map) throws Exception {
		return foDAO.selectPlayRcrd(map);
	}
	
	public List<Map<String, Object>> selectPlayRcrdList(Map<String, Object> map) throws Exception{
		return foDAO.selectPlayRcrdList(map);
	}
	
	/* 모임 */
	@Override
	public Map<String, Object> selectClubList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectClubList(map));
		resultMap.put("cnt", foDAO.selectClubListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public void insertClub(Map<String, Object> map) throws Exception {
		foDAO.insertClub(map);
	}
	
	@Override
	public void updateClub(Map<String, Object> map) throws Exception {
		foDAO.updateClub(map);
	}
	
	@Override
	public void deleteClub(Map<String, Object> map) throws Exception {
		foDAO.deleteClub(map);
	}
	
	@Override
	public void insertClubMmbr(Map<String, Object> map) throws Exception {
		foDAO.insertClubMmbr(map);
	}
	
	@Override
	public void updateClubMmbr(Map<String, Object> map) throws Exception {
		foDAO.updateClubMmbr(map);
	}
	
	@Override
	public void deleteClubMmbr(Map<String, Object> map) throws Exception {
		foDAO.deleteClubMmbr(map);
	}
	
	
	@Override
	public void insertClubJoin(Map<String, Object> map) throws Exception {
		foDAO.insertClubJoin(map);
	}
	
	@Override
	public void updateClubJoin(Map<String, Object> map) throws Exception {
		foDAO.updateClubJoin(map);
	}
	
	@Override
	public void deleteClubJoin(Map<String, Object> map) throws Exception {
		foDAO.deleteClubJoin(map);
	}
	
	
	@Override
	public Map<String, Object> selectClubPrfl(Map<String, Object> map) throws Exception {
		return foDAO.selectClubPrfl(map);
	}
	
	@Override
	public Map<String, Object> selectClubMmbrList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectClubMmbrList(map));
		resultMap.put("cnt", foDAO.selectClubMmbrListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectClubGameList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectClubGameList(map));
		resultMap.put("cnt", foDAO.selectClubGameListCnt(map).get("cnt"));
		return resultMap;
	}
	
	public List<Map<String, Object>> selectClubMapList(Map<String, Object> map) throws Exception{
		return foDAO.selectClubMapList(map);
	}
	
	@Override
	public Map<String, Object> selectClubBrdList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectClubBrdList(map));
		resultMap.put("cnt", foDAO.selectClubBrdListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectClubBrd(Map<String, Object> map) throws Exception {
		return foDAO.selectClubBrd(map);
	}
	
	@Override
	public void insertClubBrd(Map<String, Object> map) throws Exception {
		foDAO.insertClubBrd(map);
	}
	
	@Override
	public void updateClubBrd(Map<String, Object> map) throws Exception {
		foDAO.updateClubBrd(map);
	}
	
	@Override
	public void deleteClubBrd(Map<String, Object> map) throws Exception {
		foDAO.deleteClubBrd(map);
	}
	
	
	@Override
	public Map<String, Object> selectMyClub(Map<String, Object> map) throws Exception {
		return foDAO.selectMyClub(map);
	}
	
	@Override
	public Map<String, Object> selectMyClubPlayRcrdList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyClubPlayRcrdList(map));
		resultMap.put("cnt", foDAO.selectMyClubPlayRcrdListCnt(map).get("cnt"));
		return resultMap;
	}
	
	public List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map) throws Exception{
		return foDAO.selectMyClubJoinList(map);
	}
	
	public List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map) throws Exception{
		return foDAO.selectMyClubAttndNotCnfrmList(map);
	}
	
	@Override
	public Map<String, Object> selectMyClubFeePayList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyClubFeePayList(map));
		resultMap.put("cnt", foDAO.selectMyClubFeePayListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectMyClubFeeList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectMyClubFeeList(map));
		resultMap.put("cnt", foDAO.selectMyClubFeeListCnt(map).get("cnt"));
		return resultMap;
	}
	
	
	/* 플레이 */
	@Override
	public Map<String, Object> selectPlayRcrdByAllList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectPlayRcrdByAllList(map));
		resultMap.put("cnt", foDAO.selectPlayRcrdByAllListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectPlayRcrdByClubList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selecPlayRcrdByClubList(map));
		resultMap.put("cnt", foDAO.selecPlayRcrdByClubListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectPlayRcrdByMmbrList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selecPlayRcrdByMmbrList(map));
		resultMap.put("cnt", foDAO.selecPlayRcrdByMmbrListCnt(map).get("cnt"));
		return resultMap;
	}
	
	@Override
	public Map<String, Object> selectPlayRcrdByGameList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selecPlayRcrdByGameList(map));
		resultMap.put("cnt", foDAO.selecPlayRcrdByGameListCnt(map).get("cnt"));
		return resultMap;
	}

	public List<Map<String, Object>> selectPlayJoinMmbrList(Map<String, Object> map) throws Exception{
		return foDAO.selectPlayJoinMmbrList(map);
	}
	
	@Override
	public void insertPlay(Map<String, Object> map) throws Exception {
		foDAO.insertPlay(map);
	}
	
	@Override
	public void updatePlay(Map<String, Object> map) throws Exception {
		foDAO.updatePlay(map);
	}
	
	@Override
	public void deletePlay(Map<String, Object> map) throws Exception {
		foDAO.deletePlay(map);
	}
	
	@Override
	public void insertPlayMmbr(Map<String, Object> map) throws Exception {
		foDAO.insertPlayMmbr(map);
	}
	
	@Override
	public void updatePlayMmbr(Map<String, Object> map) throws Exception {
		foDAO.updatePlayMmbr(map);
	}
	
	
	/* 게임 */
	public List<Map<String, Object>> selectGameNoList(Map<String, Object> map) throws Exception{
		return foDAO.selectGameNoList(map);
	}
	
	public List<Map<String, Object>> selectGameSttngList(Map<String, Object> map) throws Exception{
		return foDAO.selectGameSttngList(map);
	}

	@Override
	public Map<String, Object> selectBocPlayRcrdList(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", foDAO.selectBocPlayRcrdList(map));
		resultMap.put("cnt", foDAO.selectBocPlayRcrdListCnt(map).get("cnt"));
		return resultMap;
	}
}
