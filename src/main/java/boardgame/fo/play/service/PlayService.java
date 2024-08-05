package boardgame.fo.play.service;

import boardgame.fo.play.dto.BeginPlayRequestDto;
import boardgame.fo.play.dto.CreatePlayRequestDto;
import boardgame.fo.play.dto.JoinPlayRequestDto;

import java.util.Map;

public interface PlayService {

    Map<String, Object> readById(long playId);

    long createPlay(CreatePlayRequestDto requestDto);

    void joinPlay(JoinPlayRequestDto requestDto);

    void reJoinPlay(JoinPlayRequestDto requestDto);

    Map<String, Object> addPlay(JoinPlayRequestDto requestDto);

    void beginPlay(BeginPlayRequestDto requestDto);

    void cancelPlay(JoinPlayRequestDto requestDto);

    void insertPlay(Map<String, Object> map);

    void updatePlay(Map<String, Object> map);


}
