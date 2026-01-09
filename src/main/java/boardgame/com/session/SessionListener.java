package boardgame.com.session;

import java.io.InputStream;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 * 동시 접속자 세션관리 HttpListener
 * /WEB-INF/classes/session.properties 설정파일을 참조
 */
public class SessionListener implements HttpSessionListener {
	public static SessionListener sessionManager = null;
	public static Hashtable<String, HttpSession> sessionMonitor;
	public static Hashtable<String, HttpSession> loginSessionMonitor;
	public static int maxSessionValidCount;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	public SessionListener() {
		if (sessionMonitor == null)
			sessionMonitor = new Hashtable<String, HttpSession>();
		if (loginSessionMonitor == null)
			loginSessionMonitor = new Hashtable<String, HttpSession>();
		sessionManager = this;

		Properties prop = new Properties();
		try {
			InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("session.properties");
			if (inputStream != null) {
				prop.load(inputStream);
				inputStream.close();
			} else {
				logger.warn("session.properties not found in classpath");
			}
		} catch (Exception e) {
			logger.error("Error loading session.properties", e);
		}

		String countStr = (String) prop.get("maxSessionValidCount");
		if (countStr != null) {
			maxSessionValidCount = Integer.parseInt(countStr);
		} else {
			maxSessionValidCount = 100000; // Default value
		}
		// System.out.println(" ########################### maxSessionValidCount : " +
		// maxSessionValidCount);
	}

	public static synchronized SessionListener getInstance() {
		if (sessionManager == null)
			sessionManager = new SessionListener();
		return sessionManager;
	}

	/** 현재 활성화 된 session의 수를 반환한다. */
	public int getActiveSessionCount() {
		return sessionMonitor.size();
	}

	/** 현재 등록된 session의 id목록을 반환한다. */
	public Enumeration getIds() {
		return sessionMonitor.keys();
	}

	/** 전체 세션갯수를 측정하여 로그인(대기)상태 메세지 창 호출 */
	public boolean isMaxLoginSessions() {
		boolean retVal = false;
		if (maxSessionValidCount <= getActiveLoginSessionCount()) {
			retVal = true;
		}
		return retVal;
	}

	/** 활성화 로그인 세션수를 조회한다. */
	public int getActiveLoginSessionCount() {
		return loginSessionMonitor.size();
	}

	/** 현재 활성화 된 session의 수를 세팅한다. */
	public void setLoginSession(HttpSession session) {
		synchronized (loginSessionMonitor) {
			loginSessionMonitor.put(session.getId(), session);
			logger.debug(" ############################################################################### ");
			logger.debug(" # 접속자 (로그인 허용인원수) : " + maxSessionValidCount + " 명#");
			logger.debug(" # 접속자 (사이트 접속자수) : " + getActiveSessionCount() + " 명#");
			logger.debug(" # 접속자 (로그인 사용자수) : " + getActiveLoginSessionCount() + " 명#");
			logger.debug(" ############################################################################### ");
		}
	}

	/** 로그인한 Session Put */
	public void setLogoutSession(HttpSession session) {
		synchronized (loginSessionMonitor) {
			loginSessionMonitor.remove(session.getId());
		}
	}

	/**
	 * 현재 등록된 session중 현재 접속된 사용자 정보와 중복 여부 확인 후 중복 접속 이면 이전의 세션을 소멸 시킨다.
	 */
	/**
	 * public boolean checkDuplicationLogin(String sessionId, String userEeno) {
	 * boolean ret = false;
	 * Enumeration eNum = sessionMonitor.elements();
	 * System.out.println("session count : " + getActiveSessionCount());
	 * while (eNum.hasMoreElements()) {
	 * HttpSession sh_session = null;
	 * try {
	 * sh_session = (HttpSession) eNum.nextElement();
	 * } catch (Exception e) {
	 * continue;
	 * }
	 * UserModel baseModel = sh_session.getAttribute("UserInfo");
	 * if (baseModel != null) {
	 * if (userEeno.equals(baseModel.getUserId_())
	 * && !sessionId.equals(sh_session.getId())) {
	 * // 전달 받은 사번과(userEeno) 기존 세션값 중 사번이 중복 되면
	 * // 기존 세션을 소멸 시킨다.
	 * // 사용자 로그아웃 이력(중복접속)을 저장한다.
	 * try {
	 * HashMap param = new HashMap();
	 * param.put("usrId", baseModel.getUserId_());
	 * param.put("ipAddr", baseModel.getRemoteIp_());
	 * param.put("logKind", "LOGOUT");
	 * param.put("logRsn", "DUPLICATE");
	 * // DB 처리
	 * xxxxxxxx.insertLoginLog(param);
	 * 
	 * } catch (Exception e) {
	 * e.printStackTrace();
	 * }
	 * // 해당 세션 무효화
	 * sh_session.invalidate();
	 * ret = true;
	 * break;
	 * }
	 * }
	 * }
	 * return ret;
	 * }
	 */

	/** 세션 생성시 이벤트 처리 **/
	public void sessionCreated(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		synchronized (sessionMonitor) {
			sessionMonitor.put(session.getId(), session);
			logger.debug(" ###############Create#####################Create1################################# ");
			logger.debug(" # 접속자 (로그인 허용인원수) : " + maxSessionValidCount + " 명#");
			logger.debug(" # 접속자 (사이트 접속자수) : " + getActiveSessionCount() + " 명#");
			logger.debug(" # 접속자 (로그인 사용자수) : " + getActiveLoginSessionCount() + " 명#");
			logger.debug(" ###############Create#####################Create################################# ");
		}
	}

	/** 세션 소멸(종료)시 이벤트 처리 **/
	public void sessionDestroyed(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		synchronized (sessionMonitor) {
			sessionMonitor.remove(session.getId());
			loginSessionMonitor.remove(session.getId());
			logger.debug(" ##############Destroy####################Destroy################################# ");
			logger.debug(" # 접속자 (로그인 허용인원수) : " + maxSessionValidCount + " 명#");
			logger.debug(" # 접속자 (사이트 접속자수) : " + getActiveSessionCount() + " 명#");
			logger.debug(" # 접속자 (로그인 사용자수) : " + getActiveLoginSessionCount() + " 명#");
			logger.debug(" ##############Destroy####################Destroy################################# ");
		}
	}
}