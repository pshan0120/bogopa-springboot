package boardgame.fo.login.presentation;

import boardgame.fo.login.dto.LoginRequestDto;
import boardgame.fo.login.service.LoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@Slf4j
@ResponseStatus(HttpStatus.OK)
@RestController
@RequiredArgsConstructor
public class LoginRestController {

    private final LoginService loginService;

    @PostMapping("/fo/api/login")
    public void login(@RequestBody LoginRequestDto requestDto, HttpServletRequest request) {
        loginService.login(requestDto, request);
    }

}
