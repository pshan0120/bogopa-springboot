package boardgame.fo.board.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.fo.board.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;

    @RequestMapping(value = "/selectBrdList")
    public ModelAndView selectBrdList(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", boardService.selectBrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

    @RequestMapping(value = "/selectBrd")
    public ModelAndView selectBrd(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("map", boardService.selectBrd(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

}
