<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/becomingADictator/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/becomingADictator/constants.js'/>"></script>
    <script src="<c:url value='/js/game/becomingADictator/roles.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let playSetting = {};
        let playStatus = {};
        let playerList = [];
        let thrownAwayRoleList = [];

        $(async () => {
            await gfn_readPlayablePlayById(PLAY_ID);

            await loadGameStatus();

            console.log('playStatus', playStatus);
            if (Object.keys(playStatus).length === 0) {
                await initializeGame();
                return;
            }

            if (0 < playStatus.round) {
                renderRound();
                return;
            }

            renderPlayMemberList(playerList);

            $("#settingDiv").show();
        });

        const initializeGame = async () => {
            playSetting = {};
            playStatus = {};
            playerList = [];
            thrownAwayRoleList = [];

            console.log('initializationSetting', initializationSetting);

            $("#settingDiv").show();
            $("#roundDiv").hide();
            $("#resultDiv").hide();

            const originalPlayMemberList = await readPlayMemberList(PLAY_ID);
            const clientPlayMemberList = originalPlayMemberList.clientPlayMemberList;
            const hostPlayMember = originalPlayMemberList.hostPlayMember;

            playStatus = {
                round: 0,
                night: false,
                hostMemberId: hostPlayMember.memberId,
                hostMemberName: hostPlayMember.nickname,
                noticeHtml: "",
            }
            playSetting = {round: initializationSetting.round};

            playerList = createPlayerList(clientPlayMemberList);

            renderPlayMemberList(playerList);
        };

        const readPlayMemberList = playId => {
            return gfn_callGetApi("/api/play/member/list", {playId})
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const createPlayerList = playerList => {
            return playerList
                .map(player => {
                    // const roleList = [Clown.name, Assassin.name, Populace.name, Priest.name, Revolutionary.name, Dictator.name, Nobility.name]
                    return {
                        playerName: player.nickname,
                        playerId: player.memberId,
                        numberOfVote: 0,
                        dismissed: false,
                        roleList: createRoleList().map(role => role.name),
                    };
                });
        }

        const renderPlayMemberList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            $playerDiv.empty();

            const htmlString = playerList.reduce((prev, next) => {
                return prev +
                    "<div class=\"form-group form-inline\">" +
                    "   <input type=\"text\" class=\"form-control form-control-alternative\" name=\"items\" readonly" +
                    "       data-member-id=\"" + next.memberId + "\" value=\"" + next.playerName + "\" >" +
                    "</div>";
            }, "");

            $playerDiv.append(htmlString);
        }

        const saveGameStatus = () => {
            const log = {
                playSetting: JSON.stringify(playSetting),
                playStatus: JSON.stringify(playStatus),
                playerList: JSON.stringify(playerList),
                thrownAwayRoleList: JSON.stringify(thrownAwayRoleList),
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

            playSetting = JSON.parse(lastPlayLogJson.playSetting);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);
            playerList = JSON.parse(lastPlayLogJson.playerList);
            thrownAwayRoleList = JSON.parse(lastPlayLogJson.thrownAwayRoleList);

            console.log('game status loaded !!');
        }

        const readLastPlayLog = playId => {
            return gfn_callGetApi("/api/play/log/last", {playId})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
                })
                .catch(response => console.error('error', response));
        }

        const beginGame = () => {
            $("#settingDiv").hide();
            proceedToNext();
        }

        const proceedToNext = () => {
            if (playStatus.round === 0) {
                playStatus.round = playStatus.round + 1;
                saveGameStatus();
                renderRound();
                return;
            }

            if (!playStatus.night) {
                if (dayAction.actionList.length !== playerList.length) {
                    alert("투표 또는 기각이 진행되지 않은 플레이어가 있습니다.");
                    throw new Error("투표 또는 기각 미실행");
                }
            } else {
                const numberOfAction = nightAction.round % 2 + 1;
                if (nightAction.actionList.length !== playerList.length * numberOfAction) {
                    alert("역할 버리기가 진행되지 않은 플레이어가 있습니다.");
                    throw new Error("역할 버리기 미실행");
                }
            }

            if (!confirm("결과를 계산한 뒤 저장하시겠습니까?")) {
                return;
            }

            if (!playStatus.night) {
                const voteActionList = dayAction.actionList.filter(action => action.action === VOTE.name);
                const dismissActionList = dayAction.actionList.filter(action => action.action === DISMISS.name);

                if (playStatus.round === 1) {
                    createVoteResult(voteActionList);
                } else if (playStatus.round === playSetting.round) {
                    createVoteResult(voteActionList);
                    createDismissResult(dismissActionList);

                    playStatus.round = playStatus.round + 1;
                } else {
                    createDismissResult(dismissActionList);
                    createVoteResult(voteActionList);
                }

                thrownAwayRoleList = [];
                dayAction.reset();
                playStatus.night = true;
            } else {
                createThrowAwayResult(nightAction.actionList);

                nightAction.reset();
                playStatus.night = false;
                playStatus.round = playStatus.round + 1;
            }

            saveGameStatus();
            renderRound();
        }

        const createVoteResult = dayActionList => {
            dayActionList.forEach(dayAction => {
                const playerTo = playerList
                    .find(player => player.playerName === dayAction.playerNameTo);

                if (dayAction.action === DISMISS.name) {
                    alert(dayAction.playerNameFrom + " 플레이어는 기각과 투표 중 하나의 액션만 선택할 수 있습니다.");
                    throw new Error("투표 또는 기각 중복 선택 불가");
                }

                playerTo.numberOfVote++;
                playerTo.dismissed = false;
            });
        }

        const createDismissResult = dayActionList => {
            dayActionList.forEach(dayAction => {
                const playerTo = playerList
                    .find(player => player.playerName === dayAction.playerNameTo);

                if (dayAction.action === VOTE.name) {
                    alert(dayAction.playerNameFrom + " 플레이어는 기각과 투표 중 하나의 액션만 선택할 수 있습니다.");
                    throw new Error("투표 또는 기각 중복 선택 불가");
                }

                if (playerTo.numberOfVote <= 0
                    && dayAction.round < playSetting.round) {
                    alert(dayAction.playerNameFrom + " 플레이어가 기각하려 했으나 상대 플레이어의 현재 득표수가 0표 이하라서 실패했습니다.(마지막 라운드 제외)");
                    throw new Error("기각 실행을 위한 득표수 부족");
                }

                playerTo.numberOfVote--;
                playerTo.dismissed = true;
            });
        }

        const createThrowAwayResult = nightActionList => {
            nightActionList.forEach(nightAction => {
                const player = playerList
                    .find(player => player.playerName === nightAction.playerName);

                thrownAwayRoleList.push(
                    {
                        playerName: nightAction.playerName,
                        roleName: nightAction.roleName,
                        dismissed: player.dismissed,
                    }
                );

                const thrownAwayIndex = player.roleList.findIndex(role => role === nightAction.roleName);
                if (thrownAwayIndex > -1) {
                    player.roleList.splice(thrownAwayIndex, 1);
                }
            });
        }

        const renderRound = () => {
            if (playSetting.round < playStatus.round) {
                endGame();
                return;
            }

            const $roundDiv = $("#roundDiv");
            $roundDiv.show();

            $roundDiv.find("span[name='roundTitle']").text(playStatus.round + " / " + playSetting.round);

            let todoText = "";
            if (playStatus.round === 1) {
                if (playStatus.night) {
                    todoText = "밤 시간입니다. 역할 버리기를 진행해 주세요.";
                } else {
                    todoText = "첫 라운드 낮 시간입니다. 투표를 진행해 주세요.";
                }
            } else if (playStatus.round === playSetting.round) {
                if (playStatus.night) {
                    todoText = "게임이 종료되었습니다.";
                } else {
                    todoText = "마지막 라운드 낮 시간입니다. 기각과 투표를 동시에 진행해 주세요.";
                }
            } else {
                if (playStatus.night) {
                    todoText = "밤 시간입니다. 역할 버리기를 진행해 주세요.";
                } else {
                    todoText = "낮 시간입니다. 기각 후 투표를 진행해 주세요.";
                }
            }

            $roundDiv.find("span[name='todoText']").text(todoText);

            const $actionDiv = $roundDiv.find("div[name='actionDiv']").empty();
            $actionDiv.empty();

            if (!playStatus.night) {
                $actionDiv.append(dayAction.createHtml(playStatus.round, playStatus.night, playerList));
            } else {
                $actionDiv.append(nightAction.createHtml(playStatus.round, playStatus.night, playerList));
            }
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

        const endGame = () => {
            $("#roundDiv").hide();
            $("#resultDiv").show();

            renderResult();
        }

        const renderResult = () => {
            const $resultDiv = $("#resultDiv");
            const $playerDiv = $resultDiv.find("div[name='playerDiv']");
            $playerDiv.empty();

            // TODO: 최종 계산 수식 작성

            let rank = 0;
            const htmlString = playerList
                .sort((prev, next) => next.money - prev.money)
                .reduce((prev, next) => {
                    rank++;
                    return prev +
                        `<div class="row">
                            <div class="col-2">
                                \${rank}위
                            </div>
                            <div class="col-6">
                                \${next.playerName}
                            </div>
                            <div class="col-4">
                                \${next.money}
                            </div>
                        </div>
                        <br>`;
                }, "");

            $playerDiv.append(htmlString);
        }

        const openRuleGuideModal = () => {
            guideModal.openRuleGuideModal();
        }

        const openRoleGuideModal = () => {
            guideModal.openRoleGuideModal();
        }

        const openPlayStatusModal = () => {
            playStatusModal.open(playerList);
        }

        const openRoundResultModal = () => {
            roundResultModal.open(PLAY_ID);
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
                        <h1 class="text-white">이리하여 나는 독재자가 되었다</h1>
                        <p class="text-lead text-light">호스트 참조</p>
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
                        <div name="playerDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-primary" onclick="beginGame()">
                                게임 시작
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="roundDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            [<span name="roundTitle"></span>] 번째 라운드
                        </h2>
                        <h3>
                            <span name="todoText"></span>
                        </h3>
                    </div>
                    <div class="card-body">
                        <div name="actionDiv"></div>
                        <div name="nightActionDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                규칙 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoleGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoundResultModal()">
                                라운드 결과 모달 표시
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNext()">
                                다음 순서 진행
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="resetGame()">
                                게임 재설정
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="resultDiv">
                    <div class="card-header bg-white border-0">
                        <h2>
                            게임 종료
                        </h2>
                    </div>
                    <div class="card-body">
                        <div name="playerDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                규칙 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoleGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRoundResultModal()">
                                라운드 결과 모달 표시
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

<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/dayAction.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/nightAction.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/guideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/playStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/roundResultModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
