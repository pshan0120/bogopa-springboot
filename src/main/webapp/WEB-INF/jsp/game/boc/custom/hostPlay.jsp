<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/boc/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/character.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let editionList = [];
        let selectedEditionId = null;
        let edition = null;
        let jinxList = [];
        let characterList = [];
        let selectedCharacterList = [];
        let playedCharacterList = [];
        let nightOrderList = [];
        let playerList = [];
        let scriptJson = {};
        let playStatus = {};

        $(async () => {
            await gfn_readPlayablePlayById(PLAY_ID);

            await loadGameStatus();

            console.log('playStatus', playStatus);
            if (Object.keys(playStatus).length === 0) {
                await initializeGame();
                return;
            }

            hideSettingDivs();
            showPlayingDivs();

            await renderPlayerStatusList();
            await renderExecution();
        });

        const readEditionList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/editions.json")
                .then(data => data)
                .catch(response => console.error('error', response));
        }

        const readScriptJsonOfEdition = async jsonFileName => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/scripts/" + jsonFileName)
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

        const initializeGame = async () => {
            console.log('initializationSetting', initializationSetting);
            await showSettingDivs();
            await hidePlayingDivs();

            editionList = await readEditionList();
            renderEditionSelect(editionList);

            characterList = await readCharacterList();

            jinxList = await readJinxList();
            nightOrderList = await readNightOrderList();

            const originalPlayMemberList = await readPlayMemberList(PLAY_ID);
            playerList = originalPlayMemberList.clientPlayMemberList;
            const hostPlayMember = originalPlayMemberList.hostPlayMember;

            playStatus = {
                hostMemberId: hostPlayMember.memberId,
                hostMemberName: hostPlayMember.nickname,
            }
        }

        const renderEditionSelect = editionList => {
            const $editionDiv = $("#editionDiv");
            const optionsHtml = editionList.reduce((prev, next) => {
                return prev + `<option value="\${next.id}">\${next.name}</option>`;
            }, `<option value="">선택</option>`);
            $editionDiv.find("select").append(optionsHtml);
        }

        const selectEdition = async () => {
            const $editionDiv = $("#editionDiv");
            const id = $editionDiv.find("select").val();

            const selected = editionList.find(edition => edition.id === id);
            if (!selected) {
                alert("존재하지 않는 에디션입니다.");
                return;
            }

            selectedEditionId = id;

            scriptJson = await readScriptJsonOfEdition(selected.scriptJson);
            scriptJson.splice(0, 1);
            $editionDiv.find("textarea").val(JSON.stringify(scriptJson));

            renderCharacterList(scriptJson, characterList);
        }

        const copyEditionJson = () => {
            const $editionDiv = $("#editionDiv");
            const text = $editionDiv.find("textarea").val();
            if (!text) {
                alert("복사할 텍스트가 없습니다.")
                return;
            }

            gfn_copyText(text);
        }

        const renderCharacterList = (scriptJson, characterList) => {
            const $characterDiv = $("#characterDiv");
            const $characterListDiv = $characterDiv.find("div[name='characterListDiv']");
            $characterListDiv.empty();

            const $playedCharacterCountDiv = $characterDiv.find("div[name='playedCharacterCountDiv']");
            $playedCharacterCountDiv.empty();

            const $playedCharacterListDiv = $characterDiv.find("div[name='playedCharacterListDiv']");
            $playedCharacterListDiv.empty();

            playedCharacterList = [];

            selectedCharacterList = characterList
                .filter(character => scriptJson.find(item => Character.characterIdEquals(item, character.id)))
                .sort((prev, next) => calculateTeamIndex(prev.team) - calculateTeamIndex(next.team));

            const listHtml = selectedCharacterList.reduce((prev, next) => {
                const fontClass = Character.calculateCharacterNameClass(next.team);
                return prev +
                    `<div class="col-4 text-center pt-2 \${fontClass}" name="\${next.id}">
                        <small class="\${fontClass}">\${next.name}</small>
                        <img src="\${next.image}" class="img-responsive img-thumbnail m-auto" onclick="setPlayedCharacter('\${next.id}')">
                    </div>`;
            }, `<div class="row">`) + '</div>';

            $characterListDiv.append(listHtml);
        }

        const setPlayedCharacter = characterId => {
            if (playerList.length <= playedCharacterList.length) {
                // alert("플레이어 수보다 많이 선택할 수 없습니다");
                return;
            }
            playedCharacterList.push(characterId);

            const $characterDiv = $("#characterDiv");
            const $characterListDiv = $characterDiv.find("div[name='characterListDiv']");
            const $selectedCharacterDiv = $characterListDiv.find("div[name='" + characterId + "']");
            $selectedCharacterDiv.find("img").removeClass("img-thumbnail");
            $selectedCharacterDiv.find("img").addClass("img-rounded");

            renderPlayedCharacterList();
        }

        const renderPlayedCharacterList = () => {
            const $characterDiv = $("#characterDiv");
            const $playedCharacterCountDiv = $characterDiv.find("div[name='playedCharacterCountDiv']");
            $playedCharacterCountDiv.empty();

            const spanClass = playerList.length === playedCharacterList.length ? "text-primary font-weight-bold" : "";
            $playedCharacterCountDiv.append(`<span class="\${spanClass}">\${playedCharacterList.length} / \${playerList.length}</span>`);

            const $playedCharacterListDiv = $characterDiv.find("div[name='playedCharacterListDiv']");
            $playedCharacterListDiv.empty();

            const listHtml = playedCharacterList.reduce((prev, next) => {
                const character = Character.getInCharacterListById(selectedCharacterList, next);
                const fontClass = Character.calculateCharacterNameClass(character.team);
                return prev +
                    `<div class="col-4 text-center pt-2 \${fontClass}">
                        <small class="\${fontClass}">\${character.name}</small>
                        <img src="\${character.image}" class="img-responsive img-thumbnail m-auto" onclick="removePlayedCharacter('\${next}')">
                    </div>`;
            }, `<div class="row">`) + '</div>';

            $playedCharacterListDiv.append(listHtml);
        }

        const removePlayedCharacter = characterId => {
            const thrownAwayIndex = playedCharacterList.findIndex(item => Character.characterIdEquals(item, characterId));
            if (thrownAwayIndex > -1) {
                playedCharacterList.splice(thrownAwayIndex, 1);
            }

            const $characterDiv = $("#characterDiv");
            const $characterListDiv = $characterDiv.find("div[name='characterListDiv']");
            const $selectedCharacterDiv = $characterListDiv.find("div[name='" + characterId + "']");
            $selectedCharacterDiv.find("img").removeClass("img-rounded");
            $selectedCharacterDiv.find("img").addClass("img-thumbnail");

            renderPlayedCharacterList();
        }

        const setPlayerSeatsRandomly = () => {
            if (Object.keys(scriptJson).length === 0) {
                alert("에디션이 선택되지 않았습니다.");
                return;
            }

            if (playedCharacterList.length !== playerList.length) {
                alert("참여 역할들이 모두 선택되지 않았습니다.");
                return;
            }

            const $seatDiv = $("#seatDiv");
            const $playerSeatsDiv = $seatDiv.find("div[name='playerSeatsDiv']");
            $playerSeatsDiv.empty();

            playedCharacterList = playedCharacterList
                .sort(() => Math.random() - 0.5);

            playerList = playerList
                .sort(() => Math.random() - 0.5)
                .map((originalPlayer, index) => {
                    return {
                        ...originalPlayer,
                        seatNumber: index + 1,
                        characterId: playedCharacterList[index],
                        nominating: false,
                        nominated: false,
                        died: false,
                        votable: true,
                    };
                });

            const playerListHtml = playerList
                .reduce((prev, next) => {
                    const character = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                    const fontClass = Character.calculateCharacterNameClass(character.team);
                    return prev +
                        `<div class="row" name="\${next.memberId}">
                            <div class="col-6">
                                \${next.seatNumber}. \${next.nickname}
                            </div>
                            <div class="col-6 text-right">
                                <span class="\${fontClass}">\${character.name}</span>
                            </div>
                        </div>
                        <br>`;
                }, "");

            $playerSeatsDiv.append(playerListHtml);
        }

        const calculateTeamIndex = team => {
            if (team === POSITION.TOWNS_FOLK.name) return 1;
            if (team === POSITION.OUTSIDER.name) return 2;
            if (team === POSITION.MINION.name) return 3;
            if (team === POSITION.DEMON.name) return 4;
            return 0;
        }

        const setPlayerSeatsSpecifically = () => {
            // TODO: 예정
            return;
        }

        const confirmPlayerSeatList = async () => {
            if (!confirm("현재 자리와 역할로 확정하시겠습니까?")) {
                return;
            }

            playStatus = {
                ...playStatus,
                playerCharacterDisplayed: true,
            }

            saveGameStatus();

            hideSettingDivs();
            showPlayingDivs();

            await renderPlayerStatusList();
            await renderExecution();
        }

        const showSettingDivs = () => {
            $("#editionDiv").show();
            $("#characterDiv").show();
            $("#seatDiv").show();
        }

        const hideSettingDivs = () => {
            $("#editionDiv").hide();
            $("#characterDiv").hide();
            $("#seatDiv").hide();
        }

        const showPlayingDivs = () => {
            $("#backgroundMusicDiv").show();
            $("#playerStatusDiv").show();
            $("#executionDiv").show();
        }

        const hidePlayingDivs = () => {
            $("#backgroundMusicDiv").hide();
            $("#playerStatusDiv").hide();
            $("#executionDiv").hide();
        }

        const renderPlayerStatusList = () => {
            const $playerStatusDiv = $("#playerStatusDiv");

            if (playStatus.playerCharacterDisplayed) {
                $playerStatusDiv.find("button[name='hideCharacterToPlayerButton']").show();
            }

            const $playerStatusListDiv = $playerStatusDiv.find("div[name='playerStatusListDiv']");
            $playerStatusListDiv.empty();

            const playerListHtml = playerList
                    .reduce((prev, next) => {
                        const character = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                        const fontClass = Character.calculateCharacterNameClass(character.team);

                        return prev +
                            `<tr class="text-center" name="\${next.memberId}" data-member-id="\${next.memberId}">
                            <td class="pl-1 pr-1 text-left">
                                \${next.seatNumber}. \${next.nickname}(<span class="\${fontClass}">\${character.name}</span>)
                            </td>
                            <td class="pl-1 pr-1">
                                <input type="checkbox" name="diedCheckbox" \${next.died ? "checked" : ""}>
                            </td>
                            <td class="pl-1 pr-1">
                                <input type="checkbox" name="nominatingCheckbox" \${next.nominating ? "checked" : ""}>
                            </td>
                            <td class="pl-1 pr-1">
                                <input type="checkbox" name="nominatedCheckbox" \${next.nominated ? "checked" : ""}>
                            </td>
                            <td class="pl-1 pr-1">
                                <input type="checkbox" name="votableCheckbox"
                                    \${next.votable ? "checked" : ""} \${next.died ? "" : "disabled"}>
                            </td>
                        </tr>`;
                    }, `<div class="table-responsive">
                        <table class="table align-items-center table-condensed">
                            <thead class="thead-light">
                                <tr class="text-center">
                                    <th scope="col" class="pl-1 pr-1">이름(역할)</th>
                                    <th scope="col" class="pl-1 pr-1">사망함</th>
                                    <th scope="col" class="pl-1 pr-1">지명함</th>
                                    <th scope="col" class="pl-1 pr-1">지명됨</th>
                                    <th scope="col" class="pl-1 pr-1">투표권</th>
                                </tr>
                            </thead>
                            <tbody>`)
                + `         </tbody>
                        </table>
                    </div>`;

            $playerStatusListDiv.append(playerListHtml);

            $playerStatusListDiv.find("input:checkbox[name='diedCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId === memberId);
                player.died = $(event.currentTarget).is(":checked");
            });

            $playerStatusListDiv.find("input:checkbox[name='nominatingCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId === memberId);
                player.nominating = $(event.currentTarget).is(":checked");
            });

            $playerStatusListDiv.find("input:checkbox[name='nominatedCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId === memberId);
                player.nominated = $(event.currentTarget).is(":checked");
            });

            $playerStatusListDiv.find("input:checkbox[name='votableCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId === memberId);
                player.votable = $(event.currentTarget).is(":checked");
            });
        }

        const renderExecution = async () => {
            const $executionDiv = $("#executionDiv");

            const virginPlayer = Character.getInPlayerListById(playerList, "virgin");
            $executionDiv.find("span[name='virginPlayer']").html((virginPlayer ? virginPlayer.nickname : ""));

            const impPlayer = Character.getInPlayerListById(playerList, "imp");
            $executionDiv.find("span[name='impPlayer']").html((impPlayer ? impPlayer.nickname : ""));

            const scarletWomanPlayer = Character.getInPlayerListById(playerList, "scarlet_woman");
            $executionDiv.find("span[name='scarletWomanPlayer']").html((scarletWomanPlayer ? scarletWomanPlayer.nickname : ""));

            const alivePlayerList = playerList.filter(player => !player.died);
            const numberOfVoteSuccess = Math.ceil(alivePlayerList.length / 2);
            $executionDiv.find("span[name='numberOfVoteSuccess']").html(numberOfVoteSuccess);
        }




        const hideCharacterToPlayer = () => {
            playStatus.playerCharacterDisplayed = false;

            const $playerStatusDiv = $("#playerStatusDiv");
            $playerStatusDiv.find("button[name='hideCharacterToPlayerButton']").hide();

            saveGameStatus();
        }

        const resetNominationStatus = () => {
            if (!confirm("현재까지의 모든 투표 상황을 초기화하고 투표를 처음부터 진행합니다.")) {
                return;
            }

            playerList.forEach(player => {
                player.nominating = false;
                player.nominated = false;
            });

            executionModal.nominatingPlayer = null;
            executionModal.nominatedPlayer = null;
            executionModal.votingPlayerList = [];
            $.each(executionModal.diedAndVotedPlayerList, (index, player) => {
                player.votable = true;
            });
            executionModal.diedAndVotedPlayerList = [];
            executionModal.candidatePlayer = null;
            executionModal.candidatePlayerListOfToday = [];
            executionModal.executionPlayerOfToday = null;

            renderPlayerStatusList();
        }

        const savePlayerStatus = () => {
            if (!confirm("현재 상태로 저장하시겠습니까?")) {
                return;
            }

            saveGameStatus();
            renderPlayerStatusList();
            renderExecution();
        }

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

        const readLastPlayLog = playId => {
            return gfn_callGetApi("/api/play/log/last", {playId})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
                })
                .catch(response => console.error('error', response));
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

            document.location.reload();
        }

        const saveGameStatus = () => {
            const log = {
                selectedEditionId,
                selectedCharacterList: JSON.stringify(selectedCharacterList),
                playedCharacterList: JSON.stringify(playedCharacterList),
                playerList: JSON.stringify(playerList),
                playStatus: JSON.stringify(playStatus),
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

            selectedEditionId = lastPlayLogJson.selectedEditionId;
            selectedCharacterList = JSON.parse(lastPlayLogJson.selectedCharacterList);
            playedCharacterList = JSON.parse(lastPlayLogJson.playedCharacterList);
            playerList = JSON.parse(lastPlayLogJson.playerList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

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

        const turnOffBackgroundMusic = () => {
            $("audio[name='backgroundMusic']").each((index, audio) => {
                audio.pause();
            });
        }

        const openMessageModal = messageHtml => {
            messageModal.open(messageHtml);
        }

        const openRuleGuideModal = () => {
            ruleGuideModal.open();
        }

        const openCharacterGuideModal = () => {
            characterGuideModal.open(selectedCharacterList);
        }

        const openTownModal = () => {
            townModal.open(PLAY_ID);
        }

        const openExecutionModal = () => {
            executionModal.open(playerList);
        }

        const openQrLoginModal = () => {
            qrLoginModal.open(createAssignedPlayerList());
        }

        const openSoundEffectModal = () => {
            soundEffectModal.open();
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
    <div class="row">
        <div class="col-md-6 col-xs-12">
            <div class="container mt--7">
                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="backgroundMusicDiv">
                            <div class="card-header bg-white border-0">
                            </div>
                            <div class="card-body">
                                <%@ include file="/WEB-INF/jsp/game/boc/troubleBrewing/jspf/backgroundMusic.jspf" %>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-info" onclick="turnOffBackgroundMusic()">
                                        음악 끄기
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="editionDiv">
                            <%--<p>
                                1. 목표<br/>
                                시간 단축을 위해...<br/>
                                - 닉네임 입력은 참여자가 직접 하도록 한다.<br/> -> 완료
                                - 참여자는 주어진 역할을 확인할 수 있다.<br/> -> 완료
                                <br/>
                                진행 편의를 위해<br/>
                                - 포켓그리모어에서 설정한 역할을 참여자에 맞게 설정할 수 있도록 한다.<br/> -> 완료
                                자동이면 좋겠지만 안되면 직접 선택이라도<br/> -> 완료
                                - 어떤 에디션을 쓸 것인지 호스트 화면에서 지정할 수 있게 한다.<br/> -> 완료
                                지정되면 그에 따라 역할 설명도 자동으로 만들어지도록 한다.<br/> -> 완료
                                커스톰 스크립트라면 포켓그리모어에 붙혀넣기 할 수 있는 json 생성과 복사 기능을 추가한다.<br/> -> 완료
                                - 포켓그리모어에서 죽었을 때 호스트 화면에서도 죽음 표시를 할 수 있는 기능을 추가한다.<br/> -> 완료
                                - 투표 기능은 호스트 화면에서 진행한다.<br/>
                                <br/>
                                게임성을 위해...<br/>
                                - 마을 광장은 참여자 화면에서 볼 수 있게 한다.<br/> -> 완료
                                - html5 canvas를 이용하여 원형으로 세팅한다.<br/>
                                - 뒤로가기 누르지 말라는 경고 문구를 추가한다.<br/> -> 완료
                            </p>--%>
                            <div class="card-header bg-white border-0">
                                <h2>
                                    에디션 선택
                                </h2>
                            </div>
                            <div class="card-body">
                                <div>
                                    <select class="form-control" onchange="selectEdition()"></select>
                                </div>
                                <div class="mt-1">
                                    <textarea rows="4" class="form-control" cols="20"></textarea>
                                </div>
                            </div>

                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-info btn-block" onclick="copyEditionJson()">
                                        복사하기
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="characterDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    참여 역할 선택
                                </h2>
                            </div>
                            <div class="card-body">
                                <p>
                                    트러블 브루잉 추천 조합(8인 기준)<br/>
                                    - 밸런스 : 요리사, 공감능력자, 점쟁이, 장의사, 처녀, 주정뱅이(조사관), 부정한 여자, 임프<br/>
                                    - 조용한 게임 : 공감능력자, 점쟁이, 레이븐키퍼, 슬레이어, 시장, 성자, 독살범, 임프<br/>
                                    - 숙련자 게임 : 세탁부, 점쟁이, 장의사, 슬레이어, 처녀, 은둔자, 스파이, 임프<br/>
                                </p>
                                <div class="" name="characterListDiv"></div>
                                <hr>
                                <div class="text-right" name="playedCharacterCountDiv"></div>
                                <div class="" name="playedCharacterListDiv"></div>
                            </div>
                        </div>
                    </div>
                </div>

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
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="seatDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    플레이어 배치
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="mt-4" name="playerSeatsDiv"></div>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-info" onclick="setPlayerSeatsRandomly()">
                                        무작위 배치
                                    </button>
                                    <%--<button type="button" class="btn btn-info" onclick="setPlayerSeatsSpecifically()" disabled>
                                        지정 배치
                                    </button>--%>
                                    <button type="button" class="btn btn-primary" onclick="confirmPlayerSeatList()">
                                        배치 확정
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="playerStatusDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    플레이어 상태
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="" name="playerStatusListDiv"></div>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-warning btn-block display-none"
                                            name="hideCharacterToPlayerButton" onclick="hideCharacterToPlayer()">
                                        플레이어 캐릭터 숨기기
                                    </button>
                                    <button type="button" class="btn btn-warning btn-block"
                                            name="savePlayerStatusButton" onclick="savePlayerStatus()">
                                        상태 저장
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="executionDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    처형 투표
                                    <a data-toggle="collapse" href="#executionVoteDiv" role="button" aria-expanded="false"
                                       aria-controls="executionVoteDiv">
                                        열기/닫기
                                    </a>
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="collapse" id="executionVoteDiv">
                                    <p>
                                        1. 한 번에 한 명의 플레이어만 지명할 수 있습니다.<br/>
                                        2. 생존 플레이어만 지명할 수 있습니다.<br/>
                                        - 만약 처녀가 지명당했고 지명한 사람이 마을주민이라면 지명한 사람은 즉시 처형됩니다.<br/>
                                        - 처녀가 지명당했고 지명한 사람이 생존 플레이어라면 '처녀 능력 사용됨'으로 바꿔야 합니다.<br/>
                                        - 처녀가 취했거나 중독된 상태라면 지명한 사람이 죽지 않습니다. 다만 이 때에도 '처녀 능력 사용됨'으로 바꿔야 합니다.<br/>
                                        <strong class="font-blue">
                                            - 처녀 : <span name="virginPlayer"></span>
                                        </strong><br/>
                                        3. 각 플레이어는 하루에 한 번만 지명할 수 있으며, 각 플레이어는 하루에 한 번만 지명될 수 있습니다.<br/>
                                        4. 지명한 플레이어에게는 이유를, 지명당한 플레이어에게 변호할 기회를 줍니다.<br/>
                                        5. 투표를 시작합니다. 후보자로부터 시계 반향으로 돌면서 손을 든 플레이어를 셉니다.<br/>
                                        - 생존 플레이어는 하루에 원하는 만큼의 플레이어에게 투표할 수 있습니다.<br/>
                                        - 사망 플레이어는 남은 게임 동안 단 한 번만 투표할 수 있습니다.<br/>
                                        - 생존 플레이어의 수의 절반 이상을 받았다면 처형 대상자가 됩니다.<br/>
                                        <strong class="font-orange">
                                            - 필요한 득표 수 : <span name="numberOfVoteSuccess"></span>
                                        </strong><br/>
                                        6. 투표 결과를 발표합니다.<br/>
                                        7. 다음 처형 투표를 진행합니다. 만약 더 이상 지명하는 플레이어가 없다면 투표가 종료됩니다.<br/>
                                        - 처형 대상자가 없었거나 두 사람 이상인데 투표 수가 같다면 아무도 처형되지 않습니다.<br/>
                                        - 처형 대상자 중 가장 많은 표를 받은 플레이어는 처형됩니다. 만약 악마가 처형되었고 부정한 여자가 없다면 선한 편이 승리합니다.<br/>
                                        <strong class="font-red">
                                            - 임프 : <span name="impPlayer"></span>
                                        </strong><br/>
                                        <strong class="font-red">
                                            - 부정한 여자 : <span name="scarletWomanPlayer"></span>
                                        </strong><br/>
                                    </p>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-info btn-block"
                                            onclick="executionModal.openNominationModal(playerList, selectedCharacterList)">
                                        투표 지명
                                    </button>
                                    <%--<button type="button" class="btn btn-warning btn-block"
                                            onclick="executionModal.resetNomination()">
                                        투표 지명 재설정
                                    </button>--%>
                                    <button type="button" class="btn btn-warning btn-block"
                                            name="resetNominationStatusButton" onclick="resetNominationStatus()">
                                        지명/지명됨 초기화
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow">
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
                                    <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                        게임 설명
                                    </button>
                                    <button type="button" class="btn btn-info btn-block" onclick="openCharacterGuideModal()">
                                        역할 설명
                                    </button>
                                    <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                        마을 광장 보기
                                    </button>
                                    <button type="button" class="btn btn-info btn-block" onclick="openExecutionModal()">
                                        처형 투표 진행
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
        </div>

        <div class="col-md-6 col-xs-12 hidden-xs">
            <div class="container mt--7">
                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow">
                            <div class="card-body p-0">
                                <iframe id="pocketGrimoireIframe" src="https://www.pocketgrimoire.co.uk/en_GB/" height="1000" width="100%"></iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/introductionModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/messageModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/playStatusModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/townModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/executionModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/boc/guide/ruleGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/characterGuideModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/noteModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/soundEffectModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/qrLoginModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
