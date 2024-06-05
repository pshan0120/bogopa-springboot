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

    static calculateResult(finalPlayerList, role) {
        const playerList = finalPlayerList.filter(player => player.lastRole === role.name);
        if (playerList.length === 0) {
            return;
        }

        const preferentialWon = finalPlayerList
            .some(player => role.preferentialRoleList
                .some(role => player.lastRole === role.name && player.conditionOfWinAchieved)
            );

        playerList.forEach(player => {
            if (preferentialWon) {
                player.won = false;
            } else {
                player.won = player.conditionOfWinAchieved;
            }
        });
    }
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

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Clown.name);
        if (playerList.length === 0) {
            return;
        }

        const dictator = finalPlayerList.find(player => player.lastRole === Dictator.name);
        if (!dictator) {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
            return;
        }

        if (dictator.conditionOfWinAchieved) {
            playerList.forEach(player => player.conditionOfWinAchieved = true);
        } else {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
        }
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

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Assassin.name);
        if (playerList.length === 0) {
            return;
        }

        const dictator = finalPlayerList.find(player => player.lastRole === Dictator.name);
        const revolutionary = finalPlayerList.find(player => player.lastRole === Revolutionary.name);
        const priest = finalPlayerList.find(player => player.lastRole === Priest.name);
        if (!dictator && !revolutionary && !priest) {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
            return;
        }

        if (!dictator.conditionOfWinAchieved && !revolutionary.conditionOfWinAchieved && !priest.conditionOfWinAchieved) {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
        }

        playerList.forEach(player => {
            if (player.numberOfVote === 0) {
                player.conditionOfWinAchieved = true;
            } else {
                player.conditionOfWinAchieved = false;
            }
        });
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

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Populace.name);
        if (playerList.length === 0) {
            return;
        }

        if (playerList.length === finalPlayerList.length) {
            playerList.forEach(player => player.conditionOfWinAchieved = true);
            return;
        }

        const winAchievedList = finalPlayerList
            .filter(player => player.lastRole !== Populace.name && player.conditionOfWinAchieved);
        if (winAchievedList.length === 0) {
            playerList.forEach(player => player.conditionOfWinAchieved = true);
            return;
        }

        playerList.forEach(player => player.conditionOfWinAchieved = false);
    }
}

class Priest extends Role {
    static name = "priest";
    static title = "성직자";
    static conditionOfWin = "모든 플레이어들 중 0표를 제외하고 최대 득표와 최소 득표의 차이가 1표 이하, 또는 모두 0표";
    static preferentialRoleList = [Assassin.name];

    constructor() {
        super(
            Priest.name,
            Priest.title,
            Priest.conditionOfWin,
            Priest.preferentialRoleList
        );
    }

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Priest.name);
        if (playerList.length === 0) {
            return;
        }

        const minimumNumberOfVote = finalPlayerList
            .filter(player => player.numberOfVote > 0)
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev < next ? prev : next, finalPlayerList.length);

        const maximumNumberOfVote = finalPlayerList
            .filter(player => player.numberOfVote > 0)
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev > next ? prev : next, 1);

        if ((maximumNumberOfVote - minimumNumberOfVote) <= 1) {
            playerList.forEach(player => player.conditionOfWinAchieved = true);
            return;
        } else {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
        }
    }
}

class Revolutionary extends Role {
    static name = "revolutionary";
    static title = "혁명가";
    static conditionOfWin = "'득표수 최하위' 또는 '최하위 바로 윗 순위'에 해당하는 혁명가가 각 1명 이상 존재.(단, 0표인 혁명가는 승리할 수 없음.)";
    static preferentialRoleList = [Assassin.name, Priest.name];

