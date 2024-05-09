package boardgame.fo.mypage.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.util.ComUtils;
import boardgame.com.util.SessionUtils;
import boardgame.fo.club.service.ClubService;
import boardgame.fo.login.service.LoginService;
import boardgame.fo.member.service.MemberService;
import boardgame.fo.mypage.service.MypageService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class MypageController {

    private final MypageService mypageService;

    private final MemberService memberService;

    private final ClubService clubService;

    private final ComUtils comUtils;

    private final LoginService loginService;

    /* 마이페이지 */
    @RequestMapping(value = "/myPage")
    public ModelAndView openMyPage() {
        ModelAndView mv = new ModelAndView("/fo/myPage");
        // 게시물유형
        mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
        return mv;
    }

    @RequestMapping(value = "/myPage/{id}")
    public ModelAndView openMyPageId(@PathVariable("id") String id, CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("/fo/myPage");
        commandMap.put("mmbrScrtKey", id);
        Map<String, Object> memberMap = memberService.selectMember(commandMap.getMap());
        if (MapUtils.isNotEmpty(memberMap)) {
            loginService.setLogin((Long) memberMap.get("mmbrNo"), request);
        }
        return mv;
    }

    @RequestMapping(value = "/selectMyPage")
    public ModelAndView selectMyPage(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", mypageService.selectMyPage(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectMyPlayRcrdList")
    public ModelAndView selectMyPlayRcrdList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", mypageService.selectMyPlayRcrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectMyClubMmbrList")
    public ModelAndView selectMyClubMmbrList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", mypageService.selectMyClubMmbrList(commandMap.getMap()));
        mv.addObject("joinList", clubService.selectMyClubJoinList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectMyClubAttndNotCnfrmList")
    public ModelAndView selectMyClubAttndNotCnfrmList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("list", clubService.selectMyClubAttndNotCnfrmList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/updateClubAttnd")
    public ModelAndView updateClubAttnd(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            clubService.updateClubAttnd(commandMap.getMap());
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
    public ModelAndView updateClubAttndCnfrm(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            // 만약 해당 모임원이 당일 회비지불내역이 없다면 1회 회비를 청구
            Map<String, Object> map = clubService.selectClubFeePay(commandMap.getMap());
            if (StringUtils.equals("N", String.valueOf(map.get("feePayYn")))) {
                Long feeType1Amt = (Long) map.get("feeType1Amt");    // 1회
                //Long feeType2Amt = (Long) map.get("feeType2Amt");	// 기간
                if (feeType1Amt > 0) {
                    commandMap.put("feeTypeCd", "1");
                    commandMap.put("feeAmt", feeType1Amt);
                    clubService.insertClubFee(commandMap.getMap());
                }
            }
            clubService.updateClubAttnd(commandMap.getMap());
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
    public ModelAndView selectMyClubFeePayList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectMyClubFeePayList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/insertMyClubFee2")
    public ModelAndView insertMyClubFee2(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("feeTypeCd", "2");
            clubService.insertClubFee(commandMap.getMap());
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
    public ModelAndView updateClubFeePay(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("mode", "pay");
            clubService.updateClubFee(commandMap.getMap());
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
    public ModelAndView selectMyClubFeeList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectMyClubFeeList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/updateClubFeeCnfrm")
    public ModelAndView updateClubFeeCnfrm(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("mode", "cnfrm");
            clubService.updateClubFee(commandMap.getMap());
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
    public ModelAndView selectMyClubBrdList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
        mv.addObject("map", clubService.selectMyClubBrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectMyClubPlayImgList")
    public ModelAndView selectMyClubPlayImgList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", clubService.selectMyClubPlayImgList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

}
