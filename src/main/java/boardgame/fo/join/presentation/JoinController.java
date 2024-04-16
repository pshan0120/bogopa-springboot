package boardgame.fo.join.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.fo.club.service.ClubService;
import boardgame.fo.login.presentation.LoginController;
import boardgame.fo.member.service.MemberService;
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
public class JoinController {

    private final ComService comService;

    private final MemberService memberService;

    private final ClubService clubService;

    private final LoginController loginController;

    /* 회원가입 */
    @RequestMapping(value = "/join")
    public ModelAndView openJoin(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("/fo/join");
        return mv;
    }

    /* 모임 초대 */
    @RequestMapping(value = "/join/{id}")
    public ModelAndView openJoinId(@PathVariable("id") String id, CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("/fo/join");
        commandMap.put("mmbrScrtKey", id);
        Map<String, Object> mmbrMap = memberService.selectMmbr(commandMap.getMap());
        if (MapUtils.isNotEmpty(mmbrMap)) {
            if (!StringUtils.isEmpty(String.valueOf(mmbrMap.get("clubNo")))) {
                mv.addObject("invtMap", memberService.selectMmbr(commandMap.getMap()));
                mv.addObject("clubMap", clubService.selectClubPrfl(mmbrMap));
            }
        }
        return mv;
    }

    @RequestMapping(value = "/doJoin")
    public ModelAndView doJoin(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (StringUtils.equals("Y", String.valueOf(memberService.selectEmailExistYn(commandMap.getMap()).get("existYn")))) {
            resultMsg = "이미 존재하는 이메일입니다.";
        } else {
            if (StringUtils.equals("Y", String.valueOf(memberService.selectNickNmExistYn(commandMap.getMap()).get("existYn")))) {
                resultMsg = "이미 존재하는 닉네임입니다.";
            } else {
                commandMap.put("param1", "mmbrNo");
                Map<String, Object> idMap = comService.selectGetId(commandMap.getMap());
                String mmbrNo = idMap.get("id").toString();
                commandMap.put("mmbrNo", mmbrNo);
                memberService.insertMmbr(commandMap.getMap());
                loginController.setLogin(commandMap.getMap(), request);

                if (commandMap.containsKey("invtMmbrNo")) {
                    clubService.insertClubJoin(commandMap.getMap());
                }

                result = true;
                resultMsg = "회원가입이 완료되었습니다.";
            }
        }

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

}
