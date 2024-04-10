package boardgame.bo.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.annotation.Resource;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import boardgame.bo.service.BoService;
import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.com.session.SessionListener;
import boardgame.com.util.ComUtils;
import boardgame.com.util.ScrapUtils;
import boardgame.com.util.MailUtils;

@Controller
public class BoController {
	Logger log = Logger.getLogger(this.getClass());
	
	public String mvPrefix = "/bo";
	
	@Resource(name="boService")
	private BoService boService;
	
	@Resource(name="comService")
	private ComService comService;
	
	@Resource(name="comUtils")
	private ComUtils comUtils;
	
	@Resource(name="mailUtils")
	private MailUtils mailUtils;
	
	@Resource(name="scrapUtils")
	private ScrapUtils scrapUtils;
	
	
	/* 공통 */
	@RequestMapping(value = "/bo")
	public ModelAndView openBo(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		HttpSession session = request.getSession();
		String loginUserId = (String) session.getAttribute("userId");
		if(StringUtils.isEmpty(loginUserId)) {
			mv.setViewName("redirect:/bo/login");
		} else {
			mv.setViewName("/bo/main");
		}
		return mv;
	}
	
	@RequestMapping(value = "/bo/login")
	public ModelAndView openLogin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/login");
		HttpSession session = request.getSession();
		String fromUri = (String) session.getAttribute("fromUri");
		if(StringUtils.equals("/bo/login", fromUri)) {
			session.setAttribute("fromUri", "/");
		}
		
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null) {
			ip = request.getRemoteAddr();
		}
		mv.addObject("userIp", ip);
		return mv;
	}
	
	@RequestMapping(value="/bo/login/bo/{id}")
	public ModelAndView openLoginId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/login");
		HttpSession session = request.getSession();
		String fromUri = id;
		if(StringUtils.equals("/bo/login", fromUri)) {
			session.setAttribute("fromUri", "/bo");
		} else {
			session.setAttribute("fromUri", "/bo/" + fromUri);
		}
		
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null) {
			ip = request.getRemoteAddr();
		}
		mv.addObject("userIp", ip);
		return mv;
	}
	
	@RequestMapping(value = "/bo/doLogin")
	public ModelAndView doLogin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		Map<String, Object> checkMap = boService.selectUserPswrdYn(commandMap.getMap());
		if(MapUtils.isEmpty(checkMap)) {
			resultMsg = "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.";
		} else {
			Integer pswrdErrCnt = (Integer) checkMap.get("pswrdErrCnt");
			String pswrdYn = (String) checkMap.get("pswrdYn");
			
			if(pswrdErrCnt > 4) {
				resultMsg = "비밀번호 5회 이상 입력 오류 상태입니다.";
				checkMap.put("useYn", "N");
			} else {
				if(StringUtils.equals("N", pswrdYn)) {
					resultMsg = "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.";
					// 비밀번호 오류 건수 증가
					checkMap.put("mode", "pswrdErr");
				} else {
					// 비밀번호 오류 건수 초기화
					checkMap.put("mode", "pswrdErrReset");
					this.setLogin(commandMap.getMap(), request);
					result = true;
				}
			}
			boService.updateUser(checkMap);
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	public void setLogin(Map<String, Object> map, HttpServletRequest request) throws Exception {
		SessionListener sessionListener = new SessionListener();
		// IP 정보 입력
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null) {
			ip = request.getRemoteAddr();
		}
		
		// 로그인 세션정보 Listener에 전달
		HttpSession session = request.getSession();
		sessionListener.setLoginSession(session);
		
		Map<String, Object> userMap = boService.selectUser(map);
		String userId = (String) userMap.get("userId");
		String userNm = (String) userMap.get("userNm");
		
		// 세션 사용자 정보 세팅
		session.setAttribute("userId", userId);
		session.setAttribute("userNm", userNm);
		session.setAttribute("userIp", ip);
		session.setAttribute("loginTime", Long.valueOf((System.currentTimeMillis())));
		
		userMap.put("userIp", ip);
		// 로그인 이력 등록
		boService.insertUserLog(userMap);
	}
	
	private String getLoginUserId(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		return (String) session.getAttribute("userId");
	}
	
	@RequestMapping(value = "/bo/logout")
	public ModelAndView logout(CommandMap commandMap, HttpServletRequest request) throws Exception{
		// 동시접속자 접속(대기)를 위한 Listener 생성
		SessionListener sessionListener = new SessionListener();
		HttpSession session = request.getSession();
		sessionListener.setLogoutSession(session);
		String userId = (String) session.getAttribute("userId");
		boolean logout = userId == null ? false : true;
		if(logout) {
			session.invalidate();
		}
		ModelAndView mv = new ModelAndView("redirect:/bo/login");
		return mv;
	}
	
	/* 회원관리 */
	@RequestMapping(value = "/bo/mmbrList")
	public ModelAndView openMmbrList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/mmbrList");
		// 상환상태
		commandMap.put("grpCd", "C002");
		mv.addObject("sttsCdList", comService.selectCdList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectMmbrList")
	public ModelAndView selectMmbrList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectMmbrList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/selectMmbr")
	public ModelAndView selectMmbr(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectMmbr(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectMmbrLogList")
	public ModelAndView selectMmbrLogList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectMmbrLogList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectMmbrCmmrcList")
	public ModelAndView selectMmbrCmmrcList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectMmbrCmmrcList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectMmbrRepayList")
	public ModelAndView selectMmbrRepayList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectMmbrRepayList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/updateMmbr")
	public ModelAndView updateMmbr(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.updateMmbr(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* CRYPTO */
	@RequestMapping(value = "/bo/cryptoBackTest")
	public ModelAndView openCryptoBackTest(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/cryptoBackTest");
		// 챠트유형코드
		commandMap.put("grpCd", "K001");
		mv.addObject("chartTypeCdList", comService.selectCdList(commandMap.getMap()));
		// 마켓코드
		mv.addObject("mrktCdList", boService.selectMarketinfoList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/doCryptoBackTest")
	public ModelAndView doCryptoBackTest(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String apiId = String.valueOf(commandMap.get("apiId"));
		resultMap.put("apiId", apiId);
		
		if(StringUtils.equals("moveAvgLine1", apiId)) {
			/*
			규칙
			- 매수 : 단기이평선이 장기이평선을 만나고 나서 상승했을 때(+1)
			- 매도 : 단기이평선이 장기이평선을 만나고 나서 하락했을 때(-1)
			* 매매는 틱 시점 시점에서 바로 진행
			상태값
			- 이하 : A선이 B선 아래(-1)
			- 동일 : A선과 B선이 같음(0)
			- 이상 : A선이 B선 위(+1)
			보유여부 : 전일 가지고 있지 않았으면서 매수면 1, 가지고 있었으면서 매도면 0, 아니면 전일값
			최소한 분석차트 데이터가 장기일평선 수보다 커야 함
			 */
			
			double fromRate = 100.0d;
			int shortLineCnt = Integer.parseInt(String.valueOf(commandMap.get("shortLineCnt")));
			int longLineCnt = Integer.parseInt(String.valueOf(commandMap.get("longLineCnt")));
			
			List<Map<String, Object>> resultlist = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> list = boService.selectCryptoCandleList(commandMap.getMap());
			// 최소한 분석차트 데이터가 장기일평선 수 + 1보다 커야 함(장기일평선 다음 날부터 이전 일평선과 계산할 수 있기 때문에)
			if(list.size() > longLineCnt + 1) {
				double bnftRate = 0.0d;
				double shortLine = 0.0d;
				double longLine = 0.0d;
				int lineStts = 0;	// 1 : 이전보다 상승, 0 : 이전과 동일, -1 : 이전보다 하락
				int actn = 0;	// 1 : 매수, 0 : 유지, -1 : 매도
				boolean own = false;
				double hldngBnftRate = fromRate;
				double strtgyBnftRate = fromRate;
				
				double hldngTotalBnftRate = 0.0d;
				int hldngOwnDays = 0;
				double hldngDayAvgBnftRate = 0.0d;
				
				double strtgyTotalBnftRate = 0.0d;
				int strtgyOwnDays = 0;
				double strtgyDayAvgBnftRate = 0.0d;
				
				for(int i=0; i<list.size(); i++){
					// 틱, 종가 포함됨
					Map<String, Object> map = list.get(i);
					double tradePrice = (double) map.get("tradePrice");
					
					// 수익률 : 2번쨰 행부터 계산
					if(i >= 1) {
						Map<String, Object> bfrMap = list.get(i-1);
						double bfrTradePrice = (double) bfrMap.get("tradePrice");
						//bnftRate = Math.round((tradePrice / bfrTradePrice - 1) * 100) / 10000;
						bnftRate = Math.round((tradePrice / bfrTradePrice - 1) * 10000) / 100.0;
					}
					map.put("bnftRate", bnftRate);
					
					// 단기이평선 : 단기이평선 수가 적용되는 행부터 계산
					if(i >= shortLineCnt-1) {
						double bfrTradePriceSum = 0.0d;
						for(int j=0; j<shortLineCnt; j++){
							Map<String, Object> bfrMap = list.get(i-j);
							double bfrTradePrice = (double) bfrMap.get("tradePrice");
							bfrTradePriceSum += bfrTradePrice;
						}
						shortLine = Math.round((bfrTradePriceSum / shortLineCnt) * 100) / 100.0;
					}
					map.put("shortLine", shortLine);
					
					// 장기이평선 : 장기이평선 수가 적용되는 행부터 계산
					if(i >= longLineCnt-1) {
						double bfrTradePriceSum = 0.0d;
						for(int j=0; j<longLineCnt; j++){
							Map<String, Object> bfrMap = list.get(i-j);
							double bfrTradePrice = (double) bfrMap.get("tradePrice");
							bfrTradePriceSum += bfrTradePrice;
						}
						longLine = Math.round((bfrTradePriceSum / longLineCnt) * 100) / 100.0;
					}
					map.put("longLine", longLine);
					
					if(shortLine > longLine) {
						lineStts = 1;
					} else if(shortLine < longLine) {
						lineStts = -1;
					} else {
						lineStts = 0;
					}
					map.put("lineStts", lineStts);
					
					// lineStts가 전일보다 상승이면 매수, 동일이면 유지, 하락이면 매도
					// 전일 단기이평선
					double bfrShortLine = 0.0d;
					if(i-1 >= shortLineCnt-1) {
						double bfrTradePriceSum = 0.0d;
						for(int j=0; j<shortLineCnt; j++){
							Map<String, Object> bfrMap = list.get(i-1-j);
							double bfrTradePrice = (double) bfrMap.get("tradePrice");
							bfrTradePriceSum += bfrTradePrice;
						}
						bfrShortLine = Math.round((bfrTradePriceSum / shortLineCnt) * 100) / 100.0;
					}
					
					// 전일 장기이평선
					double bfrLongLine = 0.0d;
					if(i-1 >= longLineCnt-1) {
						double bfrTradePriceSum = 0.0d;
						for(int j=0; j<longLineCnt; j++){
							Map<String, Object> bfrMap = list.get(i-1-j);
							double bfrTradePrice = (double) bfrMap.get("tradePrice");
							bfrTradePriceSum += bfrTradePrice;
						}
						bfrLongLine = Math.round((bfrTradePriceSum / longLineCnt) * 100) / 100.0;
					}
					
					// 전일 장기이평선이 생성되었을 때부터
					if(bfrLongLine > 0) {
						// 전일 상태
						int bfrLineStts = 0;	// 1 : 이전보다 상승, 0 : 이전과 동일, -1 : 이전보다 하락
						if(bfrShortLine > bfrLongLine) {
							bfrLineStts = 1;
						} else if(bfrShortLine < bfrLongLine) {
							bfrLineStts = -1;
						} else {
							bfrLineStts = 0;
						}
						
						if(bfrLineStts < lineStts) {
							actn = 1;
						} else if(bfrLineStts > lineStts) {
							actn = -1;
						} else {
							actn = 0;
						}
					}
					map.put("actn", actn);
					
					// 이전일 미보유하고 있을 때 매수면 1, 보유일 때 매도면 0, 아니면 이전 유지
					boolean bfrOwn = own;
					if(!own) {
						if(actn == 1) {
							own = true;
						}
					} else {
						if(actn == -1) {
							own = false;
						}
					}
					map.put("own", own);
					
					if(bfrLongLine > 0) {
						hldngBnftRate = Math.round((hldngBnftRate * (1 + bnftRate / 100)) * 100) / 100.0;
						
						if(bfrOwn) {
							strtgyBnftRate = Math.round((strtgyBnftRate * (1 + bnftRate / 100)) * 100) / 100.0;
						}
					}
					map.put("hldngBnftRate", hldngBnftRate);
					map.put("strtgyBnftRate", strtgyBnftRate);
					
					
					if(bfrLongLine > 0) {
						// 보유일 증가
						hldngOwnDays++;
						if(own) {
							strtgyOwnDays++;
						}
					}
					
					//log.debug("map : " + map);
					resultlist.add(map);
				}
				resultMap.put("list", resultlist);
				
				hldngTotalBnftRate = Math.round((hldngBnftRate - fromRate) * 100) / 100.0;
				strtgyTotalBnftRate = Math.round((strtgyBnftRate - fromRate) * 100) / 100.0;
				
				hldngDayAvgBnftRate = Math.round(hldngTotalBnftRate / hldngOwnDays * 100) / 100.0;
				strtgyDayAvgBnftRate = Math.round(strtgyTotalBnftRate / strtgyOwnDays * 100) / 100.0;
				
				resultMap.put("hldngTotalBnftRate", hldngTotalBnftRate);
				resultMap.put("hldngOwnDays", hldngOwnDays);
				resultMap.put("hldngDayAvgBnftRate", hldngDayAvgBnftRate);
				resultMap.put("strtgyTotalBnftRate", strtgyTotalBnftRate);
				resultMap.put("strtgyOwnDays", strtgyOwnDays);
				resultMap.put("strtgyDayAvgBnftRate", strtgyDayAvgBnftRate);
				
				resultMsg = "조회되었습니다.";
				result = true;
				
			} else {
				resultMsg = "분석차트 데이터가 장기일평선 수보다 적습니다.";
			}
		} else if(StringUtils.equals("moveAvgLine2", apiId)) {
			/*
			1. 실행조건 체크
			- 단기 < 중기 < 장기 일수어야 통과
			- 시작일 이전의 캔들차트 데이터가  장기이평선 수보다 많은지 체크
			2. 실행일부터 일별 필요데이터 조회
			- 수익률, 단기이평선, 중기이평선, 장기이평선 값
			3. 실행일 다음날부터 전략데이터 생성
			- 선 상태, 행동, 보유여부
			- 전일 선 상태, 전일 보유여부
			- 홀딩 수익률, 전략 수익률
			4. 필요데이터 + 전략데이터를 cryptoTradeHisTest에 저장
			
			규칙
			- 매수 : 단기이평선이 중기이평선을 만나고 나서 상승했고 장기이평선이 전일 대비 상승일 때 (+1)
			- 매도 : 단기이평선이 중기이평선을 만나고 나서 하락했고 장기이평선이 전일 대비 하락일 때(-1)
			* 매매는 틱 시점 시점에서 바로 진행
			상태값
			- 이하 : A선이 B선 아래(-1)
			- 동일 : A선과 B선이 같음(0)
			- 이상 : A선이 B선 위(+1)
			보유여부 : 전일 가지고 있지 않았으면서 매수면 1, 가지고 있었으면서 매도면 0, 아니면 전일값
			최소한 분석차트 데이터가 장기일평선 수보다 커야 함
			 */
			double fromRate = 100.0d;
			String fromDate = String.valueOf(commandMap.get("fromDate"));
			String toDate = String.valueOf(commandMap.get("toDate"));
			String mrktCd = String.valueOf(commandMap.get("mrktCd"));
			String chartTypeCd = String.valueOf(commandMap.get("chartTypeCd"));
			
			// 1. 실행조건 체크
			// - 단기 < 중기 < 장기 일수어야 통과
			int shortLineCnt = Integer.parseInt(String.valueOf(commandMap.get("shortLineCnt")));
			int middleLineCnt = Integer.parseInt(String.valueOf(commandMap.get("middleLineCnt")));
			int longLineCnt = Integer.parseInt(String.valueOf(commandMap.get("longLineCnt")));
			
			if(shortLineCnt < middleLineCnt
			&& shortLineCnt < longLineCnt
			&& middleLineCnt < longLineCnt) {
				// - 시작일 이전의 캔들차트 데이터가  장기이평선 수보다 많은지 체크
				Map<String, Object> checkMap = boService.selectCryptoCandleInfo(commandMap.getMap());
				long cnt = (long) checkMap.get("cnt");
				if(longLineCnt < cnt) {	// ex) 장기 이평선 수가 60이면 전략 데이터는 61일 이전까지 있어야 함
					// 테스트데이터 초기화
					boService.deleteCryptoTradeHisTest(commandMap.getMap());
					
					List<Map<String, Object>> resultlist = new ArrayList<>();
					
					double hldngBnftRate = fromRate;
					double strtgyBnftRate = fromRate;
					
					double hldngTotalBnftRate = 0.0d;
					int hldngOwnDays = 0;
					double hldngDayAvgBnftRate = 0.0d;
					
					double strtgyTotalBnftRate = 0.0d;
					int strtgyOwnDays = 0;
					double strtgyDayAvgBnftRate = 0.0d;
					
					// 실행틱 리스트 조회
					List<Map<String, Object>> dtlist = boService.selectCandleDtKstList(commandMap.getMap());
					// 최소한 분석차트 데이터가 장기일평선 수 + 1보다 커야 함(장기일평선 다음 날부터 이전 일평선과 계산할 수 있기 때문에)
					for(Map<String, Object> dtMap : dtlist){
						String candleDtKst = String.valueOf(dtMap.get("candleDtKst"));
						commandMap.put("candleDtKst", candleDtKst);
						
						// 2. 실행일부터 일별 필요데이터 조회
						// - 수익률, 단기이평선, 중기이평선, 장기이평선 값
						Map<String, Object> moveLineMap = boService.selectCryptoCandleMoveLine(commandMap.getMap());
						String candleDtKstBfr = String.valueOf(moveLineMap.get("candleDtKstBfr"));	// 조회 전일
						double tradePrice = (double) moveLineMap.get("tradePrice");
						double accTradeVol = (double) moveLineMap.get("accTradeVol");
						double shortMoveLine = (double) moveLineMap.get("shortMoveLine");
						double middleMoveLine = (double) moveLineMap.get("middleMoveLine");
						double longMoveLine = (double) moveLineMap.get("longMoveLine");
						long own = (long) moveLineMap.get("own");
						
						commandMap.put("candleDtKst", candleDtKstBfr);
						
						double tradePriceBfr = 0.0d;
						double shortMoveLineBfr = 0.0d;
						double middleMoveLineBfr = 0.0d;
						double longMoveLineBfr = 0.0d;
						long ownBfr = 0;
								
						// 전 틱에서 기록된 데이터가 있는지 체크
						Map<String, Object> hisBfrMap = boService.selectCryptoTradeHisTest(commandMap.getMap());
						if(MapUtils.isNotEmpty(hisBfrMap)) {
							tradePriceBfr = (double) hisBfrMap.get("tradePrice");
							shortMoveLineBfr = (double) hisBfrMap.get("shortMoveLine");
							middleMoveLineBfr = (double) hisBfrMap.get("middleMoveLine");
							longMoveLineBfr = (double) hisBfrMap.get("longMoveLine");
							ownBfr = (int) hisBfrMap.get("own");
						} else {
							// 기록된 데이터가 없으면 새로 조회
							Map<String, Object> moveLineBfrMap = boService.selectCryptoCandleMoveLine(commandMap.getMap());
							tradePriceBfr = (double) moveLineBfrMap.get("tradePrice");
							shortMoveLineBfr = (double) moveLineBfrMap.get("shortMoveLine");
							middleMoveLineBfr = (double) moveLineBfrMap.get("middleMoveLine");
							longMoveLineBfr = (double) moveLineBfrMap.get("longMoveLine");
							ownBfr = (long) moveLineBfrMap.get("own");
						}
						
						double bnftRate = 0.0d;
						int lineStts = 0;	// 1 : 이전보다 상승, 0 : 이전과 동일, -1 : 이전보다 하락
						int lineSttsBfr = 0;	// 1 : 이전보다 상승, 0 : 이전과 동일, -1 : 이전보다 하락
						int actn = 0;	// 1 : 매수, 0 : 유지, -1 : 매도
						
						bnftRate = Math.round((tradePrice / tradePriceBfr - 1) * 10000) / 100.0;
						
						if(shortMoveLine > middleMoveLine) {
							lineStts = 1;
						} else if(shortMoveLine < middleMoveLine) {
							lineStts = -1;
						} else {
							lineStts = 0;
						}
						
						// lineStts가 전일보다 상승이면 매수, 동일이면 유지, 하락이면 매도
						// 전일 상태
						if(shortMoveLineBfr > middleMoveLineBfr) {
							lineSttsBfr = 1;
						} else if(shortMoveLineBfr < middleMoveLineBfr) {
							lineSttsBfr = -1;
						} else {
							lineSttsBfr = 0;
						}
						
						//if(lineSttsBfr < lineStts) {
						if(lineSttsBfr < lineStts && longMoveLineBfr < longMoveLine) {
							actn = 1;
						} else if(lineSttsBfr > lineStts) {
							actn = -1;
						} else {
							actn = 0;
						}
						
						if(ownBfr == 0) {
							if(actn == 1) {
								own = 1;
							} else {
								own = ownBfr;
							}
						} else {
							if(actn == -1) {
								own = 0;
							} else {
								own = ownBfr;
							}
						}
						log.debug("ownBfr : " + ownBfr);
						log.debug("own : " + own);
						
						hldngBnftRate = Math.round((hldngBnftRate * (1 + bnftRate / 100)) * 100) / 100.0;
						
						if(ownBfr == 1) {
							strtgyBnftRate = Math.round((strtgyBnftRate * (1 + bnftRate / 100)) * 100) / 100.0;
						}
						
						// 보유일 증가
						hldngOwnDays++;
						if(own == 1) {
							strtgyOwnDays++;
						}
						
						Map<String, Object> strtgyMap = new HashMap<String, Object>();
						strtgyMap.put("mrktCd", mrktCd);
						strtgyMap.put("candleDtKst", candleDtKst);
						strtgyMap.put("tradePrice", tradePrice);
						strtgyMap.put("accTradeVol", accTradeVol);
						
						strtgyMap.put("bnftRate", bnftRate);
						strtgyMap.put("shortMoveLine", shortMoveLine);
						strtgyMap.put("middleMoveLine", middleMoveLine);
						strtgyMap.put("longMoveLine", longMoveLine);
						strtgyMap.put("lineStts", lineStts);
						strtgyMap.put("actn", actn);
						strtgyMap.put("own", own);
						
						strtgyMap.put("hldngBnftRate", hldngBnftRate);
						strtgyMap.put("strtgyBnftRate", strtgyBnftRate);
						
						strtgyMap.put("hldngOwnDays", hldngOwnDays);
						strtgyMap.put("strtgyOwnDays", strtgyOwnDays);
						
						boService.insertCryptoTradeHisTest(strtgyMap);
						
						log.debug("strtgyMap : " + strtgyMap);
						resultlist.add(strtgyMap);
					}
					
					resultMap.put("list", resultlist);
					
					hldngTotalBnftRate = Math.round((hldngBnftRate - fromRate) * 100) / 100.0;
					strtgyTotalBnftRate = Math.round((strtgyBnftRate - fromRate) * 100) / 100.0;
					
					hldngDayAvgBnftRate = Math.round(hldngTotalBnftRate / hldngOwnDays * 100) / 100.0;
					strtgyDayAvgBnftRate = Math.round(strtgyTotalBnftRate / strtgyOwnDays * 100) / 100.0;
					
					resultMap.put("hldngTotalBnftRate", hldngTotalBnftRate);
					resultMap.put("hldngOwnDays", hldngOwnDays);
					resultMap.put("hldngDayAvgBnftRate", hldngDayAvgBnftRate);
					resultMap.put("strtgyTotalBnftRate", strtgyTotalBnftRate);
					resultMap.put("strtgyOwnDays", strtgyOwnDays);
					resultMap.put("strtgyDayAvgBnftRate", strtgyDayAvgBnftRate);
					
					resultMsg = "조회되었습니다.";
					result = true;
					
				} else {
					resultMsg = "분석차트 데이터가 장기일평선 수보다 적습니다.";
				}
			} else {
				resultMsg = "단기 < 중기 < 장기 일수어야 테스트가 가능합니다.";
			}
			
			
			
			
			
		}
		
		resultMap.put("result", result);
		resultMap.put("resultMsg", resultMsg);
		
		mv.addObject("map", resultMap);
		return mv;
	}
	
	
	@RequestMapping(value = "/bo/cryptoApiTest")
	public ModelAndView openCryptoApiTest(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/cryptoApiTest");
		return mv;
	}
	
	@RequestMapping(value="/bo/doCryptoApiTest")
	public ModelAndView doTestCryptoApiTest(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		
		//mv.addObject("map", scrapUtils.scrapPortal(commandMap.getMap()));
		
		
		return mv;
	}
	
	
	/* MISC */
	@RequestMapping(value = "/bo/testScrap")
	public ModelAndView openTestScrap(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/testScrap");
		return mv;
	}
	
	@RequestMapping(value="/bo/doTest")
	public ModelAndView doTest(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", scrapUtils.scrapPortal(commandMap.getMap()));
		return mv;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*---------- 참조 코드 ----------*/
	/* 커머스관리 */
	@RequestMapping(value = "/bo/cmmrcList")
	public ModelAndView openCmmrcList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/cmmrcList");
		return mv;
	}
	
	@RequestMapping(value="/bo/selectCmmrcList")
	public ModelAndView selectCmmrcList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectCmmrcList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectCmmrc")
	public ModelAndView selectCmmrc(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectCmmrc(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/insertCmmrc")
	public ModelAndView insertCmmrc(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.insertCmmrc(commandMap.getMap());
			resultMsg = "등록되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/updateCmmrc")
	public ModelAndView updateCmmrc(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.updateCmmrc(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/deleteCmmrc")
	public ModelAndView deleteCmmrc(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			boService.deleteCmmrc(commandMap.getMap());
			resultMsg = "삭제되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* 정산관리 */
	@RequestMapping(value = "/bo/reqList")
	public ModelAndView openReqList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/reqList");
		// 신청상태
		commandMap.put("grpCd", "C001");
		mv.addObject("sttsCdList", comService.selectCdList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectReqList")
	public ModelAndView selectReqList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectReqList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectReq")
	public ModelAndView selectReq(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectReq(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/insertReq")
	public ModelAndView insertReq(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.insertReq(commandMap.getMap());
			resultMsg = "등록되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/updateReq")
	public ModelAndView updateReq(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.updateReq(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/deleteReq")
	public ModelAndView deleteReq(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			boService.deleteReq(commandMap.getMap());
			resultMsg = "삭제되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/scrapCmmrc")
	public ModelAndView scrapCmmrc(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Map<String, Object> map = boService.selectMmbrCmmrcList(commandMap.getMap());
		List<Map<String, Object>> mmbrCmmrclist = (List<Map<String, Object>>) map.get("list");
		if(mmbrCmmrclist.size() > 0) {
			Map<String, Object> mmbrCmmrcMap = mmbrCmmrclist.get(0);
			String sllrId = String.valueOf(mmbrCmmrcMap.get("sllrId"));
			String sllrPswrd = String.valueOf(mmbrCmmrcMap.get("sllrPswrd"));
			
			resultMap.put("clcltAmt", "1000000");
			resultMap.put("clcltDate", "2020-01-11");
			resultMap.put("extra1Amt", "50000");
			resultMap.put("extra2Amt", "");
			resultMap.put("extra3Amt", "");
			resultMap.put("rfndRate", "0.4");
			
			resultMsg = "수집되었습니다.";
			result = true;
		} else {
			resultMsg = "신청회원의 해당 커머스정보가 없습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		mv.addObject("map", resultMap);
		return mv;
	}
	
	@RequestMapping(value = "/bo/prepay")
	public ModelAndView prepay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.insertNewRepay(commandMap.getMap());
			boService.updateReq(commandMap.getMap());
			resultMsg = "변경되었으며 신청 정보에 따른 상환 일정이 생성되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	
	@RequestMapping(value = "/bo/repayList")
	public ModelAndView openRepayList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/repayList");
		// 회차상환상태
		commandMap.put("grpCd", "C002");
		mv.addObject("sttsCdList", comService.selectCdList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectRepayList")
	public ModelAndView selectRepayList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectRepayList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectRepay")
	public ModelAndView selectRepay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectRepay(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/insertRepay")
	public ModelAndView insertRepay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.insertRepay(commandMap.getMap());
			resultMsg = "등록되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/updateRepay")
	public ModelAndView updateRepay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			commandMap.put("loginUserId", loginUserId);
			boService.updateRepay(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/deleteRepay")
	public ModelAndView deleteRepay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			boService.deleteRepay(commandMap.getMap());
			resultMsg = "삭제되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	
	/* 시스템관리 */
	@RequestMapping(value = "/bo/userList")
	public ModelAndView openUserList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/userList");
		return mv;
	}
	
	@RequestMapping(value="/bo/selectUserList")
	public ModelAndView selectUserList(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectUserList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/insertUser")
	public ModelAndView insertUser(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		String loginUserId = this.getLoginUserId(request);
		if(!StringUtils.isEmpty(loginUserId)) {
			String userIdExistYn = (String) boService.selectUserIdExistYn(commandMap.getMap()).get("userIdExistYn");
			if(StringUtils.equals("N", userIdExistYn)) {
				commandMap.put("loginUserId", loginUserId);
				boService.insertUser(commandMap.getMap());
				resultMsg = "등록되었습니다.";
				
				result = true;
			} else {
				resultMsg = "이미 등록된 사용자ID입니다.";
			}
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value="/bo/selectUser")
	public ModelAndView selectUser(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectUser(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/updateUser")
	public ModelAndView updateUser(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		commandMap.put("loginUserId", this.getLoginUserId(request));
		boService.updateUser(commandMap.getMap());
		resultMsg = "수정되었습니다.";
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/deleteUser")
	public ModelAndView deleteUser(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		boService.deleteUser(commandMap.getMap());
		resultMsg = "삭제되었습니다.";
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	@RequestMapping(value = "/bo/cdList")
	public ModelAndView openCdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/cdList");
		// 그룹코드
		commandMap.put("grpCd", "GRPC");
		mv.addObject("grpCdList", comService.selectCdList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value="/bo/selectCdList")
	public ModelAndView selectCdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectCdList(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/selectCd")
	public ModelAndView selectCd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectCd(commandMap.getMap()));
		return mv;
	}
	
	@RequestMapping(value = "/bo/insertCd")
	public ModelAndView insertCd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String insertYn = (String) boService.selectInsertCdYn(commandMap.getMap()).get("insertYn");
		if(StringUtils.equals("Y", insertYn)) {
			HttpSession session = request.getSession();
			commandMap.put("loginUserId", (String) session.getAttribute("userId"));
			boService.insertCd(commandMap.getMap());
			resultMsg = "등록되었습니다.";
			result = true;
		} else {
			resultMsg = "이미 등록된 코드입니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/updateCd")
	public ModelAndView updateCd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		HttpSession session = request.getSession();
		commandMap.put("loginUserId", (String) session.getAttribute("userId"));
		boService.updateCd(commandMap.getMap());
		resultMsg = "수정되었습니다.";
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/bo/deleteCd")
	public ModelAndView deleteCd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		boService.deleteCd(commandMap.getMap());
		resultMsg = "삭제되었습니다.";
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	@RequestMapping(value="/bo/selectEmailHisList")
	public ModelAndView selectEmailHisList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		mv.addObject("map", boService.selectEmailHisList(commandMap.getMap()));
		return mv;
	}
	
	
	
	
}
