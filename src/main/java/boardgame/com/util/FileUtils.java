package boardgame.com.util;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Map;

@Component("fileUtils")
public class FileUtils {

    SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);
    private final String fileRootPath = File.separator + "file";
    private final String imgFileRootPath = fileRootPath + File.separator + "image" + File.separator;
    private final String mmbrImgFileRootPath = imgFileRootPath + File.separator + "mmbr" + File.separator;
    private final String clubImgFileRootPath = imgFileRootPath + File.separator + "club" + File.separator;
    private final String playImgFileRootPath = imgFileRootPath + File.separator + "play" + File.separator;

    public Map<String, Object> uploadFile(Map<String, Object> map, HttpServletRequest request) throws Exception {
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
        MultipartFile multipartFile = null;
        Boolean result = false;
        String resultMsg = "";

        String fileExt = "";
        String fileNm = "";
        String strdFileNm = "";
        String fileId = String.valueOf(map.get("fileId"));
        String fileTypeCd = String.valueOf(map.get("fileTypeCd"));    // 1 : 멤버프로필이미지 / 2 : 모임이미지 / 3 : 플레이 이미지
        String filePath = "";
        if (StringUtils.equals("1", fileTypeCd)) {
            filePath = mmbrImgFileRootPath + File.separator + fileId + File.separator;
        } else if (StringUtils.equals("2", fileTypeCd)) {
            filePath = clubImgFileRootPath + File.separator + fileId + File.separator;
        } else if (StringUtils.equals("3", fileTypeCd)) {
            filePath = playImgFileRootPath + File.separator + fileId + File.separator;
        }

        File file = new File(filePath);
        if (!file.exists()) {
            file.setReadable(true);
            file.setExecutable(true);
            file.mkdirs();
        } else {
            if (file.isDirectory()) { //파일이 디렉토리인지 확인
                File[] files = file.listFiles();
                for (int i = 0; i < files.length; i++) {
                    if (files[i].delete()) {
                        //System.out.println(files[i].getName()+" 삭제성공");
                    } else {
                        //System.out.println(files[i].getName()+" 삭제실패");
                    }
                }
            } else {
                //System.out.println("파일삭제 실패");
            }
        }

        if (iterator.hasNext()) {
            multipartFile = multipartHttpServletRequest.getFile(iterator.next());
            if (!multipartFile.isEmpty()) {
                fileNm = multipartFile.getOriginalFilename();
                fileExt = fileNm.substring(fileNm.lastIndexOf(".") + 1).toLowerCase();
                strdFileNm = ComUtils.getRandomString() + "." + fileExt;
                long fileSize = multipartFile.getSize();

                if (StringUtils.equals("1", fileTypeCd) || StringUtils.equals("2", fileTypeCd) || StringUtils.equals("3", fileTypeCd)) {
                    String[] allowFile = {"jpg", "jpeg", "png", "bmp", "gif"};
                    if (Arrays.asList(allowFile).indexOf(fileExt) > -1) {
                        result = true;
                    } else {
                        resultMsg = "이미지 파일은 jpg, jpeg, png, bmp, gif 종류만 등록 가능합니다.";
                    }
                }

                if (result) {
                    map.put("fileSize", fileSize);
                    map.put("fileNm", fileNm);
                    map.put("strdFileNm", strdFileNm);

                    file = new File(filePath + strdFileNm);
                    file.setReadable(true);
                    file.setExecutable(true);
                    multipartFile.transferTo(file);
                }
            }
        } else {
            map.put("strdFileNm", "");
            result = true;
        }

        map.put("result", result);
        map.put("resultMsg", resultMsg);
        return map;
    }

    public Map<String, Object> uploadFileDirect(Map<String, Object> map, HttpServletRequest request) throws Exception {
        MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
        MultipartFile multipartFile = null;
        Boolean result = false;
        String resultMsg = "";

        String fileExt = "";
        String fileNm = "";
        String fileId = String.valueOf(map.get("fileId"));
        String fileTypeCd = String.valueOf(map.get("fileTypeCd"));    // 1 : 멤버프로필이미지 / 2 : 모임이미지 / 3 : 플레이 이미지
        String filePath = "";
        if (StringUtils.equals("1", fileTypeCd)) {
            filePath = mmbrImgFileRootPath + File.separator + fileId + File.separator;
        } else if (StringUtils.equals("2", fileTypeCd)) {
            filePath = clubImgFileRootPath + File.separator + fileId + File.separator;
        } else if (StringUtils.equals("3", fileTypeCd)) {
            filePath = playImgFileRootPath + File.separator + fileId + File.separator;
        }

        File file = new File(filePath);
        if (file.exists() == false) {
            file.mkdirs();
        } else {
            if (file.isDirectory()) { //파일이 디렉토리인지 확인
                File[] files = file.listFiles();
                for (int i = 0; i < files.length; i++) {
                    if (files[i].delete()) {
                        //System.out.println(files[i].getName()+" 삭제성공");
                    } else {
                        //System.out.println(files[i].getName()+" 삭제실패");
                    }
                }
            } else {
                //System.out.println("파일삭제 실패");
            }
        }

        multipartFile = multipartHttpServletRequest.getFile(iterator.next());
        if (!multipartFile.isEmpty()) {
            fileNm = multipartFile.getOriginalFilename();
            fileExt = fileNm.substring(fileNm.lastIndexOf(".") + 1).toLowerCase();
            long fileSize = multipartFile.getSize();

            if (StringUtils.equals("1", fileTypeCd) || StringUtils.equals("2", fileTypeCd) || StringUtils.equals("3", fileTypeCd)) {
                String[] allowFile = {"jpg", "jpeg", "png", "bmp", "gif"};
                if (Arrays.asList(allowFile).indexOf(fileExt) > -1) {
                    result = true;
                } else {
                    resultMsg = "이미지 파일은 jpg, jpeg, png, bmp, gif 종류만 등록 가능합니다.";
                }
            }

            if (result) {
                map.put("fileSize", fileSize);
                map.put("fileNm", fileNm);
                map.put("strdFileNm", fileNm);

                file = new File(filePath + fileNm);
                multipartFile.transferTo(file);
            }
        }

        map.put("result", result);
        map.put("resultMsg", resultMsg);
        return map;
    }
}
