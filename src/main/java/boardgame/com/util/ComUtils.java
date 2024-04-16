package boardgame.com.util;

import boardgame.com.dao.ComDao;
import lombok.RequiredArgsConstructor;
import org.apache.commons.codec.binary.Base32;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.lang.reflect.Array;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.*;

@Component
@RequiredArgsConstructor
public class ComUtils {

	private final ComDao comDAO;
	
	public static String getRandomString(){
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	/**
	 * Object type 변수가 비어있는지 체크(mybatis 용)
	 * 
	 * @param obj
	 * @return Boolean : true / false
	 */
	public static Boolean empty(Object obj) {
		if (obj instanceof String)
			return obj == null || "".equals(obj.toString().trim());
		else if (obj instanceof List)
			return obj == null || ((List) obj).isEmpty();
		else if (obj instanceof Map)
			return obj == null || ((Map) obj).isEmpty();
		else if (obj instanceof Object[])
			return obj == null || Array.getLength(obj) == 0;
		else
			return obj == null;
	}

	/**
	 * Object type 변수가 비어있지 않은지 체크(mybatis 용)
	 * 
	 * @param obj
	 * @return Boolean : true / false
	 */
	public static Boolean notEmpty(Object obj) {
		return !empty(obj);
	}
	
	/**
	 * huni@retriever.io
	 * 구글 OTP QR Code url
	 */
	public static String getQRBarcodeURL(String user, String host, String secret) {
		String format = "https://chart.googleapis.com/chart?cht=qr&chs=300x300&chl=otpauth://totp/retriever:%s@%s%%3Fsecret%%3D%s&chld=H|0&issuer=retriever";
		return String.format(format, user, host, secret);
	}
	
	public static String getEncodedKey() {
		
			byte[] buffer = new byte[5 + 5 * 5];
				 
			// Filling the buffer with random numbers.
			// Notice: you want to reuse the same random generator
			// while generating larger random number sequences.
			new Random().nextBytes(buffer);
		
			// Getting the key and converting it to Base32
			Base32 codec = new Base32();

			byte[] secretKey = Arrays.copyOf(buffer, 10);
			byte[] bEncodedKey = codec.encode(secretKey);
				 
			// 생성된 Key!
			String encodedKey = new String(bEncodedKey);
			
			return encodedKey;
	}
	
	public static boolean check_code(String secret, long code, long t) throws NoSuchAlgorithmException, InvalidKeyException {
		Base32 codec = new Base32();
		byte[] decodedKey = codec.decode(secret);

		// Window is used to check codes generated in the near past.
		// You can use this value to tune how far you're willing to go.
		int window = 3;
		for (int i = -window; i <= window; ++i) {
			long hash = verify_code(decodedKey, t + i);

			if (hash == code) {
				return true;
			}
		}

		// The validation code is invalid.
		return false;
	}
	
	private static int verify_code(byte[] key, long t)
			throws NoSuchAlgorithmException, InvalidKeyException {
		byte[] data = new byte[8];
		long value = t;
		for (int i = 8; i-- > 0; value >>>= 8) {
			data[i] = (byte) value;
		}

		SecretKeySpec signKey = new SecretKeySpec(key, "HmacSHA1");
		Mac mac = Mac.getInstance("HmacSHA1");
		mac.init(signKey);
		byte[] hash = mac.doFinal(data);

		int offset = hash[20 - 1] & 0xF;

		// We're using a long because Java hasn't got unsigned int.
		long truncatedHash = 0;
		for (int i = 0; i < 4; ++i) {
			truncatedHash <<= 8;
			// We are dealing with signed bytes:
			// we just keep the first byte.
			truncatedHash |= (hash[offset + i] & 0xFF);
		}

		truncatedHash &= 0x7FFFFFFF;
		truncatedHash %= 1000000;

		return (int) truncatedHash;
	}
	
	public static String getNewPswd() {
		// 1. 임의의 문자열 생성
		StringBuffer sb = new StringBuffer();
		StringBuffer sc = new StringBuffer("#!$"); // 특수문자 모음, {}[] 같은

		// 대문자 3개를 임의 발생
		sb.append((char) ((Math.random() * 26) + 65)); // 첫글자는 대문자, 첫글자부터 특수문자
		for (int i = 0; i < 3; i++) {
			sb.append((char) ((Math.random() * 26) + 65)); // 아스키번호 65(A) 부터
		}
		// 소문자 4개를 임의발생
		for (int i = 0; i < 4; i++) {
			sb.append((char) ((Math.random() * 26) + 97)); // 아스키번호 97(a) 부터
		}
		// 숫자 2개를 임의 발생
		for (int i = 0; i < 2; i++) {
			sb.append((char) ((Math.random() * 10) + 48)); // 아스키번호 48(1) 부터
		}
		// 특수문자를 두개 발생시켜 랜덤하게 중간에 끼워 넣는다
		sb.setCharAt(((int) (Math.random() * 3) + 1), sc.charAt((int) (Math.random() * sc.length() - 1))); // 대문자3개중
		sb.setCharAt(((int) (Math.random() * 4) + 4), sc.charAt((int) (Math.random() * sc.length() - 1))); // 소문자4개중
		
		return sb.toString();
	}
	
	public List<Map<String, Object>> getCdList(String groupCd) {
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("grpCd", groupCd);
		return comDAO.selectCdList(map);
	}
	
	public String getCdNm(String groupCd, String cd) {
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("grpCd", groupCd);
		map.put("cd", cd);
		return comDAO.selectCdNm(map).get("nm").toString();
	}
	
}
