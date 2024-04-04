<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/fo/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/fo/constants.js'/>"></script>
    <script src="<c:url value='/js/fo/roles.js'/>"></script>

    <script>
        const PLAY_NO = ${playNo};
        let playerList = [];
        let roleList = [];
        let demonPlayerList = [];
        let minionPlayerList = [];
        let townsFolkPlayerList = [];
        let outsiderPlayerList = [];
        const playStatus = {
            round: 0,
            night: false,
        }
        /*
        1. 참가자 자리 배치
        2. 그리모어 준비
        3. 에디션 선택
        4. 마을 광장 준비
        5. 규칙 설명
        6. 비공개적으로 캐릭터 선택
        7. 캐릭터 추가 및 제거
        8. 알림 토큰 추가
        9. 캐릭터 토큰 분배
        10. 그리모어에 캐릭터 토큰 추가
        11. 첫날 밤
         */

        $(() => {
            console.log('initializationSetting', initializationSetting);
            const play = {
                round: 0,
            }
            localStorage.play = play;

            roleList = [
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
                new Butler(),
                new Drunk(),
                new Recluse(),
                new Saint(),
                new Poisoner(),
                new Spy(),
                new Baron(),
                new ScarletWomen(),
                new Imp(),
            ];

            renderPlayMemberList();
        });

        const renderPlayMemberList = async () => {
            playerList = await readPlayMemberList(PLAY_NO);

            const $settingDiv = $("#settingDiv");
            const $playersDiv = $settingDiv.find("div[name='playersDiv']");

            const htmlString = playerList.reduce((prev, next) => {
                return prev +
                    "<div class=\"form-group form-inline\">" +
                    "   <label class=\"form-control-label\">" + next.nickNm + "</label>" +
                    "   <input type=\"text\" class=\"form-control form-control-alternative\" name=\"roleName\" readonly" +
                    "       data-member-id=\"" + next.mmbrNo + "\">" +
                    "</div>";
            }, "");

            $playersDiv.append(htmlString);
        }

        const readPlayMemberList = playNo => {
            return gfn_callGetApi("/api/game/play/member/list", {playNo})
                .then(data => {
                    console.log('data', data);
                    return data;
                })
                .catch(response => console.error('error', response));
        }

        const setPlayersRole = () => {
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

            showPlayerRoleList(townsFolkPlayerList);
            showPlayerRoleList(outsiderPlayerList);
            showPlayerRoleList(minionPlayerList);
            showPlayerRoleList(demonPlayerList);

            /*localStorage.townsFolkPlayerList = JSON.stringify(townsFolkPlayerList);
            localStorage.outsiderPlayerList = JSON.stringify(outsiderPlayerList);
            localStorage.minionPlayerList = JSON.stringify(minionPlayerList);
            localStorage.demonPlayerList = JSON.stringify(demonPlayerList);

            const savedTownsFolkPlayerList = JSON.parse(localStorage.townsFolkPlayerList);
            console.log('savedTownsFolkPlayerList', savedTownsFolkPlayerList);*/
        }

        const createPlayerList = (roleList, playerList, playerNumber, position) => {
            return roleList
                .filter(role => role.position === position)
                .sort(() => Math.random() - 0.5)
                .slice(0, playerNumber)
                .map(role => {
                    const player = playerList.pop();
                    return {...role, playerName: player.nickNm, playerId: player.mmbrNo};
                });
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
                $(found).addClass(calculateRoleNameClass(player.position.name));
            });
        }

        const calculateRoleNameClass = positionName => {
            if (positionName === "towns folk") {
                return "text-primary";
            }

            if (positionName === "outsider") {
                return "text-info";
            }

            if (positionName === "minion") {
                return "text-warning";
            }

            return "text-danger"
        }

        const beginGame = () => {
            $("#settingDiv").hide();

            const $firstNightDiv = $("#firstNightDiv");
            $firstNightDiv.show();
            const $flowDiv = $firstNightDiv.find("div[name='flowDiv']").empty();
            $flowDiv.empty();

            $flowDiv.append(createInitializationHtml());
            $flowDiv.append(createDuskHtml());
            $flowDiv.append(createMinionHtml());
            $flowDiv.append(createImpHtml());
            $flowDiv.append(createPoisonerHtml());
            $flowDiv.append(createSpyHtml());
            $flowDiv.append(createWasherWomanHtml());


            /*
            <div name="minionDiv"></div>
            <div name="impDiv"></div>
            <div name="poisonerDiv"></div>
            <div name="spyDiv"></div>
            <div name="washerWomanDiv"></div>
            <div name="librarianDiv"></div>
            <div name="investigatorDiv"></div>
            <div name="chefDiv"></div>
            <div name="empathDiv"></div>
            <div name="fortuneTellerDiv"></div>
            <div name="butlerDiv"></div>
            <div name="dawnStepDiv"></div>*/

            // 0. 초기화
            // 1. 황혼 단계
            // 2. 하수인 정보
            // 3. 악마 정보
            // 4. 독살범
            // 5. 스파이
            // 6. 세탁부
            // 7. 사서
            // 8. 조사관
            // 9. 요리사
            // 11. 공감능력자
            // 12. 점쟁이
            // 13. 집사
            // 14. 새벽 단계

        }

        const openMessageModal = messageHtml => {
            messageModal.open(messageHtml);
            /*const $modal = $("#messageModal");
            $modal.find(".modal-body").css("min-height", window.innerHeight * 0.8);
            $modal.find("[name='message']").empty().html(messageHtml);
            $("#messageModal").modal("show");*/
        }

        const createAssignedPlayerList = () => [
            ...townsFolkPlayerList,
            ...outsiderPlayerList,
            ...minionPlayerList,
            ...demonPlayerList,
        ];

        const openShowPlayStatusModal = () => {
            /*const $modal = $("#showPlayStatusModal");
            $modal.find("[name='playerListDiv']").empty().html(playerListHtml);
            $("#showPlayStatusModal").modal("show");*/

            showPlayStatusModal.open(createAssignedPlayerList());
        }

        const createChoiceButtonClass = role => {
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
                        1. 레드 헤링(점쟁이에게 악으로 보일 플레이어)을 선택하세요.
                    </p>
                    <button type="button" class="btn btn-primary btn-block" onclick="openSetRedHerringModal()">
                        선택 모달 표시
                    </button>
                </div>
                <hr/>`;
            }

            // NOTE: 만약 outsiderPlayerList 중에 drunk 가 있다면 미참여 마을 주민 역할과 교환
            const drunkPlayer = Role.getPlayerByRole(outsiderPlayerList, Drunk);
            if (drunkPlayer) {
                initializationHtml += `<div name="drunkDiv">
                    <h4>주정뱅이 마을 주민 역할 부여</h4>
                    <p>
                        1. 미참여 마을 주민 역할 중 하나를 선택합니다.<br/>
                        2. 주정뱅이 플레이어는 해당 역할로 변경되면서 만취 상태가 됩니다.
                    </p>
                    <button type="button" class="btn btn-primary btn-block" onclick="openSetDrunkModal()">
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
            const goodPlayerList = [
                ...townsFolkPlayerList,
                ...outsiderPlayerList,
            ];

            const chosen = goodPlayerList.find(player => player.redHerring);
            if (chosen) {
                alert("선택 완료된 상태입니다.\n" + chosen.playerName + "(" + chosen.title + ")");
                return;
            }

            const goodPlayerListHtml = goodPlayerList.reduce((prev, next) => {
                return prev
                    + "<button class=\"" + createChoiceButtonClass(next) + "\" "
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
            const goodPlayerList = [
                ...townsFolkPlayerList,
                ...outsiderPlayerList,
            ];

            const chosen = goodPlayerList.find(player => player.redHerring);
            if (chosen) {
                return;
            }

            const redHerringPlayer = goodPlayerList.find(player => player.name === roleName);
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
                    + "<button class=\"" + createChoiceButtonClass(next) + "\" "
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
                ...unassignedTownsFolkRole,
                playerName: drunkPlayer.playerName,
                playerId: drunkPlayer.playerId,
                drunken: true,
            });

            const drunkPlayerIndex = outsiderPlayerList.findIndex(player => player.name === Drunk.name);
            if (drunkPlayerIndex > -1) {
                outsiderPlayerList.splice(drunkPlayerIndex, 1);
            }

            $("#setDrunkPlayerModal").modal("hide");
        }

        const createDuskHtml = () => {
            return `<div name="duskStepDiv">
                <h3>새벽 단계</h3>
                <p>
                   1. 모두 눈을 감았는지 확인하세요.<br/>
                   * 일부 여행자와 전설은 행동합니다.
                </p>
            </div>
            <hr/>`;
        }

        const createMinionHtml = () => {
            if (minionPlayerList.length === 0) {
                return "";
            }

            const minionPlayerListHtml = minionPlayerList.reduce((prev, next) => {
                return prev + next.playerName + "(" + next.title + ") ";
            }, "");

            const impPlayer = Role.getPlayerByRole(demonPlayerList, Imp);
            const impPlayerHtml = impPlayer.playerName;
            const messageHtml = `임프<br/> - \${impPlayerHtml}`;

            return `<div name="minionDiv">
                <h3>하수인 정보</h3>
                <p>
                    1. 다음 플레이어를(들을) 깨우세요.<br/>
                    \${minionPlayerListHtml}<br/>
                    2. 메세지 모달을 띄운 뒤 보여주세요.<br/>
                    3. 눈을 감게 하세요.
                </p>
                <button type="button" class="btn btn-info btn-block" onclick="openMessageModal('\${messageHtml}')">
                    메세지 모달 표시
                </button>
            </div>
            <hr/>`;
        }

        const createImpHtml = () => {
            const impPlayer = Role.getPlayerByRole(demonPlayerList, Imp);
            const impPlayerHtml = impPlayer.playerName;

            const minionPlayerListHtml = minionPlayerList.reduce((prev, next) => {
                return prev + next.playerName + " ";
            }, "");

            const messageHtml = `하수인<br/> - \${minionPlayerListHtml}`;

            return `<div name="impDiv">
                <h3>악마 정보</h3>
                <p>
                    1. 다음 플레이어를(들을) 깨우세요.<br/>
                    \${impPlayerHtml}<br/>
                    2. 임프 플레이어에게 보여줄 3가지 선한 역할을 골라주세요.<br/>
                    3. 메세지 모달을 띄운 뒤 보여주세요.<br/>
                    4. 눈을 감게 하세요.
                </p>
                <button type="button" class="btn btn-primary btn-block" onclick="openOfferTownsFolkRoleToImpModal()">
                    선택 모달 표시
                </button>
                <button type="button" class="btn btn-info btn-block" onclick="openImpMessageModal('\${messageHtml}')">
                    메세지 모달 표시
                </button>
                <button type="button" class="btn btn-warning btn-block" onclick="resetOfferTownsFolkRoleToImp()">
                    선택 재설정
                </button>
            </div>
            <hr/>`;
        }

        const openImpMessageModal = messageHtml => {
            const impPlayer = Role.getPlayerByRole(demonPlayerList, Imp);

            const offeredTownsFolkRoleNameHtml = impPlayer.offeredTownsFolkRoleList.reduce((prev, next) => {
                return prev + " - " + next + "<br/>";
            }, "");

            openMessageModal(messageHtml + "<hr>미참여 마을 주민 역할<br/>" + offeredTownsFolkRoleNameHtml);
        }

        const openOfferTownsFolkRoleToImpModal = () => {
            const impPlayer = Role.getPlayerByRole(demonPlayerList, Imp);

            if (impPlayer.offeredTownsFolkRoleList.length > 2) {
                const offeredTownsFolkRoleNameHtml = impPlayer.offeredTownsFolkRoleList.reduce((prev, next) => {
                    return prev + next + " ";
                }, "");

                alert("선택 완료된 상태입니다.\n" + offeredTownsFolkRoleNameHtml);
                return;
            }

            const offeredTownsFolkRoleList = [...roleList]
                .filter(role => role.position.name === POSITION.TOWNS_FOLK.name)
                .filter(role => !townsFolkPlayerList.some(player => role.name === player.name));

            const offeredTownsFolkRoleListHtml = offeredTownsFolkRoleList.reduce((prev, next) => {
                return prev
                    + "<button class=\"" + createChoiceButtonClass(next) + "\" "
                    + " onclick=\"addOfferedTownsFolkRoleList('" + next.title + "', '" + next.name + "')\" >"
                    + " " + next.title
                    + "</button>";
            }, "");

            const $modal = $("#offerTownsFolkRoleToImpModal");
            $modal.find("[name='townsFolkRoleListDiv']").empty().html(offeredTownsFolkRoleListHtml);
            $("#offerTownsFolkRoleToImpModal").modal("show");

            $modal.find("[name='townsFolkRoleListDiv']").find("button").on("click", event => {
                $(event.currentTarget).hide();
            })
        }

        const addOfferedTownsFolkRoleList = (roleTitle, roleName) => {
            const impPlayer = Role.getPlayerByRole(demonPlayerList, Imp);

            if (impPlayer.offeredTownsFolkRoleList.length > 2) {
                return;
            }

            impPlayer.offeredTownsFolkRoleList.push(roleTitle);

            if (impPlayer.offeredTownsFolkRoleList.length > 2) {
                $("#offerTownsFolkRoleToImpModal").modal("hide");
                return;
            }
        }

        const resetOfferTownsFolkRoleToImp = () => {
            const impPlayer = Role.getPlayerByRole(demonPlayerList, Imp);
            impPlayer.offeredTownsFolkRoleList = [];
        }

        const createPoisonerHtml = () => {
            const poisonerPlayer = Role.getPlayerByRole(minionPlayerList, Poisoner);
            if (!poisonerPlayer) {
                return "";
            }
            const poisonerPlayerHtml = poisonerPlayer.playerName;

            const minionPlayerListHtml = minionPlayerList.reduce((prev, next) => {
                return prev + next.playerName + "(" + next.title + ") ";
            }, "");

            const messageHtml = `중독시킬 플레이어를 손가락으로 지목해 주세요.`;

            return `<div name="poisonerDiv">
                <h3>독살범</h3>
                <p>
                    1. 다음 플레이어를(들을) 깨우세요.<br/>
                    \${poisonerPlayerHtml}<br/>
                    2. 메세지 모달을 띄운 뒤 보여주세요.<br/>
                    3. 그가 지목한 플레이어를 선택합니다.<br/>
                    4. 눈을 감게 하세요.
                </p>
                <button type="button" class="btn btn-info btn-block" onclick="openMessageModal('\${messageHtml}')">
                    메세지 모달 표시
                </button>
                <button type="button" class="btn btn-primary btn-block" onclick="openSetPoisonedPlayerModal()">
                    선택 모달 표시
                </button>
            </div>
            <hr/>`;
        }

        const openSetPoisonedPlayerModal = () => {
            const poisonerPlayer = Role.getPlayerByRole(minionPlayerList, Poisoner);

            const chosen = poisonerPlayer.poisoningPlayerByRound.find(choice => choice.round === playStatus.round);
            if (chosen) {
                alert("선택 완료된 상태입니다.\n" + chosen.playerName);
                return;
            }

            const offeredTownsFolkRoleListHtml = createAssignedPlayerList().reduce((prev, next) => {
                return prev
                    + "<button class=\"" + createChoiceButtonClass(next) + "\" "
                    + " onclick=\"addPoisonedPlayer('" + next.playerName + "', '" + next.title + "')\" >"
                    + " " + next.playerName
                    + "</button>";
            }, "");

            const $modal = $("#setPoisonedPlayerModal");
            $modal.find("[name='playerListDiv']").empty().html(offeredTownsFolkRoleListHtml);
            $("#setPoisonedPlayerModal").modal("show");

            $modal.find("[name='playerListDiv']").find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
        }

        const addPoisonedPlayer = (playerName, title) => {
            const poisonerPlayer = Role.getPlayerByRole(minionPlayerList, Poisoner);

            const chosen = poisonerPlayer.poisoningPlayerByRound.find(choice => choice.round === playStatus.round);
            if (chosen) {
                return;
            }

            poisonerPlayer.poisoningPlayerByRound.push({
                round: playStatus.round,
                playerName,
                title,
            });

            const poisonedPlayer = Role.getPlayerByTitle(createAssignedPlayerList(), title);
            poisonedPlayer.poisoned = true;

            $("#setPoisonedPlayerModal").modal("hide");
        }

        const createSpyHtml = () => {
            const spyPlayer = Role.getPlayerByRole(minionPlayerList, Spy);
            if (!spyPlayer) {
                return "";
            }

            const spyPlayerHtml = spyPlayer.playerName;

            const messageHtml = `현재 플레이 상태를 보여드리겠습니다.`;

            return `<div name="spyDiv">
                <h3>스파이</h3>
                <p>
                    1. 다음 플레이어를(들을) 깨우세요.<br/>
                    \${spyPlayerHtml}<br/>
                    2. 메세지 모달을 띄운 뒤 보여주세요.<br/>
                    3. 플레이 상태 모달을 띄운 뒤 보여주세요.<br/>
                    4. 눈을 감게 하세요.<br/>
                    * 그가 다른 플레이어들에게 감지될 때 보여지게 할 선한 역할은 플레이 중 스토리텔러가 선택합니다.
                </p>
                <button type="button" class="btn btn-info btn-block" onclick="openMessageModal('\${messageHtml}')">
                    메세지 모달 표시
                </button>
                <button type="button" class="btn btn-primary btn-block" onclick="openShowPlayStatusModal()">
                    플레이 상태 모달 표시
                </button>
            </div>
            <hr/>`;
        }

        const createWasherWomanHtml = () => {
            const washerWomanPlayer = Role.getPlayerByRole(townsFolkPlayerList, WasherWoman);
            if (!washerWomanPlayer) {
                return "";
            }

            const playerStatusListHtml = Role.createPlayerStatusListHtml(washerWomanPlayer);

            const washerWomanPlayerHtml = washerWomanPlayer.playerName
                + (playerStatusListHtml === "" ? "" : "(" + playerStatusListHtml + ")");

            return `<div name="spyDiv">
                <h3>세탁부</h3>
                <p>
                    1. 세탁부에게 알려줄 두 명의 플레이어와 역할 한 가지를 선택하세요.<br/>
                    * 정상인 상태라면 둘 중 하나 이상은 마을 주민이어야 합니다.<br/>
                    * 취했거나 중독된 상태라면 아무렇게나 고를 수 있습니다.<br/>
                    2. 다음 플레이어를(들을) 깨우세요.<br/>
                    \${washerWomanPlayerHtml}<br/>
                    3. 메세지 모달을 띄운 뒤 보여주세요.<br/>
                    4. 눈을 감게 하세요.
                </p>
                <button type="button" class="btn btn-primary btn-block" onclick="openIdentifyWasherWomanModal()">
                    선택 모달 표시
                </button>
                <button type="button" class="btn btn-info btn-block" onclick="openWasherWomanMessageModal()">
                    메세지 모달 표시
                </button>
                <button type="button" class="btn btn-warning btn-block" onclick="resetIdentifyWasherWoman()">
                    선택 재설정
                </button>
            </div>
            <hr/>`;
        }

        const openIdentifyWasherWomanModal = () => {
            const washerWomanPlayer = Role.getPlayerByRole(townsFolkPlayerList, WasherWoman);
            if (!washerWomanPlayer.skillAvailable) {
                return;
            }

            let identifyingPlayerListHtml = "";
            if (washerWomanPlayer.identifyingPlayerList.length == 2) {
                alert(
                    "플레이어들은 선택 완료된 상태입니다.\n"
                    + washerWomanPlayer.identifyingPlayerList[0].playerName
                    + "(" + washerWomanPlayer.identifyingPlayerList[0].title + ")\n"
                    + washerWomanPlayer.identifyingPlayerList[1].playerName
                    + "(" + washerWomanPlayer.identifyingPlayerList[1].title + ")"
                );
            } else {
                identifyingPlayerListHtml = createAssignedPlayerList().reduce((prev, next) => {
                    if (next.name === WasherWoman.name) {
                        return prev;
                    }

                    if (washerWomanPlayer.identifyingPlayerList.some(player => player.playerName === next.playerName)) {
                        return prev;
                    }

                    return prev
                        + "<button class=\"" + createChoiceButtonClass(next) + "\" "
                        + " onclick=\"addIdentifiedPlayerForWasherWoman('" + next.playerName + "', '" + next.title + "')\" >"
                        + " " + next.playerName + "(" + next.title + ")"
                        + "</button>";
                }, "");
            }

            let identifyingRoleListHtml = "";
            if (washerWomanPlayer.identifyingTownsFolkRole) {
                alert(
                    "역할은 선택 완료된 상태입니다.\n"
                    + washerWomanPlayer.identifyingTownsFolkRole.title
                );
            } else {
                identifyingRoleListHtml = townsFolkPlayerList.reduce((prev, next) => {
                    if (next.name === WasherWoman.name) {
                        return prev;
                    }

                    return prev
                        + "<button class=\"" + createChoiceButtonClass(next) + "\" "
                        + " onclick=\"addIdentifiedRoleForWasherWoman('" + next.name + "', '" + next.title + "')\" >"
                        + " " + next.title
                        + "</button>";
                }, "");
            }

            const $modal = $("#setIdentifyWasherWomanModal");
            $modal.find("[name='playerListDiv']").empty().html(identifyingPlayerListHtml);
            $modal.find("[name='roleListDiv']").empty().html(identifyingRoleListHtml);

            $("#setIdentifyWasherWomanModal").modal("show");

            $modal.find("[name='playerListDiv']").find("button").on("click", event => {
                $(event.currentTarget).hide();
            });
        }

        const addIdentifiedPlayerForWasherWoman = (playerName, title) => {
            const washerWomanPlayer = Role.getPlayerByRole(townsFolkPlayerList, WasherWoman);

            if (washerWomanPlayer.identifyingPlayerList.length == 2) {
                alert(
                    "플레이어들은 선택 완료된 상태입니다.\n"
                    + washerWomanPlayer.identifyingPlayerList[0].playerName
                    + "(" + washerWomanPlayer.identifyingPlayerList[0].title + ")\n"
                    + washerWomanPlayer.identifyingPlayerList[1].playerName
                    + "(" + washerWomanPlayer.identifyingPlayerList[1].title + ")"
                );
                return;
            }

            washerWomanPlayer.identifyingPlayerList.push({
                playerName,
                title,
            });

            if (washerWomanPlayer.identifyingPlayerList.length == 2
                && washerWomanPlayer.identifyingTownsFolkRole) {
                washerWomanPlayer.skillAvailable = false;
                $("#setIdentifyWasherWomanModal").modal("hide");
            }
        }

        const addIdentifiedRoleForWasherWoman = (roleName, title) => {
            const washerWomanPlayer = Role.getPlayerByRole(townsFolkPlayerList, WasherWoman);

            if (washerWomanPlayer.identifyingTownsFolkRole) {
                alert(
                    "역할은 선택 완료된 상태입니다.\n"
                    + washerWomanPlayer.identifyingTownsFolkRole.title
                );
                return;
            }

            washerWomanPlayer.identifyingTownsFolkRole = {
                roleName,
                title
            };

            if (washerWomanPlayer.identifyingPlayerList.length == 2
                && washerWomanPlayer.identifyingTownsFolkRole) {
                washerWomanPlayer.skillAvailable = false;
                $("#setIdentifyWasherWomanModal").modal("hide");
            }
        }

        const openWasherWomanMessageModal = () => {
            const washerWomanPlayer = Role.getPlayerByRole(townsFolkPlayerList, WasherWoman);
            if (washerWomanPlayer.skillAvailable) {
            /*if (washerWomanPlayer.identifyingPlayerList.length !== 2
                || !washerWomanPlayer.identifyingTownsFolkRole) {*/
                alert("플레이어 2명과 알려줄 역할이 먼저 선택되어야 합니다.");
                return;
            }

            let messageHtml = `다음 두 플레이어 중 한 명은 \${washerWomanPlayer.identifyingTownsFolkRole.title} 입니다.</br>`;

            messageHtml += washerWomanPlayer.identifyingPlayerList.reduce((prev, next) => {
                return prev + " - " + next.playerName + "<br/>";
            }, "");

            openMessageModal(messageHtml);
        }

        const resetIdentifyWasherWoman = () => {
            const washerWomanPlayer = Role.getPlayerByRole(townsFolkPlayerList, WasherWoman);
            washerWomanPlayer.identifyingPlayerList = [];
            washerWomanPlayer.identifyingTownsFolkRole = null;
            washerWomanPlayer.skillAvailable = true;
        }


        const proceedToFirstDay = () => {

            renderOtherDay();
        }

        const renderOtherDay = () => {

        }

        const renderOtherNight = () => {

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
                        <p class="text-lead text-light">trouble brewing</p>
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
            <div class="col-xl-12 mb-5 mb-xl-0">
                <div class="card shadow mt-5" id="settingDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            게임 세팅
                        </h2>
                    </div>
                    <div class="card-body">
                        <div name="playersDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default" onclick="setPlayersRole()">
                                역할 분배
                            </button>
                            <button type="button" class="btn btn-primary" onclick="beginGame()">
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
                    <div class="card-body" name="flowDiv">
                        <div name="duskStepDiv"></div>
                        <div name="minionDiv"></div>
                        <div name="demonDiv"></div>
                        <div name="poisonerDiv"></div>
                        <div name="spyDiv"></div>
                        <div name="washerWomanDiv"></div>
                        <div name="librarianDiv"></div>
                        <div name="investigatorDiv"></div>
                        <div name="chefDiv"></div>
                        <div name="empathDiv"></div>
                        <div name="fortuneTellerDiv"></div>
                        <div name="butlerDiv"></div>
                        <div name="dawnStepDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToFirstDay()">
                                첫 라운드 진행
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
                <h4 class="">스토리텔러가 점쟁이에게 악으로 보일 플레이어를 선택합니다.</h4>
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
                <h4 class="">주정뱅이와 교체될 마을 주민 역할을 선택합니다.</h4>
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

<div class="modal fade" id="offerTownsFolkRoleToImpModal" role="dialog"
     aria-labelledby="offerTownsFolkRoleToImpModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">스토리텔러가 임프에게 제공할 역할을 선택합니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div name="townsFolkRoleListDiv"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-block" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<div class="modal fade" id="setPoisonedPlayerModal" role="dialog"
     aria-labelledby="setPoisonedPlayerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">독살범이 중독시킬 플레이어를 선택합니다.</h4>
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

<div class="modal fade" id="setIdentifyWasherWomanModal" role="dialog"
     aria-labelledby="setIdentifyWasherWomanModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">세탁부에게 알려줄 플레이어와 역할을 선택합니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div name="playerListDiv"></div>
                <hr>
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

<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/modal/messageModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/modal/showPlayStatusModal.jspf" %>

<!-- 회원프로필 -->
<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
