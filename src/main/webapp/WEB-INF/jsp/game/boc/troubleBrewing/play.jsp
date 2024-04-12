<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/troubleBrewing/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/boc/troubleBrewing/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/troubleBrewing/roles.js'/>"></script>

    <script>
        const PLAY_NO = ${playNo};
        let playerList = [];
        let roleList = [];
        let demonPlayerList = [];
        let minionPlayerList = [];
        let townsFolkPlayerList = [];
        let outsiderPlayerList = [];
        let playStatus = {};
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

        $(async () => {
            await loadGameStatus();

            if (!playStatus) {
                await initializeGame();
                return;
            }

            console.log('playStatus', playStatus);
            if (0 < playStatus.round) {
                if (playStatus.night) {
                    renderOtherNight();
                    return;
                }

                renderOtherDay();
                return;
            }

            playerList.sort((prev, next) => prev.seatNumber - next.seatNumber);

            renderPlayMemberList(playerList);
            showAllPlayerRoleList();
            $("#settingDiv").show();
        });

        const initializeGame = async () => {
            console.log('initializationSetting', initializationSetting);

            playStatus = {
                round: 0,
                night: true,
            }

            $("#settingDiv").show();
            $("#firstNightDiv").hide();
            $("#otherDayDiv").hide();
            $("#otherNightDiv").hide();

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

            const originalPlayerList = await readPlayMemberList(PLAY_NO);

            playerList = originalPlayerList
                .sort(() => Math.random() - 0.5)
                .map((originalPlayer, index) => {
                    return {...originalPlayer, seatNumber: index};
                });

            renderPlayMemberList(playerList);
        };

        const renderPlayMemberList = playerList => {
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
                    // console.log('data', data);
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
        }

        const createPlayerList = (roleList, playerList, playerNumber, position) => {
            return roleList
                .filter(role => role.position === position)
                .sort(() => Math.random() - 0.5)
                .slice(0, playerNumber)
                .map(role => {
                    const player = playerList.pop();
                    return {...role, playerName: player.nickNm, playerId: player.mmbrNo, seatNumber: player.seatNumber};
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
            // 10. 공감능력자
            // 11. 점쟁이
            // 12. 집사
            // 13. 새벽 단계

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

        const openShowPlayStatusModal = () => {
            showPlayStatusModal.open(createAssignedPlayerList());
        }

        const openTownModal = () => {
            // showPlayStatusModal.open(createAssignedPlayerList());
            window.open("/game/trouble-brewing/town/" + PLAY_NO, "_blank");
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

            // NOTE: 만약 outsiderPlayerList 중에 drunk 가 있다면 미참여 마을 주민 역할과 교환
            const drunkPlayer = Role.getPlayerByRole(outsiderPlayerList, Drunk);
            if (drunkPlayer) {
                initializationHtml += `<div name="drunkDiv">
                    <h4>주정뱅이 마을 주민 역할 부여</h4>
                    <p>
                        1. 미참여 마을 주민 역할 중 하나를 선택합니다.<br/>
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
                ...unassignedTownsFolkRole,
                playerName: drunkPlayer.playerName,
                playerId: drunkPlayer.playerId,
                redHerring: drunkPlayer.redHerring,
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
                <h3>황혼 단계</h3>
                <p>
                   1. 모두 눈을 감았는지 확인하세요.<br/>
                   * 일부 여행자와 전설은 행동합니다.
                </p>
            </div>
            <hr/>`;
        }

        const createDawnHtml = () => {
            return `<div name="dawnStepDiv">
                <h3>새벽 단계</h3>
                <p>
                   1. 몇 초 기다린 뒤, 모두 눈을 뜨라고 선언합니다.
                </p>
            </div>
            <hr/>`;
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

        const readLastPlayLog = playNo => {
            return gfn_callGetApi("/api/game/play/log/last", {playNo})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
                })
                .catch(response => console.error('error', response));
        }

        const proceedToNextDay = () => {
            playStatus.round = playStatus.round + 1;
            playStatus.night = false;
            saveGameStatus();
            $("#firstNightDiv").hide();
            $("#otherNightDiv").hide();

            renderOtherDay();
        }

        const renderOtherDay = () => {
            const $otherDayDiv = $("#otherDayDiv");
            $otherDayDiv.show();

            $otherDayDiv.find("span[name='roundTitle']").text(playStatus.round);

            const $flowDiv = $otherDayDiv.find("div[name='flowDiv']").empty();
            $flowDiv.empty();

            /*$flowDiv.append(createInitializationHtml());
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
            $flowDiv.append(createDawnHtml());*/


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
            // 10. 공감능력자
            // 11. 점쟁이
            // 12. 집사
            // 13. 새벽 단계

        }

        const proceedToNextNight = () => {
            playStatus.night = true;
            saveGameStatus();
            $("#firstNightDiv").hide();
            $("#otherDayDiv").hide();

            renderOtherNight();
        }

        const renderOtherNight = () => {
            const $otherNightDiv = $("#otherNightDiv");
            $otherNightDiv.show();

            $otherNightDiv.find("span[name='roundTitle']").text(playStatus.round);


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
                playNo: PLAY_NO
            }

            gfn_callDeleteApi("/api/game/play/log/all", request)
                .then(data => {
                    console.log('data', data);
                })
                .catch(response => console.error('error', response));

            initializeGame();
        }

        const saveGameStatus = () => {
            const log = {
                playerList: JSON.stringify(playerList),
                roleList: JSON.stringify(roleList),
                townsFolkPlayerList: JSON.stringify(townsFolkPlayerList),
                outsiderPlayerList: JSON.stringify(outsiderPlayerList),
                minionPlayerList: JSON.stringify(minionPlayerList),
                demonPlayerList: JSON.stringify(demonPlayerList),
                playStatus: JSON.stringify(playStatus),
            }

            const request = {
                playNo: PLAY_NO,
                log: JSON.stringify(log)
            }

            gfn_callPostApi("/api/game/play/save", request)
                .then(data => {
                    console.log('data', data);
                    alert("저장되었습니다.");
                })
                .catch(response => console.error('error', response));
        }

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_NO);
            if (!lastPlayLog) {
                return;
            }
            // console.log('lastPlayLog', lastPlayLog);

            const lastPlayLogJson = JSON.parse(lastPlayLog);
            console.log('lastPlayLogJson', lastPlayLogJson);

            playerList = JSON.parse(lastPlayLogJson.playerList);
            roleList = JSON.parse(lastPlayLogJson.roleList);
            townsFolkPlayerList = JSON.parse(lastPlayLogJson.townsFolkPlayerList);
            outsiderPlayerList = JSON.parse(lastPlayLogJson.outsiderPlayerList);
            minionPlayerList = JSON.parse(lastPlayLogJson.minionPlayerList);
            demonPlayerList = JSON.parse(lastPlayLogJson.demonPlayerList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

            console.log('game status loaded !!');
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
                <div class="card shadow mt-5 display-none" id="settingDiv">
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
                        <%--<div name="duskStepDiv"></div>
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
                        <div name="dawnStepDiv"></div>--%>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-info btn-block" onclick="openShowPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextDay()">
                                첫 라운드 낮 순서 진행
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
                    <div class="card-body" name="flowDiv"></div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-info btn-block" onclick="openShowPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextNight()">
                                이번 라운드 밤 순서 진행
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
                    <div class="card-body" name="flowDiv"></div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-info btn-block" onclick="openShowPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextDay()">
                                다음 라운드 낮 순서 진행
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

<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/messageModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/showPlayStatusModal.jspf" %>
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

<!-- 회원프로필 -->
<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
