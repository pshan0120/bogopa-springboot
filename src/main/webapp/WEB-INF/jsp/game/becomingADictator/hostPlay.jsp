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
        let fruitList = [];
        let playerList = [];
        let auctionByRound = [];

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
            fruitList = [];
            playerList = [];
            auctionByRound = [];

            console.log('initializationSetting', initializationSetting);

            $("#settingDiv").show();
            $("#roundDiv").hide();
            $("#resultDiv").hide();

            const originalPlayMemberList = await readPlayMemberList(PLAY_ID);
            const clientPlayMemberList = originalPlayMemberList.clientPlayMemberList;
            const hostPlayMember = originalPlayMemberList.hostPlayMember;

            playStatus = {
                round: 0,
                night: true,
                hostMemberId: hostPlayMember.memberId,
                hostMemberName: hostPlayMember.nickname,
                noticeHtml: "",
            }

            playerList = clientPlayMemberList;

            playSetting = initializationSetting.item
                .find(item => playerList.length === item.numberOfPlayer);
            playSetting = {...playSetting, round: initializationSetting.round};

            renderPlayMemberList(playerList);
        };

        const renderPlayMemberList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            $playerDiv.empty();

            const htmlString = playerList.reduce((prev, next) => {
                return prev +
                    "<div class=\"form-group form-inline\">" +
                    "   <label class=\"form-control-label\">" + next.nickname + "</label>" +
                    "   <input type=\"text\" class=\"form-control form-control-alternative\" name=\"items\" readonly" +
                    "       data-member-id=\"" + next.memberId + "\">" +
                    "</div>";
            }, "");

            $playerDiv.append(htmlString);
        }

        const readPlayMemberList = playId => {
            return gfn_callGetApi("/api/play/member/list", {playId})
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const setFruitOfPlayer = () => {
            fruitList = [];

            fruitList.push({...APPLE, quantity: playSetting.apple});
            fruitList.push({...BANANA, quantity: playSetting.banana});
            fruitList.push({...GRAPE, quantity: playSetting.grape});
            fruitList.push({...MANGO, quantity: playSetting.mango});
            fruitList.push({...STRAWBERRY, quantity: playSetting.strawberry});
            fruitList.push({...WATERMELON, quantity: playSetting.watermelon});

            playerList = createPlayerList(playerList);
            console.log('playerList', playerList);

            showPlayerItemList(playerList);
        }

        const createPlayerList = playerList => {
            return playerList
                .map(player => {
                    fruitList.sort(() => Math.random() - 0.5);
                    const assignableFruit1 = fruitList.find(fruit => fruit.quantity > 0);
                    const assignableFruit2 = fruitList
                        .find(fruit => fruit.name !== assignableFruit1.name && fruit.quantity > 0);

                    assignableFruit1.quantity = assignableFruit1.quantity - 1;
                    assignableFruit2.quantity = assignableFruit2.quantity - 1;

                    return {
                        playerName: player.nickname,
                        playerId: player.memberId,
                        item1: assignableFruit1.name,
                        item2: assignableFruit2.name,
                        blindSkillUsed: false,
                        swapSkillUsed: false,
                        money: 0,
                    };
                });
        }

        const showPlayerItemList = playerList => {
            const $settingDiv = $("#settingDiv");
            const $playerDiv = $settingDiv.find("div[name='playerDiv']");
            playerList.forEach(player => {
                const found = $playerDiv.find("input[name='items']").toArray()
                    .filter(itemsObject => player.playerId == $(itemsObject).data("memberId"));

                $(found).val(
                    Fruit.getFruitByName(fruitList, player.item1).title
                    + ", "
                    + Fruit.getFruitByName(fruitList, player.item2).title
                );
                $(found).removeClass();
                $(found).addClass("form-control form-control-alternative");
            });
        }

        const saveGameStatus = () => {
            const log = {
                playSetting: JSON.stringify(playSetting),
                playStatus: JSON.stringify(playStatus),
                fruitList: JSON.stringify(fruitList),
                playerList: JSON.stringify(playerList),
                auctionByRound: JSON.stringify(auctionByRound),
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
            fruitList = JSON.parse(lastPlayLogJson.fruitList);
            playerList = JSON.parse(lastPlayLogJson.playerList);
            auctionByRound = JSON.parse(lastPlayLogJson.auctionByRound);

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
            if (fruitList.length === 0) {
                alert("과일이 분배되지 않았습니다.");
                return;
            }

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
                const bidding = auction.biddingList
                    .filter(bidding => player.playerName === bidding.playerName);
                if (bidding.length != 2) {
                    alert(player.playerName + " 플레이어의 판매 희망가가 선택되지 않았습니다.");
                    throw new Error("판매 희망가 미선택");
                }
            });

            if (!confirm("경매 결과를 계산한 뒤 저장하시겠습니까?")) {
                return;
            }

            if (auctionByRound.length > 0) {
                auctionByRound = [...auctionByRound.filter(auction => auction.round !== playStatus.round)];
            }

            auctionByRound.push(
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

            auction.resetBiddingList();

            playStatus.round = playStatus.round + 1;
            saveGameStatus();
            renderRound();
        }

        const createAuctionResultByFruit = item => {
            const biddingList = auction.biddingList.filter(bidding => bidding.itemName === item.name);
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

            const blind = auction.blindBiddingResultList.some(blind => blind.itemName === item.name);
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

            const $auctionDiv = $roundDiv.find("div[name='auctionDiv']").empty();
            $auctionDiv.empty();

            $auctionDiv.append(auction.createHtml());
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

        const openGuideModal = () => {
            guideModal.open();
        }

        const openPlayStatusModal = () => {
            playStatusModal.open(auctionByRound);
        }

        const openFruitShopModal = () => {
            shopListModal.open(PLAY_ID);
        }

        const openAuctionResultModal = () => {
            auctionResultModal.open(PLAY_ID);
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
                            <button type="button" class="btn btn-default" onclick="setFruitOfPlayer()">
                                과일 분배
                            </button>
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
                    </div>
                    <div class="card-body" name="auctionDiv"></div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
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
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
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

<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/auction.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/guideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/playStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/shopListModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/auctionResultModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
