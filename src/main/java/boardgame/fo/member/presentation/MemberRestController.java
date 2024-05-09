package boardgame.fo.member.presentation;

import boardgame.fo.member.dto.CreateTemporaryMemberRequestDto;
import boardgame.fo.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@ResponseStatus(HttpStatus.OK)
@RequestMapping("/api/member")
@RestController
@RequiredArgsConstructor
public class MemberRestController {

    private final MemberService memberService;

    @GetMapping("/profile")
    public Map<String, Object> readProfileById(@RequestParam long memberId) {
        return memberService.readProfileById(memberId);
    }

    @PostMapping("/boc")
    public void createBocMember(@Validated @RequestBody CreateTemporaryMemberRequestDto dto) {
        memberService.createBocMember(dto);
    }

    @PostMapping("/fruit-shop")
    public void createFruitShopMember(@Validated @RequestBody CreateTemporaryMemberRequestDto dto) {
        memberService.createFruitShopMember(dto);
    }

    @PostMapping("/catch-a-thief")
    public void createCatchAThiefMember(@Validated @RequestBody CreateTemporaryMemberRequestDto dto) {
        memberService.createCatchAThiefMember(dto);
    }

    /*@RequestMapping(value = "/insertBocMember")
    public ModelAndView insertBocMember(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        if (SessionUtils.isMemberLogin()) {
            commandMap.put("sttsCd", "1");    // 플레이상태 진행중
            playService.insertPlay(commandMap.getMap());
            String playNo = String.valueOf(commandMap.get("playNo"));

            String[] joinMmbrNoArr = (String.valueOf(commandMap.get("joinMmbrNoArr"))).split(",");
            String[] sttngCd1Arr = (String.valueOf(commandMap.get("sttngCd1Arr"))).split(",");
            String[] sttngCd2Arr = (String.valueOf(commandMap.get("sttngCd2Arr"))).split(",");
            String[] sttngCd3Arr = (String.valueOf(commandMap.get("sttngCd3Arr"))).split(",");
            for (int i = 0, size = joinMmbrNoArr.length; i < size; i++) {
                Map<String, Object> tempMap = new HashMap<>();
                tempMap.put("playNo", playNo);
                tempMap.put("mmbrNo", joinMmbrNoArr[i]);
                if (StringUtils.isNotEmpty(String.valueOf(commandMap.get("sttngCd1Arr")))) {
                    tempMap.put("sttng1Cd", sttngCd1Arr[i]);
                }
                if (StringUtils.isNotEmpty(String.valueOf(commandMap.get("sttngCd2Arr")))) {
                    tempMap.put("sttng2Cd", sttngCd2Arr[i]);
                }
                if (StringUtils.isNotEmpty(String.valueOf(commandMap.get("sttngCd3Arr")))) {
                    tempMap.put("sttng3Cd", sttngCd3Arr[i]);
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
    }*/

}
