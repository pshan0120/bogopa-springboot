class Role {
    constructor(name, title, description, alignment, position) {
        this.name = name;
        this.title = title;
        this.alignment = alignment;
        this.position = position;
        this.description = description;
        // this.nominating = false;
        // this.nominated = false;
        this.nominatable = true;
        this.votable = true;
        this.executed = false;
        this.died = false;
        this.diedRound = null;
        this.firstNightActive = true;
        this.restOfNightActive = false;
        this.skillAvailable = true;
        this.drunken = false;
        this.poisoned = false;
        this.redHerring = false;
        this.diedToday = false;
        this.diedTonight = false;
        this.safeByMonk = false;
    }

    static calculatePlayerStatusList(player) {
        const playerStatusList = [];
        if (!player) {
            return playerStatusList;
        }

        if (player.died) {
            playerStatusList.push("사망");
        }

        if (player.drunken) {
            playerStatusList.push("만취");
        }

        if (player.poisoned) {
            playerStatusList.push("중독");
        }

        if (player.redHerring) {
            playerStatusList.push("레드 헤링(점쟁이에게 악으로 보임)");
        }

        if (player.safeByMonk) {
            playerStatusList.push("수도승에게 보호받음");
        }

        if (player.name === Slayer.name
            && !player.skillAvailable) {
            playerStatusList.push("슬레이어 능력 없음");
        }

        if (player.name === Butler.name
            && player.masterPlayerByRound.length > 0) {
            const lastChosen = player.masterPlayerByRound.at(-1);
            playerStatusList.push("'" + lastChosen.playerName + "'을(를) 주인으로 모심");
        }

        if (player.position.name === POSITION.MINION.name
            && player.changedToImp) {
            playerStatusList.push("새로운 임프가 됨");
        }

        return playerStatusList;
    }

    static createPlayerStatusListHtml(player) {
        return Role.calculatePlayerStatusList(player).reduce((prev, next) => {
            return prev + next + ", ";
        }, "");
    }

    static getPlayerByRole(playerList, role) {
        return playerList.find(player => player.name === role.name);
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

    static createChoiceButtonClass(role) {
        if (!role) {
            return "btn btn-sm btn-outline-default mr-1 my-1";
        }

        if (role.position.name === POSITION.TOWNS_FOLK.name) {
            return "btn btn-sm btn-outline-primary mr-1 my-1";
        }

        if (role.position.name === POSITION.OUTSIDER.name) {
            return "btn btn-sm btn-outline-info mr-1 my-1";
        }

        if (role.position.name === POSITION.MINION.name) {
            return "btn btn-sm btn-outline-warning mr-1 my-1";
        }

        if (role.position.name === POSITION.DEMON.name) {
            return "btn btn-sm btn-outline-danger mr-1 my-1";
        }

        return "btn btn-sm btn-outline-default mr-1 my-1";
    }

    static calculateRoleNameClass(positionName) {
        if (positionName === "towns folk") {
            return "text-primary";
        }

        if (positionName === "outsider") {
            return "text-info";
        }

        if (positionName === "minion") {
            return "text-warning";
        }

        return "text-danger";
    }

    isAlive() {
        return !this.died;
    }
}

class GoodRole
    extends Role {
    constructor(name, title, description, position) {
        super(name, title, description, ALIGNMENT.GOOD, position);
    }
}

class TownsFolkRole extends GoodRole {
    constructor(name, title, description) {
        super(name, title, description, POSITION.TOWNS_FOLK);
    }
}

class OutsiderRole extends GoodRole {
    constructor(name, title, description) {
        super(name, title, description, POSITION.OUTSIDER);
    }
}

class EvilRole extends Role {
    constructor(name, title, description, position) {
        super(name, title, description, ALIGNMENT.EVIL, position);
        this.attackingPlayerByRound = [];
    }
}

class MinionRole extends EvilRole {
    constructor(name, title, description) {
        super(name, title, description, POSITION.MINION);
        this.changedToImp = null;
    }
}

class DemonRole extends EvilRole {
    constructor(name, title, description) {
        super(name, title, description, POSITION.DEMON);
    }
}

class WasherWoman extends TownsFolkRole {
    static name = "washer woman";
    static title = "세탁부";
    static description = "당신은 스토리텔러가 지정한 두 명의 참가자 중 한 명이 어떤 역할을 가진 마을주민인지 알고 시작합니다.";

    constructor() {
        super(WasherWoman.name, WasherWoman.title, WasherWoman.description);
        this.identifyingPlayerList = [];
        this.identifyingTownsFolkRole = null;
    }
}

class Librarian extends TownsFolkRole {
    static name = "librarian";
    static title = "사서";
    static description = "당신은 스토리텔러가 지정한 두 명의 참가자 중 한 명이 어떤 역할을 가진 이방인인지 알고 시작합니다.";

    constructor() {
        super(Librarian.name, Librarian.title, Librarian.description);
        this.identifyingPlayerList = [];
        this.identifyingOutsiderRole = null;
    }
}

class Investigator extends TownsFolkRole {
    static name = "investigator";
    static title = "조사관";
    static description = "당신은 스토리텔러가 지정한 두 명의 참가자 중 한 명이 어떤 역할을 가진 하수인인지 알고 시작합니다.";

    constructor() {
        super(Investigator.name, Investigator.title, Investigator.description);
        this.identifyingPlayerList = [];
        this.identifyingMinionRole = null;
    }
}

class Chef extends TownsFolkRole {
    static name = "chef";
    static title = "요리사";
    static description = "당신은 악한 플레이어가 몇 쌍으로 앉아있는지 알고 시작합니다. 예를 들어 악한 플레이어가 세 명 연달아 앉아 있다면 숫자 2를 알게 됩니다.";

    constructor() {
        super(Chef.name, Chef.title, Chef.description);
        this.numberOfConcatenateEvil = null;
    }
}

class Empath extends TownsFolkRole {
    static name = "empath";
    static title = "공감능력자";
    static description = "매일 밤, 당신은 좌우에 있는 살아있는 두 이웃 중 얼마나 많은 사람이 악한지 알게 됩니다.";

    constructor() {
        super(Empath.name, Empath.title, Empath.description);
        this.numberOfNearEvilByRound = [];
    }
}

class FortuneTeller extends TownsFolkRole {
    static name = "fortune teller";
    static title = "점쟁이";
    static description = "매일 밤 당신은 당신이 지정한 두 명의 플레이어 중 악마가 있는지 알게 됩니다. 다만 실제로는 선한 플레이어지만 당신에게는 악마로 보이는 사람이 한 명 있습니다.";

    constructor() {
        super(FortuneTeller.name, FortuneTeller.title, FortuneTeller.description);
        this.existenceEvilAmongTwoPlayersByRound = [];
    }
}

class Undertaker extends TownsFolkRole {
    static name = "undertaker";
    static title = "장의사";
    static description = "첫날 밤을 제외한 매일 밤 당신은 오늘 처형된 플레이어의 역할을 알게 됩니다.";

    constructor() {
        super(Undertaker.name, Undertaker.title, Undertaker.description);
        this.roleOfDiedPlayerByRound = [];
    }
}

class Monk extends TownsFolkRole {
    static name = "monk";
    static title = "수도승";
    static description = "첫날 밤을 제외한 매일 밤 당신은 당신을 제외한 플레이어를 선택합니다. 그는 오늘 밤 악마로부터 안전합니다.";

    constructor() {
        super(Monk.name, Monk.title, Monk.description);
        this.safePlayerByRound = [];
    }
}

class RavenKeeper extends TownsFolkRole {
    static name = "raven keeper";
    static title = "레이븐키퍼";
    static description = "만약 당신이 밤에 죽는다면, 당신은 플레이어를 선택한 뒤 그 사람의 역할을 알게 됩니다.";

    constructor() {
        super(RavenKeeper.name, RavenKeeper.title, RavenKeeper.description);
        this.identificationOfPlayer = null;
    }
}

class Virgin extends TownsFolkRole {
    static name = "virgin";
    static title = "처녀";
    static description = "당신이 처음 재판에 지명받았을 때, 만약 당신을 지명한 사람이 마을주민이라면 그 플레이어는 처녀 대신 즉시 처형됩니다.";

    constructor() {
        super(Virgin.name, Virgin.title, Virgin.description);
    }
}

class Slayer extends TownsFolkRole {
    static name = "slayer";
    static title = "슬레이어";
    static description = "게임 중 한 번, 낮에 공개적으로 플레이어를 지목합니다. 악마를 제대로 지목했다면 그 악마는 사망합니다.";

    constructor() {
        super(Slayer.name, Slayer.title, Slayer.description);
    }
}

class Soldier extends TownsFolkRole {
    static name = "soldier";
    static title = "군인";
    static description = "당신은 악마의 공격으로부터 안전합니다.";

    constructor() {
        super(Soldier.name, Soldier.title, Soldier.description);
        this.slayingPlayer = null;
    }
}

class Mayor extends TownsFolkRole {
    static name = "mayor";
    static title = "시장";
    static description = "만약 단 세명의 플레이어만 살아남았고 재판으로 아무도 죽지 않는다면 당신의 팀은 승리합니다. 만약 당신이 밤에 죽는다면 다른 플레이어가 당신 대신 희생될 수 있습니다.";

    constructor() {
        super(Mayor.name, Mayor.title, Mayor.description);
        this.insteadOfDiedPlayerByRound = [];
        this.archivedGoodVictoryCondition = false;
    }
}

class Butler extends OutsiderRole {
    static name = "butler";
    static title = "집사";
    static description = "매일 밤, 당신은 다른 플레이어 한 명을 지목합니다. 그리고 그 날은 당신이 지정한 플레이어가 투표할 때만 투표할 수 있습니다.";

    constructor() {
        super(Butler.name, Butler.title, Butler.description);
        this.masterPlayerByRound = [];
    }
}

class Drunk extends OutsiderRole {
    static name = "drunk";
    static title = "주정뱅이";
    static description = "당신은 취했다는 사실을 모릅니다. 당신은 자신이 마을주민 역할이라고 생각하지만, 사실은 아닙니다.";

    constructor() {
        super(Drunk.name, Drunk.title, Drunk.description);
    }
}

class Recluse extends OutsiderRole {
    static name = "recluse";
    static title = "은둔자";
    static description = "당신은 다른 사람들에게 마치 하수인이나 악마인 것처럼 보이지만 실제로는 선한 사람입니다. 죽을 때에도 다른 사람들에게 당신은 하수인이나 악마로 보입니다.";

    constructor() {
        super(Recluse.name, Recluse.title, Recluse.description);
        this.registeredRoleByRound = [];
    }
}

class Saint extends OutsiderRole {
    static name = "saint";
    static title = "성자";
    static description = "만약 당신이 재판을 통해 처형된다면 당신의 팀은 패배합니다.";

    constructor() {
        super(Saint.name, Saint.title, Saint.description);
        this.archivedEvilVictoryCondition = false;
    }
}

class Poisoner extends MinionRole {
    static name = "poisoner";
    static title = "독살범";
    static description = "매일 밤 당신은 한 명의 플레이어를 지목합니다. 그 플레이어는 오늘 밤부터 내일 해 질 녘까지 중독 상태가 됩니다.";

    constructor() {
        super(Poisoner.name, Poisoner.title, Poisoner.description);
        this.poisoningPlayerByRound = [];
    }
}

class Spy extends MinionRole {
    static name = "spy";
    static title = "스파이";
    static description = "매일 밤 당신은 스토리텔러를 통해 게임 진행상황을 볼 수 있습니다. 당신은 다른 사람들에게 마을주민이나 이방인으로 보입니다. 하지만 실제로는 악한 편입니다. 죽은 상태에서도 당신은 다른 사람들에게 마을주민이나 이방인으로 보입니다.";

    constructor() {
        super(Spy.name, Spy.title, Spy.description);
        this.showingPlayStatusByRound = [];
        this.mockingGoodPlayerByTargeting = [];
    }
}

class Baron extends MinionRole {
    static name = "baron";
    static title = "남작";
    static description = "게임을 시작할 때 마을주민 역할 두 명을 이방인 역할로 교체합니다.";

    constructor() {
        super(Baron.name, Baron.title, Baron.description);
        this.addingOutsider = null;
    }
}

class ScarletWomen extends MinionRole {
    static name = "scarlet women";
    static title = "부정한 여자";
    static description = "만약 여행자를 제외한 5명 이상의 플레이어가 살아있지만 악마가 죽는다면 당신은 악마가 됩니다. 예를 들어 5명이 남아있었고 악마가 처형되어 4명이 되는 순간, 부정한 여자는 악마가 됩니다.";

    constructor() {
        super(ScarletWomen.name, ScarletWomen.title, ScarletWomen.description);
    }
}

class Imp extends DemonRole {
    static name = "imp";
    static title = "임프";
    static description = "첫날 밤 미참여 역할 3개를 알고 시작합니다. 첫날 밤을 제외한 매일 밤 당신은 플레이어를 지목하고 그 참가자는 사망합니다. 만약 당신이 자신을 지목했다면 하수인들 중 한 명이 임프가 됩니다.";

    constructor() {
        super(Imp.name, Imp.title, Imp.description);
        this.offeredGoodRoleList = [];
    }
}
