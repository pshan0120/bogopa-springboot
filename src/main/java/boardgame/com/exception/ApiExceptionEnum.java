package boardgame.com.exception;

import lombok.Getter;
import lombok.ToString;
import org.springframework.http.HttpStatus;

@Getter
@ToString
public enum ApiExceptionEnum {

    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "INTERNAL_SERVER_ERROR", "내부 서버 오류가 발생했습니다."),

    HTTP_CALL_EXCEPTION(HttpStatus.BAD_REQUEST, "HTTP_CALL_EXCEPTION", "HTTP 호출 오류가 발생했습니다."),
    RESPONSE_BODY_PARSING_ERROR(HttpStatus.BAD_REQUEST, "RESPONSE_BODY_PARSING_ERROR", "응답 결과 파싱에서 오류가 발생했습니다."),
    NOT_ACCESSIBLE(HttpStatus.NOT_ACCEPTABLE, "NOT_ACCESSIBLE", "서버에 접근할 수 없습니다."),

    CODE_NOT_EXISTS(HttpStatus.NOT_FOUND, "CODE_NOT_EXISTS", "존재하지 않는 코드입니다"),
    ENUM_NOT_EXISTS(HttpStatus.NOT_FOUND, "ENUM_NOT_EXISTS", "존재하지 않는 ENUM입니다"),

    NOT_EXISTS_ID_OR_PASSWORD(HttpStatus.NOT_ACCEPTABLE, "NOT_EXISTS_ID_OR_PASSWORD", "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다."),
    PASSWORD_ERROR_COUNT_OVER_5(HttpStatus.NOT_ACCEPTABLE, "PASSWORD_ERROR_COUNT_OVER_5", "비밀번호 5회 이상 입력 오류 상태입니다."),
    NICKNAME_EXISTS(HttpStatus.BAD_REQUEST, "NICKNAME_EXISTS", "이미 존재하는 닉네임입니다."),

    PLAY_BEGUN(HttpStatus.BAD_REQUEST, "PLAY_BEGUN", "이미 플레이가 시작된 상태입니다."),
    NOT_HOST_OF_PLAY(HttpStatus.BAD_REQUEST, "NOT_HOST_OF_PLAY", "해당 플레이의 호스트가 아닙니다."),
    NOT_CLIENT_OF_PLAY(HttpStatus.BAD_REQUEST, "NOT_CLIENT_OF_PLAY", "해당 플레이의 클라이언트가 아닙니다."),

    ;

    private final HttpStatus status;
    private final String code;
    private String message;

    ApiExceptionEnum(HttpStatus status, String code) {
        this.status = status;
        this.code = code;
    }

    ApiExceptionEnum(HttpStatus status, String code, String message) {
        this.status = status;
        this.code = code;
        this.message = message;
    }
}
