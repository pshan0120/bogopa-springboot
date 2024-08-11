const GAME = {
    BOC_TROUBLE_BREWING: 1951,
    FRUIT_SHOP: 1952,
    CATCH_A_THIEF: 1953,
    BECOMING_A_DICTATOR: 1954,
    BOC_CUSTOM: 1955,
    ZOMBIE: 1956,
    isPlayableGame: gameId => {
        return GAME.BOC_TROUBLE_BREWING == gameId
            || GAME.FRUIT_SHOP == gameId
            || GAME.CATCH_A_THIEF == gameId
            || GAME.BECOMING_A_DICTATOR == gameId
            || GAME.BOC_CUSTOM == gameId
            || GAME.ZOMBIE == gameId
            ;
    }
};




