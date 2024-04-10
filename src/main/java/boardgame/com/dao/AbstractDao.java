package boardgame.com.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

public class AbstractDao {
	protected Log log = LogFactory.getLog(AbstractDao.class);
	 
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	protected void printQueryId(String queryId) {
		if(log.isDebugEnabled()){
			log.debug("\t QueryId  \t:  " + queryId);
		}
	}
	
	//public static String[] blackList = {"--",";--","/*","*/","select","delete","insert","update"};
	public static String[] blackList = {"--",";--","/*","*/"};
	public static String[] bannedKeywordsList = {"object","script","javascript","vbscript","onmouse","onkey","onclick","onload","onunload","iframe","href.","document.","cookie","foms","parent."};
	
	protected Map<String, String> filterParams(Object params) {
		
		@SuppressWarnings("unchecked")
		Map<String, Object> paramMap = (Map<String, Object>) params;
		HashMap<String, String> resultMap = new HashMap<String, String>();
		
		for( String key : paramMap.keySet() ){
			
			String content = String.valueOf(paramMap.get(key));
			//String content = (String) paramMap.get(key);
			
			if(content != null){
				for(int i=0;i<blackList.length;i++){
					if(content.indexOf(blackList[i]) > -1){
						if(log.isDebugEnabled()){ log.debug("\t blacklist word founded !!  \t:  " + content.toLowerCase()); }
						content = "";
					}
				}
				for(int i=0;i<bannedKeywordsList.length;i++){
					if(content.indexOf(bannedKeywordsList[i]) > -1){
						if(log.isDebugEnabled()){ log.debug("\t bannedKeywordsList word founded !!  \t:  " + content.toLowerCase()); }
						content = "";
					}
				}
			}
			resultMap.put(key, content);
		}
		return resultMap;
	}
	 
	public Object insert(String queryId, Object params){
		printQueryId(queryId);
		return sqlSession.insert(queryId, params);
	}
	 
	public Object update(String queryId, Object params){
		printQueryId(queryId);
		return sqlSession.update(queryId, params);
	}
	 
	public Object delete(String queryId, Object params){
		printQueryId(queryId);
		return sqlSession.delete(queryId, params);
	}
	 
	public Object selectOne(String queryId){
		printQueryId(queryId);
		return sqlSession.selectOne(queryId);
	}
	 
	public Object selectOne(String queryId, Object params){
		printQueryId(queryId);
		return sqlSession.selectOne(queryId, filterParams(params));
	}
	 
	@SuppressWarnings("rawtypes")
	public List selectList(String queryId){
		printQueryId(queryId);
		return sqlSession.selectList(queryId);
	}
	 
	@SuppressWarnings("rawtypes")
	public List selectList(String queryId, Object params){
		printQueryId(queryId);
		return sqlSession.selectList(queryId,params);
	}
	
	@SuppressWarnings("unchecked")
	public Object selectPagingListAjax(String queryId, Object params){
		printQueryId(queryId);
		Map<String,Object> map = (Map<String,Object>)params;
		 
		String strPageIndex = (String) map.get("pageIndex");
		String strPageRow = (String) map.get("pageRow");
		int nPageIndex = 0;
		int nPageRow = 20;
		 
		if(StringUtils.isEmpty(strPageIndex) == false){
			nPageIndex = Integer.parseInt(strPageIndex)-1;
		}
		if(StringUtils.isEmpty(strPageRow) == false){
			nPageRow = Integer.parseInt(strPageRow);
		}
		map.put("start", (nPageIndex * nPageRow) + 0);
		map.put("end", nPageRow);
		 
		return sqlSession.selectList(queryId, map);
	}
	
}
