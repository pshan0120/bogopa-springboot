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

        if (positionName === POSITION.TRAVELLER.name) {
            return "font-purple-light";
        }

        if (positionName === POSITION.FABLED.name) {
            return "font-orange";
        }

        return "";
    }

    static getAlignmentInCharacterListById(characterList, characterId) {
        const character = characterList.find(item => this.characterIdEquals(item.id, characterId));
        if (character.team === POSITION.TOWNS_FOLK.name || character.team === POSITION.OUTSIDER.name) {
            return ALIGNMENT.GOOD;
        }

        if (character.team === POSITION.MINION.name || character.team === POSITION.DEMON.name) {
            return ALIGNMENT.EVIL;
        }

        return null;
    }

}
