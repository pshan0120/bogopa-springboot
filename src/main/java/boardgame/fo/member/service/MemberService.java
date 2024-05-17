package boardgame.fo.member.service;

import boardgame.fo.member.dto.CreateTemporaryMemberRequestDto;

import java.util.Map;

public interface MemberService {

    Map<String, Object> readById(long memberId);

    Map<String, Object> readByNickname(String nickname);

    Long readOrCreateMemberByNickname(String nickname);

    Map<String, Object> readProfileById(long memberId);

    void create(Map<String, Object> map);

    Long createTemporaryMember(CreateTemporaryMemberRequestDto dto);

    /*void createBocMember(CreateTemporaryMemberRequestDto dto);

    void createFruitShopMember(CreateTemporaryMemberRequestDto dto);

    void createCatchAThiefMember(CreateTemporaryMemberRequestDto dto);*/



    /* 회원 */
    Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map);

    Map<String, Object> selectMember(Map<String, Object> map);

    Map<String, Object> selectMemberProfile(Map<String, Object> map);

    void insertMmbrLog(Map<String, Object> map);



    void updateMmbr(Map<String, Object> map);

    Map<String, Object> selectEmailExistYn(Map<String, Object> map);

    Map<String, Object> selectNickNmExistYn(Map<String, Object> map);


}
