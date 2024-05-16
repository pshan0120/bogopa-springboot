package boardgame.fo.member.dto;


import lombok.*;

@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PRIVATE)
@Builder
@Getter
public class CreateTemporaryMemberRequestDto {

    @NonNull
    private String nickname;

}
