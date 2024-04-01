package boardgame.com.util;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component("jsonUtils")
public class JsonUtils {

	/**
	 * Map을 json으로 변환한다.
	 *
	 * @param map Map<String, Object>.
	 * @return JSONObject.
	 */
	public static JSONObject getJsonFromMap(Map<String, Object> map) {
		JSONObject jsonObject = new JSONObject();
		for( Map.Entry<String, Object> entry : map.entrySet() ) {
			String key = entry.getKey();
			Object value = entry.getValue();
			jsonObject.put(key, value);
		}
		return jsonObject;
	}
	
	/**
	 * List<Map>을 jsonArray로 변환한다.
	 *
	 * @param list List<Map<String, Object>>.
	 * @return JSONArray.
	 */
	public static JSONArray getJsonArrayFromList(List<Map<String, Object>> list) {
		JSONArray jsonArray = new JSONArray();
		for( Map<String, Object> map : list ) {
			jsonArray.add( getJsonFromMap( map ) );
		}
		return jsonArray;
	}
	
	/**
	 * Map을 json으로 변환한다.(모든 value String 변환)
	 *
	 * @param map Map<String, Object>.
	 * @return JSONObject.
	 */
	public static JSONObject getJsonStringFromMap(Map<String, Object> map) {
		JSONObject jsonObject = new JSONObject();
		for( Map.Entry<String, Object> entry : map.entrySet() ) {
			String key = entry.getKey();
			String value = String.valueOf(entry.getValue());
			jsonObject.put(key, value);
		}
		return jsonObject;
	}
	
	/**
	 * List<Map>을 jsonArray로 변환한다.(모든 value String 변환)
	 *
	 * @param list List<Map<String, Object>>.
	 * @return JSONArray.
	 */
	public static JSONArray getJsonStringArrayFromList(List<Map<String, Object>> list) {
		JSONArray jsonArray = new JSONArray();
		for( Map<String, Object> map : list ) {
			jsonArray.add( getJsonStringFromMap( map ) );
		}
		return jsonArray;
	}
	
	/**
	 * List<Map>을 jsonString으로 변환한다.
	 *
	 * @param list List<Map<String, Object>>.
	 * @return String.
	 */
	public static String getJsonStringFromList(List<Map<String, Object>> list) {
		JSONArray jsonArray = getJsonArrayFromList( list );
		return jsonArray.toJSONString();
	}

	/**
	 * JsonObject를 Map<String, String>으로 변환한다.
	 *
	 * @param jsonObj JSONObject.
	 * @return Map<String, Object>.
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getMapFromJsonObject(JSONObject jsonObj) {
		Map<String, Object> map = null;
		try {
			map = new ObjectMapper().readValue(jsonObj.toJSONString(), Map.class) ;
		} catch (JsonParseException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * JsonArray를 List<Map<String, String>>으로 변환한다.
	 *
	 * @param jsonArray JSONArray.
	 * @return List<Map<String, Object>>.
	 */
	public static List<Map<String, Object>> getListMapFromJsonArray(JSONArray jsonArray) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		if(jsonArray != null) {
			int jsonSize = jsonArray.size();
			for( int i = 0; i < jsonSize; i++ ) {
				Map<String, Object> map = JsonUtils.getMapFromJsonObject((JSONObject) jsonArray.get(i));
				list.add(map);
			}
		}
		return list;
	}
	
	/**
	 * Json의 모든 객체를 UTF-8로 인코딩한다.
	 *
	 * @param JSONObject.
	 * @return JSONObject.
	 * @throws UnsupportedEncodingException 
	 */
	public static JSONObject encodeJsonObj(JSONObject jsonObj) throws UnsupportedEncodingException {
		JSONObject jsonObject = new JSONObject();
		Iterator i = jsonObj.keySet().iterator();
		while(i.hasNext()) {
			String key = (String) i.next();
			String value = (String) jsonObj.get(key);
			jsonObject.put(key, URLEncoder.encode(value, "UTF-8"));
		}
		return jsonObject;
	}
	
	/**
	 * Json의 모든 객체를 UTF-8로 디코딩한다.
	 *
	 * @param JSONObject.
	 * @return JSONObject.
	 * @throws UnsupportedEncodingException 
	 */
	public static JSONObject decodeJsonObj(JSONObject jsonObj) throws UnsupportedEncodingException {
		JSONObject jsonObject = new JSONObject();
		Iterator i = jsonObj.keySet().iterator();
		while(i.hasNext()) {
			String key = (String) i.next();
			String value = (String) jsonObj.get(key);
			jsonObject.put(key, URLDecoder.decode(value, "UTF-8"));
		}
		return jsonObject;
	}
}