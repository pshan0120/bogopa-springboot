const GAME = {
    BOC_TROUBLE_BREWING: 1951,
    FRUIT_SHOP: 1952,
    CATCH_A_THIEF: 1953,
    isPlayableGame: gameId => {
        return GAME.BOC_TROUBLE_BREWING == gameId ||
            GAME.FRUIT_SHOP == gameId ||
            GAME.CATCH_A_THIEF == gameId;
    }
};




