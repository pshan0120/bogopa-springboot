package boardgame.fo.mypage.service;

import java.util.Map;

public interface MypageService {

    /* 마이페이지 */
    Map<String, Object> selectMyPage(Map<String, Object> map);

    Map<String, Object> selectMyPlayRcrdList(Map<String, Object> map);

    Map<String, Object> selectMyClubMmbrList(Map<String, Object> map);


}
