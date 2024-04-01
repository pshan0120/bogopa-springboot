package boardgame.com.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("comDAO")
public class ComDAO extends AbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCdList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>)selectList("com.selectCdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectCdNm(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("com.selectCdNm", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectGetId(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("com.selectGetId", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> encVal(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("com.encVal", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> decVal(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("com.decVal", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectEmailTmplt(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("com.selectEmailTmplt", map);
	}
	
	public void insertEmailHis(Map<String, Object> map) {
		insert("com.insertEmailHis", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception{
		return (Map<String, Object>)selectOne("com.selectFileInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectFileList(Map<String, Object> map) throws Exception{
		return (List<Map<String, Object>>)selectList("com.selectFileList", map);
	}
	
	public void insertFile(Map<String, Object> map) throws Exception{
		insert("com.insertFile", map);
	}
	
	public void deleteFile(Map<String, Object> map) throws Exception{
		update("com.deleteFile", map);
	}
	
	public void deleteFileList(Map<String, Object> map) throws Exception{
		update("com.deleteFileList", map);
	}
}