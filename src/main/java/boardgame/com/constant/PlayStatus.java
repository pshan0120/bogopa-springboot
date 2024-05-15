package boardgame.com.constant;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum PlayStatus {

    STAND_BY("C002", "4","대기", 1, ""),
    PLAYING("C002", "2","진행중", 2, ""),
    FINISHED("C002", "3","종료", 3, ""),
    ABNORMAL("C002", "4","비정상", 4, ""),
    ;

    private final String groupCode;
    private final String code;
    private final String title;
    private final long order;
    private final String remark;

}
