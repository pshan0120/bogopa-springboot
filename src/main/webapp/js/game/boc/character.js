class Character {

    static getInCharacterListById(characterList, characterId) {
        return characterList.find(item => this.characterIdEquals(item.id, characterId));
    }

    static getInPlayerListById(playerList, characterId) {
        return playerList.find(item => this.characterIdEquals(item.characterId, characterId));
    }

    static characterIdEquals(characterId1, characterId2) {
        if (!characterId1 || !characterId2) {
            return false;
        }

        return characterId1.replace(/\-/g, "") === characterId2.replace(/\-/g, "");
    }

    static createChoiceButtonClass(positionName) {
        if (!positionName) {
            return "btn btn-sm btn-outline-default mr-1 my-1";
        }

        if (positionName === POSITION.TOWNS_FOLK.name) {
            return "btn btn-sm btn-outline-primary mr-1 my-1";
        }

        if (positionName === POSITION.OUTSIDER.name) {
            return "btn btn-sm btn-outline-info mr-1 my-1";
        }

        if (positionName === POSITION.MINION.name) {
            return "btn btn-sm btn-outline-warning mr-1 my-1";
        }

        if (positionName === POSITION.DEMON.name) {
            return "btn btn-sm btn-outline-danger mr-1 my-1";
        }

        return "btn btn-sm btn-outline-default mr-1 my-1";
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
