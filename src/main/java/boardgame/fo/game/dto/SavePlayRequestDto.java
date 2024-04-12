package boardgame.fo.game.dto;


import lombok.*;

import static boardgame.com.util.SessionUtils.getCurrentUserId;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SavePlayRequestDto {

    @NonNull
    private long playNo;

    @NonNull
    private String log;

}
