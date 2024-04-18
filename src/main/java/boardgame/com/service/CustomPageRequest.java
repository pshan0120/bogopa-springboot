package boardgame.com.service;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

@Getter
@Setter
public abstract class CustomPageRequest extends PageRequest {

    private final Boolean descending;
    private final String sortBy;
    private int offset;
    private Sort.Direction direction;

    public CustomPageRequest(int page, int size, Boolean descending, String sortBy) {
        super(page, size);
        this.descending = descending;
        this.sortBy = sortBy;
    }

    public void initialize() {
        this.offset = (super.getPageNumber() - 1) * super.getPageSize();

        if (this.descending == null) {
            return;
        }

        if (this.descending) {
            this.direction = Sort.Direction.DESC;
            return;
        }

        this.direction = Sort.Direction.ASC;
    }

}
