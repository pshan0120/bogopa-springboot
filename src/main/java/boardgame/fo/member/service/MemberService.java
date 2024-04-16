package boardgame.fo.member.service;

import java.util.Map;

public interface MemberService {

    /* 회원 */
    Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map);

    Map<String, Object> selectMmbr(Map<String, Object> map);

    Map<String, Object> selectMmbrPrfl(Map<String, Object> map);

    void insertMmbrLog(Map<String, Object> map);

    void insertMmbr(Map<String, Object> map);

    void updateMmbr(Map<String, Object> map);

    Map<String, Object> selectEmailExistYn(Map<String, Object> map);

    Map<String, Object> selectNickNmExistYn(Map<String, Object> map);

}
