package boardgame.com.service;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;

import java.util.List;

// NOTE: PageImpl 의 캐시 적용이 필요할 때 참고
@Getter
@JsonIgnoreProperties(ignoreUnknown = true, value = {"pageable"})
public class CustomPageImpl<T> extends PageImpl<T> {

    @JsonCreator(mode = JsonCreator.Mode.PROPERTIES)
    public CustomPageImpl(
            @JsonProperty("content") List<T> content,
            @JsonProperty("pageable") Pageable pageable,
            @JsonProperty("totalElements") long total) {
        super(content, pageable, total);
    }

}
