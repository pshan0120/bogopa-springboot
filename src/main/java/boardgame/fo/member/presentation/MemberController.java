package boardgame.fo.member.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.com.util.FileUtils;
import boardgame.com.util.SessionUtils;
import boardgame.fo.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Iterator;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class MemberController {

    private final ComService comService;

    private final MemberService memberService;

    private final FileUtils fileUtils;

    /* 회원 */
    @RequestMapping(value = "/updateMmbr")
    public ModelAndView updateMmbr(CommandMap commandMap, HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("mmbrNo", SessionUtils.getCurrentMemberId());
            memberService.updateMmbr(commandMap.getMap());
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

        mv.addObject("map", memberService.selectMmbrPrfl(commandMap.getMap()));
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

        if (SessionUtils.isMemberLogin()) {
            String mmbrNo = String.valueOf(commandMap.get("mmbrNo"));
            MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
            Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
            if (iterator.hasNext()) {
                commandMap.put("fileId", mmbrNo);
                commandMap.put("fileTypeCd", "1");    // 회원프로필이미지
                Map<String, Object> fileMap = fileUtils.uploadFile(commandMap.getMap(), request);
                if ((Boolean) fileMap.get("result")) {
                    fileMap.put("loginUserId", "system");
                    comService.insertFile(fileMap);

                    commandMap.put("prflImgFileNm", fileMap.get("strdFileNm"));
                    memberService.updateMmbr(commandMap.getMap());

                    resultMsg = "변경되었습니다.";
                    result = true;
                } else {
                    resultMsg = String.valueOf(fileMap.get("resultMsg"));
                }
            } else {
                memberService.updateMmbr(commandMap.getMap());

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

}
