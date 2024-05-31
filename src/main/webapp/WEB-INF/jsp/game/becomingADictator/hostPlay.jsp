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
        let thrownByRound = [];

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
            thrownByRound = [];

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
                    const roleList = [Clown.name, Assassin.name, Populace.name, Priest.name, Revolutionary.name, Dictator.name, Nobility.name]
                    return {
                        playerName: player.nickname,
                        playerId: player.memberId,
                        numberOfVote: 0,
                        voted: false,
                        dismissed: false,
                        roleList
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
                thrownByRound: JSON.stringify(thrownByRound),
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
            thrownByRound = JSON.parse(lastPlayLogJson.thrownByRound);

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
            proceedToNextRound();
        }

        const proceedToNextRound = () => {
            if (playStatus.round === 0) {
                playStatus.round = playStatus.round + 1;
                saveGameStatus();
                renderRound();
                return;
            }

            playerList.forEach(player => {
                const bidding = dismiss.biddingList
                    .filter(bidding => player.playerName === bidding.playerName);
                if (bidding.length != 2) {
                    alert(player.playerName + " 플레이어의 판매 희망가가 선택되지 않았습니다.");
                    throw new Error("판매 희망가 미선택");
                }
            });

            if (!confirm("경매 결과를 계산한 뒤 저장하시겠습니까?")) {
                return;
            }

            if (thrownByRound.length > 0) {
                thrownByRound = [...thrownByRound.filter(dismiss => dismiss.round !== playStatus.round)];
            }

            thrownByRound.push(
                {
                    round: playStatus.round,
                    resultList: [
                        createAuctionResultByFruit(APPLE),
                        createAuctionResultByFruit(GRAPE),
                        createAuctionResultByFruit(STRAWBERRY),
                        createAuctionResultByFruit(WATERMELON),
                        createAuctionResultByFruit(BANANA),
                        createAuctionResultByFruit(MANGO),
                    ]
                }
            )

            dismiss.resetBiddingList();

            playStatus.round = playStatus.round + 1;
            saveGameStatus();
            renderRound();
        }

        const createAuctionResultByFruit = item => {
            const biddingList = dismiss.biddingList.filter(bidding => bidding.itemName === item.name);
            if (biddingList.length === 0) {
                return {
                    itemName: item.name,
                    biddingList,
                    totalBidding: 0,
                    minimumBidding: 0,
                    revenue: 0,
                    successfulBiddingList: [],
                    blind: false,
                }
            }

            const totalBidding = biddingList.map(bidding => bidding.bidding).reduce((prev, next) => prev + next, 0);
            const minimumBidding = Math.min(...biddingList.map(bidding => bidding.bidding));
            const successfulBiddingList = biddingList.filter(bidding => bidding.bidding === minimumBidding);
            const revenue = Math.floor(totalBidding / successfulBiddingList.length);

            successfulBiddingList.forEach(successfulBidding => {
                const player = playerList
                    .find(player => player.playerName === successfulBidding.playerName);
                player.money = player.money + revenue;
            });

            const blind = dismiss.blindBiddingResultList.some(blind => blind.itemName === item.name);
            return {
                itemName: item.name,
                biddingList,
                totalBidding,
                minimumBidding,
                revenue,
                successfulBiddingList,
                blind
            }
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
            } else if (playStatus.round === 5) {
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

            const $dismissDiv = $roundDiv.find("div[name='dismissDiv']").empty();
            $dismissDiv.empty();
            $dismissDiv.append(dismiss.createHtml(playStatus.round, playStatus.night));

            const $voteDiv = $roundDiv.find("div[name='voteDiv']").empty();
            $voteDiv.empty();
            $voteDiv.append(vote.createHtml(playStatus.round, playStatus.night));
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
            playStatusModal.open(thrownByRound);
        }

        const openFruitShopModal = () => {
            shopListModal.open(PLAY_ID);
        }

        const openAuctionResultModal = () => {
            dismissResultModal.open(PLAY_ID);
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
                        <div name="dismissDiv"></div>
                        <div name="voteDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                규칙 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openFruitShopModal()">
                                플레이어 과일가게 보기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openAuctionResultModal()">
                                경매 결과 모달 표시
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="proceedToNextRound()">
                                다음 라운드 진행
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
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                역할 설명
                            </button>

                            <button type="button" class="btn btn-info btn-block" onclick="openPlayStatusModal()">
                                플레이 상태 모달 표시
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openFruitShopModal()">
                                플레이어 과일가게 보기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openAuctionResultModal()">
                                경매 결과 모달 표시
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

<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/dismiss.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/vote.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/guideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/playStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/shopListModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/dismissResultModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
