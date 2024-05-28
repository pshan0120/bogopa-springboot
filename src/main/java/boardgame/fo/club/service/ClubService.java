package boardgame.fo.club.service;

import boardgame.com.service.CustomPageResponse;
import boardgame.fo.club.dto.ReadPageRequestDto;

import java.util.List;
import java.util.Map;

public interface ClubService {

    Map<String, Object> readInfoById(long clubId, Long memberId);

    CustomPageResponse<Map<String, Object>> readClubMemberPageById(ReadPageRequestDto requestDto);

    CustomPageResponse<Map<String, Object>> readClubGamePageById(ReadPageRequestDto requestDto);

    CustomPageResponse<Map<String, Object>> readClubActivityPageById(ReadPageRequestDto requestDto);

    CustomPageResponse<Map<String, Object>> readPlayImagePageById(ReadPageRequestDto requestDto);


    Map<String, Object> selectClubMmbrList(Map<String, Object> map);



    /* 모임 */
    Map<String, Object> selectClubList(Map<String, Object> map);

    void insertClub(Map<String, Object> map);

    void updateClub(Map<String, Object> map);

    void deleteClub(Map<String, Object> map);

    void insertClubMmbr(Map<String, Object> map);

    void updateClubMmbr(Map<String, Object> map);

    void deleteClubMmbr(Map<String, Object> map);

    void insertClubJoin(Map<String, Object> map);

    void updateClubJoin(Map<String, Object> map);

    void deleteClubJoin(Map<String, Object> map);





    Map<String, Object> selectClubGameList(Map<String, Object> map);

    List<Map<String, Object>> selectClubMapList(Map<String, Object> map);

    Map<String, Object> selectClubBrdList(Map<String, Object> map);

    Map<String, Object> selectClubBrd(Map<String, Object> map);

    void insertClubBrd(Map<String, Object> map);

    void updateClubBrd(Map<String, Object> map);

    void deleteClubBrd(Map<String, Object> map);

    Map<String, Object> selectMyClub(Map<String, Object> map);

    Map<String, Object> selectMyClubPlayRecordList(Map<String, Object> map);

    List<Map<String, Object>> selectMyClubJoinList(Map<String, Object> map);

    List<Map<String, Object>> selectMyClubAttndNotCnfrmList(Map<String, Object> map);

    Map<String, Object> selectMyClubFeePayList(Map<String, Object> map);

    Map<String, Object> selectMyClubFeeList(Map<String, Object> map);

    Map<String, Object> selectMyClubBrdList(Map<String, Object> map);

    Map<String, Object> selectMyClubPlayImgList(Map<String, Object> map);

    Map<String, Object> selectClubGameHasList(Map<String, Object> map);

    void insertClubGame(Map<String, Object> map);

    void deleteClubGame(Map<String, Object> map);

    Map<String, Object> selectClubAttndList(Map<String, Object> map);

    void insertClubAttndAll(Map<String, Object> map);

    void updateClubAttnd(Map<String, Object> map);

    void deleteClubAttnd(Map<String, Object> map);

    Map<String, Object> selectClubFee(Map<String, Object> map);

    Map<String, Object> selectClubFeePay(Map<String, Object> map);

    void insertClubFee(Map<String, Object> map);

    void updateClubFee(Map<String, Object> map);

    void deleteClubFee(Map<String, Object> map);

}
