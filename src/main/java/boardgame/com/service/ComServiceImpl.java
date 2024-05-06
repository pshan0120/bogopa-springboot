package boardgame.com.service;

import boardgame.com.dao.ComDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
@RequiredArgsConstructor
public class ComServiceImpl implements ComService {

    private final ComDao comDAO;

    @Override
    public String decrypted(String encrypted) {
        Map<String, Object> map = new HashMap<>();
        map.put("encrypted", encrypted);
        return comDAO.selectDecrypted(map);
    }
   
    @Override
    public List<Map<String, Object>> selectCdList(Map<String, Object> map) {
        return comDAO.selectCdList(map);
    }

    @Override
    public Map<String, Object> selectCdNm(Map<String, Object> map) {
        return comDAO.selectCdNm(map);
    }

    @Override
    public Map<String, Object> selectGetId(Map<String, Object> map) {
        return comDAO.selectGetId(map);
    }

    public String encVal(String val) {
        Map<String, Object> map = new HashMap<>();
        map.put("val", val);
        Map<String, Object> resultMap = comDAO.encVal(map);
        String returnVal = (String) resultMap.get("RETURN_VAL");
        return returnVal;
    }

    public String decVal(String val) {
        Map<String, Object> map = new HashMap<>();
        map.put("val", val);
        Map<String, Object> resultMap = comDAO.decVal(map);
        String returnVal = (String) resultMap.get("RETURN_VAL");
        return returnVal;
    }

    @Override
    public String selectNewPswrd() {
        Map<String, Object> resultMap = new HashMap<>();

        // 1. 임의의 문자열 생성
        StringBuffer sb = new StringBuffer();
        StringBuffer sc = new StringBuffer("#!$"); // 특수문자 모음, {}[] 같은

        // 대문자 3개를 임의 발생
		/*sb.append((char) ((Math.random() * 26) + 65)); // 첫글자는 대문자, 첫글자부터 특수문자
		for (int i = 0; i < 3; i++) {
			sb.append((char) ((Math.random() * 26) + 65)); // 아스키번호 65(A) 부터
		}*/
        // 소문자 6개를 임의발생
        for (int i = 0; i < 6; i++) {
            sb.append((char) ((Math.random() * 26) + 97)); // 아스키번호 97(a) 부터
        }
        // 숫자 2개를 임의 발생
        for (int i = 0; i < 2; i++) {
            sb.append((char) ((Math.random() * 10) + 48)); // 아스키번호 48(1) 부터
        }
        // 특수문자를 두개 발생시켜 랜덤하게 중간에 끼워 넣는다
        //sb.setCharAt(((int) (Math.random() * 3) + 1), sc.charAt((int) (Math.random() * sc.length() - 1))); // 대문자3개중
        //sb.setCharAt(((int) (Math.random() * 4) + 4), sc.charAt((int) (Math.random() * sc.length() - 1))); // 소문자4개중
        sb.setCharAt(((int) (Math.random() * 5) + 1), sc.charAt((int) (Math.random() * sc.length() - 1))); // 소문자6개중

        return sb.toString();
    }

    @Override
    public Map<String, Object> selectEmailTmplt(Map<String, Object> map) {
        return comDAO.selectEmailTmplt(map);
    }

    @Override
    public void insertEmailHis(Map<String, Object> map) {
        comDAO.insertEmailHis(map);
    }

    @Override
    public Map<String, Object> selectFileInfo(Map<String, Object> map) {
        return comDAO.selectFileInfo(map);
    }

    @Override
    public void insertFile(Map<String, Object> map) {
        comDAO.insertFile(map);
    }

    @Override
    public List<Map<String, Object>> selectFileList(Map<String, Object> map) {
        return comDAO.selectFileList(map);
    }

}
