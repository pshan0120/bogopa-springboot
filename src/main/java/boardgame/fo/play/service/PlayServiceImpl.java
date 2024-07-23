package boardgame.fo.play.service;

import boardgame.com.constant.PlayStatus;
import boardgame.com.exception.ApiException;
import boardgame.com.exception.ApiExceptionEnum;
import boardgame.com.util.SessionUtils;
import boardgame.fo.login.service.LoginService;
import boardgame.fo.member.service.MemberService;
import boardgame.fo.play.dao.PlayDao;
import boardgame.fo.play.dto.BeginPlayRequestDto;
import boardgame.fo.play.dto.CreatePlayRequestDto;
import boardgame.fo.play.dto.JoinPlayRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlayServiceImpl implements PlayService {

    private final MemberService memberService;

    private final LoginService loginService;

    private final PlayDao playDao;

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> readById(long playId) {
        return playDao.selectPlayById(playId);
    }

    @Override
    public long createPlay(CreatePlayRequestDto requestDto) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("gameNo", requestDto.getGameId());
        requestMap.put("playNm", requestDto.getPlayName());
        requestMap.put("clubNo", SessionUtils.getCurrentMemberClubId());
        requestMap.put("hostMmbrNo", SessionUtils.getCurrentMemberId());
        requestMap.put("sttsCd", PlayStatus.STAND_BY.getCode());
        playDao.insertPlay(requestMap);

        return (long) requestMap.get("playNo");
    }

    @Override
    public void joinPlay(JoinPlayRequestDto requestDto) {
        Long memberId = memberService.readOrCreateMemberByNickname(requestDto.getNickname());
        loginService.setLogin(memberId, SessionUtils.getHttpServletRequest());

        List<Map<String, Object>> clientPlayMemberList = playDao.selectClientPlayMemberList(requestDto.getPlayId());
        boolean joined = clientPlayMemberList.stream()
                .anyMatch(member -> memberId.equals(member.get("memberId")));
        if (joined) {
            return;
        }

        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("playNo", requestDto.getPlayId());
        requestMap.put("mmbrNo", memberId);
        playDao.insertPlayMember(requestMap);

        // TODO: settingCd1 관련 작업
        // playMemberService.insertPlayMmbr(tempMap);

        /*ModelAndView mv = new ModelAndView("jsonView");
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
                playMemberService.insertPlayMmbr(tempMap);
            }

            mv.addObject("playNo", playNo);
            resultMsg = "플레이가 시작되었습니다.";
            result = true;
        } else {
            resultMsg = "로그인 세션이 종료되었습니다.";
        }

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;*/

        // playDao.insertPlay(requestDto);
    }

    @Override
    public void reJoinPlay(JoinPlayRequestDto requestDto) {
        Long memberId = memberService.readOrCreateMemberByNickname(requestDto.getNickname());
        List<Map<String, Object>> clientPlayMemberList = playDao.selectClientPlayMemberList(requestDto.getPlayId());
        boolean joined = clientPlayMemberList.stream()
                .anyMatch(member -> memberId.equals(member.get("memberId")));
        if (!joined) {
            throw new ApiException(ApiExceptionEnum.NOT_CLIENT_OF_PLAY);
        }

        loginService.setLogin(memberId, SessionUtils.getHttpServletRequest());
    }

    @Override
    public void beginPlay(BeginPlayRequestDto requestDto) {
        Map<String, Object> playMap = this.readById(requestDto.getPlayId());

        PlayStatus playStatus = PlayStatus.ofCode(String.valueOf(playMap.get("statusCode")));
        if (!playStatus.equals(PlayStatus.STAND_BY)) {
            throw new ApiException(ApiExceptionEnum.PLAY_BEGUN);
        }

        Long hostMemberId = (Long) playMap.get("hostMemberId");
        if (!hostMemberId.equals(SessionUtils.getCurrentMemberId())) {
            throw new ApiException(ApiExceptionEnum.NOT_HOST_OF_PLAY);
        }

        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("playNo", requestDto.getPlayId());
        requestMap.put("sttsCd", PlayStatus.PLAYING.getCode());
        playDao.updatePlay(requestMap);
    }

    @Override
    public void cancelPlay(JoinPlayRequestDto requestDto) {
        Map<String, Object> playMap = this.readById(requestDto.getPlayId());

        PlayStatus playStatus = PlayStatus.ofCode(String.valueOf(playMap.get("statusCode")));
        if (!playStatus.equals(PlayStatus.STAND_BY)) {
            throw new ApiException(ApiExceptionEnum.PLAY_BEGUN);
        }

        Long hostMemberId = (Long) playMap.get("hostMemberId");
        if (!hostMemberId.equals(SessionUtils.getCurrentMemberId())) {
            throw new ApiException(ApiExceptionEnum.NOT_HOST_OF_PLAY);
        }

        playDao.deletePlay(requestDto.getPlayId());
        playDao.deletePlayMember(requestDto.getPlayId());
    }

    @Override
    public void insertPlay(Map<String, Object> map) {
        playDao.insertPlay(map);
    }

    @Override
    public void updatePlay(Map<String, Object> map) {
        playDao.updatePlay(map);
    }

}
