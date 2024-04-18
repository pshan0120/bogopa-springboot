package boardgame.fo.board.dto;

import boardgame.com.service.CustomPageRequest;
import lombok.Getter;
import lombok.Setter;


@Setter
@Getter
public class ReadPageRequestDto extends CustomPageRequest {

    private String brdTypeCd;

    private String searchText;


    public ReadPageRequestDto() {
        super(1, 15, true, "");
    }

    public ReadPageRequestDto(int page, int size, Boolean descending, String sortBy,
                              String brdTypeCd, String searchText) {
        super(page, size, descending, sortBy);
        this.brdTypeCd = brdTypeCd;
        this.searchText = searchText;
    }

}

