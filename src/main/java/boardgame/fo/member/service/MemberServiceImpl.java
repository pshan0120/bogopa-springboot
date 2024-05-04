package boardgame.fo.member.service;

import boardgame.com.constant.Game;
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

@RequiredArgsConstructor
@Service
public class MemberServiceImpl implements MemberService {

    private final ClubService clubService;

    private final MemberDao memberDao;

    private static final String DEFAULT_PASSWORD = "Qwer1234!@#";

    @Override
    public Map<String, Object> readById(long memberId) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("mmbrNo", memberId);
        return this.selectMmbr(requestMap);
    }

    @Override
    public void create(Map<String, Object> map) {
        memberDao.insertMember(map);
    }

    @Override
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
    }

    private void createTemporaryMember(CreateTemporaryMemberRequestDto dto, Game game) {
        // 회원 생성
        Map<String, Object> memberRequestMap = new HashMap<>();
        memberRequestMap.put("email", LocalDateTime.now().toEpochSecond(ZoneOffset.UTC) + "@bogopa.com");
        memberRequestMap.put("nickNm", dto.getNickname());
        memberRequestMap.put("pswrd", DEFAULT_PASSWORD);
        if (SessionUtils.isAdminMemberLogin()) {
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
    public Map<String, Object> selectMmbr(Map<String, Object> map) {
        return memberDao.selectMmbr(map);
    }

    @Override
    public Map<String, Object> selectMmbrPrfl(Map<String, Object> map) {
        return memberDao.selectMmbrPrfl(map);
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
