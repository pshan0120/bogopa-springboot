package boardgame.fo.play.service;

import boardgame.com.constant.PlayStatus;
import boardgame.com.util.SessionUtils;
import boardgame.fo.play.dao.PlayDao;
import boardgame.fo.play.dto.CreatePlayRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class PlayServiceImpl implements PlayService {

    private final PlayDao playDao;

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> readById(long playId) {
        return playDao.selectPlayById(playId);
    }

    @Override
    public long createPlay(CreatePlayRequestDto dto) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("gameNo", dto.getGameId());
        requestMap.put("playNm", dto.getPlayName());
        requestMap.put("clubNo", SessionUtils.getCurrentMemberClubId());
        requestMap.put("hostMmbrNo", SessionUtils.getCurrentMemberId());
        requestMap.put("sttsCd", PlayStatus.STAND_BY.getCode());
        playDao.insertPlay(requestMap);

        return (long) requestMap.get("playNo");

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

        // playDao.insertPlay(dto);
    }

    @Override
    public void insertPlay(Map<String, Object> map) {
        playDao.insertPlay(map);
    }

    @Override
    public void updatePlay(Map<String, Object> map) {
        playDao.updatePlay(map);
    }

    @Override
    public void deletePlay(Map<String, Object> map) {
        playDao.deletePlay(map);
    }

}
