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
                    "   <span> => </span>" +
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
            const randomSortedPlayerList = playerList
                .sort(() => Math.random() - 0.5);

            const playerSetting = initializationSetting.player
                .find(player => playerList.length === player.townsFolk + player.outsider + player.minion + player.imp);

            const roleList = [
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

            const townsFolkPlayerList = createPlayerList(roleList, randomSortedPlayerList, playerSetting.townsFolk, POSITION.TOWNS_FOLK);
            console.log('townsFolkPlayerList', townsFolkPlayerList);
            const outsiderPlayerList = createPlayerList(roleList, randomSortedPlayerList, playerSetting.outsider, POSITION.OUTSIDER);
            console.log('outsiderPlayerList', outsiderPlayerList);
            const minionPlayerList = createPlayerList(roleList, randomSortedPlayerList, playerSetting.minion, POSITION.MINION);
            console.log('minionPlayerList', minionPlayerList);
            const impPlayerList = createPlayerList(roleList, randomSortedPlayerList, playerSetting.imp, POSITION.IMP);
            console.log('impPlayerList', impPlayerList);

            showPlayerRoleList(townsFolkPlayerList);
            showPlayerRoleList(outsiderPlayerList);
            showPlayerRoleList(minionPlayerList);
            showPlayerRoleList(impPlayerList);

            /*localStorage.townsFolkPlayerList = JSON.stringify(townsFolkPlayerList);
            localStorage.outsiderPlayerList = JSON.stringify(outsiderPlayerList);
            localStorage.minionPlayerList = JSON.stringify(minionPlayerList);
            localStorage.impPlayerList = JSON.stringify(impPlayerList);

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
            });
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
                                준비
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div name="playersDiv"></div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="form-control btn btn-info" onclick="setPlayersRole()">
                                참가자 확정
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<!-- 새로운 플레이 Modal -->
<div class="modal fade" id="insertPlayModal" role="dialog" aria-labelledby="insertPlayModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">새로운 플레이</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="insertPlayForm">
                    <input type="hidden" name="hostMmbrNo">
                    <input type="hidden" name="hostNickNm">
                    <input type="hidden" name="clubNo">
                    <div class="row clearfix">
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="form-control-label">*플레이이름</label>
                                <input type="text" data-name="플레이이름" name="playNm"
                                       class="form-control form-control-alternative hasValue">
                            </div>
                        </div>
                    </div>
                </form>

                <label class="form-control-label">*플레이어</label>
                <div class="mb-4" id="playJoinMmbrNListDiv"></div>
                <div class="table-responsive">
                    <table class="table align-items-center table-flush" id="playMmbrListTbl">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col">닉네임</th>
                            <th scope="col" colspan="2">세팅</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="fn_insertPlay();">등록</button>
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
