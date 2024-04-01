package boardgame.com.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface ComService {
	/* 코드 */
	List<Map<String,Object>> selectCdList(Map<String, Object> map) throws Exception;
	Map<String, Object> selectCdNm(Map<String, Object> map) throws Exception;
	Map<String, Object> selectGetId(Map<String, Object> map) throws Exception;
	
	/* 암복호화 관련 */
	String encVal(String val) throws Exception;
	String decVal(String val) throws Exception;
	
	/* 비밀번호 관련 */
	String selectNewPswrd() throws Exception;
	
	/* 이메일 관련 */
	Map<String, Object> selectEmailTmplt(Map<String, Object> map) throws Exception;
	void insertEmailHis(Map<String, Object> map) throws Exception;
	
	// 파일 관련
	Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception;
	void insertFile(Map<String, Object> map) throws Exception;
	List<Map<String,Object>> selectFileList(Map<String, Object> map) throws Exception;
}
