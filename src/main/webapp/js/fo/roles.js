class Role {
    constructor(name, title, order, alignment, position) {
        this.name = name;
        this.title = title;
        this.alignment = alignment;
        this.position = position;
        this.order = order;
        this.nominating = false;
        this.died = false;
        this.diedRound = null;
        this.firstNightActive = true;
        this.restOfNightActive = false;
        this.skillAvailable = true;
        this.drunken = false;
        this.poisoned = false;
        this.redHerring = false;
        this.diedToday = false;
    }

    isAlive() {
        return !this.died;
    }
}

class GoodRole extends Role {
    constructor(name, title, order, position) {
        super(name, title, order, ALIGNMENT.GOOD, position);
    }
}

class TownsFolkRole extends GoodRole {
    constructor(name, title, order) {
        super(name, title, order, POSITION.TOWNS_FOLK);
    }
}

class OutsiderRole extends GoodRole {
    constructor(name, title, order) {
        super(name, title, order, POSITION.OUTSIDER);
    }
}

class EvilRole extends Role {
    constructor(name, title, order, position) {
        super(name, title, order, ALIGNMENT.EVIL, position);
    }
}

class MinionRole extends EvilRole {
    constructor(name, title, order) {
        super(name, title, order, POSITION.MINION);
    }
}

class DemonRole extends EvilRole {
    constructor(name, title, order) {
        super(name, title, order, POSITION.DEMON);
    }
}

class WasherWoman extends TownsFolkRole {
    static name = "washer woman";
    static title = "세탁부";
    static order = 1;

    constructor() {
        super(WasherWoman.name, WasherWoman.title, WasherWoman.order);
        this.identificationOfTownFolk = null;
        this.identificationOfNotTownFolk = null;
    }
}

class Librarian extends TownsFolkRole {
    static name = "librarian";
    static title = "사서";
    static order = 2;

    constructor() {
        super(Librarian.name, Librarian.title, Librarian.order);
        this.identificationOfOutsider = null;
        this.identificationOfNotOutsider = null;
    }
}

class Investigator extends TownsFolkRole {
    static name = "investigator";
    static title = "조사관";
    static order = 3;

    constructor() {
        super(Investigator.name, Investigator.title, Investigator.order);
        this.identificationOfMinion = null;
        this.identificationOfNotMinion = null;
    }
}

class Chef extends TownsFolkRole {
    static name = "chef";
    static title = "요리사";
    static order = 4;

    constructor() {
        super(Chef.name, Chef.title, Chef.order);
        this.numberOfConcatenateEvil = null;
    }
}

class Empath extends TownsFolkRole {
    static name = "empath";
    static title = "공감능력자";
    static order = 5;

    constructor() {
        super(Empath.name, Empath.title, Empath.order);
        this.numberOfNearEvilByRound = [];
    }
}

class FortuneTeller extends TownsFolkRole {
    static name = "fortune teller";
    static title = "점쟁이";
    static order = 6;

    constructor() {
        super(FortuneTeller.name, FortuneTeller.title, FortuneTeller.order);
        this.existenceEvilAmongTwoPlayersByRound = [];
    }
}

class Undertaker extends TownsFolkRole {
    static name = "undertaker";
    static title = "장의사";
    static order = 7;

    constructor() {
        super(Undertaker.name, Undertaker.title, Undertaker.order);
        this.roleOfDiedPlayerByRound = [];
    }
}

class Monk extends TownsFolkRole {
    static name = "monk";
    static title = "수도승";
    static order = 8;

    constructor() {
        super(Monk.name, Monk.title, Monk.order);
        this.safePlayerByRound = [];
    }
}

class RavenKeeper extends TownsFolkRole {
    static name = "raven keeper";
    static title = "레이븐키퍼";
    static order = 9;

    constructor() {
        super(RavenKeeper.name, RavenKeeper.title, RavenKeeper.order);
        this.identificationOfPlayer = null;
        this.diedRound = null;
    }
}

class Virgin extends TownsFolkRole {
    static name = "virgin";
    static title = "처녀";
    static order = 10;

    constructor() {
        super(Virgin.name, Virgin.title, Virgin.order);
        this.nominatedBy = null;
    }
}

class Slayer extends TownsFolkRole {
    static name = "slayer";
    static title = "슬레이어";
    static order = 11;

    constructor() {
        super(Slayer.name, Slayer.title, Slayer.order);
    }
}

class Soldier extends TownsFolkRole {
    static name = "soldier";
    static title = "군인";
    static order = 12;

    constructor() {
        super(Soldier.name, Soldier.title, Soldier.order);
    }
}

class Mayor extends TownsFolkRole {
    static name = "mayor";
    static title = "시장";
    static order = 13;

    constructor() {
        super(Mayor.name, Mayor.title, Mayor.order);
        this.insteadOfDiedPlayerByRound = [];
        this.archivedGoodVictoryCondition = false;
    }
}

class Butler extends OutsiderRole {
    static name = "butler";
    static title = "집사";
    static order = 14;

    constructor() {
        super(Butler.name, Butler.title, Butler.order);
        this.masterPlayerByRound = [];
    }
}

class Drunk extends OutsiderRole {
    static name = "drunk";
    static title = "주정뱅이";
    static order = 15;

    constructor(townsFolkRole) {
        super(Drunk.name, Drunk.title, Drunk.order);
        this.fakeTownsFolkRole = townsFolkRole;
        this.drunken = true;
    }
}

class Recluse extends OutsiderRole {
    static name = "recluse";
    static title = "은둔자";
    static order = 16;

    constructor() {
        super(Recluse.name, Recluse.title, Recluse.order);
        this.registeredRoleByRound = [];
    }
}

class Saint extends OutsiderRole {
    static name = "saint";
    static title = "성자";
    static order = 17;

    constructor() {
        super(Saint.name, Saint.title, Saint.order);
        this.archivedEvilVictoryCondition = false;
    }
}

class Poisoner extends MinionRole {
    static name = "poisoner";
    static title = "독살범";
    static order = 18;

    constructor() {
        super(Poisoner.name, Poisoner.title, Poisoner.order);
        this.poisoningPlayerByRound = [];
    }
}

class Spy extends MinionRole {
    static name = "spy";
    static title = "스파이";
    static order = 19;

    constructor() {
        super(Spy.name, Spy.title, Spy.order);
        this.spyingPlayerByRound = [];
    }
}

class Baron extends MinionRole {
    static name = "baron";
    static title = "남작";
    static order = 20;

    constructor() {
        super(Baron.name, Baron.title, Baron.order);
        this.addingOutsider = null;
    }
}

class ScarletWomen extends MinionRole {
    static name = "scarlet women";
    static title = "부정한 여자";
    static order = 21;

    constructor() {
        super(ScarletWomen.name, ScarletWomen.title, ScarletWomen.order);
        this.changedToImp = null;
    }
}

class Imp extends DemonRole {
    static name = "imp";
    static title = "임프";
    static order = 21;

    constructor() {
        super(Imp.name, Imp.title, Imp.order);
        this.offeredTownsFolkRoleList = [];
        this.killingPlayer = null;
    }
}
