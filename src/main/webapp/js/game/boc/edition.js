class Edition {

    static getInEditionListById(editionList, editionId) {
        return editionList.find(item => this.editionIdEquals(item.id, editionId));
    }

    static editionIdEquals(editionId1, editionId2) {
        if (!editionId1 || !editionId2) {
            return false;
        }

        return editionId1.replace(/\-/g, "") === editionId2.replace(/\-/g, "");
    }

}
