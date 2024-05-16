package boardgame.com.constant;

import boardgame.com.exception.ApiException;
import boardgame.com.exception.ApiExceptionEnum;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

@Getter
@AllArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum PlayStatus {

    STAND_BY("C002", "4","대기", 1, ""),
    PLAYING("C002", "1","진행중", 2, ""),
    FINISHED("C002", "2","종료", 3, ""),
    ABNORMAL("C002", "3","비정상", 4, ""),
    ;

    private final String groupCode;
    private final String code;
    private final String title;
    private final long order;
    private final String remark;

    public static PlayStatus ofCode(String code) {
        return Arrays.stream(PlayStatus.values())
                .filter(value -> value.getCode().equals(code))
                .findAny()
                .orElseThrow(() -> {
                    throw new ApiException(ApiExceptionEnum.CODE_NOT_EXISTS);
                });
    }
    
}
