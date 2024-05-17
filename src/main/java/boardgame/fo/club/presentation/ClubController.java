package boardgame.fo.club.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.com.util.ComUtils;
import boardgame.com.util.FileUtils;
import boardgame.com.util.SessionUtils;
import boardgame.fo.club.service.ClubService;
import boardgame.fo.login.service.LoginService;
import boardgame.fo.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections.MapUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ClubController {

    private final ComService comService;

    private final ClubService clubService;

    private final MemberService memberService;

    private final ComUtils comUtils;

    private final FileUtils fileUtils;

    private final LoginService loginService;

    /* 모임 */
    @RequestMapping(value = "/club")
    public ModelAndView openClub(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("/fo/club");
        // 은행코드
        mv.addObject("bankCdList", comUtils.getCdList("C006"));
        return mv;
    }

    @RequestMapping(value = "/club/{id}")
    public ModelAndView openClubId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/fo/club");
        commandMap.put("mmbrScrtKey", id);

        Map<String, Object> memberMap = memberService.selectMember(commandMap.getMap());
        if (MapUtils.isNotEmpty(memberMap)) {
            loginService.setLogin((Long) memberMap.get("mmbrNo"), request);
        }
        // 은행코드
        mv.addObject("bankCdList", comUtils.getCdList("C006"));
        return mv;
    }

    @RequestMapping(value = "/selectClubList")
    public ModelAndView selectClubList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", clubService.selectClubList(commandMap.getMap()));
        mv.addObject("mapList", clubService.selectClubMapList(commandMap.getMap()));
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

        if (SessionUtils.isMemberLoggedIn()) {
            Long memberId = SessionUtils.getCurrentMemberId();
            commandMap.put("mmbrNo", memberId);

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
                if (responseCode == 200) { // 정상 호출
                    br = new BufferedReader(new InputStreamReader(con.getInputStream()));
                } else {    // 에러 발생
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
            if (result) {
                MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
                Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
                if (iterator.hasNext()) {
                    commandMap.put("fileTypeCd", "2");    // 모임프로필이미지
                    commandMap.put("fileId", clubNo);
                    Map<String, Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
                    if ((Boolean) fileMap.get("result")) {
                        fileMap.put("loginUserId", "system");
                        comService.insertFile(fileMap);
                        prflImgFileNm = String.valueOf(fileMap.get("strdFileNm"));
                    } else {
                        resultMsg = String.valueOf(fileMap.get("resultMsg"));
                        result = false;
                    }
                }
            }

            if (result) {
                // 정보등록
                commandMap.put("prflImgFileNm", prflImgFileNm);
                commandMap.put("clubTypeCd", "1");    // 모임유형 : 보드게임
                commandMap.put("clubGrdCd", "1");    // 모임등급 : 브론즈

                clubService.insertClub(commandMap.getMap());

                commandMap.put("clubMmbrGrdCd", "5");    // 모임회원등급 : 모임장
                clubService.insertClubMmbr(commandMap.getMap());

                Map<String, Object> mmbrMap = new HashMap<>();
                mmbrMap.put("mmbrNo", memberId);
                mmbrMap.put("mmbrTypeCd", "2");    // 회원등급 : 모임장
                memberService.updateMmbr(mmbrMap);

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

    /*@RequestMapping(value = "/selectClubPrfl")
    public ModelAndView selectClubPrfl(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        Boolean isLogin = false;
        Long memberId = SessionUtils.getCurrentMemberId();
        if (SessionUtils.isMemberLogin()) {
            commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
            isLogin = true;
        }

        long clubId = (long) commandMap.get("clubNo");
        mv.addObject("map", clubService.readInfoById(clubId, memberId));
        result = true;

        mv.addObject("isLogin", isLogin);
        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }*/

    /*@RequestMapping(value = "/selectClubMmbrList")
    public ModelAndView selectClubMmbrList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectClubMmbrList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }*/

    @RequestMapping(value = "/selectClubGameList")
    public ModelAndView selectClubGameList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectClubGameList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectClubBrdList")
    public ModelAndView selectClubBrdList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectClubBrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectClubBrd")
    public ModelAndView selectClubBrd(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectClubBrd(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/insertClubBrd")
    public ModelAndView insertClubBrd(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
            clubService.insertClubBrd(commandMap.getMap());
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
    public ModelAndView updateClubBrd(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            clubService.updateClubBrd(commandMap.getMap());
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
    public ModelAndView deleteClubBrd(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("useYn", "N");
            clubService.updateClubBrd(commandMap.getMap());
            //clubService.deleteClubBrd(commandMap.getMap());
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
    public ModelAndView selectClubAttndList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectClubAttndList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/insertClubAttndAll")
    public ModelAndView insertClubAttndAll(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mode", "cancel");
            clubService.deleteClubAttnd(commandMap.getMap());

            clubService.insertClubAttndAll(commandMap.getMap());
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
    public ModelAndView deleteClubAttndAll(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mode", "cancel");
            clubService.deleteClubAttnd(commandMap.getMap());
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
    public ModelAndView clubJoin(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
            clubService.insertClubJoin(commandMap.getMap());
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
    public ModelAndView cancelJoinClub(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
            clubService.deleteClubJoin(commandMap.getMap());
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
    public ModelAndView quitClub(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
            clubService.deleteClubMmbr(commandMap.getMap());
            resultMsg = "탈퇴하였습니다.";
            result = true;
        } else {
            resultMsg = "로그인 세션이 종료되었습니다.";
        }

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/myClub")
    public ModelAndView openMyClub(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("/fo/myClub");
        // 은행코드
        mv.addObject("bankCdList", comUtils.getCdList("C006"));
        // 게시물유형
        mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
        return mv;
    }

    @RequestMapping(value = "/selectMyClub")
    public ModelAndView selectMyClub(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", clubService.selectMyClub(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/updateClub")
    public ModelAndView updateClub(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            clubService.updateClub(commandMap.getMap());
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
    public ModelAndView selectMyClubPlayRcrdList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", clubService.selectMyClubPlayRcrdList(commandMap.getMap()));
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

        if (SessionUtils.isMemberLoggedIn()) {
            String clubNo = String.valueOf(commandMap.get("clubNo"));
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
            if (iterator.hasNext()) {
                commandMap.put("fileId", clubNo);
                commandMap.put("fileTypeCd", "2");    // 모임프로필이미지
                Map<String, Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
                if ((Boolean) fileMap.get("result")) {
                    fileMap.put("loginUserId", "system");
                    comService.insertFile(fileMap);

                    commandMap.put("prflImgFileNm", fileMap.get("strdFileNm"));
                    clubService.updateClub(commandMap.getMap());

                    resultMsg = "변경되었습니다.";
                    result = true;
                } else {
                    resultMsg = String.valueOf(fileMap.get("resultMsg"));
                }
            } else {
                clubService.updateClub(commandMap.getMap());

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
    public ModelAndView selectClubGameHasList(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectClubGameHasList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/insertClubGame")
    public ModelAndView insertClubGame(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            clubService.insertClubGame(commandMap.getMap());
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
    public ModelAndView deleteClubGame(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            clubService.deleteClubGame(commandMap.getMap());
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
    public ModelAndView cnfrmClubJoin(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mode", "cnfrm");
            clubService.updateClubJoin(commandMap.getMap());

            commandMap.put("clubMmbrGrdCd", "1");    // 모임회원등급 : 준회원
            clubService.insertClubMmbr(commandMap.getMap());

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
    public ModelAndView rjctClubJoin(CommandMap commandMap) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLoggedIn()) {
            commandMap.put("mode", "rjct");
            clubService.updateClubJoin(commandMap.getMap());
            resultMsg = "거부되었습니다.";
            result = true;
        } else {
            resultMsg = "로그인 세션이 종료되었습니다.";
        }

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

}
