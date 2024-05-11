package boardgame.fo.club.service;

import boardgame.com.service.CustomPageResponse;
import boardgame.fo.club.dao.ClubDao;
import boardgame.fo.club.dto.ReadPageRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class ClubServiceImpl implements ClubService {

    private final ClubDao clubDao;

    @Override
    public Map<String, Object> readInfoById(long clubId, Long memberId) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("clubId", clubId);
        requestMap.put("memberId", memberId);
        return clubDao.selectClubInfo(requestMap);
    }

    @Override
    public CustomPageResponse<Map<String, Object>> readClubMemberPageById(ReadPageRequestDto requestDto) {
        return clubDao.selectClubMemberPage(requestDto);
    }

    @Override
    public Map<String, Object> selectClubMmbrList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectClubMmbrList(map));
        resultMap.put("cnt", clubDao.selectClubMmbrListCnt(map).get("cnt"));
        return resultMap;
    }


    /* 모임 */
    @Override
    public Map<String, Object> selectClubList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectClubList(map));
        resultMap.put("cnt", clubDao.selectClubListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public void insertClub(Map<String, Object> map) {
        clubDao.insertClub(map);
    }

    @Override
    public void updateClub(Map<String, Object> map) {
        clubDao.updateClub(map);
    }

    @Override
    public void deleteClub(Map<String, Object> map) {
        clubDao.deleteClub(map);
    }

    @Override
    public void insertClubMmbr(Map<String, Object> map) {
        clubDao.insertClubMmbr(map);
    }

    @Override
    public void updateClubMmbr(Map<String, Object> map) {
        clubDao.updateClubMmbr(map);
    }

    @Override
    public void deleteClubMmbr(Map<String, Object> map) {
        clubDao.deleteClubMmbr(map);
    }


    @Override
    public void insertClubJoin(Map<String, Object> map) {
        clubDao.insertClubJoin(map);
    }

    @Override
    public void updateClubJoin(Map<String, Object> map) {
        clubDao.updateClubJoin(map);
    }

    @Override
    public void deleteClubJoin(Map<String, Object> map) {
        clubDao.deleteClubJoin(map);
    }






    @Override
    public Map<String, Object> selectClubGameList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectClubGameList(map));
        resultMap.put("cnt", clubDao.selectClubGameListCnt(map).get("cnt"));
        return resultMap;
    }

    public List<Map<String, Object>> selectClubMapList(Map<String, Object> map) {
        return clubDao.selectClubMapList(map);
    }

    @Override
    public Map<String, Object> selectClubBrdList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectClubBrdList(map));
        resultMap.put("cnt", clubDao.selectClubBrdListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectClubBrd(Map<String, Object> map) {
        return clubDao.selectClubBrd(map);
    }

    @Override
    public void insertClubBrd(Map<String, Object> map) {
        clubDao.insertClubBrd(map);
    }

    @Override
    public void updateClubBrd(Map<String, Object> map) {
        clubDao.updateClubBrd(map);
    }

    @Override
    public void deleteClubBrd(Map<String, Object> map) {
        clubDao.deleteClubBrd(map);
    }


    @Override
    public Map<String, Object> selectMyClub(Map<String, Object> map) {
        return clubDao.selectMyClub(map);
    }

    @Override
    public Map<String, Object> selectMyClubPlayRcrdList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectMyClubPlayRcrdList(map));
        resultMap.put("cnt", clubDao.selectMyClubPlayRcrdListCnt(map).get("cnt"));
        return resultMap;
    }

    public List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map) {
        return clubDao.selectMyClubJoinList(map);
    }

    public List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map) {
        return clubDao.selectMyClubAttndNotCnfrmList(map);
    }

    @Override
    public Map<String, Object> selectMyClubFeePayList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectMyClubFeePayList(map));
        resultMap.put("cnt", clubDao.selectMyClubFeePayListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectMyClubFeeList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectMyClubFeeList(map));
        resultMap.put("cnt", clubDao.selectMyClubFeeListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectMyClubBrdList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectMyClubBrdList(map));
        resultMap.put("cnt", clubDao.selectMyClubBrdListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectMyClubPlayImgList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectMyClubPlayImgList(map));
        resultMap.put("cnt", clubDao.selectMyClubPlayImgListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public Map<String, Object> selectClubGameHasList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectClubGameHasList(map));
        resultMap.put("cnt", clubDao.selectClubGameHasListCnt(map).get("cnt"));
        return resultMap;
    }


    @Override
    public void insertClubGame(Map<String, Object> map) {
        clubDao.insertClubGame(map);
    }

    @Override
    public void deleteClubGame(Map<String, Object> map) {
        clubDao.deleteClubGame(map);
    }


    @Override
    public Map<String, Object> selectClubAttndList(Map<String, Object> map) {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("list", clubDao.selectClubAttndList(map));
        resultMap.put("cnt", clubDao.selectClubAttndListCnt(map).get("cnt"));
        return resultMap;
    }

    @Override
    public void insertClubAttndAll(Map<String, Object> map) {
        clubDao.insertClubAttndAll(map);
    }

    @Override
    public void updateClubAttnd(Map<String, Object> map) {
        clubDao.updateClubAttnd(map);
    }

    @Override
    public void deleteClubAttnd(Map<String, Object> map) {
        clubDao.deleteClubAttnd(map);
    }

    @Override
    public Map<String, Object> selectClubFee(Map<String, Object> map) {
        return clubDao.selectClubFee(map);
    }

    @Override
    public Map<String, Object> selectClubFeePay(Map<String, Object> map) {
        return clubDao.selectClubFeePay(map);
    }

    @Override
    public void insertClubFee(Map<String, Object> map) {
        clubDao.insertClubFee(map);
    }

    @Override
    public void updateClubFee(Map<String, Object> map) {
        clubDao.updateClubFee(map);
    }

    @Override
    public void deleteClubFee(Map<String, Object> map) {
        clubDao.deleteClubFee(map);
    }

}
