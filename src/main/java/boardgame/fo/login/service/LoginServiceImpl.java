package boardgame.fo.login.service;

import boardgame.com.exception.ApiException;
import boardgame.com.exception.ApiExceptionEnum;
import boardgame.com.session.SessionListener;
import boardgame.fo.login.dto.LoginRequestDto;
import boardgame.fo.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Service("loginService")
@Slf4j
@Transactional
@RequiredArgsConstructor
public class LoginServiceImpl implements LoginService {

    private final MemberService memberService;

    @Override
    public void login(LoginRequestDto requestDto, HttpServletRequest request) {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("email", requestDto.getEmail());
        requestMap.put("pswrd", requestDto.getPassword());
        Map<String, Object> checkMap = memberService.selectMmbrPswrdYn(requestMap);
        if (MapUtils.isEmpty(checkMap)) {
            throw new ApiException(ApiExceptionEnum.NOT_EXISTS_ID_OR_PASSWORD);
        }

        Integer pswrdErrCnt = (Integer) checkMap.get("pswrdErrCnt");
        if (pswrdErrCnt > 4) {
            checkMap.put("useYn", "N");
            memberService.updateMmbr(checkMap);
            throw new ApiException(ApiExceptionEnum.PASSWORD_ERROR_COUNT_OVER_5);
        }

        String pswrdYn = (String) checkMap.get("pswrdYn");
        if (StringUtils.equals("N", pswrdYn)) {
            // 비밀번호 오류 건수 증가
            checkMap.put("mode", "pswrdErr");
            memberService.updateMmbr(checkMap);
            throw new ApiException(ApiExceptionEnum.NOT_EXISTS_ID_OR_PASSWORD);
        }

        // 비밀번호 오류 건수 초기화
        checkMap.put("mode", "pswrdErrReset");
        memberService.updateMmbr(checkMap);

        this.setLogin((Long) checkMap.get("mmbrNo"), request);
    }

    // 로그인 정보 session 세팅
    @Override
    public void setLogin(Long memberId, HttpServletRequest request) {
        SessionListener sessionListener = new SessionListener();
        // IP 정보 입력
        String ip = request.getHeader("X-FORWARDED-FOR");
        if (ip == null) {
            ip = request.getRemoteAddr();
        }

        // 로그인 세션정보 Listener에 전달
        HttpSession session = request.getSession();
        sessionListener.setLoginSession(session);

        Map<String, Object> mmbrMap = memberService.readById(memberId);

        Long mmbrNo = (Long) mmbrMap.get("mmbrNo");
        String nickNm = (String) mmbrMap.get("nickNm");
        String email = (String) mmbrMap.get("email");
        String mmbrTypeCd = (String) mmbrMap.get("mmbrTypeCd");
        Integer clubNo = (Integer) mmbrMap.get("clubNo");

        // 세션 사용자 정보 세팅
        session.setAttribute("mmbrNo", mmbrNo);
        session.setAttribute("nickNm", nickNm);
        session.setAttribute("email", email);
        session.setAttribute("mmbrTypeCd", mmbrTypeCd);
        session.setAttribute("clubNo", clubNo);
        session.setAttribute("mmbrIp", ip);
        session.setAttribute("loginTime", Long.valueOf((System.currentTimeMillis())));

        mmbrMap.put("mmbrIp", ip);
        // 로그인 이력 등록
        memberService.insertMmbrLog(mmbrMap);
    }

}
