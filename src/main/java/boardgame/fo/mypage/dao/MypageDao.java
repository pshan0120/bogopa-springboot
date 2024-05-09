package boardgame.fo.mypage.dao;

import boardgame.com.dao.AbstractDao;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MypageDao extends AbstractDao {

    /* 마이페이지 */
    public Map<String, Object> selectMyPage(Map<String, Object> map) {
			/*SELECT
				m.mmbrNo,
				encVal(m.mmbrNo) AS mmbrScrtKey,
				IFNULL(decVal(m.email), '') AS email,
				IFNULL(m.nickNm, '') AS nickNm,
				m.mmbrTypeCd,
				cd.nm AS mmbrTypeNm,
				IFNULL(m.intrdctn, '') AS intrdctn,
				IFNULL(m.prflImgFileNm, '') AS prflImgFileNm,
				IFNULL(cm2.clubNm, '무소속') AS mmbrClubNm,
				(SELECT
					COUNT(*)
				FROM
					playMmbr pm1
				WHERE
					pm1.mmbrNo = m.mmbrNo
				) AS playCnt,
				IF(cm2.mstrMmbrNo = m.mmbrNo,
					'Y',
					'N'
				) AS mstrMmbrYn,
				IFNULL(cm2.clubNo, '') AS clubNo,
				IFNULL((SELECT
					IF((CURDATE() BETWEEN cf3.feeFromDate AND cf3.feeToDate),
						'Y',
						'N'
					)
				FROM
					clubFee cf3,
					mmbr m3,
					club c3
				WHERE
					cf3.mmbrNo = m3.mmbrNo
				AND
					cf3.clubNo = c3.clubNo
				AND
					cf3.clubNo = cm2.clubNo
				AND
					cf3.mmbrNo = m.mmbrNo
				AND
					cf3.payYn = 'Y'
				AND
					cf3.cnfrmYn = 'Y'
				AND
					cf3.feeTypeCd = '2'
				), 'N') AS myClubFee2Yn,
				IFNULL(cm2.feeType2Amt, '') AS feeType2Amt
			FROM
				mmbr m
				LEFT JOIN (
					SELECT
						cm1.mmbrNo,
						c1.clubNo,
						c1.clubNm,
						c1.mstrMmbrNo,
						c1.feeType2Amt
					FROM
						club c1,
						clubMmbr cm1
					WHERE
						c1.clubNo = cm1.clubNo
					AND
						cm1.activated IS TRUE
				) cm2 ON m.mmbrNo = cm2.mmbrNo,
				cd cd
			WHERE
				m.mmbrTypeCd = cd.cd
			AND
				cd.grpCd = 'C001'
			AND
				m.useYn = 'Y'
			AND
				m.mmbrNo = #{mmbrNo}*/
        return selectOne("mypage.selectMyPage", map);
    }

    public List<Map<String, Object>> selectMyPlayRcrdList(Map<String, Object> map) {
        return selectPagingListAjax("mypage.selectMyPlayRcrdList", map);
    }

    public Map<String, Object> selectMyPlayRcrdListCnt(Map<String, Object> map) {
        return selectOne("mypage.selectMyPlayRcrdListCnt", map);
    }

    public List<Map<String, Object>> selectMyClubMmbrList(Map<String, Object> map) {
        return selectPagingListAjax("mypage.selectMyClubMmbrList", map);
    }

    public Map<String, Object> selectMyClubMmbrListCnt(Map<String, Object> map) {
        return selectOne("mypage.selectMyClubMmbrListCnt", map);
    }

}
