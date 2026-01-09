package boardgame.fo.main.presentation;

import boardgame.com.mapping.CommandMap;
import boardgame.com.util.ComUtils;
import boardgame.fo.board.service.BoardService;
import boardgame.fo.play.service.PlayRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequiredArgsConstructor
public class MainController {

    public String mvPrefix = "/fo";

    private final PlayRecordService playRecordService;

    private final BoardService boardService;

    private final ComUtils comUtils;

    /* 메인 */
    @RequestMapping(value = "/main")
    public ModelAndView openMain(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView(mvPrefix + "/main");

        // 메인 페이지 디자인 리뉴얼에 따른 SSR 데이터 로딩
        mv.addObject("playRecordList", playRecordService.selectMainPlayRecordList(commandMap.getMap()));
        mv.addObject("clubBrdList", boardService.selectMainClubBrdList(commandMap.getMap()));

        // 게시물유형
        mv.addObject("clubBrdTypeCdList", comUtils.getCdList("C007"));
        return mv;
    }

    /* 디자인 프리뷰 */
    @RequestMapping(value = "/preview")
    public ModelAndView openPreview(CommandMap commandMap) {
        ModelAndView mv = new ModelAndView(mvPrefix + "/preview");
        // 실제 데이터 로드 (Main 페이지와 동일한 로직)
        mv.addObject("playRecordList", playRecordService.selectMainPlayRecordList(commandMap.getMap()));
        mv.addObject("clubBrdList", boardService.selectMainClubBrdList(commandMap.getMap()));
        return mv;
    }

    @RequestMapping(value = "/selectMain")
    public ModelAndView selectMain(CommandMap commandMap, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView("jsonView");
        Boolean result = false;
        String resultMsg = "";

        mv.addObject("playRecordList", playRecordService.selectMainPlayRecordList(commandMap.getMap()));
        mv.addObject("clubBrdList", boardService.selectMainClubBrdList(commandMap.getMap()));
        result = true;

        mv.addObject("result", result);
        mv.addObject("resultMsg", resultMsg);
        return mv;
    }

}
