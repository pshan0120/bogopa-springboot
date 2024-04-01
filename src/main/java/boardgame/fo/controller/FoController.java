package boardgame.fo.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.com.session.SessionListener;
import boardgame.com.util.ComUtils;
import boardgame.com.util.FileUtils;
import boardgame.fo.service.FoService;

@Controller
public class FoController {
	Logger log = Logger.getLogger(this.getClass());
	
	public String mvPrefix = "/fo";
	
	@Resource(name="foService")
	private FoService foService;
	
	@Resource(name="comService")
	private ComService comService;
	
	@Resource(name="fileUtils")
	private FileUtils fileUtils;
	
	@Resource(name="comUtils")
	private ComUtils comUtils;
	
	/* 메인 */
	@RequestMapping(value="/main")
	public ModelAndView openMain(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/main");
		// 게시물유형
		mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
		return mv;
	}
	
	@RequestMapping(value = "/selectMain")
	public ModelAndView selectMain(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("playRcrdList", foService.selectMainPlayRcrdList(commandMap.getMap()));
		mv.addObject("clubBrdList", foService.selectMainClubBrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* 회원가입 */
	@RequestMapping(value="/join")
	public ModelAndView openJoin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/join");
		return mv;
	}

	/* 모임 초대 */
	@RequestMapping(value="/join/{id}")
	public ModelAndView openJoinId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/join");
		commandMap.put("mmbrScrtKey", id);
		Map<String, Object> mmbrMap = foService.selectMmbr(commandMap.getMap());
		if(MapUtils.isNotEmpty(mmbrMap)) {
			if(!StringUtils.isEmpty(String.valueOf(mmbrMap.get("clubNo")))) {
				mv.addObject("invtMap", foService.selectMmbr(commandMap.getMap()));
				mv.addObject("clubMap", foService.selectClubPrfl(mmbrMap));
			}
		}
		return mv;
	}
	
