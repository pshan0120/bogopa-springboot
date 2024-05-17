package boardgame.fo.member.service;

import boardgame.com.constant.Game;
import boardgame.com.exception.ApiException;
import boardgame.com.exception.ApiExceptionEnum;
import boardgame.com.util.SessionUtils;
import boardgame.fo.club.service.ClubService;
import boardgame.fo.member.dao.MemberDao;
import boardgame.fo.member.dto.CreateTemporaryMemberRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class MemberServiceImpl implements MemberService {

    private final ClubService clubService;

    private final MemberDao memberDao;

    private static final String DEFAULT_PASSWORD = "Qwer1234!@#";

    @Override
    public Map<String, Object> readById(long memberId) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("memberId", memberId);
        return this.selectMember(requestMap);
    }

    @Override
    public Map<String, Object> readByNickname(String nickname) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("nickname", nickname);
        return this.selectMember(requestMap);
    }

    @Override
    public Long readOrCreateMemberByNickname(String nickname) {
        Map<String, Object> memberMap = this.readByNickname(nickname);
        if (Optional.ofNullable(memberMap).isEmpty()) {
            return this.createTemporaryMember(
                    CreateTemporaryMemberRequestDto.builder()
                            .nickname(nickname)
                            .build()
            );
        }

        return (Long) memberMap.get("mmbrNo");
    }

    @Override
    public Map<String, Object> readProfileById(long memberId) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("memberId", memberId);
        return this.selectMemberProfile(requestMap);
    }

    @Override
    public void create(Map<String, Object> map) {
        Map<String, Object> member = this.readByNickname(String.valueOf(map.get("nickNm")));
        if (Optional.ofNullable(member).isPresent()) {
            throw new ApiException(ApiExceptionEnum.NICKNAME_EXISTS);
        }

        memberDao.insertMember(map);
    }

    @Override
    public Long createTemporaryMember(CreateTemporaryMemberRequestDto dto) {
        // 회원 생성
        Map<String, Object> memberRequestMap = new HashMap<>();
        memberRequestMap.put("email", LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) + "@bogopa.com");
        memberRequestMap.put("nickNm", dto.getNickname());
        memberRequestMap.put("pswrd", DEFAULT_PASSWORD);
        memberRequestMap.put("temporarilyJoined", true);
        this.create(memberRequestMap);

        return (Long) memberRequestMap.get("mmbrNo");
    }

    /*@Override
    public void createBocMember(CreateTemporaryMemberRequestDto dto) {
        createTemporaryMember(dto, Game.BOC_TROUBLE_BREWING);
    }

    @Override
    public void createFruitShopMember(CreateTemporaryMemberRequestDto dto) {
        createTemporaryMember(dto, Game.FRUIT_SHOP);
    }

    @Override
    public void createCatchAThiefMember(CreateTemporaryMemberRequestDto dto) {
        createTemporaryMember(dto, Game.CATCH_A_THIEF);
    }*/

    private void createTemporaryMember(CreateTemporaryMemberRequestDto dto, Game game) {
        // 회원 생성
        Map<String, Object> memberRequestMap = new HashMap<>();
        memberRequestMap.put("email", LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) + "@bogopa.com");
        memberRequestMap.put("nickNm", dto.getNickname());
        memberRequestMap.put("pswrd", DEFAULT_PASSWORD);
        if (SessionUtils.isAdminMemberLoggedIn()) {
            memberRequestMap.put("invtMmbrNo", SessionUtils.getCurrentMemberId());
        }
        memberRequestMap.put("temporarilyJoined", true);

        this.create(memberRequestMap);
        Long memberId = (Long) memberRequestMap.get("mmbrNo");

        Map<String, Object> clubJoinRequestMap = new HashMap<>();
        clubJoinRequestMap.put("clubNo", game.getClubId());
        clubJoinRequestMap.put("mmbrNo", memberId);
        clubJoinRequestMap.put("joinAnswr", game.getGameName() + "회원 자동 가입");
        clubService.insertClubJoin(clubJoinRequestMap);

        clubJoinRequestMap.put("mode", "cnfrm");
        clubService.updateClubJoin(clubJoinRequestMap);

        Map<String, Object> clubMemberRequestMap = new HashMap<>();
        clubMemberRequestMap.put("clubNo", game.getClubId());
        clubMemberRequestMap.put("mmbrNo", memberId);
        clubMemberRequestMap.put("clubMmbrGrdCd", "1");
        clubService.insertClubMmbr(clubMemberRequestMap);
    }


    /* 회원 */
    @Override
    public Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) {
        return memberDao.selectMmbrPswrdYn(map);
    }

    @Override
    public Map<String, Object> selectMember(Map<String, Object> map) {
        return memberDao.selectMember(map);
    }

    @Override
    public Map<String, Object> selectMemberProfile(Map<String, Object> map) {
        return memberDao.selectMemberProfile(map);
    }

    @Override
    public void insertMmbrLog(Map<String, Object> map) {
        memberDao.insertMmbrLog(map);
    }


    @Override
    public void updateMmbr(Map<String, Object> map) {
        memberDao.updateMmbr(map);
    }

    @Override
    public Map<String, Object> selectEmailExistYn(Map<String, Object> map) {
        return memberDao.selectEmailExistYn(map);
    }

    @Override
    public Map<String, Object> selectNickNmExistYn(Map<String, Object> map) {
        return memberDao.selectNickNmExistYn(map);
    }


}
