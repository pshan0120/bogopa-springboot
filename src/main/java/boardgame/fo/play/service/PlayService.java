package boardgame.fo.play.service;

import boardgame.fo.play.dto.CreatePlayRequestDto;

import java.util.Map;

public interface PlayService {

    Map<String, Object> readById(long playId);

    long createPlay(CreatePlayRequestDto dto);





    void insertPlay(Map<String, Object> map);

    void updatePlay(Map<String, Object> map);

    void deletePlay(Map<String, Object> map);



}
