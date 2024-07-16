class Character {

    static getCharacterInListById(characterList, characterId) {
        return characterList.find(item => this.characterIdEquals(item.id, characterId));
    }

    static characterIdEquals(characterId1, characterId2) {
        return characterId1.replace(/\-/g, "") === characterId2.replace(/\-/g, "");
    }

    static calculateCharacterNameClass(positionName) {
        if (positionName === POSITION.TOWNS_FOLK.name) {
            return "text-primary";
        }

        if (positionName === POSITION.OUTSIDER.name) {
            return "text-info";
        }

        if (positionName === POSITION.MINION.name) {
            return "text-warning";
        }

        if (positionName === POSITION.DEMON.name) {
            return "text-danger";
        }

        return "";
    }

}
