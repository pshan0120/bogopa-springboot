package boardgame.fo.play.dto;


import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class SavePlayRequestDto {

    private long playId;

    @NonNull
    private String log;

}
