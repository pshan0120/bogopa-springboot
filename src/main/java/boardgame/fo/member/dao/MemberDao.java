package boardgame.fo.member.dao;

import boardgame.com.dao.AbstractDao;
import org.springframework.stereotype.Repository;

import java.util.Map;

@Repository
public class MemberDao extends AbstractDao {

    public void insertMember(Map<String, Object> map) {
        insert("member.insertMember", map);
    }

    public Map<String, Object> selectMember(Map<String, Object> map) {
        return selectOne("member.selectMember", map);
    }

    public Map<String, Object> selectMemberProfile(Map<String, Object> map) {
        return selectOne("member.selectMemberProfile", map);
    }



    /* 회원 */
    public Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) {
        return selectOne("member.selectMmbrPswrdYn", map);
    }





    public void insertMmbrLog(Map<String, Object> map) {
        insert("member.insertMmbrLog", map);
    }



    public void updateMmbr(Map<String, Object> map) {
        update("member.updateMmbr", map);
    }

    public Map<String, Object> selectEmailExistYn(Map<String, Object> map) {
        return selectOne("member.selectEmailExistYn", map);
    }

    public Map<String, Object> selectNickNmExistYn(Map<String, Object> map) {
        return selectOne("member.selectNickNmExistYn", map);
    }

}
