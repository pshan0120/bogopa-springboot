package boardgame.fo.game.dto;

import lombok.*;

import java.util.List;
import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Getter
public class ReadPlayMemberListResponseDto {

    private List<Map<String, Object>> clientPlayMemberList;
    private Map<String, Object> hostPlayMember;

}
