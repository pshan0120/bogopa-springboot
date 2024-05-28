class Role {
    constructor(name, title, description) {
        this.name = name;
        this.title = title;
        this.description = description;
    }
}

class Dictator extends Role {
    static name = "dictator";
    static title = "독재자";
    static description = "당신은 이야기꾼이 지정한 두 명의 참가자 중 한 명이 어떤 역할을 가진 마을주민인지 알고 시작합니다.";

    constructor() {
        super(Dictator.name, Dictator.title, Dictator.description);
        this.identifyingPlayerList = [];
        this.identifyingTownsFolkRole = null;
    }
}

class Clown extends Role {
    static name = "clown";
    static title = "광대";
    static description = "당신은 이야기꾼이 지정한 두 명의 참가자 중 한 명이 어떤 역할을 가진 이방인인지 알고 시작합니다.";

    constructor() {
        super(Clown.name, Clown.title, Clown.description);
        this.identifyingPlayerList = [];
        this.identifyingOutsiderRole = null;
    }
}

class Nobility extends Role {
    static name = "nobility";
    static title = "귀족";
    static description = "당신은 이야기꾼이 지정한 두 명의 참가자 중 한 명이 어떤 역할을 가진 하수인인지 알고 시작합니다.";

    constructor() {
        super(Nobility.name, Nobility.title, Nobility.description);
        this.identifyingPlayerList = [];
        this.identifyingMinionRole = null;
    }
}

class Revolutionary extends Role {
    static name = "revolutionary";
    static title = "혁명가";
    static description = "당신은 악한 플레이어가 몇 쌍으로 앉아있는지 알고 시작합니다. 예를 들어 악한 플레이어가 세 명 연달아 앉아 있다면 숫자 2를 알게 됩니다.";

    constructor() {
        super(Revolutionary.name, Revolutionary.title, Revolutionary.description);
        this.numberOfConcatenateEvil = null;
    }
}

class Assassin extends Role {
    static name = "assassin";
    static title = "암살자";
    static description = "당신은 악한 플레이어가 몇 쌍으로 앉아있는지 알고 시작합니다. 예를 들어 악한 플레이어가 세 명 연달아 앉아 있다면 숫자 2를 알게 됩니다.";

    constructor() {
        super(Assassin.name, Assassin.title, Assassin.description);
        this.numberOfConcatenateEvil = null;
    }
}

class Populace extends Role {
    static name = "populace";
    static title = "민중";
    static description = "당신은 악한 플레이어가 몇 쌍으로 앉아있는지 알고 시작합니다. 예를 들어 악한 플레이어가 세 명 연달아 앉아 있다면 숫자 2를 알게 됩니다.";

    constructor() {
        super(Populace.name, Populace.title, Populace.description);
        this.numberOfConcatenateEvil = null;
    }
}

class Priest extends Role {
    static name = "priest";
    static title = "성직자";
    static description = "당신은 악한 플레이어가 몇 쌍으로 앉아있는지 알고 시작합니다. 예를 들어 악한 플레이어가 세 명 연달아 앉아 있다면 숫자 2를 알게 됩니다.";

    constructor() {
        super(Priest.name, Priest.title, Priest.description);
        this.numberOfConcatenateEvil = null;
    }
}
