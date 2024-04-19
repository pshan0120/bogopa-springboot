package boardgame.fo.login.service;

import boardgame.fo.login.dto.LoginRequestDto;

import javax.servlet.http.HttpServletRequest;

public interface LoginService {

    void login(LoginRequestDto requestDto, HttpServletRequest request);

    // 로그인 정보 session 세팅
    void setLogin(Long memberId, HttpServletRequest request);

}
