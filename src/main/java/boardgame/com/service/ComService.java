package boardgame.com.service;

import java.util.List;
import java.util.Map;

public interface ComService {
    /* 코드 */
    List<Map<String, Object>> selectCdList(Map<String, Object> map);

    Map<String, Object> selectCdNm(Map<String, Object> map);

    Map<String, Object> selectGetId(Map<String, Object> map);

    /* 암복호화 관련 */
    String encVal(String val);

    String decVal(String val);

    /* 비밀번호 관련 */
    String selectNewPswrd();

    /* 이메일 관련 */
    Map<String, Object> selectEmailTmplt(Map<String, Object> map);

    void insertEmailHis(Map<String, Object> map);

    // 파일 관련
    Map<String, Object> selectFileInfo(Map<String, Object> map);

    void insertFile(Map<String, Object> map);

    List<Map<String, Object>> selectFileList(Map<String, Object> map);
}
