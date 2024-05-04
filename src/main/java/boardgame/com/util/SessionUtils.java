package boardgame.com.util;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.Optional;

public class SessionUtils {

    // private static Long ADMIN_MEMBER_ID = 25L;
    private static Long[] ADMIN_MEMBER_IDS = new Long[]{4L, 25L, 41L, 71L};

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

    public static Long getCurrentMemberId() {
        try {
            return Optional.of((Long) getSessionAttribute("mmbrNo"))
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
            return Arrays.stream(ADMIN_MEMBER_IDS)
                    .anyMatch(id -> id.equals(getCurrentMemberId()));
            // return ADMIN_MEMBER_ID.equals(getCurrentMemberId());
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
