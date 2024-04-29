class Fruit {

    static getFruitByName(fruitList, fruitName) {
        return fruitList.find(fruit => fruit.name === fruitName);
    }

    static getPlayerByRoleName(playerList, roleName) {
        return playerList.find(player => player.name === roleName);
    }

    static getPlayerByTitle(playerList, title) {
        return playerList.find(player => player.title === title);
    }

    static getPlayerByPlayerName(playerList, playerName) {
        return playerList.find(player => player.playerName === playerName);
    }

}
