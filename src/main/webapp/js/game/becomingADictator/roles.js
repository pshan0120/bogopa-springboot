class Role {
    constructor(name, title, conditionOfWin, preferentialRoleList) {
        this.name = name;
        this.title = title;
        this.conditionOfWin = conditionOfWin;
        this.preferentialRoleList = preferentialRoleList;
    }

    static getRoleByRoleName(roleName) {
        return createRoleList().find(role => role.name === roleName);
    }

    /*static getPlayerByTitle(roleList, title) {
        return roleList.find(player => player.title === title);
    }

    static getPlayerByPlayerName(roleList, playerName) {
        return roleList.find(player => player.playerName === playerName);
    }*/
}

const createRoleList = () => {
    return [
        new Dictator(),
        new Clown(),
        new Nobility(),
        new Revolutionary(),
        new Assassin(),
        new Populace(),
        new Priest(),
    ];
};

class Clown extends Role {
    static name = "clown";
    static title = "광대";
    static conditionOfWin = "독재자가 승리하는 경우 함께 승리.";
    static preferentialRoleList = [];

    constructor() {
        super(
            Clown.name,
            Clown.title,
            Clown.conditionOfWin,
            Clown.preferentialRoleList
        );
    }
}

class Assassin extends Role {
    static name = "assassin";
    static title = "암살자";
    static conditionOfWin = "독재자, 혁명가 또는 성직자가 승리조건을 만족했을 때, 자신의 득표 수가 0표인 경우 승리.";
    static preferentialRoleList = [];

    constructor() {
        super(
            Assassin.name,
            Assassin.title,
            Assassin.conditionOfWin,
            Assassin.preferentialRoleList
        );
    }
}

class Populace extends Role {
    static name = "populace";
    static title = "민중";
    static conditionOfWin = "모두가 민중이거나, 민중 이외에 승리조건을 달성한 플레이어가 없음.";
    static preferentialRoleList = [];

    constructor() {
        super(
            Populace.name,
            Populace.title,
            Populace.conditionOfWin,
            Populace.preferentialRoleList
        );
    }
}

class Priest extends Role {
    static name = "priest";
    static title = "성직자";
    static conditionOfWin = "모든 플레이어들 중 0표를 제외하고 최대 득표와 최소 득표의 차이가 1표 이하, 또는 모두 0표";
    static preferentialRoleList = [Assassin];

    constructor() {
        super(
            Priest.name,
            Priest.title,
            Priest.conditionOfWin,
            Priest.preferentialRoleList
        );
    }
}

class Revolutionary extends Role {
    static name = "revolutionary";
    static title = "혁명가";
    static conditionOfWin = "'득표수 최하위' 또는 '최하위 바로 윗 순위'에 해당하는 혁명가가 각 1명 이상 존재.(단, 0표인 혁명가는 승리할 수 없음.)";
    static preferentialRoleList = [Assassin, Priest];

    constructor() {
        super(
            Revolutionary.name,
            Revolutionary.title,
            Revolutionary.conditionOfWin,
            Revolutionary.preferentialRoleList
        );
    }
}

class Dictator extends Role {
    static name = "dictator";
    static title = "독재자";
    static conditionOfWin = "득표수 단독 1위.";
    static preferentialRoleList = [Revolutionary, Assassin, Priest];

    constructor() {
        super(
            Dictator.name,
            Dictator.title,
            Dictator.conditionOfWin,
            Dictator.preferentialRoleList
        );
    }
}

class Nobility extends Role {
    static name = "nobility";
    static title = "귀족";
    static conditionOfWin = "'득표수 2위' 또는 '1표 이상 득표'에 해당하는 귀족이 각 1명 이상 존재.(단, 단독 1위인 귀족은 승리할 수 없음.) 또는 암살자의 승리.";
    static preferentialRoleList = [Dictator, Revolutionary, Priest];

    constructor() {
        super(
            Nobility.name,
            Nobility.title,
            Nobility.conditionOfWin,
            Nobility.preferentialRoleList
        );
    }
}
