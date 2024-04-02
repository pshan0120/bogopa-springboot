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
        let offeredTownsFolkRoleTitleToImpList = [];
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
                new Butler,
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

            $flowDiv.append(createDuskHtml());

            $flowDiv.append(createMinionHtml());

            $flowDiv.append(createImpHtml());


            /*
            <div name="minionDiv">
                <p>플레이어가 </p>
            </div>
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

        const createDuskHtml = () => {
            return `<div name="duskStepDiv">
                <h3>새벽 단계</h3>
                <p>
                   1. 모두 눈을 감았는지 확인하세요.<br/>
                   * 일부 여행자와 전설은 행동합니다.
                </p>
            </div>
            <hr/>`
        }

        const createMinionHtml = () => {
            if (minionPlayerList.length === 0) {
                return "";
            }

            const minionPlayerListHtml = minionPlayerList.reduce((prev, next) => {
                return prev + next.playerName + "(" + next.title + ") ";
            }, "");

            const impPlayer = demonPlayerList.find(player => player.name === Imp.name);
            const impPlayerHtml = impPlayer.playerName;
            const messageHtml = `임프<br/> - \${impPlayerHtml}`;

            return `<div name="minionDiv">
                <h3>하수인 정보</h3>
                <p>
                    1. 다음 플레이어를(들을) 깨우세요: \${minionPlayerListHtml}<br/>
                    2. 메세지 모달을 띄운 뒤 보여주세요.
                </p>
                <button type="button" class="btn btn-info btn-block" onclick="openMessageModal('\${messageHtml}')">
                    메세지 모달 표시
                </button>
            </div>
            <hr/>`
        }

        const createImpHtml = () => {
            const impPlayer = demonPlayerList.find(player => player.name === Imp.name);
            const impPlayerHtml = impPlayer.playerName;

            const minionPlayerListHtml = minionPlayerList.reduce((prev, next) => {
                return prev + next.playerName + " ";
            }, "");

            const messageHtml = `하수인<br/> - \${minionPlayerListHtml}`;

            return `<div name="impDiv">
                <h3>악마 정보</h3>
                <p>
                    1. 다음 플레이어를(들을) 깨우세요: \${impPlayerHtml}<br/>
                    2. 임프 플레이어에게 보여줄 3가지 선한 역할을 골라주세요.<br/>
                    3. 메세지 모달을 띄운 뒤 보여주세요.
                </p>
                <button type="button" class="btn btn-primary btn-block" onclick="openOfferTownsFolkRoleToImpModal()">
                    선택 모달
                </button>
                <button type="button" class="btn btn-info btn-block" onclick="openImpMessageModal('\${messageHtml}')">
                    메세지 모달 표시
                </button>
            </div>
            <hr/>`
        }

        const openMessageModal = messageHtml => {
            const $modal = $("#messageModal");
            $modal.find("[name='message']").empty().html(messageHtml);
            $("#messageModal").modal("show");
        }

        const openImpMessageModal = messageHtml => {
            const offeredTownsFolkRoleNameHtml = offeredTownsFolkRoleTitleToImpList.reduce((prev, next) => {
                return prev + " - " + next + "<br/>";
            }, "");

            openMessageModal(messageHtml + "<br/>미참여 마을 주민 역할<br/>" + offeredTownsFolkRoleNameHtml);
        }

        const openOfferTownsFolkRoleToImpModal = () => {
            if (offeredTownsFolkRoleTitleToImpList.length > 2) {
                const offeredTownsFolkRoleNameHtml = offeredTownsFolkRoleTitleToImpList.reduce((prev, next) => {
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
                    + "<button class=\"btn btn-sm btn-outline-info mr-1 my-1\" "
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
            if (offeredTownsFolkRoleTitleToImpList.length > 2) {
                return;
            }

            const impPlayer = demonPlayerList.find(player => player.name === Imp.name);
            impPlayer.offeredTownsFolkRoleList.push(roleName);
            offeredTownsFolkRoleTitleToImpList.push(roleTitle);

            if (offeredTownsFolkRoleTitleToImpList.length > 2) {
                $("#offerTownsFolkRoleToImpModal").modal("hide");
                return;
            }
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
                        <div class="row">
                            <div class="col-lg-12">
                                준비 단계
                            </div>
                        </div>
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
                        <div class="row">
                            <div class="col-lg-12">
                                첫번째 밤
                            </div>
                        </div>
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
                            <button type="button" class="btn btn-primary" onclick="proceedToFirstDay()">
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

<div class="modal fade" id="messageModal" role="dialog" aria-labelledby="messageModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">당신에게 알려드립니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h1 class="display-3" name="message"></h1>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
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
                <h4 class="">스토리텔러가 선택합니다.</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div name="townsFolkRoleListDiv"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 회원프로필 -->
<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
