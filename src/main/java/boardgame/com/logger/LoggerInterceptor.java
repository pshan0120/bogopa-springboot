package boardgame.com.logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import boardgame.com.logger.LoggerInterceptor;

public class LoggerInterceptor extends HandlerInterceptorAdapter {
	protected Log log = LogFactory.getLog(LoggerInterceptor.class);
	public static String devicePrefix = "";
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug("======================================          START         ======================================");
			log.debug(" Request URI \t:  " + request.getRequestURI());
		}
		// 접속 기기에 따라 MV prefix 세팅
		String agent = request.getHeader("User-Agent");
		if (agent != null) {
			if(agent.indexOf("iPhone") > -1 && agent.indexOf("Mobile") > -1) {
				devicePrefix = "/m";
			} else if (agent.indexOf("Android") > -1 && agent.indexOf("Mobile") > -1) {
				devicePrefix = "/m";
			} else {
				devicePrefix = "";
			}
			log.debug(" devicePrefix :  " + devicePrefix);
		}
		
		return super.preHandle(request, response, handler);
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		if (log.isDebugEnabled()) {
			log.debug("======================================           END          ======================================\n");
		}
	}
}