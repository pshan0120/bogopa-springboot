package boardgame.com.dao;

import boardgame.com.aop.PrintQueryId;
import boardgame.com.service.CustomPageRequest;
import boardgame.com.service.CustomPageResponse;
import lombok.extern.slf4j.Slf4j;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static boardgame.com.service.KeywordValidator.isBannedKeywordFound;
import static boardgame.com.service.KeywordValidator.isBlackKeywordFound;

@Slf4j
public class AbstractDao {
    @Autowired
    private SqlSessionTemplate sqlSession;

    private static <V extends Map<String, Object>> int calculatePageIndex(V params) {
        if (!params.containsKey("pageIndex")) {
            return 0;
        }

        String pageIndex = String.valueOf(params.get("pageIndex"));
        if (StringUtils.isEmpty(pageIndex)) {
            return 0;
        }

        return Integer.parseInt(pageIndex) - 1;
    }

    private static <V extends Map<String, Object>> int calculatePageRow(V params) {
        if (!params.containsKey("pageRow")) {
            return 20;
        }

        String pageRow = String.valueOf(params.get("pageRow"));
        if (StringUtils.isEmpty(pageRow)) {
            return 20;
        }

        return Integer.parseInt(pageRow);
    }

    private static void printQueryId(String queryId) {
        if (log.isDebugEnabled()) {
            log.debug("\t QueryId  \t:  " + queryId);
        }
    }

    private static Map<String, Object> filterParams(Map<String, Object> paramMap) {
        HashMap<String, Object> resultMap = new HashMap<>();
        paramMap.entrySet()
                .forEach(entry -> {
                    /*if (!(entry instanceof List)) {
                        resultMap.put(entry.getKey(), entry.getValue());
                        return;
                    }*/

                    if (isBlackKeywordFound(String.valueOf(entry.getValue()))) {
                        if (log.isDebugEnabled()) {
                            log.debug("\t blacklist word founded !!  \t:  " + entry.getValue());
                        }
                        resultMap.put(entry.getKey(), "");
                        return;
                    }

                    if (isBannedKeywordFound(String.valueOf(entry.getValue()))) {
                        if (log.isDebugEnabled()) {
                            log.debug("\t bannedKeywordsList word founded !!  \t:  " + entry.getValue());
                        }
                        resultMap.put(entry.getKey(), "");
                        return;
                    }

                    resultMap.put(entry.getKey(), entry.getValue());
                });

        return resultMap;
    }

    @PrintQueryId
    public <V> int insert(String queryId, V params) {
        printQueryId(queryId);
        return sqlSession.insert(queryId, params);
    }

    @PrintQueryId
    public <V> int update(String queryId, V params) {
        printQueryId(queryId);
        return sqlSession.update(queryId, params);
    }

    @PrintQueryId
    public <V> int delete(String queryId, V params) {
        printQueryId(queryId);
        return sqlSession.delete(queryId, params);
    }

    @PrintQueryId
    public <T> T selectOne(String queryId) {
        printQueryId(queryId);
        return sqlSession.selectOne(queryId);
    }

    @PrintQueryId
    public <T, V> T selectOne(String queryId, V params) {
        printQueryId(queryId);
        if (params instanceof Map) {
            return sqlSession.selectOne(queryId, filterParams((Map<String, Object>) params));
        }
        return sqlSession.selectOne(queryId, params);
    }

    @PrintQueryId
    public <T> List<T> selectList(String queryId) {
        printQueryId(queryId);
        return sqlSession.selectList(queryId);
    }

    @PrintQueryId
    public <T, V> List<T> selectList(String queryId, V params) {
        printQueryId(queryId);
        if (params instanceof Map) {
            return sqlSession.selectList(queryId, filterParams((Map<String, Object>) params));
        }
        return sqlSession.selectList(queryId, params);
    }

    @PrintQueryId
    public <T, V extends Map<String, Object>> List<T> selectPagingListAjax(String queryId, V params) {
        printQueryId(queryId);

        int nPageIndex = calculatePageIndex(params);
        int nPageRow = calculatePageRow(params);

        params.put("start", (nPageIndex * nPageRow));
        params.put("end", nPageRow);

        return sqlSession.selectList(queryId, params);
    }

    @PrintQueryId
    public <T, V extends CustomPageRequest> CustomPageResponse<T> selectPage(String listQueryId, String countQueryId, V pageRequest) {
        pageRequest.initialize();

        printQueryId(listQueryId);
        List<T> list = sqlSession.selectList(listQueryId, pageRequest);

        printQueryId(countQueryId);
        Long count = sqlSession.selectOne(countQueryId, pageRequest);

        return new CustomPageResponse<T>(list, pageRequest, count);
    }

}