	@RequestMapping(value = "/doJoin")
	public ModelAndView doJoin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(StringUtils.equals("Y", String.valueOf(foService.selectEmailExistYn(commandMap.getMap()).get("existYn")))) {
			resultMsg = "이미 존재하는 이메일입니다.";
		} else {
			if(StringUtils.equals("Y", String.valueOf(foService.selectNickNmExistYn(commandMap.getMap()).get("existYn")))) {
				resultMsg = "이미 존재하는 닉네임입니다.";
			} else {
				commandMap.put("param1", "mmbrNo");
				Map<String, Object> idMap = comService.selectGetId(commandMap.getMap());
				String mmbrNo = idMap.get("id").toString();
				commandMap.put("mmbrNo", mmbrNo);
				foService.insertMmbr(commandMap.getMap());
				this.setLogin(commandMap.getMap(), request);
				
				if(commandMap.containsKey("invtMmbrNo")) {
					foService.insertClubJoin(commandMap.getMap());
				}
				
				result = true;
				resultMsg = "회원가입이 완료되었습니다.";
			}
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* 로그인 */
	@RequestMapping(value = "/login")
	public ModelAndView openLogin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/login");
		HttpSession session = request.getSession();
		String fromUri = (String) session.getAttribute("fromUri");
		if(StringUtils.equals("/login", fromUri)) {
			session.setAttribute("fromUri", "/");
		}
		
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null) {
			ip = request.getRemoteAddr();
		}
		mv.addObject("userIp", ip);
		return mv;
	}
	
	// 로그인 from URI
	@RequestMapping(value="/login/{id}")
	public ModelAndView openLoginId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/login");
		HttpSession session = request.getSession();
		String fromUri = id;
		if(StringUtils.equals("/login", fromUri)) {
			session.setAttribute("fromUri", "/");
		} else {
			session.setAttribute("fromUri", "/" + fromUri);
		}
		
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null) {
			ip = request.getRemoteAddr();
		}
		mv.addObject("userIp", ip);
		return mv;
	}
	
	@RequestMapping(value="/login/{id}/{id2}")
	public ModelAndView openLoginId(@PathVariable("id") String id, @PathVariable("id2") String id2, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/login");
		HttpSession session = request.getSession();
		String fromUri = id + "/" + id2;
		if(StringUtils.equals("/login", fromUri)) {
			session.setAttribute("fromUri", "/");
		} else {
			session.setAttribute("fromUri", "/" + fromUri);
		}
		
		String ip = request.getHeader("X-FORWARDED-FOR");
		if(ip == null) {
			ip = request.getRemoteAddr();
		}
		mv.addObject("userIp", ip);
		return mv;
	}
	
	@RequestMapping(value = "/doLogin")
	public ModelAndView doLogin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		Map<String, Object> checkMap = foService.selectMmbrPswrdYn(commandMap.getMap());
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
			foService.updateMmbr(checkMap);
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
		
		Map<String, Object> mmbrMap = foService.selectMmbr(map);
		String mmbrNo = (String) mmbrMap.get("mmbrNo");
		String nickNm = (String) mmbrMap.get("nickNm");
		String email = (String) mmbrMap.get("email");
		String mmbrTypeCd = (String) mmbrMap.get("mmbrTypeCd");
		String clubNo = (String) mmbrMap.get("clubNo");
		
		// 세션 사용자 정보 세팅
		session.setAttribute("mmbrNo", mmbrNo);
		session.setAttribute("nickNm", nickNm);
		session.setAttribute("email", email);
		session.setAttribute("mmbrTypeCd", mmbrTypeCd);
		session.setAttribute("clubNo", clubNo);
		session.setAttribute("mmbrIp", ip);
		session.setAttribute("loginTime", Long.valueOf((System.currentTimeMillis())));
		
		mmbrMap.put("mmbrIp", ip);
		// 로그인 이력 등록
		foService.insertMmbrLog(mmbrMap);
	}
	
	private String getLoginMmbrNo(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		return (String) session.getAttribute("mmbrNo");
	}
	
	private Boolean isLogin(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		Boolean isLogin = false;
		if(session.getAttribute("mmbrNo") != null) {
			isLogin = true;
		}
		return isLogin;
	}
	
	/* 로그아웃 */
	@RequestMapping(value = "/logout")
	public ModelAndView logout(CommandMap commandMap, HttpServletRequest request) throws Exception{
		// 동시접속자 접속(대기)를 위한 Listener 생성
		SessionListener sessionListener = new SessionListener();
		HttpSession session = request.getSession();
		sessionListener.setLogoutSession(session);
		String mmbrNo = (String) session.getAttribute("mmbrNo");
		boolean logout = mmbrNo == null ? false : true;
		if(logout) {
			session.invalidate();
		}
		ModelAndView mv = new ModelAndView("redirect:/");
		return mv;
	}
	
	/* 이용안내 */
	@RequestMapping(value = "/guide")
	public ModelAndView openGuide(CommandMap commandMap, HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView(mvPrefix + "/guide");
		return mv;
	}
	
	
	@RequestMapping(value = "/selectBrdList")
	public ModelAndView selectBrdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectBrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectBrd")
	public ModelAndView selectBrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectBrd(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* 회원 */
	@RequestMapping(value = "/updateMmbr")
	public ModelAndView updateMmbr(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
			foService.updateMmbr(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMmbrPrfl")
	public ModelAndView selectMmbrPrfl(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectMmbrPrfl(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateMmbrPrflImg")
	public ModelAndView updateMmbrPrflImg(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		if(this.isLogin(request)) {
			String mmbrNo = String.valueOf(commandMap.get("mmbrNo"));
			MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
			Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
			if(iterator.hasNext()) {
				commandMap.put("fileId", mmbrNo);
				commandMap.put("fileTypeCd", "1");	// 회원프로필이미지
				Map<String,Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
				if((Boolean) fileMap.get("result")) {
					fileMap.put("loginUserId", "system");
					comService.insertFile(fileMap);
					
					commandMap.put("prflImgFileNm", fileMap.get("strdFileNm"));
					foService.updateMmbr(commandMap.getMap());
					
					resultMsg = "변경되었습니다.";
					result = true;
				} else {
					resultMsg = String.valueOf(fileMap.get("resultMsg"));
				}
			} else {
				foService.updateMmbr(commandMap.getMap());
				
				resultMsg = "변경되었습니다.";
				result = true;
			}
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* 마이페이지 */
	@RequestMapping(value="/myPage")
	public ModelAndView openMyPage(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/myPage");
		// 게시물유형
		mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
		return mv;
	}
	
	@RequestMapping(value="/myPage/{id}")
	public ModelAndView openMyPageId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/myPage");
		commandMap.put("mmbrScrtKey", id);
		if(MapUtils.isNotEmpty(foService.selectMmbr(commandMap.getMap()))) {
			this.setLogin(commandMap.getMap(), request);
		}
		return mv;
	}
	
	@RequestMapping(value = "/selectMyPage")
	public ModelAndView selectMyPage(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectMyPage(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyPlayRcrdList")
	public ModelAndView selectMyPlayRcrdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectMyPlayRcrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClubMmbrList")
	public ModelAndView selectMyClubMmbrList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectMyClubMmbrList(commandMap.getMap()));
		mv.addObject("joinList", foService.selectMyClubJoinList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClubAttndNotCnfrmList")
	public ModelAndView selectMyClubAttndNotCnfrmList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("list", foService.selectMyClubAttndNotCnfrmList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClubAttnd")
	public ModelAndView updateClubAttnd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			foService.updateClubAttnd(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClubAttndCnfrm")
	public ModelAndView updateClubAttndCnfrm(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			// 만약 해당 모임원이 당일 회비지불내역이 없다면 1회 회비를 청구
			Map<String, Object> map = foService.selectClubFeePay(commandMap.getMap());
			if(StringUtils.equals("N", String.valueOf(map.get("feePayYn")))) {
				Long feeType1Amt = (Long) map.get("feeType1Amt");	// 1회
				//Long feeType2Amt = (Long) map.get("feeType2Amt");	// 기간
				if(feeType1Amt > 0) {
					commandMap.put("feeTypeCd", "1");
					commandMap.put("feeAmt", feeType1Amt);
					foService.insertClubFee(commandMap.getMap());
				}
			}
			foService.updateClubAttnd(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClubFeePayList")
	public ModelAndView selectMyClubFeePayList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectMyClubFeePayList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/insertMyClubFee2")
	public ModelAndView insertMyClubFee2(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("feeTypeCd", "2");
			foService.insertClubFee(commandMap.getMap());
			resultMsg = "요청되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClubFeePay")
	public ModelAndView updateClubFeePay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "pay");
			foService.updateClubFee(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClubFeeList")
	public ModelAndView selectMyClubFeeList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectMyClubFeeList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClubFeeCnfrm")
	public ModelAndView updateClubFeeCnfrm(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "cnfrm");
			foService.updateClubFee(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	@RequestMapping(value = "/selectMyClubBrdList")
	public ModelAndView selectMyClubBrdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectMyClubBrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClubPlayImgList")
	public ModelAndView selectMyClubPlayImgList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectMyClubPlayImgList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	/* 모임 */
	@RequestMapping(value="/club")
	public ModelAndView openClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/club");
		// 은행코드
		mv.addObject("bankCdList", comUtils.getCdList("C006"));
		return mv;
	}
	
	@RequestMapping(value="/club/{id}")
	public ModelAndView openClubId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/club");
		commandMap.put("mmbrScrtKey", id);
		if(MapUtils.isNotEmpty(foService.selectMmbr(commandMap.getMap()))) {
			this.setLogin(commandMap.getMap(), request);
		}
		// 은행코드
		mv.addObject("bankCdList", comUtils.getCdList("C006"));
		return mv;
	}
	
	@RequestMapping(value = "/selectClubList")
	public ModelAndView selectClubList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectClubList(commandMap.getMap()));
		mv.addObject("mapList", foService.selectClubMapList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/insertClub")
	public ModelAndView insertClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			String mmbrNo = this.getLoginMmbrNo(request);
			commandMap.put("mmbrNo", mmbrNo);
			
			// 모임번호 채번
			commandMap.put("param1", "clubNo");
			String clubNo = String.valueOf(comService.selectGetId(commandMap.getMap()).get("id"));
			commandMap.put("clubNo", clubNo);
			
			// 주소로 좌표 가져오기
			String clientId = "0jj742ww77";
			String clientSecret = "bSiROCe3SNg56JwcNl6F1lgFOs7nhz0TBK1VjfUd";
			
			Double latDouble = 0.0;
			Double lngDouble = 0.0;
			String addr1 = (String) commandMap.get("addrs1");
			String addr2 = (String) commandMap.get("addrs2");
			String fullAddr = addr1 + " " + addr2;
			try {
				String addr = URLEncoder.encode(fullAddr, "UTF-8");
				String apiURL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=" + addr;
				URL url = new URL(apiURL);
				HttpURLConnection con = (HttpURLConnection) url.openConnection();
				con.setRequestMethod("GET");
				con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
				con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
				int responseCode = con.getResponseCode();
				BufferedReader br;
				if(responseCode==200) { // 정상 호출
					br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				} else {	// 에러 발생
					br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
				}
				String inputLine;
				StringBuffer response = new StringBuffer();
				while ((inputLine = br.readLine()) != null) {
					response.append(inputLine);
				}
				br.close();
				
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObject = (JSONObject) jsonParser.parse(response.toString());
				JSONArray addresses = (JSONArray) jsonObject.get("addresses");
				JSONObject item0 = (JSONObject) addresses.get(0);
				lngDouble = Double.valueOf((String) item0.get("x"));
				latDouble = Double.valueOf((String) item0.get("y"));
				
				result = true;
			} catch (Exception e) {
				System.out.println(e);
			}
			commandMap.put("lng", lngDouble);
			commandMap.put("lat", latDouble);
			
			// 프로필이미지가 있다면 파일업로드
			String prflImgFileNm = "";
			if(result) {
				MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
				Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
				if(iterator.hasNext()) {
					commandMap.put("fileTypeCd", "2");	// 모임프로필이미지
					commandMap.put("fileId", clubNo);
					Map<String,Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
					if((Boolean) fileMap.get("result")) {
						fileMap.put("loginUserId", "system");
						comService.insertFile(fileMap);
						prflImgFileNm = String.valueOf(fileMap.get("strdFileNm"));
					} else {
						resultMsg = String.valueOf(fileMap.get("resultMsg"));
						result = false;
					}
				}
			}
			
			if(result) {
				// 정보등록
				commandMap.put("prflImgFileNm", prflImgFileNm);
				commandMap.put("clubTypeCd", "1");	// 모임유형 : 보드게임
				commandMap.put("clubGrdCd", "1");	// 모임등급 : 브론즈
				
				foService.insertClub(commandMap.getMap());
				
				commandMap.put("clubMmbrGrdCd", "5");	// 모임회원등급 : 모임장
				foService.insertClubMmbr(commandMap.getMap());
				
				Map<String, Object> mmbrMap = new HashMap<String,Object>();
				mmbrMap.put("mmbrNo", mmbrNo);
				mmbrMap.put("mmbrTypeCd", "2");	// 회원등급 : 모임장
				foService.updateMmbr(mmbrMap);
				
				resultMsg = "등록되었습니다.";
				result = true;
			}
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubPrfl")
	public ModelAndView selectClubPrfl(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		String mmbrNo = "";
		Boolean isLogin = false;
		if(this.isLogin(request)) {
			mmbrNo = this.getLoginMmbrNo(request);
			isLogin = true;
		}
		commandMap.put("mmbrNo", mmbrNo);
		
		mv.addObject("map", foService.selectClubPrfl(commandMap.getMap()));
		result = true;
		
		mv.addObject("isLogin", isLogin);
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubMmbrList")
	public ModelAndView selectClubMmbrList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectClubMmbrList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubGameList")
	public ModelAndView selectClubGameList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectClubGameList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubBrdList")
	public ModelAndView selectClubBrdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectClubBrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubBrd")
	public ModelAndView selectClubBrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectClubBrd(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/insertClubBrd")
	public ModelAndView insertClubBrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
			foService.insertClubBrd(commandMap.getMap());
			resultMsg = "등록되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClubBrd")
	public ModelAndView updateClubBrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			foService.updateClubBrd(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/deleteClubBrd")
	public ModelAndView deleteClubBrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("useYn", "N");
			foService.updateClubBrd(commandMap.getMap());
			//foService.deleteClubBrd(commandMap.getMap());
			resultMsg = "삭제되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubAttndList")
	public ModelAndView selectClubAttndList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectClubAttndList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/insertClubAttndAll")
	public ModelAndView insertClubAttndAll(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "cancel");
			foService.deleteClubAttnd(commandMap.getMap());
			
			foService.insertClubAttndAll(commandMap.getMap());
			resultMsg = "요청하였습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/deleteClubAttndAll")
	public ModelAndView deleteClubAttndAll(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "cancel");
			foService.deleteClubAttnd(commandMap.getMap());
			resultMsg = "취소되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/clubJoin")
	public ModelAndView clubJoin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
			foService.insertClubJoin(commandMap.getMap());
			resultMsg = "신청되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/cancelJoinClub")
	public ModelAndView cancelJoinClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
			foService.deleteClubJoin(commandMap.getMap());
			resultMsg = "취소되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/quitClub")
	public ModelAndView quitClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
			foService.deleteClubMmbr(commandMap.getMap());
			resultMsg = "탈퇴하였습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value="/myClub")
	public ModelAndView openMyClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/myClub");
		// 은행코드
		mv.addObject("bankCdList", comUtils.getCdList("C006"));
		// 게시물유형
		mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClub")
	public ModelAndView selectMyClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectMyClub(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClub")
	public ModelAndView updateClub(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			foService.updateClub(commandMap.getMap());
			resultMsg = "변경되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectMyClubPlayRcrdList")
	public ModelAndView selectMyClubPlayRcrdList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("mmbrNo", this.getLoginMmbrNo(request));
		mv.addObject("map", foService.selectMyClubPlayRcrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updateClubPrflImg")
	public ModelAndView updateClubPrflImg(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		if(this.isLogin(request)) {
			String clubNo = String.valueOf(commandMap.get("clubNo"));
			MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
			Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
			if(iterator.hasNext()) {
				commandMap.put("fileId", clubNo);
				commandMap.put("fileTypeCd", "2");	// 모임프로필이미지
				Map<String,Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
				if((Boolean) fileMap.get("result")) {
					fileMap.put("loginUserId", "system");
					comService.insertFile(fileMap);
					
					commandMap.put("prflImgFileNm", fileMap.get("strdFileNm"));
					foService.updateClub(commandMap.getMap());
					
					resultMsg = "변경되었습니다.";
					result = true;
				} else {
					resultMsg = String.valueOf(fileMap.get("resultMsg"));
				}
			} else {
				foService.updateClub(commandMap.getMap());
				
				resultMsg = "변경되었습니다.";
				result = true;
			}
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectClubGameHasList")
	public ModelAndView selectClubGameHasList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectClubGameHasList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/insertClubGame")
	public ModelAndView insertClubGame(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			foService.insertClubGame(commandMap.getMap());
			resultMsg = "등록되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/deleteClubGame")
	public ModelAndView deleteClubGame(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			foService.deleteClubGame(commandMap.getMap());
			resultMsg = "삭제되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/cnfrmClubJoin")
	public ModelAndView cnfrmClubJoin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "cnfrm");
			foService.updateClubJoin(commandMap.getMap());
			
			commandMap.put("clubMmbrGrdCd", "1");	// 모임회원등급 : 준회원
			foService.insertClubMmbr(commandMap.getMap());
			
			resultMsg = "승인되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/rjctClubJoin")
	public ModelAndView rjctClubJoin(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "rjct");
			foService.updateClubJoin(commandMap.getMap());
			resultMsg = "거부되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	
	/* 플레이 */
	@RequestMapping(value="/play")
	public ModelAndView openPlay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/play");
		return mv;
	}
	
	@RequestMapping(value="/play/{id}")
	public ModelAndView openPlayId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView(mvPrefix + "/play");
		commandMap.put("mmbrScrtKey", id);
		if(MapUtils.isNotEmpty(foService.selectMmbr(commandMap.getMap()))) {
			this.setLogin(commandMap.getMap(), request);
		}
		return mv;
	}
	
	@RequestMapping(value = "/selecPlayRcrdByAllList")
	public ModelAndView selecPlayRcrdByAllList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selecPlayRcrdByAllList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selecPlayRcrdByClubList")
	public ModelAndView selecPlayRcrdByClubList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selecPlayRcrdByClubList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selecPlayRcrdByMmbrList")
	public ModelAndView selecPlayRcrdByMmbrList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selecPlayRcrdByMmbrList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selecPlayRcrdByGameList")
	public ModelAndView selecPlayRcrdByGameList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selecPlayRcrdByGameList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	@RequestMapping(value = "/selectPlayRcrd")
	public ModelAndView selectPlayRcrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("map", foService.selectPlayRcrd(commandMap.getMap()));
		mv.addObject("list", foService.selectPlayRcrdList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updatePlayRcrd")
	public ModelAndView updatePlayRcrd(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		if(this.isLogin(request)) {
			commandMap.put("mode", "end");
			foService.updatePlay(commandMap.getMap());
			
			// 플레이어당 획득 포인트 계산
			int totalPnt = 100;
			String[] seqArr = (String.valueOf(commandMap.get("seqArr"))).split(",");
			String[] playPntArr = (String.valueOf(commandMap.get("playPntArr"))).split(",");
			Integer[] playPntArrInt = new Integer[seqArr.length];
			String[] rsltRnkArr = (String.valueOf(commandMap.get("rsltRnkArr"))).split(",");
			Integer[] minusRnkArrInt = new Integer[seqArr.length];
			String[] rsltScrArr = (String.valueOf(commandMap.get("rsltScrArr"))).split(",");
			Integer[] rsltScrArrInt = new Integer[seqArr.length];
			Integer[] rnkArrInt = new Integer[seqArr.length];
			Integer[] pntArrInt = new Integer[seqArr.length];
			int size = seqArr.length;
			int playPntIntSum = 0;
			for(int i=0; i<size; i++) {
				minusRnkArrInt[i] = -Integer.parseInt(rsltRnkArr[i]);
				rnkArrInt[i] = 1;
				playPntArrInt[i] = Integer.parseInt(playPntArr[i]);
				playPntIntSum += playPntArrInt[i];
				if(rsltScrArr[i] != "") {
					rsltScrArrInt[i] = Integer.parseInt(rsltScrArr[i]);
				} else {
					rsltScrArrInt[i] = 0;
				}
			}
			int playPntIntAvg = Math.round(playPntIntSum / size);
			
			log.debug("평균 플레이포인트 : " + playPntIntAvg);
			
			int i, j;
			for(i=0; i<size-1; i++){
				for(j=i; j<size; j++){
					if(minusRnkArrInt[i] < minusRnkArrInt[j]){
						rnkArrInt[i] = rnkArrInt[i] + 1;
					} else if(minusRnkArrInt[i] > minusRnkArrInt[j]){
						rnkArrInt[j] = rnkArrInt[j] + 1;
					}
				}
			}
			
			for(i=0; i<size; i++){
				log.debug("계산용 순위 : " + rnkArrInt[i]);
				pntArrInt[i] = Math.round((totalPnt * (size + 1 - rnkArrInt[i]) / size) * (100 + (playPntIntAvg - playPntArrInt[i]) / 10) / 100);
				log.debug("포인트 : " + pntArrInt[i]);
				log.debug("점수 : " + rsltScrArrInt[i]);
			}
			
			for(int k=0; k<size; k++) {
				Map<String, Object> tempMap = new HashMap<String,Object>();
				tempMap.put("seq", seqArr[k]);
				tempMap.put("rsltRnk", rsltRnkArr[k]);
				tempMap.put("rsltScr", rsltScrArr[k]);
				tempMap.put("rsltPnt", pntArrInt[k]);
				foService.updatePlayMmbr(tempMap);
			}
			
			result = true;
			resultMsg = "플레이 결과가 기록되었습니다.";
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/updatePlayMmbrFdbck")
	public ModelAndView updatePlayMmbrFdbck(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		String resultMsg = "";
		Boolean result = false;
		
		if(this.isLogin(request)) {
			String seq = String.valueOf(commandMap.get("seq"));
			MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
			Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
			if(iterator.hasNext()) {
				commandMap.put("fileId", seq);
				commandMap.put("fileTypeCd", "3");	// 플레이소감 이미지
				Map<String,Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
				if((Boolean) fileMap.get("result")) {
					fileMap.put("loginUserId", "system");
					comService.insertFile(fileMap);
					
					commandMap.put("fdbckImgFileNm", fileMap.get("strdFileNm"));
					foService.updatePlayMmbr(commandMap.getMap());
					
					resultMsg = "저장되었습니다.";
					result = true;
				} else {
					resultMsg = String.valueOf(fileMap.get("resultMsg"));
				}
			} else {
				foService.updatePlayMmbr(commandMap.getMap());
				
				resultMsg = "저장되었습니다.";
				result = true;
			}
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectPlayJoinMmbrList")
	public ModelAndView selectPlayJoinMmbrList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("list", foService.selectPlayJoinMmbrList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/insertPlay")
	public ModelAndView insertPlay(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		if(this.isLogin(request)) {
			commandMap.put("sttsCd", "1");	// 플레이상태 진행중
			foService.insertPlay(commandMap.getMap());
			String playNo = String.valueOf(commandMap.get("playNo"));
			
			String[] joinMmbrNoArr = (String.valueOf(commandMap.get("joinMmbrNoArr"))).split(",");
			String[] sttngCd1Arr = (String.valueOf(commandMap.get("sttngCd1Arr"))).split(",");
			String[] sttngCd2Arr = (String.valueOf(commandMap.get("sttngCd2Arr"))).split(",");
			String[] sttngCd3Arr = (String.valueOf(commandMap.get("sttngCd3Arr"))).split(",");
			for(int i=0, size=joinMmbrNoArr.length; i<size; i++){
				Map<String, Object> tempMap = new HashMap<String,Object>();
				tempMap.put("playNo", playNo);
				tempMap.put("mmbrNo", joinMmbrNoArr[i]);
				if(StringUtils.isNotEmpty(String.valueOf(commandMap.get("sttngCd1Arr")))) {
					tempMap.put("sttng1Cd", sttngCd1Arr[i]);
				}
				if(StringUtils.isNotEmpty(String.valueOf(commandMap.get("sttngCd2Arr")))) {
					tempMap.put("sttng2Cd", sttngCd2Arr[i]);
				}
				if(StringUtils.isNotEmpty(String.valueOf(commandMap.get("sttngCd3Arr")))) {
					tempMap.put("sttng3Cd", sttngCd3Arr[i]);
				}
				foService.insertPlayMmbr(tempMap);
			}
			
			resultMsg = "플레이가 시작되었습니다.";
			result = true;
		} else {
			resultMsg = "로그인 세션이 종료되었습니다.";
		}
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	
	/* 게임 */
	@RequestMapping(value = "/selectGameNoList")
	public ModelAndView selectGameNoList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		mv.addObject("list", foService.selectGameNoList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
	@RequestMapping(value = "/selectGameSttngList")
	public ModelAndView selectGameSttngList(CommandMap commandMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView("jsonView");
		Boolean result = false;
		String resultMsg = "";
		
		commandMap.put("grpCd", "1");
		mv.addObject("sttng1List", foService.selectGameSttngList(commandMap.getMap()));
		commandMap.put("grpCd", "2");
		mv.addObject("sttng2List", foService.selectGameSttngList(commandMap.getMap()));
		commandMap.put("grpCd", "3");
		mv.addObject("sttng3List", foService.selectGameSttngList(commandMap.getMap()));
		result = true;
		
		mv.addObject("result", result);
		mv.addObject("resultMsg", resultMsg);
		return mv;
	}
	
}
