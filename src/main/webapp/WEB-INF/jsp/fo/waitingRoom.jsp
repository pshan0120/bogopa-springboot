<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script>
        const PLAY_ID = ${playId};
        let playUri = null;
        let numberOfMinPlayer = null;
        let numberOfMaxPlayer = null;
        let hostPlayMember = {};
        let clientPlayMemberList = [];

        $(async () => {
            const play = await gfn_readBeginablePlayById(PLAY_ID);

            playUri = play.playUri;
            numberOfMinPlayer = play.numberOfMinPlayer;
            numberOfMaxPlayer = play.numberOfMaxPlayer;

            renderPlaySetting(play);

            const game = await readGameById(play.gameId);
            console.log('game', game);
            renderGameSetting(game);

            const playMemberList = await readPlayMemberListByPlayId(PLAY_ID);
            console.log('playMemberList', playMemberList);
            hostPlayMember = playMemberList.hostPlayMember;
            clientPlayMemberList = playMemberList.clientPlayMemberList;

            renderPlayerList(clientPlayMemberList);

            renderButtons();
        });

        const renderPlaySetting = play => {
            const $div = $("#settingDiv");
            const $form = $div.find("form");
            $form.find("input[name='playName']").val(play.playName);
        }

        const readGameById = async gameId => {
            return gfn_callGetApi("/api/game", {gameId})
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const renderGameSetting = game => {
            const $div = $("#settingDiv");
            const $form = $div.find("form");
            $form.find("input[name='gameName']").val(game.gameName);
            $form.find("input[name='numberOfPlayer']").val(game.numberOfMinPlayer + " ~ " + game.numberOfMaxPlayer);
        }

        const readPlayMemberListByPlayId = async playId => {
            return gfn_callGetApi("/api/play/member/list", {playId})
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const renderPlayerList = list => {
            const $div = $("#playerListDiv");
            const $numberOfJoined = $div.find("span[name='numberOfJoined']");
            $numberOfJoined.text(list.length);

            const $tbody = $div.find("tbody");
            if (list.length === 0) {
                const htmlString = "<tr><td colspan='1' class=\"text-center\">조회결과가 없습니다.</td></tr>";
                gfn_removeElementChildrenAndAppendHtmlString($tbody, htmlString);
                return;
            }

            let htmlString = "";
            $.each(list, (index, value) => {
                htmlString += "<tr>";
                htmlString += "	<td scope=\"row\">";
                htmlString += "		<div class=\"media align-items-center\">";
                htmlString += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\"" +
                    " onclick=\"openMemberProfileModal('" + value.memberId + "')\">";
                htmlString += "			    <img src=\"" + createMemberImageUrl(value.memberId, value.profileImageFileName) + "\" class=\"rounded-circle\">";
                htmlString += "			</a>";
                htmlString += "			<div class=\"media-body\">";
                htmlString += "				<span class=\"mb-0 text-sm\">" + value.nickname + "</span>";
                htmlString += "			</div>";
                htmlString += "		</div>";
                htmlString += "	</td>";
                htmlString += "</tr>";
            });

            gfn_removeElementChildrenAndAppendHtmlString($tbody, htmlString);
        }

        const renderButtons = () => {
            const $div = $("#buttonDiv");

            const memberId = JSON.parse("<%= SessionUtils.getCurrentMemberIdOrNull() %>");
            if (hostPlayMember.memberId === memberId) {
                $div.find("button[name='beginPlayButton']").show();
                $div.find("button[name='cancelPlayButton']").show();
                return;
            }

            if (!clientPlayMemberList.some(playMember => playMember.memberId === memberId)) {
                $div.find("button[name='joinPlayButton']").show();
                return;
            }
        }

        const joinPlay = () => {
            if (numberOfMaxPlayer <= clientPlayMemberList.length) {
                alert("자리가 부족하네요!");
                return;
            }

            const nickname = prompt("닉네임을 입력해 주세요.\n※ 만약 첫 플레이라면 계정이 생성됩니다.");
            if (!nickname) {
                return;
            }

            const replacedNickname = nickname.replace(/\s+/g, "");
            if (!confirm("[" + replacedNickname + "] 닉네임으로 참가할까요?")) {
                return;
            }

            const request = {
                playId: PLAY_ID,
                nickname: replacedNickname
            }

            gfn_callPostApi("/api/play/member/join", request)
                .then(data => {
                    console.log('play joined !!', data);
                    document.location.reload();
                })
                .catch(response => console.error('error', response));
        }

        const beginPlay = () => {
            if (clientPlayMemberList.length < numberOfMinPlayer) {
                alert("최소 플레이 인원(" + numberOfMinPlayer + "명)이 필요합니다.");
                return;
            }

            if (!confirm("게임을 시작할까요?")) {
                return;
            }

            const request = {
                playId: PLAY_ID,
            }

            gfn_callPatchApi("/api/play/begin", request)
                .then(data => {
                    console.log('play begun !!', data);
                    location.href = "/game/" + playUri + "/play/" + PLAY_ID;
                })
                .catch(response => console.error('error', response));
        }

        const cancelPlay = () => {
            if (!confirm("게임을 취소할까요?")) {
                return;
            }

            const request = {
                playId: PLAY_ID,
            }

            gfn_callPatchApi("/api/play/cancel", request)
                .then(data => {
                    console.log('play canceled !!', data);
                    location.href = "/game/" + playUri + "/play";
                })
                .catch(response => console.error('error', response));
        }

        const openMemberProfileModal = memberId => {
            memberProfileModal.open(memberId);
        }
    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbar.jsp" %>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">대기실</h1>
                        <p class="text-lead text-light">우물쭈물 하다간 혼쭐날 줄 알라구</p>
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
                        <div class="row">
                            <div class="col-lg-12">
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div id="settingDiv">
                            <form>
                                <div class="form-group">
                                    <label class="form-control-label">게임 이름</label>
                                    <input type="text" name="gameName" class="form-control form-control-alternative"
                                           disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-control-label">플레이어 수</label>
                                    <input type="text" name="numberOfPlayer"
                                           class="form-control form-control-alternative"
                                           disabled>
                                </div>
                                <div class="form-group">
                                    <label class="form-control-label">플레이 이름</label>
                                    <input type="text" name="playName"
                                           class="form-control form-control-alternative hasValue"
                                           disabled>
                                </div>
                            </form>
                        </div>
                        <div id="playerListDiv">
                            <h5>참가 플레이어 : <span name="numberOfJoined"></span>명</h5>
                            <div class="table-responsive">
                                <table class="table align-items-center table-flush">
                                    <thead class="thead-light">
                                    <tr>
                                        <th scope="col">닉네임</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <div id="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="joinPlay()"
                                    name="joinPlayButton" style="display: none">
                                플레이 참가
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="beginPlay()"
                                    name="beginPlayButton" style="display: none">
                                플레이 시작
                            </button>
                            <button type="button" class="btn btn-danger btn-block" onclick="cancelPlay()"
                                    name="cancelPlayButton" style="display: none">
                                플레이 취소
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>
<!-- 플레이기록 -->
<%@ include file="/WEB-INF/jsp/fo/jspf/memberProfileModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
