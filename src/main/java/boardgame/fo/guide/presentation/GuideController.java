package boardgame.fo.guide.presentation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequiredArgsConstructor
public class GuideController {

    /* 이용안내 */
    @RequestMapping(value = "/guide")
    public ModelAndView openGuide() {
        ModelAndView mv = new ModelAndView("/fo/guide");
        return mv;
    }

}
