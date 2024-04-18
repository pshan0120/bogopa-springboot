package boardgame.fo.game.dto;


import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SavePlayRequestDto {

    private long playNo;

    @NonNull
    private String log;

}
