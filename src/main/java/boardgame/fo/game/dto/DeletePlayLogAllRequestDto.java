package boardgame.fo.game.dto;


import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DeletePlayLogAllRequestDto {

    @NonNull
    private long playNo;

}
