package boardgame.fo.main.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.util.ComUtils;
import boardgame.fo.board.service.BoardService;
import boardgame.fo.play.service.PlayService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequiredArgsConstructor
public class MainController {

    public String mvPrefix = "/fo";

    private final PlayService playService;

    private final BoardService boardService;

    private final ComUtils comUtils;


    /* 메인 */
    @RequestMapping(value = "/main")
    public ModelAndView openMain() {
        ModelAndView mv = new ModelAndView(mvPrefix + "/main");
        // 게시물유형
        mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
        return mv;
    }

    @RequestMapping(value = "/selectMain")
    public ModelAndView selectMain(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("playRcrdList", playService.selectMainPlayRcrdList(commandMap.getMap()));
        mv.addObject("clubBrdList", boardService.selectMainClubBrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }



}
