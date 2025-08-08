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
        let selectedJinxList = [];
        let playedCharacterList = [];
        let playedReminderList = [];
        let travellerCharacterList = [];
        let nightOrderList = [];
        let playerList = [];
        let scriptJson = {};
        let playStatus = {};

        $(async () => {
            await gfn_readPlayablePlayById(PLAY_ID);

            await loadGameStatus();

            const $playerStatusDiv = $("#playerStatusDiv");
            const $filterDiv = $playerStatusDiv.find("div[name='filterDiv']");

            $filterDiv.find("input[type='radio']").on("click", async event => {
                /*console.log($(event.currentTarget).val());
                const filteredBy = $(event.currentTarget).val();*/
                await renderPlayerStatusList();
            });

            console.log('playStatus', playStatus);
            if (Object.keys(playStatus).length === 0) {
                await initializeGame();
                return;
            }

            hideSettingDivs();
            showPlayingDivs();

            await renderEditionInfo();
            await renderPlayerStatusList();
            await renderInfoMessageDiv();
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

        const readMessageList = async () => {
            return await gfn_callGetApi(BOC_DATA_PATH + "/messages/kr_KO.json")
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
            const optionsHtml = editionList
                .sort((prev, next) => calculateEditionIndex(prev.type) - calculateEditionIndex(next.type))
                .reduce((prev, next) => {
                    const typeTag = next.type === "full" ? "F" : "T";
                    return prev + `<option value="\${next.id}">[\${typeTag}] \${next.name}</option>`;
                }, `<option value="">선택</option>`);
            $editionDiv.find("select").append(optionsHtml);
        }

        const calculateEditionIndex = type => {
            if (type === "teensyville") return 1;
            return 0;
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

            scriptJson = await readScriptJsonOfEdition(selected.jsonFileName);

            playStatus = {
                ...playStatus,
                editionId: id,
                editionName: scriptJson[0].name,
                scriptJson,
            }

            scriptJson.splice(0, 1);
            $editionDiv.find("textarea").val(JSON.stringify(scriptJson));

            travellerCharacterList = characterList
                .filter(character => character.team === POSITION.TRAVELLER.name && character.edition === selectedEditionId)
                .sort((prev, next) => prev.id - next.id);

            await renderCharacterList(scriptJson, characterList);
            await renderJinxList(selectedCharacterList);


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
                if (next.team === POSITION.FABLED.name) {
                    return prev +
                        `<div class="col-4 text-center pt-2 \${fontClass}" name="\${next.id}">
                            <small class="\${fontClass}">\${next.name}</small>
                            <img src="\${next.image}" class="img-responsive img-rounded m-auto" />
                        </div>`;
                }

                return prev +
                    `<div class="col-4 text-center pt-2 \${fontClass}" name="\${next.id}">
                        <small class="\${fontClass}">\${next.name}</small>
                        <img src="\${next.image}" class="img-responsive img-thumbnail m-auto"
                            onclick="setPlayedCharacter('\${next.id}')" />
                    </div>`;
            }, `<div class="row">`) + '</div>';

            $characterListDiv.append(listHtml);

            const playerSetting = initializationSetting.player
                .find(player => playerList.length === player.townsFolk + player.outsider + player.minion + player.demon);

            const roleInitializationHtml = `
                <span class="text-default">총 \${playerList.length}명</span>
                (<span class="text-primary">마을주민 \${playerSetting.townsFolk}명</span>,
                <span class="text-info">이방인 \${playerSetting.outsider}명</span>,
                <span class="text-warning">하수인 \${playerSetting.minion}명</span>,
                <span class="text-danger">악마 \${playerSetting.demon}명</span>)`;
            $characterDiv.find("span[name='roleInitialization']").html(roleInitializationHtml);
        }

        const renderJinxList = selectedCharacterList => {
            selectedJinxList = [];

            selectedCharacterList.forEach(character => {
                const source = jinxList.find(jinx => jinx.id === character.id);
                if (source) {
                    const targetList = source.jinx;

                    targetList.forEach(target => {
                        const existsTarget = selectedCharacterList.find(character => target.id === character.id);
                        if (existsTarget) {
                            selectedJinxList.push({
                                source: source.id,
                                target: target.id,
                                reason: target.reason,
                            })
                        }
                    });
                }
            });

            const listHtml = selectedJinxList.reduce((prev, next) => {
                const sourceCharacter = Character.getInCharacterListById(selectedCharacterList, next.source);
                const sourceFontClass = Character.calculateCharacterNameClass(sourceCharacter.team);
                const targetCharacter = Character.getInCharacterListById(selectedCharacterList, next.target);
                const targetFontClass = Character.calculateCharacterNameClass(sourceCharacter.team);

                return prev +
                    `<div class="col-12 pt-2">
                        <span class="\${sourceFontClass}">\${sourceCharacter.name}</span> & <span class="\${targetFontClass}">\${targetCharacter.name}</span><br/>
                        <small>\${next.reason}</small>
                    </div>`;
            }, `<div class="row">`) + '</div>';

            const $characterDiv = $("#characterDiv");
            const $selectedJinxListDiv = $characterDiv.find("div[name='selectedJinxListDiv']");
            $selectedJinxListDiv.empty().append(listHtml);
        }

        const setPlayedCharacter = characterId => {
            if (playerList.length <= playedCharacterList.length) {
                // alert("플레이어 수보다 많이 선택할 수 없습니다");
                return;
            }

            playedCharacterList.push({
                characterId,
                displayedCharacterId: characterId
            });

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
            const spanClass = playerList.length === playedCharacterList.length ? "text-primary font-weight-bold" : "";
            $playedCharacterCountDiv.empty().append(`<span class="\${spanClass}">\${playedCharacterList.length} / \${playerList.length}</span>`);

            const listHtml = playedCharacterList.reduce((prev, next) => {
                const character = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                const fontClass = Character.calculateCharacterNameClass(character.team);

                return prev +
                    `<div class="col-4 text-center pt-2 \${fontClass}">
                        <small class="\${fontClass}">\${character.name}</small>
                        <img src="\${character.image}" class="img-responsive img-thumbnail m-auto"
                            onclick="removePlayedCharacter('\${next.characterId}')" />
                    </div>`;
            }, `<div class="row">`) + '</div>';

            const $playedCharacterListDiv = $characterDiv.find("div[name='playedCharacterListDiv']");
            $playedCharacterListDiv.empty().append(listHtml);
        }

        const removePlayedCharacter = characterId => {
            const thrownAwayIndex = playedCharacterList.findIndex(item => Character.characterIdEquals(item.characterId, characterId));
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

        const confirmPlayedCharacterList = async () => {
            if (playedCharacterList.length !== playerList.length) {
                alert("참여 역할들이 모두 선택되지 않았습니다.");
                return;
            }

            if (!confirm("현재 역할로 확정하시겠습니까?")) {
                return;
            }

            $("#characterDiv").hide();

            renderCharacterDisplayedDiv();
        }

        const renderCharacterDisplayedDiv = () => {
            const $characterDisplayedDiv = $("#characterDisplayedDiv");
            const $playedCharacterListDiv = $characterDisplayedDiv.find("div[name='playedCharacterListDiv']");
            $playedCharacterListDiv.empty();

            const listHtml = playedCharacterList
                /*.map(playedCharacter => Character.getInCharacterListById(selectedCharacterList, playedCharacter.characterId))
                .sort((prev, next) => calculateTeamIndex(prev.team) - calculateTeamIndex(next.team))*/
                .reduce((prev, next) => {
                    const character = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                    const displayedCharacter = Character.getInCharacterListById(selectedCharacterList, next.displayedCharacterId);
                    const fontClass = Character.calculateCharacterNameClass(character.team);
                    const displayedCharacterFontClass = Character.calculateCharacterNameClass(displayedCharacter.team);

                    return prev +
                        `<div class="col-4 text-center pt-2 \${fontClass}">
                            <small class="\${fontClass}">\${character.name}</small>
                            <img src="\${character.image}" class="img-responsive img-rounded m-auto" />
                        </div>
                        <div class="col-4 text-center display-1" style="margin: auto">
                            <i class="ni ni-bold-right"></i>
                        </div>
                        <div class="col-4 text-center pt-2 \${displayedCharacterFontClass}"
                            name="displayedCharacterDiv" data-character-id="\${next.characterId}">
                            <small class="\${displayedCharacterFontClass}">\${displayedCharacter.name}</small>
                            <img src="\${displayedCharacter.image}" class="img-responsive img-thumbnail m-auto"
                                onclick="openSetCharacterDisplayedModal('\${next.characterId}')" />
                        </div>`;
                }, `<div class="row">`) + '</div>';

            $playedCharacterListDiv.append(listHtml);
        }

        const openSetCharacterDisplayedModal = characterId => {
            characterModal.open(selectedCharacterList, characterId, null, setCharacterDisplayed);
        }

        const setCharacterDisplayed = (characterId, displayedCharacterId) => {
            const playedCharacter = playedCharacterList.find(character => character.characterId === characterId);
            playedCharacter.displayedCharacterId = displayedCharacterId;
            renderCharacterDisplayedDiv();
        }

        const confirmCharacterDisplayed = async () => {
            if (!confirm("현재 표시 역할로 확정하시겠습니까?")) {
                return;
            }

            playedReminderList = [];

            playedCharacterList.forEach(played => {
                const character = Character.getInCharacterListById(selectedCharacterList, played.characterId);
                if (character.reminders && character.reminders.length > 0) {
                    character.reminders.forEach(reminder => {
                        playedReminderList.push({
                            characterId: character.id,
                            reminder,
                        });
                    });
                }
            });

            selectedCharacterList.forEach(selected => {
                if (selected.remindersGlobal && selected.remindersGlobal.length > 0) {
                    selected.remindersGlobal.forEach(reminder => {
                        playedReminderList.push({
                            characterId: selected.id,
                            reminder,
                        });
                    });
                }
            });

            selectedCharacterList.forEach(selected => {
                const character = Character.getInCharacterListById(selectedCharacterList, selected.id);
                if (character.team === POSITION.FABLED.name
                    && selected.reminders
                    && selected.reminders.length > 0) {
                    selected.reminders.forEach(reminder => {
                        playedReminderList.push({
                            characterId: character.id,
                            reminder,
                        });
                    });
                }
            });

            $("#characterDisplayedDiv").hide();

            setPlayerSeatsRandomly();
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
                    const characterId = playedCharacterList[index].characterId;
                    return {
                        ...originalPlayer,
                        seatNumber: index + 1,
                        characterId,
                        alignment: Character.getAlignmentInCharacterListById(selectedCharacterList, characterId),
                        nominating: false,
                        nominated: false,
                        died: false,
                        votable: true,
                        reminderList: [],
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
            if (!confirm("현재 자리와 플레이어 역할을 확정하시겠습니까?")) {
                return;
            }

            playStatus = {
                ...playStatus,
                playerCharacterDisplayed: true,
                changeToDay: true,
            }

            saveGameStatus();

            hideSettingDivs();
            showPlayingDivs();

            await renderEditionInfo();
            await renderPlayerStatusList();
            await renderInfoMessageDiv();
        }

        const showSettingDivs = () => {
            $("#editionDiv").show();
            $("#characterDiv").show();
            $("#characterDisplayedDiv").show();
            $("#seatDiv").show();
        }

        const hideSettingDivs = () => {
            $("#editionDiv").hide();
            $("#characterDiv").hide();
            $("#characterDisplayedDiv").hide();
            $("#seatDiv").hide();
        }

        const showPlayingDivs = () => {
            $("#editionInfoDiv").show();
            $("#playerStatusDiv").show();
            $("#backgroundMusicDiv").show();
            $("#executionDiv").show();
            $("#infoMessageDiv").show();
        }

        const hidePlayingDivs = () => {
            $("#editionInfoDiv").hide();
            $("#playerStatusDiv").hide();
            $("#backgroundMusicDiv").hide();
            $("#executionDiv").hide();
            $("#infoMessageDiv").hide();
        }

        const renderEditionInfo = async () => {
            const $editionInfoDiv = $("#editionInfoDiv");
            $editionInfoDiv.find("[name='editionName']").text(playStatus.editionName);

            const scriptJson = playStatus.scriptJson;

            scriptJson.splice(0, 1);
            $editionInfoDiv.find("textarea").val(JSON.stringify(scriptJson));
        }

        const renderPlayerStatusList = () => {
            const $playerStatusDiv = $("#playerStatusDiv");

            if (playStatus.playerCharacterDisplayed) {
                $playerStatusDiv.find("button[name='hideCharacterToPlayerButton']").show();
            }

            if (playStatus.isDay) {
                $playerStatusDiv.find("span[name='daySpan']").text("☀️");
                $playerStatusDiv.find("button[name='changeToNightButton']").show();
            } else {
                $playerStatusDiv.find("span[name='daySpan']").text("🌙");
                $playerStatusDiv.find("button[name='changeToDayButton']").show();
            }

            const $playerStatusListDiv = $playerStatusDiv.find("div[name='playerStatusListDiv']");
            $playerStatusListDiv.empty();

            const $filterDiv = $playerStatusDiv.find("div[name='filterDiv']");
            const filteredBy = $filterDiv.find("input[type='radio']:checked").val() ?? "seatNumber";

            let filteredPlayerList = playerList;
            // if (filteredBy) {
            if (filteredBy === "seatNumber") {
                filteredPlayerList = playerList.sort((prev, next) => prev.seatNumber - next.seatNumber);
            }

            if (filteredBy === "firstNight") {
                filteredPlayerList = playerList
                    .filter(player => {
                        // const character = Character.getInCharacterListById(selectedCharacterList, player.characterId);
                        const playedCharacter = playedCharacterList
                            .find(playedCharacter => playedCharacter.characterId === player.characterId);
                        const displayedCharacter = Character.getInCharacterListById(selectedCharacterList, playedCharacter.displayedCharacterId);
                        return displayedCharacter.firstNight > 0;
                    })
                    .sort((prev, next) => {
                        const prevCharacter = Character.getInCharacterListById(selectedCharacterList, prev.characterId);
                        const nextCharacter = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                        return prevCharacter.firstNight - nextCharacter.firstNight;
                    });
            }

            if (filteredBy === "otherNight") {
                filteredPlayerList = playerList
                    .filter(player => {
                        const playedCharacter = playedCharacterList
                            .find(playedCharacter => playedCharacter.characterId === player.characterId);
                        const displayedCharacter = Character.getInCharacterListById(selectedCharacterList, playedCharacter.displayedCharacterId);
                        //const character = Character.getInCharacterListById(selectedCharacterList, player.characterId);
                        return displayedCharacter.otherNight > 0;
                    })
                    .sort((prev, next) => {
                        const prevCharacter = Character.getInCharacterListById(selectedCharacterList, prev.characterId);
                        const nextCharacter = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                        return prevCharacter.otherNight - nextCharacter.otherNight;
                    });
            }
            // }

            const playerListHtml = filteredPlayerList
                    .reduce((prev, next) => {
                        const player = next;

                        const character = Character.getInCharacterListById(selectedCharacterList, player.characterId);
                        const fontClass = Character.calculateCharacterNameClass(character.team);

                        const wikiUrl = "https://wiki.bloodontheclocktower.com/";
                        const characterHtml =
                            `<a href="\${wikiUrl + capitalizeFirstAndAfterUnderBar(player.characterId)}" target="_blank" class="\${fontClass}">\${character.name}</a>`;

                        const playedCharacter = playedCharacterList
                            .find(playedCharacter => playedCharacter.characterId === player.characterId);

                        const displayedCharacter = Character.getInCharacterListById(selectedCharacterList, playedCharacter.displayedCharacterId);
                        const displayedFontClass = Character.calculateCharacterNameClass(displayedCharacter.team);
                        const displayedCharacterHtml = playedCharacter.characterId !== playedCharacter.displayedCharacterId
                            ? `→<a href="\${wikiUrl + capitalizeFirstAndAfterUnderBar(displayedCharacter.id)}" target="_blank" class="\${displayedFontClass}">\${displayedCharacter.name}</a>`
                            : "";

                        const statusHtml =
                            `<tr class="text-center" name="\${player.memberId}" data-member-id="\${player.memberId}">
                                <td class="pl-1 text-left">
                                    \${player.seatNumber}. \${player.nickname}<br/>\${characterHtml}\${displayedCharacterHtml}
                                </td>
                                <td class="pl-1">
                                    <input type="checkbox" name="diedCheckbox" \${player.died ? "checked" : ""}>
                                </td>
                                <td class="pl-1">
                                    <input type="checkbox" name="nominatingCheckbox"
                                        \${player.nominating ? "checked" : ""} \${(player.died || player.nominating) ? "disabled" : ""}>
                                </td>
                                <td class="pl-1">
                                    <input type="checkbox" name="nominatedCheckbox"
                                        \${player.nominated ? "checked" : ""} \${player.nominated ? "disabled" : ""}>
                                </td>
                                <td class="pl-1">
                                    <input type="checkbox" name="votableCheckbox"
                                        \${player.votable ? "checked" : ""} \${player.died ? "" : "disabled"}>
                                </td>
                            </tr>`;

                        const playedReminderListHtml = player.reminderList.reduce((prev, next) => {
                            const character = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                            return prev
                                + "<button class=\"" + Character.createChoiceButtonClass(character.team) + "\""
                                + " onclick=\"removeReminder(" + player.memberId + ", '" + next.characterId + "', '" + next.reminder + "')\" >"
                                + " " + "[" + character.name + "] " + next.reminder
                                + "</button>";
                        }, "");

                        const addReminderButtonHtml = playedReminderList.length > 0
                            ? `<button class="btn btn-sm btn-outline-default mr-1 my-1" name="\${next.memberId}"
                                        onclick="openAddPlayerReminderModal(\${player.memberId})">
                                        +
                                    </button>`
                            : "";

                        const changeCharacterButtonHtml =
                            `<button class="btn btn-sm btn-outline-default mr-1 my-1" name="\${next.memberId}"
                                onclick="openChangePlayerCharacterModal(\${player.memberId}, '\${player.characterId}')">
                                ↔
                            </button>`;

                        const alignmentFontClass = player.alignment.name === ALIGNMENT.GOOD.name ? "text-primary" : "text-danger";
                        const changeAlignmentButtonHtml =
                            `<button class="btn btn-sm btn-outline-default mr-1 my-1" name="\${next.memberId}"
                                onclick="changeAlignment(\${player.memberId})">
                                <span class="\${alignmentFontClass}">\${player.alignment.title}</span>
                            </button>`;

                        const actionListHtml =
                            `<tr class="text-center">
                                <td class="p-1 text-left" colspan="5">
                                    \${playedReminderListHtml} \${addReminderButtonHtml} \${changeCharacterButtonHtml} \${changeAlignmentButtonHtml}
                                </td>
                            </tr>`;

                        let nightReminderHtml = "";
                        if (filteredBy === "firstNight" && character.firstNightReminder) {
                            nightReminderHtml =
                                `<tr class="text-center">
                                    <td class="p-1 text-left" colspan="5">
                                        <textarea rows="4" class="form-control">\${character.firstNightReminder}</textarea>
                                    </td>
                                </tr>`;
                        }

                        if (filteredBy === "otherNight" && character.otherNightReminder) {
                            nightReminderHtml =
                                `<tr class="text-center">
                                    <td class="p-1 text-left" colspan="5">
                                        <textarea rows="4" class="form-control">\${character.otherNightReminder}</textarea>
                                    </td>
                                </tr>`;
                        }

                        return prev + statusHtml + actionListHtml + nightReminderHtml;
                    }, `<div class="table-responsive">
                        <table class="table align-items-center table-condensed">
                            <thead class="thead-light">
                                <tr class="text-center">
                                    <th scope="col" class="pl-1">이름(역할)</th>
                                    <th scope="col" class="pl-1">사망함</th>
                                    <th scope="col" class="pl-1">지명함</th>
                                    <th scope="col" class="pl-1">지명됨</th>
                                    <th scope="col" class="pl-1">투표권</th>
                                </tr>
                            </thead>
                            <tbody>`)
                + `         </tbody>
                        </table>
                    </div>`;

            $playerStatusListDiv.append(playerListHtml);

            $playerStatusListDiv.find("input:checkbox[name='diedCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId == memberId);
                player.died = $(event.currentTarget).is(":checked");
            });

            $playerStatusListDiv.find("input:checkbox[name='nominatingCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId == memberId);
                player.nominating = $(event.currentTarget).is(":checked");
            });

            $playerStatusListDiv.find("input:checkbox[name='nominatedCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId == memberId);
                player.nominated = $(event.currentTarget).is(":checked");
            });

            $playerStatusListDiv.find("input:checkbox[name='votableCheckbox']").on("click", event => {
                const memberId = $(event.currentTarget).closest("tr").data("memberId");
                const player = playerList.find(player => player.memberId == memberId);
                player.votable = $(event.currentTarget).is(":checked");
            });
        }

        const capitalizeFirstAndAfterUnderBar = source => {
            if (source.length === 0) return source;

            let parts = source.split("_");
            parts[0] = parts[0].charAt(0).toUpperCase() + parts[0].slice(1);

            for (let i = 1; i < parts.length; i++) {
                parts[i] = parts[i].charAt(0).toUpperCase() + parts[i].slice(1);
            }

            return parts.join("_");
        }

        const openAddPlayerReminderModal = memberId => {
            reminderModal.open(selectedCharacterList, playedReminderList, memberId, addPlayerReminder);
        }

        const addPlayerReminder = async (memberId, characterId, reminder) => {
            const player = playerList.find(player => player.memberId == memberId);
            player.reminderList.push({characterId, reminder});
            await renderPlayerStatusList();
        }

        const removeReminder = async (memberId, characterId, reminder) => {
            const player = playerList.find(player => player.memberId == memberId);
            if (!confirm(player.nickname + "님의 '" + reminder + "' 리마인더를 제거하시겠습니까?")) {
                return;
            }

            const thrownAwayIndex = player.reminderList
                .findIndex(item => item.characterId === characterId && item.reminder === reminder);
            if (thrownAwayIndex > -1) {
                player.reminderList.splice(thrownAwayIndex, 1);
            }

            await renderPlayerStatusList();
        }

        const changeAlignment = async memberId => {
            const player = playerList.find(player => player.memberId == memberId);
            if (!confirm(player.nickname + "님의 편을 바꾸시겠습니까?")) {
                return;
            }

            player.alignment = player.alignment.name === ALIGNMENT.GOOD.name ? ALIGNMENT.EVIL : ALIGNMENT.GOOD;
            await renderPlayerStatusList();
        }

        const openChangePlayerCharacterModal = (memberId, characterId) => {
            const playableCharacterList = selectedCharacterList.filter(selected => selected.team !== POSITION.FABLED.name);
            characterModal.open(playableCharacterList, characterId, memberId, changePlayerCharacter);
        }

        const changePlayerCharacter = async (characterId, selectedCharacterId, memberId) => {
            const player = playerList.find(player => player.memberId == memberId);
            const character = Character.getInCharacterListById(selectedCharacterList, characterId);
            const selectedCharacter = Character.getInCharacterListById(selectedCharacterList, selectedCharacterId);

            if (!confirm(player.nickname + "님의 역할을 [" + character.name + "]에서 [" + selectedCharacter.name + "]로 바꾸시겠습니까?")) {
                return;
            }

            player.characterId = selectedCharacterId;

            const thrownAwayIndex = playedCharacterList.findIndex(item => Character.characterIdEquals(item.characterId, characterId));
            if (thrownAwayIndex > -1) {
                playedCharacterList.splice(thrownAwayIndex, 1);
            }

            playedCharacterList.push({
                characterId: selectedCharacterId,
                displayedCharacterId: selectedCharacterId
            });

            if (selectedCharacter.reminders && selectedCharacter.reminders.length > 0) {
                selectedCharacter.reminders.forEach(reminder => {
                    playedReminderList.push({
                        characterId: selectedCharacterId,
                        reminder,
                    });
                });
            }

            await renderPlayerStatusList();
        }


        const renderInfoMessageDiv = async () => {
            const messageList = await readMessageList();

            const $infoMessageDiv = $("#infoMessageDiv");

            const setInfoMessageTextDivHtml = messageList.reduce((prev, next) => {
                return prev +
                    `<button class="btn btn-sm btn-outline-default mr-1 my-1" name="\${next.id}"
                        onclick="setInfoMessageText('\${next.id}', '\${next.text}')">
                        \${next.text}
                    </button>`;
            }, "");

            const $setInfoMessageTextDiv = $infoMessageDiv.find("div[name='setInfoMessageTextDiv']");
            $setInfoMessageTextDiv.append(setInfoMessageTextDivHtml);

            const setInfoMessageCharacterDivHtml = selectedCharacterList.reduce((prev, next) => {
                const fontClass = Character.calculateCharacterNameClass(next.team);
                const played = playedCharacterList.some(played => Character.characterIdEquals(played.characterId, next.id));
                const playedClass = played ? "font-weight-bold" : "";
                const playedIcon = played ? "v" : "";

                return prev +
                    `<div class="col-3 text-center pt-2 \${fontClass}" name="\${next.id}">
                        <small class="\${fontClass} \${playedClass}">\${playedIcon} \${next.name}</small>
                        <img src="\${next.image}" class="img-responsive img-rounded m-auto"
                            onclick="setInfoMessageCharacter('\${next.id}')" />
                    </div>`;
            }, `<div class="row">`) + '</div>';

            const $setInfoMessageCharacterDiv = $infoMessageDiv.find("div[name='setInfoMessageCharacterDiv']");
            $setInfoMessageCharacterDiv.append(setInfoMessageCharacterDivHtml);

            const setInfoMessagePlayerDivHtml = playerList.reduce((prev, next) => {
                const character = Character.getInCharacterListById(selectedCharacterList, next.characterId);
                const buttonClass = Character.createChoiceButtonClass(character.team);
                return prev +
                    `<button class="\${buttonClass}" name="\${next.memberId}"
                        onclick="setInfoMessagePlayer('\${next.nickname}')">
                        \${next.nickname}(\${character.name})
                    </button>`;
            }, "");

            const $setInfoMessagePlayerDiv = $infoMessageDiv.find("div[name='setInfoMessagePlayerDiv']");
            $setInfoMessagePlayerDiv.append(setInfoMessagePlayerDivHtml);

            const teamList = [
                POSITION.TOWNS_FOLK,
                POSITION.OUTSIDER,
                POSITION.MINION,
                POSITION.DEMON,
                POSITION.TRAVELLER,
            ];
            const setInfoMessageTeamDivHtml = teamList.reduce((prev, next) => {
                return prev +
                    `<button class="btn btn-sm btn-outline-default mr-1 my-1" name="\${next.name}"
                        onclick="setInfoMessageTeam('\${next.name}', '\${next.title}')">
                        \${next.title}
                    </button>`;
            }, "");

            const $setInfoMessageTeamDiv = $infoMessageDiv.find("div[name='setInfoMessageTeamDiv']");
            $setInfoMessageTeamDiv.append(setInfoMessageTeamDivHtml);

            const alignmentList = [
                ALIGNMENT.GOOD,
                ALIGNMENT.EVIL,
            ];
            const setInfoMessageAlignmentDivHtml = alignmentList.reduce((prev, next) => {
                return prev +
                    `<button class="btn btn-sm btn-outline-default mr-1 my-1" name="\${next.name}"
                        onclick="setInfoMessageAlignment('\${next.name}', '\${next.title}')">
                        \${next.title}
                    </button>`;
            }, "");

            const $setInfoMessageAlignmentDiv = $infoMessageDiv.find("div[name='setInfoMessageAlignmentDiv']");
            $setInfoMessageAlignmentDiv.append(setInfoMessageAlignmentDivHtml);
        }

        const setInfoMessageText = (id, text) => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageTextDiv = $infoMessageResultDiv.find("div[name='infoMessageTextDiv']");

            const html =
                `<div class="text-center display-4" name="\${id}" onclick="removeInfoMessageText('\${id}')">
                    \${text}
                </div>`;
            $infoMessageTextDiv.empty().html(html);
        }

        const removeInfoMessageText = id => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageTextDiv = $infoMessageResultDiv.find("div[name='infoMessageTextDiv']");
            $infoMessageTextDiv.find("div[name=" + id + "]").remove();
        }

        const setInfoMessageCharacter = characterId => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageCharacterDiv = $infoMessageResultDiv.find("div[name='infoMessageCharacterDiv']");

            const character = Character.getInCharacterListById(selectedCharacterList, characterId);
            const fontClass = Character.calculateCharacterNameClass(character.team);

            const html =
                `<div class="col-6 pt-2 \${fontClass}" name="\${character.id}" style="margin: auto;"
                    onclick="removeInfoMessageCharacter('\${character.id}')">
                    <span class="\${fontClass}">\${character.name}<span/>
                    <img src="\${character.image}" class="img-responsive img-rounded m-auto" />
                </div>`;
            $infoMessageCharacterDiv.append(html);
        }

        const removeInfoMessageCharacter = characterId => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageCharacterDiv = $infoMessageResultDiv.find("div[name='infoMessageCharacterDiv']");
            $infoMessageCharacterDiv.find("div[name=" + characterId + "]").remove();
        }

        const setInfoMessagePlayer = nickname => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessagePlayerDiv = $infoMessageResultDiv.find("div[name='infoMessagePlayerDiv']");

            const html =
                `<div class="col-10 pt-2" name="\${nickname}" style="margin: auto;"
                    onclick="removeInfoMessagePlayer('\${nickname}')">
                    <span class="text-center display-4">\${nickname}</span>
                </div>`;
            $infoMessagePlayerDiv.append(html);
        }

        const removeInfoMessagePlayer = nickname => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessagePlayerDiv = $infoMessageResultDiv.find("div[name='infoMessagePlayerDiv']");
            $infoMessagePlayerDiv.find("div[name=" + nickname + "]").remove();
        }

        const setInfoMessageTeam = (name, title) => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageTeamDiv = $infoMessageResultDiv.find("div[name='infoMessageTeamDiv']");

            const html =
                `<div class="col-10 pt-2" name="\${name}" style="margin: auto;"
                    onclick="removeInfoMessageTeam('\${name}')">
                    <span class="text-center display-4">\${title}</span>
                </div>`;
            $infoMessageTeamDiv.append(html);
        }

        const removeInfoMessageTeam = name => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageTeamDiv = $infoMessageResultDiv.find("div[name='infoMessageTeamDiv']");
            $infoMessageTeamDiv.find("div[name=" + name + "]").remove();
        }

        const setInfoMessageAlignment = (name, title) => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageAlignmentDiv = $infoMessageResultDiv.find("div[name='infoMessageAlignmentDiv']");

            const html =
                `<div class="col-10 pt-2" name="\${name}" style="margin: auto;"
                    onclick="removeInfoMessageAlignment('\${name}')">
                    <span class="text-center display-4">\${title}</span>
                </div>`;
            $infoMessageAlignmentDiv.append(html);
        }

        const removeInfoMessageAlignment = name => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            const $infoMessageAlignmentDiv = $infoMessageResultDiv.find("div[name='infoMessageAlignmentDiv']");
            $infoMessageAlignmentDiv.find("div[name=" + name + "]").remove();
        }

        const resetInfoMessageResult = () => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");
            $infoMessageResultDiv.find("div").empty();
        }

        const hideCharacterToPlayer = () => {
            playStatus.playerCharacterDisplayed = false;

            const $playerStatusDiv = $("#playerStatusDiv");
            $playerStatusDiv.find("button[name='hideCharacterToPlayerButton']").hide();

            saveGameStatus();
        }

        const changeToDay = () => {
            playStatus.isDay = true;

            const $playerStatusDiv = $("#playerStatusDiv");
            $playerStatusDiv.find("span[name='daySpan']").text("☀️");
            $playerStatusDiv.find("button[name='changeToDayButton']").hide();
            $playerStatusDiv.find("button[name='changeToNightButton']").show();

            saveGameStatus();
        }

        const changeToNight = () => {
            playStatus.isDay = false;

            const $playerStatusDiv = $("#playerStatusDiv");
            $playerStatusDiv.find("span[name='daySpan']").text("🌙");
            $playerStatusDiv.find("button[name='changeToNightButton']").hide();
            $playerStatusDiv.find("button[name='changeToDayButton']").show();

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

            renderPlayerStatusList();
        }


        /*const restNomination = () => {
            if (!confirm("지명 상태를 초기화하시겠습니까?")) {
                return;
            }

            playerList.map(player => {
                if (!player.died) {
                    player.nominating = false;
                }

                player.nominated = false;
            });

            renderPlayerStatusList();
        }*/

        const openAddTravellerCharacterModal = () => {
            addTravellerModal.open(
                PLAY_ID,
                playerList,
                travellerCharacterList,
                selectedCharacterList,
                playedCharacterList,
                playedReminderList
            );
        }

        const savePlayerStatus = () => {
            if (!confirm("현재 상태로 저장하시겠습니까?")) {
                return;
            }

            saveGameStatus();
            renderPlayerStatusList();
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
                selectedJinxList: JSON.stringify(selectedJinxList),
                playedCharacterList: JSON.stringify(playedCharacterList),
                playedReminderList: JSON.stringify(playedReminderList),
                travellerCharacterList: JSON.stringify(travellerCharacterList),
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
            selectedJinxList = JSON.parse(lastPlayLogJson.selectedJinxList);
            playedCharacterList = JSON.parse(lastPlayLogJson.playedCharacterList);
            playedReminderList = JSON.parse(lastPlayLogJson.playedReminderList);
            travellerCharacterList = JSON.parse(lastPlayLogJson.travellerCharacterList);
            playerList = JSON.parse(lastPlayLogJson.playerList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

            console.log('game status loaded !!');
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

        const openCharacterGuideModal = async () => {
            characterGuideModal.open(playStatus.editionName, selectedCharacterList, selectedJinxList);
        }

        const openTownModal = () => {
            townModal.open(PLAY_ID);
        }

        const openInfoMessageModal = () => {
            const $infoMessageDiv = $("#infoMessageDiv");
            const $infoMessageResultDiv = $infoMessageDiv.find("div[name='infoMessageResultDiv']");

            const $infoMessageTextDiv = $infoMessageResultDiv.find("div[name='infoMessageTextDiv']");
            const $infoMessageCharacterDiv = $infoMessageResultDiv.find("div[name='infoMessageCharacterDiv']");
            const $infoMessagePlayerDiv = $infoMessageResultDiv.find("div[name='infoMessagePlayerDiv']");
            const $infoMessageTeamDiv = $infoMessageResultDiv.find("div[name='infoMessageTeamDiv']");
            const $infoMessageAlignmentDiv = $infoMessageResultDiv.find("div[name='infoMessageAlignmentDiv']");
            const $infoMessageDirectDiv = $infoMessageResultDiv.find("div[name='infoMessageDirectDiv']");
            const infoMessageDirect = $infoMessageDirectDiv.find("input").val();

            const html = $infoMessageTextDiv[0].outerHTML + "<br/>"
                + $infoMessageCharacterDiv[0].outerHTML + "<br/>"
                + $infoMessagePlayerDiv[0].outerHTML + "<br/>"
                + $infoMessageTeamDiv[0].outerHTML + "<br/>"
                + $infoMessageAlignmentDiv[0].outerHTML + "<br/>"
                + (infoMessageDirect ? `<br/><span class="text-center display-4">\${infoMessageDirect}</span>` : ``);

            openMessageModal(html);
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
                                <div class="" name="characterListDiv"></div>
                                <hr class="mt-2 mb-2">
                                <h4>참여 역할</h4>
                                <div class="text-right" name="playedCharacterCountDiv"></div>
                                <h4><span name="roleInitialization"></span></h4>
                                <div class="" name="playedCharacterListDiv"></div>
                                <hr class="mt-2 mb-2">
                                <h4>징크스</h4>
                                <div class="" name="selectedJinxListDiv"></div>
                                <hr class="mt-2 mb-2">
                                트러블 브루잉 추천 조합(8인 기준)<br/>
                                <small>
                                    - 밸런스 : 요리사, 공감능력자, 점쟁이, 장의사, 처녀, 주정뱅이(조사관), 부정한 여자, 임프<br/>
                                    - 조용한 게임 : 공감능력자, 점쟁이, 레이븐키퍼, 슬레이어, 시장, 성자, 독살범, 임프<br/>
                                    - 숙련자 게임 : 세탁부, 점쟁이, 장의사, 슬레이어, 처녀, 은둔자, 스파이, 임프<br/>
                                </small>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-primary"
                                            onclick="confirmPlayedCharacterList()">
                                        역할 확정
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow display-none" id="characterDisplayedDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    표시 역할 선택
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="" name="playedCharacterListDiv"></div>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-primary" onclick="confirmCharacterDisplayed()">
                                        표시 역할 확정
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%--<div class="row">
                    <div class="col-xl-12 pr-0 pl-0">
                        <div class="card bg-transparent">
                            <div class="card-body p-0">
                                <%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/pocketGrimoire.jspf" %>
                            </div>
                        </div>
                    </div>
                </div>--%>

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
                        <div class="card shadow display-none" id="editionInfoDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    에디션 정보
                                    <a data-toggle="collapse" href="#editionInfoBodyDiv" role="button"
                                       aria-expanded="false"
                                       aria-controls="playerStatusListDiv">
                                        열기/닫기
                                    </a>
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="collapse" id="editionInfoBodyDiv">
                                    <h3 name="editionName"></h3>
                                    <div class="mt-1">
                                        <textarea rows="4" class="form-control" cols="20"></textarea>
                                    </div>
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
                                    <a data-toggle="collapse" href="#playerStatusBodyDiv" role="button"
                                       aria-expanded="false"
                                       aria-controls="playerStatusBodyDiv">
                                        열기/닫기
                                    </a>
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="collapse" id="playerStatusBodyDiv">
                                    <div class="row">
                                        <div class="col-10" name="filterDiv">
                                            <input type="radio" id="filterBySeatNumber" name="playerStatusFilter"
                                                   value="seatNumber" checked/>
                                            <label for="filterBySeatNumber">자리 순서</label>
                                            <input type="radio" id="filterByFirstNight" name="playerStatusFilter"
                                                   value="firstNight"/>
                                            <label for="filterByFirstNight">첫날 밤</label>
                                            <input type="radio" id="filterByOtherNight" name="playerStatusFilter"
                                                   value="otherNight"/>
                                            <label for="filterByOtherNight">다음날 밤</label>
                                        </div>
                                        <div class="col-2">
                                            <span name="daySpan"></span>
                                        </div>
                                    </div>

                                    <div name="playerStatusListDiv" id="playerStatusListDiv"></div>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-warning btn-block display-none"
                                            name="hideCharacterToPlayerButton" onclick="hideCharacterToPlayer()">
                                        플레이어 캐릭터 숨기기
                                    </button>
                                    <button type="button" class="btn btn-warning btn-block display-none"
                                            name="changeToDayButton" onclick="changeToDay()">
                                        ☀️ 낮으로 변경
                                    </button>
                                    <button type="button" class="btn btn-warning btn-block display-none"
                                            name="changeToNightButton" onclick="changeToNight()">
                                        🌙 밤으로 변경
                                    </button>
                                    <%--<button type="button" class="btn btn-warning btn-block"
                                            name="restNominationButton" onclick="restNomination()">
                                        지명 초기화
                                    </button>--%>
                                    <button type="button" class="btn btn-info btn-block display-none"
                                            name="addTravellerCharacterButton"
                                            onclick="openAddTravellerCharacterModal()">
                                        여행자 추가
                                    </button>
                                    <button type="button" class="btn btn-primary btn-block"
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
                        <div class="card shadow display-none" id="backgroundMusicDiv">
                            <div class="card-header bg-white border-0">
                            </div>
                            <div class="card-body">
                                <%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/backgroundMusic.jspf" %>
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
                        <div class="card shadow display-none" id="executionDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    처형 투표
                                </h2>
                            </div>
                            <div class="card-body">
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-info btn-block"
                                            onclick="executionModal.open(playerList, selectedCharacterList)">
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
                        <div class="card shadow display-none" id="infoMessageDiv">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    정보메세지 조합
                                    <a data-toggle="collapse" href="#setInfoMessageDiv" role="button"
                                       aria-expanded="false"
                                       aria-controls="setInfoMessageDiv">
                                        열기/닫기
                                    </a>
                                </h2>
                            </div>
                            <div class="card-body">
                                <div class="collapse" name="setInfoMessageDiv" id="setInfoMessageDiv">
                                    <div name="setInfoMessageTextDiv"></div>
                                    <hr class="mt-2 mb-2">
                                    <div name="setInfoMessageCharacterDiv"></div>
                                    <hr class="mt-2 mb-2">
                                    <div name="setInfoMessagePlayerDiv"></div>
                                    <hr class="mt-2 mb-2">
                                    <div name="setInfoMessageTeamDiv"></div>
                                    <hr class="mt-2 mb-2">
                                    <div name="setInfoMessageAlignmentDiv"></div>
                                    <hr class="mt-2 mb-2">
                                    <div name="infoMessageResultDiv">
                                        <div name="infoMessageTextDiv" class="text-center"></div>
                                        <hr class="mt-2 mb-2">
                                        <div name="infoMessageCharacterDiv" class="row text-center"></div>
                                        <hr class="mt-2 mb-2">
                                        <div name="infoMessagePlayerDiv" class="row text-center"></div>
                                        <hr class="mt-2 mb-2">
                                        <div name="infoMessageTeamDiv" class="row text-center"></div>
                                        <hr class="mt-2 mb-2">
                                        <div name="infoMessageAlignmentDiv" class="row text-center"></div>
                                        <hr class="mt-2 mb-2">
                                        <div name="infoMessageDirectDiv" class="text-center">
                                            <input class="form-control" type="text"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <div name="buttonDiv">
                                    <button type="button" class="btn btn-warning btn-block"
                                            onclick="resetInfoMessageResult()">
                                        정보메세지 초기화
                                    </button>
                                    <button type="button" class="btn btn-info btn-block"
                                            onclick="openInfoMessageModal()">
                                        정보메세지 표시
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
                                    <button type="button" class="btn btn-default btn-block"
                                            onclick="openIntroductionModal()">
                                        인트로 보기
                                    </button>
                                    <button type="button" class="btn btn-default btn-block"
                                            onclick="openQrLoginModal()">
                                        로그인 QR 공유
                                    </button>
                                    <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                        QR 이미지로 공유
                                    </button>
                                    <button type="button" class="btn btn-info btn-block" onclick="openRuleGuideModal()">
                                        게임 설명
                                    </button>
                                    <button type="button" class="btn btn-info btn-block"
                                            onclick="openCharacterGuideModal()">
                                        역할 설명
                                    </button>
                                    <button type="button" class="btn btn-info btn-block" onclick="openTownModal()">
                                        마을 광장 보기
                                    </button>
                                    <button type="button" class="btn btn-default btn-block" onclick="openNoteModal()">
                                        노트
                                    </button>
                                    <button type="button" class="btn btn-default btn-block"
                                            onclick="openSoundEffectModal()">
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

        <div class="col-md-6 col-xs-12">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12 mb-2 mt-2 mb-xl-0">
                        <div class="card shadow">
                            <div class="card-header bg-white border-0">
                                <h2>
                                    Pocket Grimoire
                                    <a data-toggle="collapse" href="#pocketGrimoireBodyDiv" role="button"
                                       aria-expanded="false"
                                       aria-controls="pocketGrimoireDiv">
                                        열기/닫기
                                    </a>
                                </h2>
                            </div>
                            <div class="card-body p-0">
                                <div class="collapse" id="pocketGrimoireBodyDiv">
                                    <iframe id="pocketGrimoireIframe" src="https://www.pocketgrimoire.co.uk/en_GB/"
                                            height="700" width="100%"></iframe>
                                </div>
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
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/characterModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/townModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/executionModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/reminderModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/custom/jspf/addTravellerModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/boc/guide/ruleGuideModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/boc/guide/characterGuideModal.jspf" %>

<%@ include file="/WEB-INF/jsp/game/noteModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/soundEffectModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/qrLoginModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
