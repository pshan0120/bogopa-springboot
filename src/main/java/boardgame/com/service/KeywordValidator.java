package boardgame.com.service;

import java.util.Arrays;

public class KeywordValidator {

    //public static String[] blackList = {"--",";--","/*","*/","select","delete","insert","update"};
    private static final String[] BLACK_KEYWORDS = {"--", ";--", "/*", "*/"};

    private static final String[] BANNED_KEYWORDS = {"object", "script", "javascript", "vbscript", "onmouse", "onkey", "onclick", "onload", "onunload", "iframe", "href.", "document.", "foms", "parent."};

    public static boolean isBlackKeywordFound(String value) {
        return Arrays.stream(BLACK_KEYWORDS).anyMatch(value::contains);
    }

    public static boolean isBannedKeywordFound(String value) {
        return Arrays.stream(BANNED_KEYWORDS).anyMatch(value::contains);
    }

}
