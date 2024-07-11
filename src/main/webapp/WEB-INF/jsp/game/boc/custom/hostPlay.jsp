<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/boc/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/roles.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let editionList = [];
        let jinxList = [];
        let characterList = [];
        let nightOrderList = [];
        let playerList = [];
        let townsFolkRoleList = [];
        let outsiderRoleList = [];
        let minionRoleList = [];
        let demonRoleList = [];
        let roleList = [];
        let roleListByHost = [];
        let townsFolkPlayerList = [];
        let outsiderPlayerList = [];
        let minionPlayerList = [];
        let demonPlayerList = [];
        let playStatus = {};
        let edition = null;

        $(async () => {
            // TODO: 에디션 내 역할 [] 만들 것
            editionList = await readEditionList();
            jinxList = await readJinxList();
            characterList = await readCharacterList();
            nightOrderList = await readNightOrderList();

            await gfn_readPlayablePlayById(PLAY_ID);

            await loadGameStatus();

            console.log('playStatus', playStatus);
            if (Object.keys(playStatus).length === 0) {
                await initializeGame();
                return;
            }

            if (0 < playStatus.round) {
                if (playStatus.night) {
                    renderOtherNight();
                    return;
                }

                renderOtherDay();
                return;
            }

            if (playStatus.night) {
                beginGame();
                return;
            }

            playerList.sort((prev, next) => prev.seatNumber - next.seatNumber);

            renderPlayMemberList(playerList);
            showAllPlayerRoleList();

            $("#settingDiv").show();

        });

        const readEditionList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/editions.json")
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const readJinxList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/jinxes/kr_KO.json")
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const readCharacterList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/characters/kr_KO.json")
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const readNightOrderList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/night-order.json")
                .then(data => data)
                .catch(response => console.error('error', response));
        }


        const setRoleList = edition => {
            if (edition === EDITION.TROUBLE_BREWING.name) {
                townsFolkRoleList = [
                    new WasherWoman(),
                    new Librarian(),
                    new Investigator(),
                    new Chef(),
                    new Empath(),
                    new FortuneTeller(),
                    new Undertaker(),
                    new Monk(),
                    new RavenKeeper(),
                    new Virgin(),
                    new Slayer(),
                    new Soldier(),
                    new Mayor(),
                ];

                outsiderRoleList = [
                    new Butler(),
                    new Drunk(),
                    new Recluse(),
                    new Saint(),
                ];

                minionRoleList = [
                    new Poisoner(),
                    new Spy(),
                    new Baron(),
                    new ScarletWoman(),
                ];

                demonRoleList = [
                    new Imp(),
                ];
            }

            if (edition === EDITION.TROUBLE_BREWING_EXPERT.name) {
                townsFolkRoleList = [
                    new WasherWoman(),
                    new Librarian(),
                    new Investigator(),
                    new Chef(),
                    new Empath(),
                    new FortuneTeller(),
                    new Undertaker(),
                    new Monk(),
                    new RavenKeeper(),
                    new Virgin(),
                    new Slayer(),
                    new Soldier(),
                    new Mayor(),
                    new PoppyGrower(),
                    new Atheist(),
                ];

                outsiderRoleList = [
                    new Butler(),
                    new Drunk(),
                    new Recluse(),
                    new Saint(),
                    new Lunatic(),
                ];

                minionRoleList = [
                    new Poisoner(),
                    new Spy(),
                    new Baron(),
                    new ScarletWoman(),
                ];

                demonRoleList = [
                    new Imp(),
                    new Legion(),
                ];
            }

            roleList = [
                ...townsFolkRoleList,
                ...outsiderRoleList,
                ...minionRoleList,
                ...demonRoleList,
            ];
            // createAssignedPlayerList();
        };

        const initializeGame = async () => {
            console.log('initializationSetting', initializationSetting);

            $("#settingDiv").show();
            $("#firstNightDiv").hide();
            $("#otherDayDiv").hide();
            $("#otherNightDiv").hide();

            const originalPlayMemberList = await readPlayMemberList(PLAY_ID);
            const clientPlayMemberList = originalPlayMemberList.clientPlayMemberList;
            const hostPlayMember = originalPlayMemberList.hostPlayMember;

            playStatus = {
                round: 0,
                night: true,
                hostMemberId: hostPlayMember.memberId,
                hostMemberName: hostPlayMember.nickname,
            }

            playerList = clientPlayMemberList
                .sort(() => Math.random() - 0.5)
                .map((originalPlayer, index) => {
                    return {...originalPlayer, seatNumber: index};
                });

            renderPlayMemberList(playerList);
        };

        const renderPlayMemberList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playersDiv = $settingDiv.find("div[name='playersDiv']");
            $playersDiv.empty();

            const playerListHtml = playerList.reduce((prev, next) => {
                return prev +
                    "<div class=\"form-group form-inline\">" +
                    "   <label class=\"form-control-label\">" + next.nickname + "</label>" +
                    "   <input type=\"text\" class=\"form-control form-control-alternative\" name=\"roleName\" readonly" +
                    "       data-member-id=\"" + next.memberId + "\">" +
                    "</div>";
            }, "");

            $playersDiv.append(playerListHtml);
        }

        const readPlayMemberList = playId => {
            return gfn_callGetApi("/api/play/member/list", {playId})
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const openSetPlayerRoleByHostModal = () => {
            roleListByHost = [];
            // TODO: 악마 군단까지 플레이 가능하면 해제
            //setRoleList(EDITION.TROUBLE_BREWING_EXPERT.name);
            setRoleList(EDITION.TROUBLE_BREWING.name);

            const $modal = $("#setPlayerRoleByHostModal");
            const townsFolkRoleListHtml = roleList
                .filter(role => role.position.name === POSITION.TOWNS_FOLK.name)
                .reduce((prev, next) => {
                    return prev
                        + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                        + " onclick=\"addRoleToPlayerRoleList('" + next.name + "')\" >"
                        + " " + next.title
                        + "</button>";
                }, "");
            $modal.find("[name='townsFolkRoleListDiv']").empty().html(townsFolkRoleListHtml)
                .find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
            $modal.find("[name='townsFolkRoleSetListDiv']").empty();

            const outsiderRoleListHtml = roleList
                .filter(role => role.position.name === POSITION.OUTSIDER.name)
                .reduce((prev, next) => {
                    return prev
                        + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                        + " onclick=\"addRoleToPlayerRoleList('" + next.name + "')\" >"
                        + " " + next.title
                        + "</button>";
                }, "");
            $modal.find("[name='outsiderRoleListDiv']").empty().html(outsiderRoleListHtml)
                .find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
            $modal.find("[name='outsiderRoleSetListDiv']").empty();

            const minionRoleListHtml = roleList
                .filter(role => role.position.name === POSITION.MINION.name)
                .reduce((prev, next) => {
                    return prev
                        + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                        + " onclick=\"addRoleToPlayerRoleList('" + next.name + "')\" >"
                        + " " + next.title
                        + "</button>";
                }, "");
            $modal.find("[name='minionRoleListDiv']").empty().html(minionRoleListHtml)
                .find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
            $modal.find("[name='minionRoleSetListDiv']").empty();

            const demonRoleListHtml = roleList
                .filter(role => role.position.name === POSITION.DEMON.name)
                .reduce((prev, next) => {
                    return prev
                        + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                        + " onclick=\"addRoleToPlayerRoleList('" + next.name + "')\" >"
                        + " " + next.title
                        + "</button>";
                }, "");
            $modal.find("[name='demonRoleListDiv']").empty().html(demonRoleListHtml)
                .find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
            $modal.find("[name='demonRoleSetListDiv']").empty();

            $modal.modal("show");
        }

        const addRoleToPlayerRoleList = roleName => {
            const role = roleList.find(role => role.name === roleName);
            roleListByHost.push(role);

            const playerSetting = initializationSetting.player
                .find(player => playerList.length === player.townsFolk + player.outsider + player.minion + player.demon);

            const $modal = $("#setPlayerRoleByHostModal");

            const townsFolkList = roleListByHost.filter(role => role.position.name === POSITION.TOWNS_FOLK.name);
            if (playerSetting.townsFolk === townsFolkList.length) {
                $modal.find("[name='townsFolkRoleListDiv']").empty();
            }
            const townsFolkListHtml = townsFolkList.reduce((prev, next) => {
                return prev + next.title + ", ";
            }, "");
            $modal.find("[name='townsFolkRoleSetListDiv']").empty().html(townsFolkListHtml);

            const outsiderList = roleListByHost.filter(role => role.position.name === POSITION.OUTSIDER.name);
            if (playerSetting.outsider === outsiderList.length) {
                $modal.find("[name='outsiderRoleListDiv']").empty();
            }
            const outsiderListHtml = outsiderList.reduce((prev, next) => {
                return prev + next.title + ", ";
            }, "");
            $modal.find("[name='outsiderRoleSetListDiv']").empty().html(outsiderListHtml);

            const minionList = roleListByHost.filter(role => role.position.name === POSITION.MINION.name);
            if (playerSetting.minion === minionList.length) {
                $modal.find("[name='minionRoleListDiv']").empty();
            }
            const minionListHtml = minionList.reduce((prev, next) => {
                return prev + next.title + ", ";
            }, "");
            $modal.find("[name='minionRoleSetListDiv']").empty().html(minionListHtml);

            const demonList = roleListByHost.filter(role => role.position.name === POSITION.DEMON.name);
            if (playerSetting.demon === demonList.length) {
                $modal.find("[name='demonRoleListDiv']").empty();
            }
            const demonListHtml = demonList.reduce((prev, next) => {
                return prev + next.title + ", ";
            }, "");
            $modal.find("[name='demonRoleSetListDiv']").empty().html(demonListHtml);
        }

        const setPlayersRoleByHost = () => {
            if (roleListByHost.length !== playerList.length) {
                alert("아직 선택되지 않은 역할이 있습니다.");
                return;
            }

            const minionList = roleListByHost.filter(role => role.position.name === POSITION.MINION.name);
            const baronExists = minionList.some(minionPlayer => minionPlayer.name === Baron.name);
            if (baronExists) {
                const outsiderList = roleListByHost.filter(role => role.position.name === POSITION.OUTSIDER.name);
                const unassignedOutsiderRoleList = roleList
                    .filter(role => role.position.name === POSITION.OUTSIDER.name)
                    .filter(role => !outsiderList.some(outsider => outsider.name === role.name))
                    .sort(() => Math.random() - 0.5);
                roleListByHost.push(unassignedOutsiderRoleList[0]);
                roleListByHost.push(unassignedOutsiderRoleList[1]);
            }

            setPlayersRole(playerList, roleListByHost);

            $("#setPlayerRoleByHostModal").modal("hide");
        }

        const setPlayersRoleByRandom = () => {
            setRoleList(EDITION.TROUBLE_BREWING.name);
            setPlayersRole(playerList, roleList);
        }

        const setPlayersRole = (playerList, roleList) => {
            const randomSortedPlayerList = [...playerList.sort(() => Math.random() - 0.5)];

            const playerSetting = initializationSetting.player
                .find(player => playerList.length === player.townsFolk + player.outsider + player.minion + player.demon);

            demonPlayerList = createPlayerList(roleList, randomSortedPlayerList, playerSetting.demon, POSITION.DEMON);
            console.log('demonPlayerList', demonPlayerList);

            minionPlayerList = createPlayerList(roleList, randomSortedPlayerList, playerSetting.minion, POSITION.MINION);
            console.log('minionPlayerList', minionPlayerList);
            // NOTE: 만약 minionPlayerList 중 Baron 이 있다면 townsFolkPlayerList, outsiderPlayerList 가 조정됨
            const baronExists = minionPlayerList.some(minionPlayer => minionPlayer.name === Baron.name);

            let townsFolkNumber = playerSetting.townsFolk;
            if (baronExists) {
                townsFolkNumber = townsFolkNumber - 2;
            }
            townsFolkPlayerList = createPlayerList(roleList, randomSortedPlayerList, townsFolkNumber, POSITION.TOWNS_FOLK);
            console.log('townsFolkPlayerList', townsFolkPlayerList);

            let outsiderNumber = playerSetting.outsider;
            if (baronExists) {
                outsiderNumber = outsiderNumber + 2;
            }
            outsiderPlayerList = createPlayerList(roleList, randomSortedPlayerList, outsiderNumber, POSITION.OUTSIDER);
            console.log('outsiderPlayerList', outsiderPlayerList);

            showAllPlayerRoleList();
        }

        const createPlayerList = (roleList, playerList, playerNumber, position) => {
            return roleList
                .filter(role => role.position.name === position.name)
                .sort(() => Math.random() - 0.5)
                .slice(0, playerNumber)
                .map(role => {
                    const player = playerList.pop();
                    return {
                        playerName: player.nickname,
                        playerId: player.memberId,
                        hashKey: player.hashKey,
                        seatNumber: player.seatNumber,
                        ...role
                    };
                });
        }

        const showAllPlayerRoleList = () => {
            showPlayerRoleList(townsFolkPlayerList);
            showPlayerRoleList(outsiderPlayerList);
            showPlayerRoleList(minionPlayerList);
            showPlayerRoleList(demonPlayerList);
        }

        const showPlayerRoleList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playersDiv = $settingDiv.find("div[name='playersDiv']");
            playerList.forEach(player => {
                const found = $playersDiv.find("input[name='roleName']").toArray()
                    .filter(roleNameObject => player.playerId == $(roleNameObject).data("memberId"));
                $(found).val(player.title);
                $(found).removeClass();
                $(found).addClass("form-control form-control-alternative");
                $(found).addClass(Role.calculateRoleNameClass(player.position.name));
            });
        }

        const beginGame = () => {
            if (createAssignedPlayerList().length !== playerList.length) {
                alert("역할이 분배되지 않았습니다.");
                return;
            }

            $("#settingDiv").hide();

            const $firstNightDiv = $("#firstNightDiv");
            $firstNightDiv.show();
            const $flowDiv = $firstNightDiv.find("div[name='flowDiv']").empty();
            $flowDiv.empty();

            $flowDiv.append(createInitializationHtml());
            $flowDiv.append(createDuskHtml());
            $flowDiv.append(minion.createHtml());
            $flowDiv.append(imp.createInitializationHtml());
            $flowDiv.append(poisoner.createHtml());
            $flowDiv.append(spy.createHtml());
            $flowDiv.append(washerWoman.createHtml());
            $flowDiv.append(librarian.createHtml());
            $flowDiv.append(investigator.createHtml());
            $flowDiv.append(chef.createHtml());
            $flowDiv.append(empath.createHtml());
            $flowDiv.append(fortuneTeller.createHtml());
            $flowDiv.append(butler.createHtml());
            $flowDiv.append(createDawnHtml());

            saveGameStatus();
        }

        const winByGood = () => {
            messageModal.open(`선한 편이 승리했습니다.<hr><audio name="victoryOfGood" src="https://bogopayo.cafe24.com/sound/level-win-6416.mp3" controls></audio>`);
        }

        const winByEvil = () => {
            messageModal.open(`악한 편이 승리했습니다.<hr><audio name="victoryOfGood" src="https://bogopayo.cafe24.com/sound/evil-laugh-21137.mp3" controls></audio>`);
        }

        const openMessageModal = messageHtml => {
            messageModal.open(messageHtml);
        }

        const createAssignedPlayerList = () => [
            ...townsFolkPlayerList,
            ...outsiderPlayerList,
            ...minionPlayerList,
            ...demonPlayerList,
        ];

        const openPlayStatusModal = () => {
            playStatusModal.open(createAssignedPlayerList());
        }

        const openRuleGuideModal = () => {
            ruleGuideModal.open();
        }

        const openRoleGuideModal = () => {
            roleGuideModal.open();
        }

        const openExpertRoleGuideModal = () => {
            expertRoleGuideModal.open();
        }

        const openTeensyvilleRoleGuideModal = () => {
            teensyvilleRoleGuideModal.open();
        }

        const openNightStepGuideModal = () => {
            nightStepGuideModal.open();
        }

        const openTownModal = () => {
            townModal.open(PLAY_ID);
        }

        const openQrLoginModal = () => {
            qrLoginModal.open(createAssignedPlayerList());
        }

        const openSoundEffectModal = () => {
            soundEffectModal.open();
        }

        const createInitializationHtml = () => {
            if (!townsFolkPlayerList.some(player => player.name === FortuneTeller.name)
                && !outsiderPlayerList.some(player => player.name === Drunk.name)) {
                return "";
            }

            // NOTE: 만약 townsFolkPlayerList 중에 fortune teller 가 있다면 선 플레이어 중 redHerring 세팅
            let initializationHtml = "";

            const fortuneTellerPlayer = Role.getPlayerByRole(townsFolkPlayerList, FortuneTeller);
            if (fortuneTellerPlayer) {
                initializationHtml += `<div name="redHerringDiv">
                    <h4>레드 헤링 선택</h4>
                    <p>
                        1. 레드 헤링(점쟁이에게 악으로 보일 플레이어)을 선택하세요.<br/>
                        * 소규모 게임일 때는 점쟁의 정보가 중요하기 때문에 레드 헤링을 점쟁이 스스로 하는 것도 좋습니다.
                    </p>
                    <button type="button" class="btn btn-info btn-block" onclick="openSetRedHerringModal()">
                        선택 모달 표시
                    </button>
                </div>
                <hr/>`;
            }

            // NOTE: 만약 outsiderPlayerList 중에 drunk 가 있다면 미참여 마을주민 역할과 교환
            const drunkPlayer = Role.getPlayerByRole(outsiderPlayerList, Drunk);
            if (drunkPlayer) {
                initializationHtml += `<div name="drunkDiv">
                    <h4>주정뱅이 마을주민 역할 부여</h4>
                    <p>
                        1. 미참여 마을주민 역할 중 하나를 선택합니다.<br/>
                        2. 주정뱅이 플레이어는 해당 역할로 변경되면서 만취 상태가 됩니다.
                    </p>
                    <button type="button" class="btn btn-info btn-block" onclick="openSetDrunkModal()">
                        선택 모달 표시
                    </button>
                </div>
                <hr/>`;
            }

            return `<div name="initializationDiv">
                        <h3>초기화 단계</h3>
                        \${initializationHtml}
                    </div>`;
        }

        const openSetRedHerringModal = () => {
            const redHerringPlayerList = [
                ...townsFolkPlayerList,
                ...outsiderPlayerList,
                ...minionPlayerList,
            ];

            const chosen = redHerringPlayerList.find(player => player.redHerring);
            if (chosen) {
                alert("선택 완료된 상태입니다.\n" + chosen.playerName + "(" + chosen.title + ")");
                return;
            }

            const goodPlayerListHtml = redHerringPlayerList.reduce((prev, next) => {
                return prev
                    + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                    + " onclick=\"addRedHerringPlayer('" + next.name + "')\" >"
                    + " " + next.playerName + "(" + next.title + ")"
                    + "</button>";
            }, "");

            const $modal = $("#setRedHerringPlayerModal");
            $modal.find("[name='playerListDiv']").empty().html(goodPlayerListHtml);
            $("#setRedHerringPlayerModal").modal("show");

            $modal.find("[name='playerListDiv']").find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
        }

        const addRedHerringPlayer = roleName => {
            const redHerringPlayerList = [
                ...townsFolkPlayerList,
                ...outsiderPlayerList,
                ...minionPlayerList,
            ];

            const chosen = redHerringPlayerList.find(player => player.redHerring);
            if (chosen) {
                return;
            }

            const redHerringPlayer = redHerringPlayerList.find(player => player.name === roleName);
            redHerringPlayer.redHerring = true;

            $("#setRedHerringPlayerModal").modal("hide");
        }

        const openSetDrunkModal = () => {
            const chosen = townsFolkPlayerList.find(player => player.drunken);
            if (chosen) {
                alert("선택 완료된 상태입니다.\n" + chosen.playerName + "(" + chosen.title + ")");
                return;
            }

            const unassignedTownsFolkRoleList = roleList
                .filter(role => role.position.name === POSITION.TOWNS_FOLK.name)
                .filter(role => !townsFolkPlayerList.some(player => role.name === player.name));

            const unassignedTownsFolkPlayerListHtml = unassignedTownsFolkRoleList.reduce((prev, next) => {
                return prev
                    + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                    + " onclick=\"replaceDrunkPlayerToTownsFolk('" + next.name + "')\" >"
                    + " " + next.title
                    + "</button>";
            }, "");

            const $modal = $("#setDrunkPlayerModal");
            $modal.find("[name='roleListDiv']").empty().html(unassignedTownsFolkPlayerListHtml);
            $("#setDrunkPlayerModal").modal("show");

            $modal.find("[name='roleListDiv']").find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
        }

        const replaceDrunkPlayerToTownsFolk = unassignedTownsFolkRoleName => {
            const drunkPlayer = Role.getPlayerByRole(outsiderPlayerList, Drunk);
            const unassignedTownsFolkRole = roleList.find(role => role.name === unassignedTownsFolkRoleName);

            townsFolkPlayerList.push({
                playerName: drunkPlayer.playerName,
                playerId: drunkPlayer.playerId,
                hashKey: drunkPlayer.hashKey,
                seatNumber: drunkPlayer.seatNumber,
                ...unassignedTownsFolkRole,
                redHerring: drunkPlayer.redHerring,
                drunken: true,
            });

            const drunkPlayerIndex = outsiderPlayerList.findIndex(player => player.name === Drunk.name);
            if (drunkPlayerIndex > -1) {
                outsiderPlayerList.splice(drunkPlayerIndex, 1);
            }

            saveGameStatus();

            $("#setDrunkPlayerModal").modal("hide");
        }

        const createDuskHtml = () => {
            const assignedPlayerListHtml = createAssignedPlayerList()
                .sort((prev, next) => prev.seatNumber - next.seatNumber)
                .reduce((prev, next) => {
                    return prev
                        + "<button class=\"" + Role.createChoiceButtonClass(next) + "\" "
                        + " onclick=\"openDuskStepMessageModal('" + next.playerName + "')\" >"
                        + " " + next.playerName + "(" + next.title + ")"
                        + "</button>";
                }, "");

            return `<div name="duskStepDiv">
                <h3>황혼 단계</h3>
                <p>
                    1. 모두 눈을 감았는지 확인하세요.<br/>
                    * 일부 여행자와 전설은 행동합니다.<br/>
                    <!--2. 첫날 밤이라면 첫번째 플레이어부터 순서대로 깨워서 역할을 보여줍니다.<br/>-->
                    2. 각 플레이어들의 자리 배치와 역할을 확인하세요.<br/>
                    * 만약 자기 역할을 미처 확인하지 못한 플레이어가 있다면 깨워서 역할을 보여줍니다.<br/>
                    * 이 때 주정뱅이에게는 변경된 직업으로 보여주게 됩니다.<br/>
                    \${assignedPlayerListHtml}<br/>
                </p>
            </div>
            <hr/>`;
        }

        const openDuskStepMessageModal = playerName => {
            const player = Role.getPlayerByPlayerName(createAssignedPlayerList(), playerName);

            if (player.name === Drunk.name) {
                alert("주정뱅이 마을주민 역할이 부여되지 않았습니다.");
                return;
            }

            if (player.name === FortuneTeller.name) {
                const redHerringPlayerList = [
                    ...townsFolkPlayerList,
                    ...outsiderPlayerList,
                    ...minionPlayerList,
                ];

                const chosen = redHerringPlayerList.find(player => player.redHerring);
                if (!chosen) {
                    alert("레드 헤링이 선택되지 않았습니다.");
                    return;
                }
            }

            const nameClass = Role.calculateRoleNameClass(player.position.name);
            const message = `당신의 역할입니다.<br/><span class=\${nameClass}>\${player.title}</span>`;

            openMessageModal(message);
        }

        const createDawnHtml = () => {
            return `<div name="dawnStepDiv">
                <h3>새벽 단계</h3>
                <p>
                   1. 몇 초 기다린 뒤, 모두 눈을 뜨라고 선언합니다.
                </p>
            </div>`;
        }

        const createMorningHtml = () => {
            return `<div name="morningStepDiv">
                <h3>아침 단계</h3>
                <p>
                    1. 밤 사이 사망한 플레이어를 즉시 선언합니다. 사망한 플레이어가 없다면 아무도 죽지 않았다고 말합니다.<br/>
                    * 이 때 사망하거나 사망하지 않은 이유는 말하면 안됩니다.<br/>
                    2. 플레이어들끼리 토론을 시작하게 합니다.
                </p>
            </div>
            <hr/>`;
        }

        const readLastPlayLog = playId => {
            return gfn_callGetApi("/api/play/log/last", {playId})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
                })
                .catch(response => console.error('error', response));
        }

        const proceedToNextDay = () => {
            if (!confirm("다음 순서로 진행합니다.")) {
                return;
            }

            playStatus.round = playStatus.round + 1;
            playStatus.night = false;
            saveGameStatus();
            $("#firstNightDiv").hide();
            $("#otherNightDiv").hide();

            $("audio[name='backgroundMusic']").each((index, audio) => {
                audio.pause();
            });

            createAssignedPlayerList().forEach(player => {
                player.diedToday = false;
                player.diedTonight = false;
                player.safeByMonk = false;
            });

            renderOtherDay();
        }

        const renderOtherDay = () => {
            const $otherDayDiv = $("#otherDayDiv");
            $otherDayDiv.show();

            $otherDayDiv.find("span[name='roundTitle']").text(playStatus.round);

            const $flowDiv = $otherDayDiv.find("div[name='flowDiv']").empty();
            $flowDiv.empty();

            $flowDiv.append(slayer.createHtml());
            $flowDiv.append(execution.createHtml());
        }

        const proceedToNextNight = () => {
            if (!confirm("다음 순서로 진행합니다.")) {
                return;
            }

            $("audio[name='backgroundMusic']").each((index, audio) => {
                audio.pause();
            });

            const mayorPlayer = Role.getPlayerByRole(townsFolkPlayerList, Mayor);
            if (mayorPlayer
                && !mayorPlayer.died
                && !mayorPlayer.poisoned
                && !mayorPlayer.drunken) {

                const alivePlayerList = createAssignedPlayerList().filter(player => !player.died);
                const diedTodayPlayerList = createAssignedPlayerList().filter(player => player.diedToday);
                if (alivePlayerList.length === 3
                    && diedTodayPlayerList.length === 0) {
                    alert("낮 단계가 끝날 때 생존 플레이어가 3명이고 처형이 발생하지 않았기에 시장 승리조건이 달성되었습니다.");
                    winByGood();
                    mayorPlayer.archivedGoodVictoryCondition = true;
                    saveGameStatus();
                    return;
                }
            }

            playStatus.night = true;
            saveGameStatus();
            $("#firstNightDiv").hide();
            $("#otherDayDiv").hide();

            createAssignedPlayerList().forEach(player => {
                player.poisoned = false;
            });

            renderOtherNight();
        }

        const renderOtherNight = () => {
            const $otherNightDiv = $("#otherNightDiv");
            $otherNightDiv.show();

            $otherNightDiv.find("span[name='roundTitle']").text(playStatus.round);

            const $flowDiv = $otherNightDiv.find("div[name='flowDiv']").empty();
            $flowDiv.empty();

            $flowDiv.append(createDuskHtml());
            $flowDiv.append(poisoner.createHtml());
            $flowDiv.append(monk.createHtml());
            $flowDiv.append(spy.createHtml());
            $flowDiv.append(scarletWoman.createHtml());
            $flowDiv.append(imp.createHtml());
            $flowDiv.append(ravenKeeper.createHtml());
            $flowDiv.append(undertaker.createHtml());
            $flowDiv.append(empath.createHtml());
            $flowDiv.append(fortuneTeller.createHtml());
            $flowDiv.append(butler.createHtml());
            $flowDiv.append(createDawnHtml());

            saveGameStatus();

            // 1. 황혼 단계
            // 2. 독살범
            // 3. 수도승
            // 4. 스파이
            // 5. 부정한 여자
            // 6. 임프
            // 7. 레이븐키퍼
            // 8. 장의사
            // 9. 공감능력자
            // 10. 점쟁이
            // 11. 집사
            // 12. 새벽 단계
        }

        const resetGame = () => {
            if (!confirm("현재까지의 모든 진행 상황을 초기화하고 게임을 처음부터 진행합니다.")) {
                return;
            }

            const request = {
                playId: PLAY_ID
            }

            gfn_callDeleteApi("/api/play/log/all", request)
                .then(data => {
                    console.log('data', data);
                })
                .catch(response => console.error('error', response));

            initializeGame();
        }

        const saveGameStatus = () => {
            const log = {
                playerList: JSON.stringify(playerList),
                /*townsFolkRoleList: JSON.stringify(townsFolkRoleList),
                outsiderRoleList: JSON.stringify(outsiderRoleList),
                minionRoleList: JSON.stringify(minionRoleList),
                demonRoleList: JSON.stringify(demonRoleList),*/
                townsFolkPlayerList: JSON.stringify(townsFolkPlayerList),
                outsiderPlayerList: JSON.stringify(outsiderPlayerList),
                minionPlayerList: JSON.stringify(minionPlayerList),
                demonPlayerList: JSON.stringify(demonPlayerList),
                playStatus: JSON.stringify(playStatus),
                edition,
            }

            const request = {
                playId: PLAY_ID,
                log: JSON.stringify(log)
            }

            gfn_callPostApi("/api/play/save", request)
                .then(data => {
                    console.log('game status saved !!', data);
                })
                .catch(response => console.error('error', response));
        }

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_ID);
            if (!lastPlayLog) {
                return;
            }

            const lastPlayLogJson = JSON.parse(lastPlayLog);
            console.log('lastPlayLogJson', lastPlayLogJson);

            playerList = JSON.parse(lastPlayLogJson.playerList);
            /*townsFolkRoleList = JSON.parse(lastPlayLogJson.townsFolkRoleList);
            outsiderRoleList = JSON.parse(lastPlayLogJson.outsiderRoleList);
            minionRoleList = JSON.parse(lastPlayLogJson.minionRoleList);
            demonRoleList = JSON.parse(lastPlayLogJson.demonRoleList);*/

            townsFolkPlayerList = JSON.parse(lastPlayLogJson.townsFolkPlayerList);
            outsiderPlayerList = JSON.parse(lastPlayLogJson.outsiderPlayerList);
            minionPlayerList = JSON.parse(lastPlayLogJson.minionPlayerList);
            demonPlayerList = JSON.parse(lastPlayLogJson.demonPlayerList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

            setRoleList(EDITION.TROUBLE_BREWING.name);
            console.log('game status loaded !!');
        }

        const diePlayer = diedPlayer => {
            diedPlayer.died = true;
            diedPlayer.diedRound = playStatus.round;
            diedPlayer.nominatable = false;

            if (playStatus.night) {
                diedPlayer.diedTonight = true;
            } else {
                diedPlayer.diedToday = true;
            }

            if (diedPlayer.name === Saint.name
                && diedPlayer.executed) {
                alert("성자가 사망하여 악한 팀이 승리했습니다.");
                // $("#setDiedPlayerByExecutionModal").modal("hide");
                winByEvil();
                saveGameStatus();
                return true;
            }

            const alivePlayerList = createAssignedPlayerList().filter(player => !player.died);

            if (diedPlayer.name === Imp.name) {
                const scarletWomanPlayer = Role.getPlayerByRole(minionPlayerList, ScarletWoman);

                if (scarletWomanPlayer
                    && !scarletWomanPlayer.died) {
                    if (4 <= alivePlayerList.length) {
                        scarletWomanPlayer.changedToImp = true;
                        alert("임프는 사망하였지만 부정한 여자가 새로운 임프가 되었습니다. 게임이 계속 진행됩니다.");
                        return false;
                    }
                }

                alert("모든 악마가 사망하여 선한 팀이 승리했습니다.");
                winByGood();
                saveGameStatus();
                return true;
            }

            const minionPlayer = minionPlayerList.find(minionPlayer => minionPlayer.name === diedPlayer.name);
            if (minionPlayer
                && minionPlayer.changedToImp) {
                alert("임프가 된 하수인이 사망하여 선한 팀이 승리했습니다.");
                winByGood();
                saveGameStatus();
                return true;
            }

            const aliveImpPlayer = Role.getPlayerByRole(alivePlayerList, Imp);
            const changedToImpMinionPlayer = minionPlayerList.find(minionPlayer => !minionPlayer.died && minionPlayer.changedToImp);
            if (aliveImpPlayer
                || changedToImpMinionPlayer) {
                if (alivePlayerList.length <= 2) {
                    alert("임프가 생존한 상태에서 생존한 플레이어의 수가 2 이하가 되어 악한 팀이 승리했습니다.");
                    winByEvil();
                    saveGameStatus();
                    return true;
                }
            }

            alert(diedPlayer.playerName + "(" + diedPlayer.title + ") 플레이어가 사망하였습니다.");
            return false;
        }

        const openNoteModal = () => {
            noteModal.open();
        }

        const openIntroductionModal = () => {
            introductionModal.open();
        }
    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp" %>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">Blood on the Clocktower</h1>
                        <p class="text-lead text-light">custom</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="separator separator-bottom separator-skew zindex-100">
            <svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1"
                 xmlns="http://www.w3.org/2000/svg">
                <polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
            </svg>
        </div>
    </div>
    <!-- Page content -->
    <div class="container mt--7">
        <div class="row">
            <div class="col-xl-12 pr-0 pl-0">
                <div class="card bg-transparent">
                    <div class="card-body p-0">
                        <%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/pocketGrimoire.jspf" %>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-xl-12 mb-5 mb-xl-0">
                <div class="card shadow mt-5 display-none" id="settingDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            게임 세팅
                        </h2>
                    </div>
                    <div class="card-body">
                        <h3>
                            1. 에디션 결정
                        </h3>
                        <h3>
                            2. 그리모어 세팅
                        </h3>
                        <h3>
                            3. 플레이어 역할 지정
                        </h3>
                        <p>
                            1. 목표<br/>
                            시간 단축을 위해...<br/>
                            - 닉네임 입력은 참여자가 직접 하도록 한다.<br/>
                            - 참여자는 주어진 역할을 확인할 수 있다.<br/>
                            <br/>
                            진행 편의를 위해<br/>
                            - 포켓그리모어에서 설정한 역할을 참여자에 맞게 설정할 수 있도록 한다.<br/>
                            자동이면 좋겠지만 안되면 직접 선택이라도<br/>
                            - 어떤 에디션을 쓸 것인지 호스트 화면에서 지정할 수 있게 한다.<br/>
                            지정되면 그에 따라 역할 설명도 자동으로 만들어지도록 한다.<br/>
                            커스톰 스크립트라면 포켓그리모어에 붙혀넣기 할 수 있는 json 생성과 복사 기능을 추가한다.<br/>
                            - 포켓그리모어에서 죽었을 때 호스트 화면에서도 죽음 표시를 할 수 있는 기능을 추가한다.<br/>
                            - 투표 기능은 호스트 화면에서 진행한다.<br/>
                            <br/>
                            게임성을 위해...<br/>
                            - 마을 광장은 참여자 화면에서 볼 수 있게 한다.<br/>
                            - html5 canvas를 이용하여 원형으로 세팅한다.<br/>
                            - 뒤로가기 누르지 말라는 경고 문구를 추가한다.<br/>
                        </p>
                        <div name="playersDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openIntroductionModal()">
                                인트로 보기
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="setPlayersRoleByRandom()">
                                역할 임의 분배
                            </button>
                            <button type="button" class="btn btn-default btn-block"
                                    onclick="openSetPlayerRoleByHostModal()">
                                역할 지정 분배
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="beginGame()">
                                게임 시작
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="firstNightDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            첫번째 밤
                        </h2>
                    </div>
                    <div class="card-body">
                        <%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/backgroundMusic.jspf" %>
                        <hr>
                        <div name="flowDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openIntroductionModal()">
                                인트로 보기
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoleGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openExpertRoleGuideModal()">
                                (임시) 숙련자 모드 역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block"
                                    onclick="openTeensyvilleRoleGuideModal()">
                                (임시) 탄시빌 모드 역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openNightStepGuideModal()">
                                밤 역할 진행 순서
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextDay()">
                                첫 라운드 낮 순서 진행
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openNoteModal()">
                                노트
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openSoundEffectModal()">
                                소리 효과
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="resetGame()">
                                게임 재설정
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="otherDayDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            [<span name="roundTitle"></span>] 번째 낮
                        </h2>
                    </div>
                    <div class="card-body">
                        <h3>
                            배경음악
                        </h3>
                        <h4>닭 소리</h4>
                        <audio name="backgroundMusic"
                               src="https://bogopayo.cafe24.com/sound/cock-rooster-cockerel-scream-sound-100787.mp3"
                               controls></audio>
                        <hr>
                        <h4>church-bell</h4>
                        <audio name="backgroundMusic" src="https://bogopayo.cafe24.com/sound/church-bell-5993.mp3"
                               controls></audio>
                        <hr>
                        <div name="flowDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoleGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openExpertRoleGuideModal()">
                                (임시) 숙련자 모드 역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block"
                                    onclick="openTeensyvilleRoleGuideModal()">
                                (임시) 탄시빌 모드 역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openNightStepGuideModal()">
                                밤 역할 진행 순서
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextNight()">
                                이번 라운드 밤 순서 진행
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openNoteModal()">
                                노트
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openSoundEffectModal()">
                                소리 효과
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="resetGame()">
                                게임 재설정
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="otherNightDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            [<span name="roundTitle"></span>] 번째 밤
                        </h2>
                    </div>
                    <div class="card-body">
                        <%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/backgroundMusic.jspf" %>
                        <hr>
                        <div name="flowDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="openQrLoginModal()">
                                로그인 QR 공유
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoleGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openExpertRoleGuideModal()">
                                (임시) 숙련자 모드 역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block"
                                    onclick="openTeensyvilleRoleGuideModal()">
                                (임시) 탄시빌 모드 역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openNightStepGuideModal()">
                                밤 역할 진행 순서
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextDay()">
                                다음 라운드 낮 순서 진행
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openNoteModal()">
                                노트
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="openSoundEffectModal()">
                                소리 효과
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="resetGame()">
                                게임 재설정
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<div class="modal fade" id="setRedHerringPlayerModal" role="dialog"
     aria-labelledby="setRedHerringPlayerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">이야기꾼이 점쟁이에게 악으로 보일 플레이어를 선택합니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div name="playerListDiv"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-block" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="setDrunkPlayerModal" role="dialog"
     aria-labelledby="setDrunkPlayerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">주정뱅이와 교체될 마을주민 역할을 선택합니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div name="roleListDiv"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-block" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="setPlayerRoleByHostModal" role="dialog"
     aria-labelledby="setDrunkPlayerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">이번 게임에서 사용될 역할을 선택합니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>
                    추천 조합(8인 기준)<br/>
                    - 밸런스 : 요리사, 공감능력자, 점쟁이, 장의사, 처녀, 주정뱅이(조사관), 부정한 여자, 임프<br/>
                    - 조용한 게임 : 공감능력자, 점쟁이, 레이븐키퍼, 슬레이어, 시장, 성자, 독살범, 임프<br/>
                    - 숙련자 게임 : 세탁부, 점쟁이, 장의사, 슬레이어, 처녀, 은둔자, 스파이, 임프<br/>
                </p>
                <h3>마을 주민</h3>
                <div name="townsFolkRoleListDiv"></div>
                <div name="townsFolkRoleSetListDiv"></div>
                <hr>
                <h3>이방인</h3>
                <div name="outsiderRoleListDiv"></div>
                <div name="outsiderRoleSetListDiv"></div>
                <hr>
                <h3>하수인</h3>
                <div name="minionRoleListDiv"></div>
                <div name="minionRoleSetListDiv"></div>
                <hr>
                <h3>악마</h3>
                <div name="demonRoleListDiv"></div>
                <div name="demonRoleSetListDiv"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="setPlayersRoleByHost()">
                    역할 지정
                </button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/introductionModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/messageModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/playStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/townModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/minion.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/imp.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/poisoner.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/spy.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/washerWoman.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/librarian.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/investigator.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/chef.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/empath.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/fortuneTeller.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/butler.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/slayer.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/execution.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/monk.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/scarletWoman.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/ravenKeeper.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/undertaker.jspf" %>

<%@ include file="/WEB-INF/jsp/game/boc/guide/ruleGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/nightStepGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/roleGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/expertRoleGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/teensyvilleRoleGuideModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/noteModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/soundEffectModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/qrLoginModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
