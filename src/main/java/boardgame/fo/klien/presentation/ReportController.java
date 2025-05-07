package boardgame.fo.klien.presentation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class ReportController {

    /* 이용안내 */
    @GetMapping("/report")
    public String openGuide() {
        return "/klien/report";
    }

}