    constructor() {
        super(
            Revolutionary.name,
            Revolutionary.title,
            Revolutionary.conditionOfWin,
            Revolutionary.preferentialRoleList
        );
    }

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Revolutionary.name);
        if (playerList.length === 0) {
            return;
        }

        if (playerList.length < 2) {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
            return;
        }

        const minimumNumberOfVote = playerList
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev < next ? prev : next, finalPlayerList.length);

        const minimumVotedPlayerList = playerList
            .filter(player => player.numberOfVote === minimumNumberOfVote);

        const secondMinimumNumberOfVote = playerList
            .filter(player => player.numberOfVote > minimumNumberOfVote)
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev < next ? prev : next, finalPlayerList.length);

        const secondMinimumVotedPlayerList = playerList
            .filter(player => player.numberOfVote === secondMinimumNumberOfVote);

        if (minimumVotedPlayerList.length > 0 && secondMinimumVotedPlayerList.length > 0) {
            playerList.forEach(player => {
                if (player.numberOfVote > 0) {
                    player.conditionOfWinAchieved = true;
                } else {
                    player.conditionOfWinAchieved = false;
                }
            });
        } else {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
        }
    }
}

class Dictator extends Role {
    static name = "dictator";
    static title = "독재자";
    static conditionOfWin = "득표수 단독 1위.";
    static preferentialRoleList = [Revolutionary.name, Assassin.name, Priest.name];

    constructor() {
        super(
            Dictator.name,
            Dictator.title,
            Dictator.conditionOfWin,
            Dictator.preferentialRoleList
        );
    }

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Dictator.name);
        if (playerList.length === 0) {
            return;
        }

        const maximumNumberOfVote = playerList
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev > next ? prev : next, 1);

        const maximumVotedPlayerList = playerList.filter(player => player.numberOfVote === maximumNumberOfVote);
        if (maximumVotedPlayerList.length !== 1) {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
            return;
        }

        playerList.forEach(player => {
            if (player.numberOfVote > 0 && player.numberOfVote === maximumNumberOfVote) {
                player.conditionOfWinAchieved = true;
            } else {
                player.conditionOfWinAchieved = false;
            }
        });
    }
}

class Nobility extends Role {
    static name = "nobility";
    static title = "귀족";
    static conditionOfWin = "'득표수 2위' 또는 '1표 이상 득표'에 해당하는 귀족이 각 1명 이상 존재.(단, 단독 1위인 귀족은 승리할 수 없음.) 또는 암살자의 승리.";
    static preferentialRoleList = [Dictator.name, Revolutionary.name, Priest.name];

    constructor() {
        super(
            Nobility.name,
            Nobility.title,
            Nobility.conditionOfWin,
            Nobility.preferentialRoleList
        );
    }

    static calculateWinAchieved(finalPlayerList) {
        const playerList = finalPlayerList.filter(player => player.lastRole === Nobility.name);
        if (playerList.length === 0) {
            return;
        }

        if (playerList.length < 2) {
            playerList.forEach(player => player.conditionOfWinAchieved = false);
            return;
        }

        const votedPlayerList = playerList
            .filter(player => player.numberOfVote > 0);

        const maximumNumberOfVote = playerList
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev > next ? prev : next, 1);

        const maximumVotedPlayerList = playerList
            .filter(player => player.numberOfVote === maximumNumberOfVote);

        const secondMaximumNumberOfVote = playerList
            .filter(player => player.numberOfVote > maximumNumberOfVote)
            .map(player => player.numberOfVote)
            .reduce((prev, next) => prev > next ? prev : next, 1);

        const secondMaximumVotedPlayerList = playerList
            .filter(player => player.numberOfVote === secondMaximumNumberOfVote);

        if (votedPlayerList.length > 1 && secondMaximumVotedPlayerList.length > 0) {
            playerList.forEach(player => {
                if (player.numberOfVote === maximumNumberOfVote && maximumVotedPlayerList.length === 1) {
                    player.conditionOfWinAchieved = false;
                } else {
                    player.conditionOfWinAchieved = true;
                }
            });
        } else {
            const assassin = finalPlayerList.find(player => player.lastRole === Assassin.name);
            if (assassin.conditionOfWinAchieved) {
                playerList.forEach(player => player.conditionOfWinAchieved = true);
            } else {
                playerList.forEach(player => player.conditionOfWinAchieved = false);
            }
        }
    }

}
