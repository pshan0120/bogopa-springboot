package boardgame.com.constant;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum Game {

    BOC_TROUBLE_BREWING("BOC 트러블 브루잉", 1951, 4),
    FRUIT_SHOP("과일가게", 1952, 5),
    CATCH_A_THIEF("도둑잡기", 1953, 6),
    BECOMING_A_DICTATOR("이리하여 나는 독재자가 되었다", 1954, 7),
    ;

    private final String gameName;
    private final long gameId;
    private final long clubId;

}
