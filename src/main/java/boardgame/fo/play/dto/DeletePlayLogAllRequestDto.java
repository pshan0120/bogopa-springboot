package boardgame.fo.play.dto;


import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class DeletePlayLogAllRequestDto {

    private long playId;

}
