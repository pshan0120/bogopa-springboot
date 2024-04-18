package boardgame.com.service;

import lombok.Getter;

import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import java.util.List;

@Getter
public class CustomPageResponse<T> extends PageImpl<T> {

    private final long total;

    public CustomPageResponse(List content, Pageable pageable, long total) {
        super(content, pageable, total);
        this.total = total;
    }

    public CustomPageResponse(List content, long total) {
        super(content);
        this.total = total;
    }

    @Override
    public long getTotalElements() {
        return this.total;
    }

}
