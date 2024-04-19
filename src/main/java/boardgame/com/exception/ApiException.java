package boardgame.com.exception;

import lombok.Getter;

import java.io.Serializable;

@Getter
public class ApiException extends RuntimeException implements Serializable {
    private ApiExceptionEnum error;

    public ApiException(ApiExceptionEnum error) {
        super(error.getMessage());
        this.error = error;
    }

    public ApiException(ApiExceptionEnum error, String content) {
        super(content);
        this.error = error;
    }

}
