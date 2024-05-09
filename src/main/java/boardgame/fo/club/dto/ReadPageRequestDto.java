package boardgame.fo.club.dto;

import boardgame.com.service.CustomPageRequest;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ReadPageRequestDto extends CustomPageRequest {

    private long clubId;

    public ReadPageRequestDto() {
        super(1, 15, true, "");
    }

    public ReadPageRequestDto(int page, int size, Boolean descending, String sortBy,
                              long clubId) {
        super(page, size, descending, sortBy);
        this.clubId = clubId;
    }

}

