package boardgame.fo.member.service;

import boardgame.fo.member.dao.MemberDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Map;

@RequiredArgsConstructor
@Service
public class MemberServiceImpl implements MemberService {

    private final MemberDao memberDao;

    /* 회원 */
    @Override
    public Map<String, Object> selectMmbrPswrdYn(Map<String, Object> map) {
        return memberDao.selectMmbrPswrdYn(map);
    }

    @Override
    public Map<String, Object> selectMmbr(Map<String, Object> map) {
        return memberDao.selectMmbr(map);
    }

    @Override
    public Map<String, Object> selectMmbrPrfl(Map<String, Object> map) {
        return memberDao.selectMmbrPrfl(map);
    }

    @Override
    public void insertMmbrLog(Map<String, Object> map) {
        memberDao.insertMmbrLog(map);
    }

    @Override
    public void insertMmbr(Map<String, Object> map) {
        memberDao.insertMmbr(map);
    }

    @Override
    public void updateMmbr(Map<String, Object> map) {
        memberDao.updateMmbr(map);
    }

    @Override
    public Map<String, Object> selectEmailExistYn(Map<String, Object> map) {
        return memberDao.selectEmailExistYn(map);
    }

    @Override
    public Map<String, Object> selectNickNmExistYn(Map<String, Object> map) {
        return memberDao.selectNickNmExistYn(map);
    }

}
