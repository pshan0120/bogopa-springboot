package boardgame.com.exception;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Builder
@Getter
@ToString
public class ApiExceptionEntity {
    private String code;
    private String message;
    private String content;
}
