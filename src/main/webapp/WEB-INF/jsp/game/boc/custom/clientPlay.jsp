<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/character.js'/>"></script>
    <script src="<c:url value='/js/game/boc/initializationSetting.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let playerList = [];
        let selectedCharacterList = [];
        let playStatus = {};

        $(async () => {
            const play = await gfn_readPlayablePlayById(PLAY_ID);
            $("#titleDiv").find("span[name='playName']").text(play.playName);

            await loadGameStatus();

            const loggedIn = JSON.parse("<%= SessionUtils.isMemberLoggedIn() %>");
            if (!loggedIn) {
                $("#reJoinPlayButton").show();
            }
        });

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_ID);
            if (!lastPlayLog) {
                return;
            }

            const lastPlayLogJson = JSON.parse(lastPlayLog);
            console.log('lastPlayLogJson', lastPlayLogJson);

            playerList = JSON.parse(lastPlayLogJson.playerList);
            selectedCharacterList = JSON.parse(lastPlayLogJson.selectedCharacterList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

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

        const readEditionList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/editions.json")
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const openRuleGuideModal = () => {
            ruleGuideModal.open();
        }

        const openCharacterGuideModal = async () => {
            await loadGameStatus();
            characterGuideModal.open(selectedCharacterList, playStatus.editionName);
        }

        const openTownModal = () => {
            townModal.open(PLAY_ID);
        }

        const openMyCharacterModal = () => {
            myCharacterModal.open(PLAY_ID);
        }

        const openNoteModal = () => {
            noteModal.open();
        }

        const reJoinPlay = () => {
            const nickname = prompt("참여중이었던 닉네임을 입력해 주세요.");
            if (!nickname) {
                return;
            }

            const replacedNickname = nickname.replace(/\s+/g, "");
            const request = {
                playId: PLAY_ID,
                nickname: replacedNickname
            }

            gfn_callPostApi("/api/play/member/reJoinPlay", request)
                .then(data => {
                    console.log('play rejoined !!', data);
                    document.location.reload();
                })
                .catch(response => {
                    console.error('error', response);
                    alert(response.responseJSON?.message);
                });
        }
    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbar.jsp" %>
    <%--<%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp" %>--%>

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
            <div class="col-xl-12 mb-5 mb-xl-0">
                <div class="card shadow mt-5">
                    <div class="card-header bg-white border-0">
                        플레이어용 참조표
                    </div>
                    <div class="card-body" id="titleDiv">
                        <h4>
                            <span name="playName"></span>
                        </h4>
                        <p>
                            ※ 카카오톡 같은 인앱 브라우저에서 <strong class="text-danger">'뒤로가기'</strong>를 누르면 이 페이지가 닫힐 수 있으니 주의하세요. 가급적 크롬이나 삼성, 사파리 브라우저에서 보시는 것을 추천합니다.
                        </p>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openCharacterGuideModal()">
                                역할 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                마을 광장
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openNoteModal()">
                                노트
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="openMyCharacterModal()">
                                내 역할 보기
                            </button>
                            <button type="button" class="btn btn-primary btn-block display-none"
                                    onclick="reJoinPlay()" id="reJoinPlayButton">
                                다시 마을 입장
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/townModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/myCharacterModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/boc/guide/ruleGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/characterGuideModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/noteModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
