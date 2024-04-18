package boardgame.fo.game.dto;


import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DeletePlayLogAllRequestDto {

    private long playNo;

}
