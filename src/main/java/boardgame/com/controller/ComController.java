package boardgame.com.controller;

import boardgame.com.mapping.CommandMap;
import boardgame.com.service.ComService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ComController {

    private final ComService comService;
    private final String fileRootPath = File.separator + "file";
    private final String imgFileRootPath = fileRootPath + File.separator + "image" + File.separator;

    @RequestMapping(value = "/com/downloadFile")
    public void downloadFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
        Object seqObj = commandMap.getMap().get("seq");
        String seq = "";
        if (seqObj instanceof String) {
            seq = seqObj.toString();
        } else if (seqObj instanceof String[]) {
            String[] seqArr = (String[]) seqObj;
            seq = seqArr[seqArr.length - 1];
        }

        Map<String, Object> seqMap = new HashMap<>();
        seqMap.put("seq", seq);

        Map<String, Object> map = comService.selectFileInfo(seqMap);

        String fileId = String.valueOf(map.get("fileId"));
        String strdFileNm = String.valueOf(map.get("strdFileNm"));
        String fileTypeCd = String.valueOf(map.get("fileTypeCd"));    // 1 : 이미지
        String filePath = "";
        if (StringUtils.equals("1", fileTypeCd)) {
            filePath = imgFileRootPath + fileId + File.separator;
        }

        if (StringUtils.isNotEmpty(filePath)) {
            byte fileByte[] = FileUtils.readFileToByteArray(new File(filePath + File.separator + strdFileNm));
            response.setContentType("application/octet-stream");
            response.setContentLength(fileByte.length);
            response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(strdFileNm, "UTF-8") + "\";");
            response.setHeader("Content-Transfer-Encoding", "binary");
            response.getOutputStream().write(fileByte);
            response.getOutputStream().flush();
            response.getOutputStream().close();
        }
    }

}
