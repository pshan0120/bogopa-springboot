package boardgame.fo.guide.presentation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class GuideController {

    /* 이용안내 */
    @GetMapping("/guide")
    public String openGuide() {
        return "/fo/guide";
    }

}
