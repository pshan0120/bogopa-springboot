package boardgame.fo.member.dto;


import lombok.*;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class CreateTemporaryMemberRequestDto {

    @NonNull
    private String nickname;

}
