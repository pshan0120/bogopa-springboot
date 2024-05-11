package boardgame.fo.join.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import boardgame.fo.club.service.ClubService;
import boardgame.fo.login.service.LoginService;
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
import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class JoinController {

    private final ComService comService;

    private final MemberService memberService;

    private final ClubService clubService;

    private final LoginService loginService;

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
        Map<String, Object> memberMap = memberService.selectMember(commandMap.getMap());
        if (MapUtils.isEmpty(memberMap)) {
            return mv;
        }

        Long memberId = (Long) memberMap.get("mmbrNo");
        Long clubId = (Long) memberMap.get("clubNo");
        if (Optional.ofNullable(clubId).isPresent()) {
            mv.addObject("invtMap", memberService.selectMember(commandMap.getMap()));
            mv.addObject("clubMap", clubService.readInfoById(clubId, memberId));
        }
        return mv;
    }

    @RequestMapping(value = "/doJoin")
    public ModelAndView doJoin(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";
        // TODO: 이하 JoinService 로 옮길 것

        if (StringUtils.equals("Y", String.valueOf(memberService.selectEmailExistYn(commandMap.getMap()).get("existYn")))) {
            resultMsg = "이미 존재하는 이메일입니다.";
        } else {
            if (StringUtils.equals("Y", String.valueOf(memberService.selectNickNmExistYn(commandMap.getMap()).get("existYn")))) {
                resultMsg = "이미 존재하는 닉네임입니다.";
            } else {
                Map<String, Object> requestMap = commandMap.getMap();
                requestMap.put("temporarilyJoined", false);
                memberService.create(requestMap);

                Long memberId = (Long) requestMap.get("mmbrNo");
                loginService.setLogin(memberId, request);

                if (requestMap.containsKey("invtMmbrNo")) {
                    clubService.insertClubJoin(requestMap);
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
