package boardgame.com.util;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

public class SessionUtils {

    private static String ADMIN_MEMBER_ID = "1000000004";

    public static String getCurrentUserId() {
        try {
            String loginUserId = String.valueOf(getSessionAttribute("userId"));
            System.out.println("loginUserId : " + loginUserId);
            if (loginUserId == null || loginUserId.isEmpty()) {
                throw new RuntimeException();
            }
            return loginUserId;
        } catch (Exception e) {
            throw new RuntimeException();
        }
    }

    public static String getCurrentMemberId() {
        try {
            return Optional.of(getSessionAttribute("mmbrNo"))
                    .map(String::valueOf)
                    .orElseThrow(() -> new RuntimeException());

            /*String loginMemberId = String.valueOf(getSessionAttribute("mmbrNo"));
            if (loginMemberId == null || loginMemberId.isEmpty()) {
                throw new RuntimeException();
            }
            return loginMemberId;*/
        } catch (Exception e) {
            throw new RuntimeException();
        }
    }

    public static Boolean isUserLogin() {
        try {
            getCurrentUserId();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static Boolean isMemberLogin() {
        try {
            getCurrentMemberId();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static Boolean isAdminMemberLogin() {
        try {
            return ADMIN_MEMBER_ID.equals(getCurrentMemberId());
        } catch (Exception e) {
            return false;
        }
    }

    public static Object getSessionAttribute(String key) {
        try {
            return getHttpServletRequest().getSession()
                    .getAttribute(key);
        } catch (Exception e) {
            throw new RuntimeException();
        }
    }

    public static void setSessionAttribute(String key, Object value) {
        try {
            getHttpServletRequest().getSession()
                    .setAttribute(key, value);
        } catch (Exception e) {
            throw new RuntimeException();
        }
    }

    public static void removeSessionAttribute(String key) {
        try {
            getHttpServletRequest().getSession().removeAttribute(key);
        } catch (Exception e) {
            throw new RuntimeException();
        }
    }

    public static String getUserIp() {
        HttpServletRequest request = getHttpServletRequest();
        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    public static String getUserIpFromRequest(HttpServletRequest request) {
        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

    public static HttpServletRequest getHttpServletRequest() {
        return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
    }

}
