<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="boardgame.com.util.SessionUtils" %>
        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

                <!-- 다음 주소찾기 적용  -->
                <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>

                <script>
                    let setting1Str = "";
                    let setting2Str = "";
                    let setting3Str = "";
                    let minPlayerCount = 0;
                    let maxPlayerCount = 0;
                    let joinPlayerCount = 0;
                    let playGameNo = 0;
                    let gameList = [];

                    $(function () {
                        gfn_setSortTh("playRecord1List", "fn_selectPlayRecord1List(1)");
                        gfn_setSortTh("playRecord2List", "fn_selectPlayRecord2List(1)");
                        gfn_setSortTh("playRecord3List", "fn_selectPlayRecord3List(1)");
                        gfn_setSortTh("playRecord4List", "fn_selectPlayRecord4List(1)");

                        $("#tabList a").click(function (e) {
                            //e.preventDefault();
                            //$(this).tab('show');
                            $("#playRecord1ListPageNav").val(1);
                            $("#playRecord2ListPageNav").val(1);
                            $("#playRecord3ListPageNav").val(1);
                            $("#playRecord4ListPageNav").val(1);

                            let tabId = $(this).attr('id');
                            if (tabId == "playRecordTab1A") {
                                fn_selectPlayRecord1List(1);
                            } else if (tabId == "playRecordTab2A") {
                                fn_selectPlayRecord2List(1);
                            } else if (tabId == "playRecordTab3A") {
                                fn_selectPlayRecord3List(1);
                            } else if (tabId == "playRecordTab4A") {
                                fn_selectPlayRecord4List(1);
                            }
                        });

                        $("#insertPlayForm select[name='gameNo']").on("change", function () {
                            $("#playMmbrListTbl>tbody").empty();
                            $("div[name='settingControlDiv']").empty();
                            playGameNo = this.value;
                            minPlayerCount = $("#insertPlayForm select[name='gameNo'] option:selected").data("minPlayerCount");
                            maxPlayerCount = $("#insertPlayForm select[name='gameNo'] option:selected").data("maxPlayerCount");
                            joinPlayerCount = 0;

                            fn_selectPlayJoinMmbrList(1);
                            setPlayName($("#insertPlayForm select[name='gameNo'] option:selected").text());
                            //fn_selectGameSttngList($("#insertPlayForm select[name='gameNo'] option:selected").val());
                            readGameSettingList($("#insertPlayForm select[name='gameNo'] option:selected").val());
                        });

                        $("[data-toggle='tooltip']").tooltip();

                        fn_selectPlayRecord1List(1);
                    });


                    function fn_selectPlayRecord1List(pageNo) {
                        const comAjax = new ComAjax("playRecord1Form");
                        comAjax.setUrl("<c:url value='/selectPlayRecordByAllList' />");
                        comAjax.setCallback("fn_selectPlayRecord1ListCallback");
                        comAjax.addParam("pageIndex", pageNo);
                        comAjax.addParam("pageRow", 5);
                        comAjax.addParam("orderBy", $('#playRecord1ListCurOrderBy').val());
                        comAjax.ajax();
                    }

                    function fn_selectPlayRecord1ListCallback(data) {
                        var cnt = data.map.cnt;
                        var body = $("#playRecord1ListGrid");
                        body.empty();
                        var str = "";
                        if (cnt == 0) {
                            str += "<div style='grid-column: 1 / -1; text-align: center; padding: 4rem; color: var(--text-dim);'>조회결과가 없습니다.</div>";
                        } else {
                            var params = {
                                divId: "playRecord1ListPageNav",
                                pageIndex: "pageIndex",
                                totalCount: cnt,
                                eventName: "fn_selectPlayRecord1List",
                                recordCount: 5
                            };
                            gfn_renderPaging(params);

                            $.each(data.map.list, function (key, value) {
                                str += '<div class="premium-card" onclick="fn_openPlayRecordModal(\'' + value.playNo + '\')" style="cursor: pointer;">';

                                // Header
                                str += '  <div class="card-tag">' + value.gameNm + '</div>';
                                str += '  <h3 class="card-title">' + value.playNm + '</h3>';
                                str += '  <div style="font-size: 0.85rem; color: var(--text-dim); margin-bottom: 0.5rem;">';
                                str += '    <i class="far fa-calendar-alt mr-1"></i> ' + value.strtDt.substring(0, 16);
                                str += '  </div>';

                                // Club Info
                                str += '  <div class="club-info clickable" onclick="event.stopPropagation(); openClubProfileModal(\'' + value.clubNo + '\')">';
                                str += '    <div class="avatar-sm">';
                                if (value.clubPrflImgFileNm && value.clubPrflImgFileNm != "") {
                                    str += '      <img src="https://bogopayo.cafe24.com/img/club/' + value.clubNo + '/' + value.clubPrflImgFileNm + '" onerror="this.src=\'https://bogopayo.cafe24.com/img/club/default.png\'">';
                                } else {
                                    str += '      <img src="https://bogopayo.cafe24.com/img/club/default.png">';
                                }
                                str += '    </div>';
                                str += '    <span style="font-weight: 500;">' + value.clubNm + '</span>';
                                str += '  </div>';

                                // Footer (Avatars)
                                str += '  <div class="card-footer">';
                                str += '    <div class="player-avatars">';

                                if (value.playMmbrPrflImgFileNms && value.playMmbrNos) {
                                    var mmbrImgList = value.playMmbrPrflImgFileNms.split(',');
                                    var mmbrNoList = value.playMmbrNos.split(',');

                                    for (var i = 0; i < mmbrImgList.length; i++) {
                                        if (i < 10) {
                                            var imgFile = mmbrImgList[i];
                                            var mmbrNo = mmbrNoList[i];
                                            str += '<div class="avatar-sm" style="background-color: white;">';
                                            if (imgFile == 'default' || !imgFile) {
                                                str += '<img src="https://bogopayo.cafe24.com/img/mmbr/default.png" style="width:100%; height:100%; object-fit:cover; opacity: 0.9;">';
                                            } else {
                                                str += '<img src="https://bogopayo.cafe24.com/img/mmbr/' + mmbrNo + '/' + imgFile + '" style="width:100%; height:100%; object-fit:cover;" onerror="this.src=\'https://bogopayo.cafe24.com/img/mmbr/default.png\'">';
                                            }
                                            str += '</div>';
                                        }
                                    }
                                    if (mmbrImgList.length > 10) {
                                        str += '<div class="avatar-sm" style="background:#21262d; display:flex; align-items:center; justify-content:center; font-size:0.6rem; color:var(--accent-color); font-weight:bold;">+' + (mmbrImgList.length - 10) + '</div>';
                                    }
                                }

                                str += '    </div>';
                                str += '  </div>'; // End Footer

                                str += '</div>'; // End Card
                            });
                        }
                        body.append(str);
                    }


                    function fn_selectPlayRecord2List(pageNo) {
                        const comAjax = new ComAjax("playRecord2Form");
                        comAjax.setUrl("<c:url value='/selectPlayRecordByClubList' />");
                        comAjax.setCallback("fn_selectPlayRecord2ListCallback");
                        comAjax.addParam("pageIndex", pageNo);
                        comAjax.addParam("pageRow", 5);
                        comAjax.addParam("orderBy", $('#playRecord2ListCurOrderBy').val());
                        comAjax.ajax();
                    }

                    function fn_selectPlayRecord2ListCallback(data) {
                        var cnt = data.map.cnt;
                        var body = $("#playRecord2ListTbl>tbody");
                        body.empty();
                        var str = "";
                        if (cnt == 0) {
                            str += "<tr><td colspan='5' class=\"text-center\">조회결과가 없습니다.</td></tr>";
                        } else {
                            var params = {
                                divId: "playRecord2ListPageNav",
                                pageIndex: "pageIndex",
                                totalCount: cnt,
                                eventName: "fn_selectPlayRecord2List",
                                recordCount: 5
                            };
                            gfn_renderPaging(params);

                            $.each(data.map.list, function (key, value) {
                                str += "<tr>";
                                str += "	<td scope=\"row\">";
                                str += "		<div class=\"media align-items-center\">";
                                str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"openClubProfileModal('" + value.clubNo + "')\">";
                                if (value.prflImgFileNm != "") {
                                    str += "			<img src=\"https://bogopayo.cafe24.com/img/club/" + value.clubNo + "/" + value.prflImgFileNm + "\">";
                                } else {
                                    str += "			<img src=\"https://bogopayo.cafe24.com/img/club/default.png\">";
                                }
                                str += "			</a>";
                                str += "			<div class=\"media-body\">";
                                str += "				<span class=\"mb-0 text-sm\">" + value.clubNm + "</span>";
                                str += "			</div>";
                                str += "		</div>";
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.clubGrdNm;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.clubMmbrCnt;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.clubPlayCnt;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.mostPlay3GameNms;
                                str += "	</td>";
                                str += "</tr>";
                            });
                        }
                        body.append(str);
                    }

                    function fn_selectPlayRecord3List(pageNo) {
                        const comAjax = new ComAjax("playRecord3Form");
                        comAjax.setUrl("<c:url value='/selectPlayRecordByMmbrList' />");
                        comAjax.setCallback("fn_selectPlayRecord3ListCallback");
                        comAjax.addParam("pageIndex", pageNo);
                        comAjax.addParam("pageRow", 5);
                        comAjax.addParam("orderBy", $('#playRecord3ListCurOrderBy').val());
                        comAjax.ajax();
                    }

                    function fn_selectPlayRecord3ListCallback(data) {
                        var cnt = data.map.cnt;
                        var body = $("#playRecord3ListTbl>tbody");
                        body.empty();
                        var str = "";
                        if (cnt == 0) {
                            str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
                        } else {
                            var params = {
                                divId: "playRecord3ListPageNav",
                                pageIndex: "pageIndex",
                                totalCount: cnt,
                                eventName: "fn_selectPlayRecord3List",
                                recordCount: 5
                            };
                            gfn_renderPaging(params);

                            $.each(data.map.list, function (key, value) {
                                str += "<tr>";
                                str += "	<td scope=\"row\">";
                                str += "		<div class=\"media align-items-center\">";
                                str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"openMemberProfileModal('" + value.mmbrNo + "')\">";
                                if (value.prflImgFileNm != "") {
                                    str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + value.mmbrNo + "/" + value.prflImgFileNm + "\">";
                                } else {
                                    str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\">";
                                }
                                str += "			</a>";
                                str += "			<div class=\"media-body\">";
                                str += "				<span class=\"mb-0 text-sm\">" + value.nickNm + "</span>";
                                str += "			</div>";
                                str += "		</div>";
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.rsltPntAvg;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.playCnt;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.mostPlay3GameNms;
                                str += "	</td>";
                                str += "</tr>";
                            });
                        }
                        body.append(str);
                    }

                    function fn_selectPlayRecord4List(pageNo) {
                        const comAjax = new ComAjax("playRecord4Form");
                        comAjax.setUrl("<c:url value='/selectPlayRecordByGameList' />");
                        comAjax.setCallback("fn_selectPlayRecord4ListCallback");
                        comAjax.addParam("pageIndex", pageNo);
                        comAjax.addParam("pageRow", 5);
                        comAjax.addParam("orderBy", $('#playRecord4ListCurOrderBy').val());
                        comAjax.ajax();
                    }

                    function fn_selectPlayRecord4ListCallback(data) {
                        var cnt = data.map.cnt;
                        var body = $("#playRecord4ListTbl>tbody");
                        body.empty();
                        var str = "";
                        if (cnt == 0) {
                            str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
                        } else {
                            var params = {
                                divId: "playRecord4ListPageNav",
                                pageIndex: "pageIndex",
                                totalCount: cnt,
                                eventName: "fn_selectPlayRecord4List",
                                recordCount: 5
                            };
                            gfn_renderPaging(params);

                            $.each(data.map.list, function (key, value) {
                                str += "<tr>";
                                str += "	<td>";
                                str += "		" + value.gameNm;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.playCnt;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		" + value.mostPlayClubNm;
                                str += "	</td>";
                                str += "	<td>";
                                str += "		<div class=\"avatar-group\">";
                                var mostPlay3NickNms = value.mostPlay3NickNms.split(",");
                                var mostPlay3MmbrNos = value.mostPlay3MmbrNos.split(",");
                                var mostPlay3MmbrPrflImgFileNms = value.mostPlay3MmbrPrflImgFileNms.split(",");
                                for (var i in mostPlay3NickNms) {
                                    str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm\" onclick=\"openMemberProfileModal('" + mostPlay3MmbrNos[i] + "')\" data-toggle=\"tooltip\" data-original-title=\"" + mostPlay3NickNms[i] + "\">";
                                    if (mostPlay3MmbrPrflImgFileNms[i] == "default") {
                                        str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\" class=\"rounded-circle\">";
                                    } else {
                                        str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + mostPlay3MmbrNos[i] + "/" + mostPlay3MmbrPrflImgFileNms[i] + "\" class=\"rounded-circle\">";
                                    }
                                    str += "			</a>";
                                }
                                str += "		</div>";
                                str += "	</td>";
                                str += "</tr>";
                            });
                        }
                        body.append(str);
                    }

                    function fn_openInsertPlayModal() {
                        $("#playMmbrListTbl>tbody").empty();
                        $("#playJoinMmbrNListDiv").empty();
                        $("#insertPlayForm input[name='hostMmbrNo']").val("<c:out value="${ mmbrNo }" />");
                        $("#insertPlayForm input[name='hostNickNm']").val("<c:out value="${ nickNm }" />");
                        $("#insertPlayForm input[name='clubNo']").val("<c:out value="${ clubNo }" />");
                        $("#insertPlayForm input[name='playNm']").val("");
                        readGameList();

                        $("#insertPlayModal").modal("show");
                    }

                    const readGameList = () => {
                        const request = {
                            gameName: $("#insertPlayForm input[name='gameNm']").val(),
                        }

                        gfn_callGetApi("/api/game/list", request)
                            .then(data => {
                                readGameListCallback(data);
                            })
                            .catch(response => console.error('error', response));
                    }

                    const readGameListCallback = list => {
                        gameList = list;
                        renderGameSelect(list);
                    }

                    const renderGameSelect = list => {
                        let htmlString = "";
                        if (list.length > 0) {
                            htmlString += "<option value=\"\">선택하세요.</option>";
                            $.each(list, (index, item) => {
                                htmlString += "<option value=" + item.gameNo +
                                    " data-min-player-count=" + item.minPlyrCnt +
                                    " data-max-player-count=" + item.maxPlyrCnt + ">" +
                                    item.gameNm +
                                    "</option>";
                            });
                        }

                        const $body = $("#insertPlayForm select[name='gameNo']");
                        gfn_removeElementChildrenAndAppendHtmlString($body, htmlString);
                    }

                    const filterGameList = () => {
                        const filterText = $("#insertPlayForm input[name='gameNm']").val();

                        const filteredList = gameList
                            .filter(game => {
                                console.log(game);
                                return game.gameNm.indexOf(filterText) > -1;
                            })

                        renderGameSelect(filteredList);
                    }

                    const setPlayName = gameName => {
                        $("#insertPlayForm input[name='playNm']").val("'" + "<c:out value="${ nickNm }" />" + "'의 " + gameName);
                    };

                    const readGameSettingList = async gameNo => {
                        let groupCode = "1";
                        await gfn_callGetApi("/api/game/setting/list", { groupCode, gameNo })
                            .then(data => setting1Str = renderGameSettingList(data, groupCode))
                            .catch(response => console.error('error', response));

                        groupCode = "2";
                        await gfn_callGetApi("/api/game/setting/list", { groupCode, gameNo })
                            .then(data => setting2Str = renderGameSettingList(data, groupCode))
                            .catch(response => console.error('error', response));

                        groupCode = "3";
                        await gfn_callGetApi("/api/game/setting/list", { groupCode, gameNo })
                            .then(data => setting3Str = renderGameSettingList(data, groupCode))
                            .catch(response => console.error('error', response));

                        await addPlayMember("<c:out value="${ mmbrNo }" />", "<c:out value="${ nickNm }" />");
                    };

                    const renderGameSettingList = (list, groupCode) => {
                        let settingControlSameStr = "";
                        $.each(list, (key, value) => {
                            settingControlSameStr += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\"" +
                                " onclick=\"setSameGameSetting('" + groupCode + "', '" + value.cd + "')\" >";
                            settingControlSameStr += "	" + value.nm;
                            settingControlSameStr += "</a>";
                        });

                        if (list.length > 0) {
                            settingControlSameStr += "<a class=\"btn btn-sm btn-outline-warning mr-1 my-1\" href=\"javascript:(void(0));\"" +
                                " onclick=\"setRandomGameSetting('" + groupCode + "')\" >";
                            settingControlSameStr += "	랜덤으로 고르기";
                            settingControlSameStr += "</a>";

                            $("#settingControlDiv" + groupCode).append(settingControlSameStr);
                            $("#gameSettingDiv" + groupCode).show();
                        }

                        let settingStr = "";
                        $.each(list, (key, value) => {
                            settingStr += "	<option value=\"" + value.cd + "\">" + value.nm + "</option>";
                        });
                        return settingStr;
                    }

                    const setSameGameSetting = (grpCd, cd) => {
                        $("#playMmbrListTbl select[name='setting" + grpCd + "Cd']").val(cd);
                    };

                    const setRandomGameSetting = grpCd => {
                        var settingCdArr = new Array();
                        $("#playMmbrListTbl > tbody > tr:nth-child(1) select[name='setting" + grpCd + "Cd'] option").each(function () {
                            settingCdArr.push(this.value);
                        });

                        var cdCnt = settingCdArr.length - 1;
                        var playMmbrNoArr = new Array();
                        $("#playMmbrListTbl > tbody > tr").each(function () {
                            var rndmIdx = Math.round(Math.random() * cdCnt);
                            $("#" + this.id + " select[name='setting" + grpCd + "Cd']").val(settingCdArr[rndmIdx]);
                            settingCdArr.splice(rndmIdx, 1);
                            cdCnt--;
                        });
                    };

                    const addPlayMember = async function (mmbrNo, nickNm) {
                        if (joinPlayerCount < maxPlayerCount) {
                            var body = $("#playMmbrListTbl>tbody");
                            var str = "";
                            str += "<tr name=\"addPlayMmbrTr\" id=\"addPlayMmbrTr" + mmbrNo + "\">";
                            str += "	<td>";
                            str += "		" + nickNm;
                            str += "	</td>";
                            str += "	<td>";
                            if (setting1Str != "") {
                                str += "	<select class=\"form-control hasValue\" name=\"setting1Cd\">";
                                str += "	" + setting1Str;
                                str += "	</select>";
                            }
                            if (setting2Str != "") {
                                str += "	<select class=\"form-control hasValue\" name=\"setting2Cd\">";
                                str += "	" + setting2Str;
                                str += "	</select>";
                            }
                            if (setting3Str != "") {
                                str += "	<select class=\"form-control hasValue\" name=\"setting3Cd\">";
                                str += "	" + setting3Str;
                                str += "	</select>";
                            }
                            str += "	</td>";
                            str += "	<td>";
                            if (mmbrNo == "<c:out value="${ mmbrNo } " />") {
                                str += "	호스트";
                            } else {
                                str += "	<a class=\"btn btn-sm btn-outline-warning\" href=\"javascript:(void(0));\" onclick=\"fn_removePlayMmbr('" + mmbrNo + "','" + nickNm + "')\">제외</a>";
                            }
                            str += "	</td>";
                            str += "</tr>";
                            body.append(str);

                            $("#playJoinMmbrNListDiv a").each(function () {
                                var playJoinNickNm = $(this).text().trim();
                                if (playJoinNickNm == nickNm) {
                                    $(this).remove();
                                }
                            });

                            joinPlayerCount++;
                        } else {
                            alert("최대 플레이 가능인원은 " + maxPlayerCount + "명까지입니다.");
                            return false;
                        }
                    };

                    function fn_removePlayMmbr(mmbrNo, nickNm) {
                        var body = $("#playJoinMmbrNListDiv");
                        var str = "";
                        str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"addPlayMember('" + mmbrNo + "', '" + nickNm + "')\" >";
                        str += "	" + nickNm;
                        str += "</a>";
                        body.append(str);

                        $("#playMmbrListTbl td:nth-child(1)").each(function () {
                            var playJoinNickNm = $(this).text().trim();
                            if (playJoinNickNm == nickNm.trim()) {
                                $("#addPlayMmbrTr" + mmbrNo).remove();
                                joinPlayerCount--;
                            }
                        });
                    }

                    function fn_selectPlayJoinMmbrList(pageNo) {
                        const comAjax = new ComAjax("insertPlayForm");
                        comAjax.setUrl("<c:url value='/selectPlayJoinMmbrList' />");
                        comAjax.setCallback("fn_selectPlayJoinMmbrListCallback");
                        comAjax.ajax();
                    }

                    function fn_selectPlayJoinMmbrListCallback(data) {
                        var cnt = data.list.length;
                        var body = $("#playJoinMmbrNListDiv");
                        body.empty();
                        var str = "";
                        if (cnt > 0) {
                            $.each(data.list, function (key, value) {
                                var isRun = true;
                                $("#playMmbrListTbl td:nth-child(1)").each(function () {
                                    var playJoinNickNm = $(this).text().trim();
                                    if (playJoinNickNm != $("#hostMmbrNo").val() && playJoinNickNm == value.nickNm) {
                                        isRun = false;
                                    }
                                });
                                if (isRun) {
                                    str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"addPlayMember('" + value.mmbrNo + "', '" + value.nickNm + "')\" >";
                                    str += "	" + value.nickNm;
                                    str += "</a>";
                                }
                            });
                        }
                        body.append(str);
                    }

                    function fn_insertPlay() {
                        if (joinPlayerCount < minPlayerCount) {
                            alert("선택된 플레이어가 최소 플레이어수보다 적습니다.");
                            return false;
                        }

                        if (joinPlayerCount > maxPlayerCount) {
                            alert("선택된 플레이어가 최대 플레이어수보다 많습니다.");
                            return false;
                        }

                        const joinMmbrNoArr = new Array();
                        $("#playMmbrListTbl > tbody > tr").each(function () {
                            joinMmbrNoArr.push(this.id.replace("addPlayMmbrTr", ""));
                        });

                        const settingCd1Arr = new Array();
                        $("#playMmbrListTbl > tbody > tr select[name='setting1Cd'] option:selected").each(function () {
                            settingCd1Arr.push(this.value);
                        });

                        const settingCd2Arr = new Array();
                        $("#playMmbrListTbl > tbody > tr select[name='setting2Cd'] option:selected").each(function () {
                            settingCd2Arr.push(this.value);
                        });

                        const settingCd3Arr = new Array();
                        $("#playMmbrListTbl > tbody > tr select[name='setting3Cd'] option:selected").each(function () {
                            settingCd3Arr.push(this.value);
                        });

                        if (gfn_validate("insertPlayForm")) {
                            if (confirm("바로 플레이가 시작됩니다. 진행하시겠습니까?")) {
                                const comAjax = new ComAjax("insertPlayForm");
                                comAjax.setUrl("<c:url value='/insertPlay' />");
                                comAjax.setCallback("gfn_defaultCallback");
                                comAjax.addParam("joinMmbrNoArr", joinMmbrNoArr);
                                comAjax.addParam("settingCd1Arr", settingCd1Arr);
                                comAjax.addParam("settingCd2Arr", settingCd2Arr);
                                comAjax.addParam("settingCd3Arr", settingCd3Arr);
                                comAjax.ajax();
                            } else {
                                return;
                            }
                        }
                    }

                    const openMemberProfileModal = memberId => {
                        memberProfileModal.open(memberId);
                    }

                    const openClubProfileModal = clubId => {
                        clubProfileModal.open(clubId);
                    }

                </script>
        </head>

        <body>
            <div class="preview-container">
                <!-- Navigation -->
                <nav class="modern-nav">
                    <a href="<c:url value='/'/>" class="logo">BOGO<span>PA</span></a>

                    <button class="menu-toggle" id="mobileMenuBtn">
                        <i class="fas fa-bars"></i>
                    </button>

                    <div class="nav-links" id="navLinks">
                        <a href="<c:url value='/guide'/>"><i class="fas fa-info-circle"></i> 이용안내</a>
                        <a href="<c:url value='/club'/>"><i class="fas fa-users"></i> 모임</a>
                        <a href="<c:url value='/play'/>" class="active"><i class="fas fa-history"></i> 플레이기록</a>
                        <a href="<c:url value='/play'/>"><i class="fas fa-gamepad"></i> 게임하기</a>

                        <c:choose>
                            <c:when test="${empty sessionScope.loginMember}">
                                <a href="<c:url value='/login/page'/>"><i class="fas fa-sign-in-alt"></i> 로그인</a>
                                <a href="<c:url value='/join/page'/>"><i class="fas fa-user-plus"></i> 회원가입</a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/my/page'/>"><i class="fas fa-user"></i> 마이페이지</a>
                                <a href="<c:url value='/login/logout'/>"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </nav>

                <!-- Hero Section -->
                <header class="hero-section" style="min-height: 40vh;">
                    <h1 class="hero-title">신사답게 <span>기록해</span></h1>
                    <p class="hero-subtitle">그리고 너 다음에 한판 더 해</p>
                </header>

                <!-- Page content -->
                <div class="container" style="margin-top: -5rem; position: relative; z-index: 10;">
                    <div class="separator separator-bottom separator-skew zindex-100">
                        <svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1"
                            xmlns="http://www.w3.org/2000/svg">
                            <polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
                        </svg>
                    </div>
                </div>
                <!-- Page content -->
                <div class="container" style="margin-top: -5rem; position: relative; z-index: 10;">
                    <!-- Tabs -->
                    <ul class="modern-tabs" id="tabList" role="tablist">
                        <li class="nav-item">
                            <a class="modern-tab-item active" id="playRecordTab1A" data-toggle="tab"
                                href="#playRecordTab1" role="tab" aria-controls="playRecordTab1"
                                aria-selected="true">전체</a>
                        </li>
                        <li class="nav-item">
                            <a class="modern-tab-item" id="playRecordTab2A" data-toggle="tab" href="#playRecordTab2"
                                role="tab" aria-controls="playRecordTab2" aria-selected="false">모임별</a>
                        </li>
                        <li class="nav-item">
                            <a class="modern-tab-item" id="playRecordTab3A" data-toggle="tab" href="#playRecordTab3"
                                role="tab" aria-controls="playRecordTab3" aria-selected="false">회원별</a>
                        </li>
                        <li class="nav-item">
                            <a class="modern-tab-item" id="playRecordTab4A" data-toggle="tab" href="#playRecordTab4"
                                role="tab" aria-controls="playRecordTab4" aria-selected="false">게임별</a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- 전체 탭 컨텐츠 -->
                        <div id="playRecordTab1" class="tab-pane fade show active" role="tabpanel"
                            aria-labelledby="playRecordTab1A">

                            <form id="playRecord1Form" onsubmit="return false;">
                                <input type="hidden" id="playRecord1ListCurOrderBy">
                                <div class="search-container">
                                    <input type="text" name="srchText" class="search-input" placeholder="플레이 검색..."
                                        onKeypress="gfn_hitEnter(event, 'fn_selectPlayRecord1List(1)');">
                                    <button type="button" class="search-btn" onclick="fn_selectPlayRecord1List(1)">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                                <div class="text-right mb-3">
                                    <c:if test="${clubNo ne ''}">
                                        <button type="button" class="btn btn-sm btn-primary"
                                            onclick="fn_openInsertPlayModal();" style="border-radius: 2rem;">새로운 플레이
                                        </button>
                                    </c:if>
                                </div>
                            </form>

                            <div class="modern-grid" id="playRecord1ListGrid">
                                <!-- JS Rendered Content -->
                            </div>

                            <div class="card-footer py-4" style="background: transparent; border: none;">
                                <nav aria-label="">
                                    <ul class="pagination pagination-sm justify-content-center mb-0"
                                        id="playRecord1ListPageNav"></ul>
                                </nav>
                            </div>
                        </div>
                        <!-- 모임별 탭 컨텐츠 -->
                        <div id="playRecordTab2" class="tab-pane fade" role="tabpanel"
                            aria-labelledby="playRecordTab2A">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-6 col-lg-6">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <form id="playRecord2Form" onsubmit="return false;">
                                    <input type="hidden" id="playRecord2ListCurOrderBy">
                                    <div class="row clearfix">
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label class="form-control-label">모임찾기</label>
                                                <input type="text" name="srchText"
                                                    class="form-control form-control-alternative"
                                                    onKeypress="gfn_hitEnter(event, 'fn_selectPlayRecord2List(1)');"
                                                    placeholder="모임이름, 가장 많이 플레이된 게임">
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <c:if test="${clubNo ne ''}">
                                                <button type="button" class="btn btn-sm btn-primary float-right"
                                                    onclick="fn_openInsertPlayModal();">새로운 플레이
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </form>
                                <div class="table-responsive">
                                    <table class="table align-items-center table-flush" id="playRecord2ListTbl">
                                        <thead class="thead-light">
                                            <tr>
                                                <th name="playRecord2ListSortTh" id="sortTh_clubNm">
                                                    모임 <span name="playRecord2ListSort" id="playRecord2ListSort_clubNm"
                                                        class="fa"></span>
                                                </th>
                                                <th name="playRecord2ListSortTh" id="sortTh_clubGrdNm">
                                                    등급 <span name="playRecord2ListSort"
                                                        id="playRecord2ListSort_clubGrdNm" class="fa"></span>
                                                </th>
                                                <th name="playRecord2ListSortTh" id="sortTh_clubMmbrCnt">
                                                    모임원수 <span name="playRecord2ListSort"
                                                        id="playRecord2ListSort_clubMmbrCnt" class="fa"></span>
                                                </th>
                                                <th name="playRecord2ListSortTh" id="sortTh_clubPlayCnt">
                                                    플레이횟수 <span name="playRecord2ListSort"
                                                        id="playRecord2ListSort_clubPlayCnt" class="fa"></span>
                                                </th>
                                                <th scope="col">가장 많이 플레이한 게임 TOP3</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <nav aria-label="">
                                    <ul class="pagination pagination-sm justify-content-end mb-0"
                                        id="playRecord2ListPageNav"></ul>
                                </nav>
                            </div>
                        </div>
                        <!-- 회원별 탭 컨텐츠 -->
                        <div id="playRecordTab3" class="tab-pane fade" role="tabpanel"
                            aria-labelledby="playRecordTab3A">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-lg-12">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <form id="playRecord3Form" onsubmit="return false;">
                                    <input type="hidden" id="playRecord3ListCurOrderBy">
                                    <div class="row clearfix">
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label class="form-control-label">회원찾기</label>
                                                <input type="text" name="srchText"
                                                    class="form-control form-control-alternative"
                                                    onKeypress="gfn_hitEnter(event, 'fn_selectPlayRecord3List(1)');"
                                                    placeholder="닉네임, 가장 많이 플레이된 게임">
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <c:if test="${clubNo ne ''}">
                                                <button type="button" class="btn btn-sm btn-primary float-right"
                                                    onclick="fn_openInsertPlayModal();">새로운 플레이
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </form>
                                <div class="table-responsive">
                                    <table class="table align-items-center table-flush" id="playRecord3ListTbl">
                                        <thead class="thead-light">
                                            <tr>
                                                <th name="playRecord3ListSortTh" id="sortTh_nickNm">
                                                    회원 <span name="playRecord3ListSort" id="playRecord3ListSort_nickNm"
                                                        class="fa"></span>
                                                </th>
                                                <th name="playRecord3ListSortTh" id="sortTh_rsltPntAvg">
                                                    평균승점 <span name="playRecord3ListSort"
                                                        id="playRecord3ListSort_rsltPntAvg" class="fa"></span>
                                                </th>
                                                <th name="playRecord3ListSortTh" id="sortTh_playCnt">
                                                    플레이횟수 <span name="playRecord3ListSort"
                                                        id="playRecord3ListSort_playCnt" class="fa"></span>
                                                </th>
                                                <th scope="col">가장 많이 플레이한 게임 TOP3</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <nav aria-label="">
                                    <ul class="pagination pagination-sm justify-content-end mb-0"
                                        id="playRecord3ListPageNav"></ul>
                                </nav>
                            </div>
                        </div>
                        <!-- 게임별 탭 컨텐츠 -->
                        <div id="playRecordTab4" class="tab-pane fade" role="tabpanel"
                            aria-labelledby="playRecordTab4A">
                            <div class="card-header bg-white border-0">
                                <div class="row">
                                    <div class="col-lg-12">
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <form id="playRecord4Form" onsubmit="return false;">
                                    <input type="hidden" id="playRecord4ListCurOrderBy">
                                    <div class="row clearfix">
                                        <div class="col-lg-6">
                                            <div class="form-group">
                                                <label class="form-control-label">플레이찾기</label>
                                                <input type="text" name="srchText"
                                                    class="form-control form-control-alternative"
                                                    onKeypress="gfn_hitEnter(event, 'fn_selectPlayRecord4List(1)');"
                                                    placeholder="게임이름(한글, 영어)">
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <c:if test="${clubNo ne ''}">
                                                <button type="button" class="btn btn-sm btn-primary float-right"
                                                    onclick="fn_openInsertPlayModal();">새로운 플레이
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </form>
                                <div class="table-responsive">
                                    <table class="table align-items-center table-flush" id="playRecord4ListTbl">
                                        <thead class="thead-light">
                                            <tr>
                                                <th name="playRecord4ListSortTh" id="sortTh_gameNm">
                                                    게임 <span name="playRecord4ListSort" id="playRecord4ListSort_gameNm"
                                                        class="fa"></span>
                                                </th>
                                                <th name="playRecord4ListSortTh" id="sortTh_playCnt">
                                                    플레이횟수 <span name="playRecord4ListSort"
                                                        id="playRecord4ListSort_playCnt" class="fa"></span>
                                                </th>
                                                <th name="playRecord4ListSortTh" id="sortTh_mostPlayClubNm">
                                                    가장 많이 플레이한 모임 <span name="playRecord4ListSort"
                                                        id="playRecord4ListSort_mostPlayClubNm" class="fa"></span>
                                                </th>
                                                <th scope="col">가장 많이 플레이한 회원 TOP3</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer py-4">
                                <nav aria-label="">
                                    <ul class="pagination pagination-sm justify-content-end mb-0"
                                        id="playRecord4ListPageNav"></ul>
                                </nav>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
            </div>
            </div>
            <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
                </div>

                <!-- 새로운 플레이 Modal -->
                <div class="modal fade" id="insertPlayModal" role="dialog" aria-labelledby="insertPlayModalLabel"
                    aria-hidden="true">
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
                                                <label class="form-control-label">게임찾기</label>
                                                <input type="text" name="gameNm"
                                                    class="form-control form-control-alternative"
                                                    onKeypress="gfn_hitEnter(event, 'filterGameList()');">
                                            </div>
                                        </div>
                                        <div class="col-lg-12">
                                            <div class="form-group">
                                                <label class="form-control-label">*플레이 할 게임</label>
                                                <select data-name="게임" name="gameNo"
                                                    class="form-control form-control-alternative hasValue">
                                                </select>
                                            </div>
                                        </div>
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

                                <hr class="my-4" />

                                <div class="mb-4 display-none" id="gameSettingDiv1">
                                    <h4>모든 첫번째 세팅을..</h4>
                                    <div name="settingControlDiv" id="settingControlDiv1"></div>
                                </div>

                                <div class="mb-4 display-none" id="gameSettingDiv2">
                                    <h4>모든 두번째 세팅을..</h4>
                                    <div name="settingControlDiv" id="settingControlDiv2"></div>
                                </div>

                                <div class="mb-4 display-none" id="gameSettingDiv3">
                                    <h3>모든 세번째 세팅을..</h3>
                                    <div name="settingControlDiv" id="settingControlDiv3"></div>
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
                <%@ include file="/WEB-INF/jsp/fo/jspf/memberProfileModal.jspf" %>
                    <!-- 모임프로필 -->
                    <%@ include file="/WEB-INF/jsp/fo/jspf/clubProfileModal.jspf" %>
                        <!-- 플레이기록 -->
                        <%@ include file="/WEB-INF/jsp/fo/playRecordModal.jsp" %>

                            <%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

        </body>

        </html>