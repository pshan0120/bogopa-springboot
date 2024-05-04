package boardgame.fo.play.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.com.util.FileUtils;
import boardgame.com.util.SessionUtils;
import boardgame.fo.login.service.LoginService;
import boardgame.fo.member.service.MemberService;
import boardgame.fo.play.service.PlayService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class PlayController {

    private final PlayService playService;

    private final MemberService memberService;

    private final ComService comService;

    private final FileUtils fileUtils;

    private final LoginService loginService;

    /* 플레이 */
    @RequestMapping(value = "/play")
    public ModelAndView openPlay() {
        ModelAndView mv = new ModelAndView("/fo/play");
        return mv;
    }

    @RequestMapping(value = "/play/{id}")
    public ModelAndView openPlayId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("/fo/play");
        commandMap.put("mmbrScrtKey", id);
        Map<String, Object> memberMap = memberService.selectMmbr(commandMap.getMap());
        if (MapUtils.isNotEmpty(memberMap)) {
            loginService.setLogin((Long) memberMap.get("mmbrNo"), request);
        }
        return mv;
    }

    @RequestMapping(value = "/selectPlayRcrdByAllList")
    public ModelAndView selectPlayRcrdByAllList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectPlayRcrdByAllList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selecPlayRcrdByClubList")
    public ModelAndView selecPlayRcrdByClubList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectPlayRcrdByClubList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selecPlayRcrdByMmbrList")
    public ModelAndView selecPlayRcrdByMmbrList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectPlayRcrdByMmbrList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selecPlayRcrdByGameList")
    public ModelAndView selecPlayRcrdByGameList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectPlayRcrdByGameList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }


    @RequestMapping(value = "/selectPlayRcrd")
    public ModelAndView selectPlayRcrd(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectPlayRcrd(commandMap.getMap()));
        mv.addObject("list", playService.selectPlayRcrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/updatePlayRcrd")
    public ModelAndView updatePlayRcrd(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        String resultMsg = "";
        Boolean result = false;

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("mode", "end");
            playService.updatePlay(commandMap.getMap());

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
            for (int i = 0; i < size; i++) {
                minusRnkArrInt[i] = -Integer.parseInt(rsltRnkArr[i]);
                rnkArrInt[i] = 1;
                playPntArrInt[i] = Integer.parseInt(playPntArr[i]);
                playPntIntSum += playPntArrInt[i];
                if (rsltScrArr[i] != "") {
                    rsltScrArrInt[i] = Integer.parseInt(rsltScrArr[i]);
                } else {
                    rsltScrArrInt[i] = 0;
                }
            }
            int playPntIntAvg = Math.round(playPntIntSum / size);

            log.debug("평균 플레이포인트 : " + playPntIntAvg);

            int i, j;
            for (i = 0; i < size - 1; i++) {
                for (j = i; j < size; j++) {
                    if (minusRnkArrInt[i] < minusRnkArrInt[j]) {
                        rnkArrInt[i] = rnkArrInt[i] + 1;
                    } else if (minusRnkArrInt[i] > minusRnkArrInt[j]) {
                        rnkArrInt[j] = rnkArrInt[j] + 1;
                    }
                }
            }

            for (i = 0; i < size; i++) {
                log.debug("계산용 순위 : " + rnkArrInt[i]);
                pntArrInt[i] = Math.round((totalPnt * (size + 1 - rnkArrInt[i]) / size) * (100 + (playPntIntAvg - playPntArrInt[i]) / 10) / 100);
                log.debug("포인트 : " + pntArrInt[i]);
                log.debug("점수 : " + rsltScrArrInt[i]);
            }

            for (int k = 0; k < size; k++) {
                Map<String, Object> tempMap = new HashMap<>();
                tempMap.put("seq", seqArr[k]);
                tempMap.put("rsltRnk", rsltRnkArr[k]);
                tempMap.put("rsltScr", rsltScrArr[k]);
                tempMap.put("rsltPnt", pntArrInt[k]);
                playService.updatePlayMmbr(tempMap);
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

        if (SessionUtils.isMemberLogin()) {
            String seq = String.valueOf(commandMap.get("seq"));
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
            if (iterator.hasNext()) {
                commandMap.put("fileId", seq);
                commandMap.put("fileTypeCd", "3");    // 플레이소감 이미지
                Map<String, Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
                if ((Boolean) fileMap.get("result")) {
                    fileMap.put("loginUserId", "system");
                    comService.insertFile(fileMap);

                    commandMap.put("fdbckImgFileNm", fileMap.get("strdFileNm"));
                    playService.updatePlayMmbr(commandMap.getMap());

                    resultMsg = "저장되었습니다.";
                    result = true;
                } else {
                    resultMsg = String.valueOf(fileMap.get("resultMsg"));
                }
            } else {
                playService.updatePlayMmbr(commandMap.getMap());

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
    public ModelAndView selectPlayJoinMmbrList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("list", playService.selectPlayJoinMmbrList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/insertPlay")
    public ModelAndView insertPlay(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("sttsCd", "1");    // 플레이상태 진행중
            playService.insertPlay(commandMap.getMap());
            String playNo = String.valueOf(commandMap.get("playNo"));

            String[] joinMmbrNoArr = (String.valueOf(commandMap.get("joinMmbrNoArr"))).split(",");

            String[] settingCd1Arr = (String.valueOf(commandMap.get("settingCd1Arr"))).split(",");
            String[] settingCd2Arr = (String.valueOf(commandMap.get("settingCd2Arr"))).split(",");
            String[] settingCd3Arr = (String.valueOf(commandMap.get("settingCd3Arr"))).split(",");
            for (int i = 0, size = joinMmbrNoArr.length; i < size; i++) {
                Map<String, Object> tempMap = new HashMap<>();
                tempMap.put("playNo", playNo);
                tempMap.put("mmbrNo", joinMmbrNoArr[i]);
                if (commandMap.containsKey("settingCd1Arr")
                        && StringUtils.isNotEmpty(String.valueOf(commandMap.get("settingCd1Arr")))) {
                    tempMap.put("setting1Cd", settingCd1Arr[i]);
                }
                if (commandMap.containsKey("settingCd2Arr")
                        && StringUtils.isNotEmpty(String.valueOf(commandMap.get("settingCd2Arr")))) {
                    tempMap.put("setting2Cd", settingCd2Arr[i]);
                }
                if (commandMap.containsKey("settingCd3Arr")
                        && StringUtils.isNotEmpty(String.valueOf(commandMap.get("settingCd3Arr")))) {
                    tempMap.put("setting3Cd", settingCd3Arr[i]);
                }
                playService.insertPlayMmbr(tempMap);
            }

            mv.addObject("playNo", playNo);
            resultMsg = "플레이가 시작되었습니다.";
            result = true;
        } else {
            resultMsg = "로그인 세션이 종료되었습니다.";
        }

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectBocPlayRcrdList")
    public ModelAndView selectBocPlayRcrdList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectBocPlayRcrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectFruitShopPlayRcrdList")
    public ModelAndView selectFruitShopPlayRcrdList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectFruitShopPlayRcrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectCatchAThiefPlayRcrdList")
    public ModelAndView selectCatchAThiefPlayRcrdList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", playService.selectCatchAThiefPlayRcrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

}
