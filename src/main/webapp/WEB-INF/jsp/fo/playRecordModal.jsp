<%@ page pageEncoding="utf-8" %>

<script>
    function fn_openPlayRecordModal(playNo) {
        const comAjax = new ComAjax();
        comAjax.setUrl("<c:url value='/selectPlayRecord' />");
        comAjax.setCallback("fn_openPlayRecordModalCallback");
        comAjax.addParam("playNo", playNo);
        comAjax.ajax();
    }

    function fn_openPlayRecordModalCallback(data) {
        gfn_setDataVal(data.map, "playRecordForm");
        $("#playRecordModalLabel").text(data.map.playNm);

        var body = $("#playRecordModal tbody");
        body.empty();
        var str = "";

        var fdbckBody = $("#playMmbrFdbck");
        fdbckBody.empty();
        var fdbckStr = "";

        if (data.list.length == 0) {
            str += "<tr><td colspan=\"4\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
        } else {
            var isFrstFdbckImg = false;
            var mmbrNo = "<c:out value="${mmbrNo}" />";
            $.each(data.list, function (key, value) {
                str += "<tr>";
                str += "	<td>";
                str += "		" + value.nickNm;
                str += "	</td>";
                str += "	<td>";
                var sttng = "";
                if (value.sttng1Nm != "") {
                    sttng += value.sttng1Nm;
                }
                if (value.sttng2Nm != "") {
                    sttng += "/" + value.sttng2Nm;
                }
                if (value.sttng3Nm != "") {
                    sttng += "/" + value.sttng3Nm;
                }
                str += "		" + sttng;
                str += "	</td>";
                str += "	<td>";
                if (value.rsltRnk != "") {
                    str += value.rsltRnk;
                }
                str += "	</td>";
                str += "	<td>";
                if (value.rsltScr != "") {
                    str += value.rsltScr;
                }
                str += "	</td>";
                str += "</tr>";

                if (!isFrstFdbckImg && value.fdbckImgFileNm != "") {
                    isFrstFdbckImg = true;
                    fdbckStr += "<div class=\"alert alert-success alert-dismissible fade show\" role=\"alert\" id=\"fdbckDiv" + value.seq + "\">";
                    fn_showPlayMmbrFdbckImg(value.seq, value.fdbckImgFileNm);
                } else {
                    fdbckStr += "<div class=\"alert alert-default alert-dismissible fade show\" role=\"alert\" id=\"fdbckDiv" + value.seq + "\">";
                }

                fdbckStr += "		<strong>" + value.nickNm + "</strong>";
                if (mmbrNo == value.mmbrNo) {
                    fdbckStr += "	<a href=\"javascript:(void(0));\" onclick=\"fn_showUpdatePlayMmbrFdbck(" + value.seq + ")\">";
                    fdbckStr += "		<i class=\"ni ni-settings-gear-65\"></i>";
                    fdbckStr += "	</a>";
                }
                fdbckStr += "		<br><span id=\"fdbck" + value.seq + "\">" + value.fdbck + "</span>";

                if (value.fdbckImgFileNm != "") {
                    fdbckStr += "	<button type=\"button\" class=\"close\" onclick=\"fn_showPlayMmbrFdbckImg(" + value.seq + ", '" + value.fdbckImgFileNm + "')\">";
                    fdbckStr += "		<i class=\"ni ni-image\"></i>";
                    fdbckStr += "	</button>";
                }
                fdbckStr += "</div>";
            });
        }
        body.append(str);

        if (fdbckStr != "" && $("#playRecordForm input[name='sttsCd']").val() == "2") {
            fdbckBody.append(fdbckStr);
            $("#playMmbrFdbckDiv").show();
        } else {
            $("#playMmbrFdbckDiv").hide();
        }

        const gameNo = $("#playRecordForm").find("input[name='gameNo']").val();
        if (GAME.isPlayableGame(gameNo)) {
            $("#openPlayingGameBtn").show();
        }

        $("#updatePlayMmbrFdbckDiv").hide();
        $("#updatePlayMmbrFdbckBtn").hide();

        $("#playRecordModal").modal({
            //escapeClose: false,
            //clickClose: false,
            //showClose: false,
            //closeExisting: false
        });
    }

    function fn_showPlayMmbrFdbckImg(seq, fdbckImgFileNm) {
        $("#playMmbrFdbck .alert").removeClass("alert-success");
        $("#playMmbrFdbck .alert").removeClass("alert-default");
        $("#playMmbrFdbck .alert").addClass("alert-default");
        $("#playMmbrFdbckImg").empty();
        var str = "<img src=\"https://bogopayo.cafe24.com/img/play/" + seq + "/" + fdbckImgFileNm + "\" class=\"img-responsive img-thumbnail m-auto\">";
        $("#playMmbrFdbckImg").append(str);
        $("#fdbckDiv" + seq).removeClass("alert-default");
        $("#fdbckDiv" + seq).addClass("alert-success");
    }

    function fn_showUpdatePlayMmbrFdbck(seq) {
        $("#updatePlayMmbrFdbckDiv").show();
        $("#updatePlayMmbrFdbckBtn").show();
        $("#updatePlayMmbrFdbckForm input[name='seq']").val(seq);
        $("#updatePlayMmbrFdbckForm textarea[name='fdbck']").val($("#fdbck" + seq).text());
        $("#updatePlayMmbrFdbckForm textarea[name='fdbck']").focus();
    }

    function fn_updatePlayMmbrFdbck() {
        if (gfn_validate("updatePlayMmbrFdbckForm")) {
            var url = "<c:url value='/updatePlayMmbrFdbck'/>";
            $("#updatePlayMmbrFdbckForm").ajaxForm({
                url: url,
                type: 'POST',
                dataType: 'JSON',
                data: {},
                success: function (data) {
                    gfn_defaultCallback(data);
                }
            });
            // submit 필수
            $("#updatePlayMmbrFdbckForm").submit();
        }
    }

    const openPlayingGame = () => {
        const gameNo = $("#playRecordForm").find("input[name='gameNo']").val();
        const playNo = $("#playRecordForm").find("input[name='playNo']").val();

        if (GAME.BOC_TROUBLE_BREWING == gameNo) {
            location.href = "/game/trouble-brewing/play/" + playNo;
        }

        if (GAME.FRUIT_SHOP == gameNo) {
            location.href = "/game/fruit-shop/play/" + playNo;
        }

        if (GAME.CATCH_A_THIEF == gameNo) {
            location.href = "/game/catch-a-thief/play/" + playNo;
        }

        if (GAME.BECOMING_A_DICTATOR == gameNo) {
            location.href = "/game/becoming-a-dictator/play/" + playNo;
        }

        if (GAME.BOC_CUSTOM == gameNo) {
            location.href = "/game/boc-custom/play/" + playNo;
        }

        if (GAME.ZOMBIE == gameNo) {
            location.href = "/game/zombie/play/" + playNo;
        }
    };

</script>

<!-- 플레이기록 모달 -->
<div class="modal fade" id="playRecordModal" role="dialog" aria-labelledby="playRecordModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="playRecordModalLabel"></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="playRecordForm">
                    <input type="hidden" name="playNo">
                    <input type="hidden" name="gameNo">
                    <input type="hidden" name="sttsCd">
                    <div class="row clearfix">
                        <div class="col-lg-5">
                            <div class="form-group">
                                <label class="form-control-label">모임</label>
                                <input type="text" name="clubNm" class="form-control form-control-alternative" readonly>
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <div class="form-group">
                                <label class="form-control-label">게임</label>
                                <input type="text" name="gameNm" class="form-control form-control-alternative" readonly>
                            </div>
                        </div>
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label class="form-control-label">플레이인원</label>
                                <input type="text" name="playMmbrCnt" class="form-control form-control-alternative"
                                       readonly>
                            </div>
                        </div>
                        <div class="col-lg-5">
                            <div class="form-group">
                                <label class="form-control-label">시작시간</label>
                                <input type="text" name="strtDt" class="form-control form-control-alternative" readonly>
                            </div>
                        </div>
                        <div class="col-lg-5">
                            <div class="form-group">
                                <label class="form-control-label">종료시간</label>
                                <input type="text" name="endDt" class="form-control form-control-alternative" readonly>
                            </div>
                        </div>
                    </div>
                </form>

                <hr class="my-4"/>
                <h3>플레이 결과</h3>
                <div class="table-responsive">
                    <table class="table align-items-center table-flush">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col">닉네임</th>
                            <th scope="col">세팅</th>
                            <th scope="col">순위</th>
                            <th scope="col">점수</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
                <div class="display-none" id="playMmbrFdbckDiv">
                    <hr class="my-4"/>
                    <h3>플레이 소감</h3>
                    <div class="row clearfix">
                        <div class="col-lg-6" id="playMmbrFdbckImg"></div>
                        <div class="col-lg-6 onShowImage" id="playMmbrFdbck"></div>
                    </div>
                </div>

                <div class="display-none" id="updatePlayMmbrFdbckDiv">
                    <hr class="my-4"/>
                    <h3>이 플레이에 대한 소감을 작성해 주세요.</h3>
                    <form id="updatePlayMmbrFdbckForm" enctype="multipart/form-data">
                        <input type="hidden" name="seq">
                        <div class="row clearfix">
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <label class="form-control-label">*한마디</label>
                                    <textarea rows="4" name="fdbck"
                                              class="form-control form-control-alternative hasValue"></textarea>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="form-group">
                                    <label class="form-control-label">플레이사진</label>
                                    <input type="file" data-name="플레이사진" name="file"
                                           class="form-control form-control-alternative">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" id="updatePlayMmbrFdbckBtn" class="btn btn-primary display-none"
                        onclick="fn_updatePlayMmbrFdbck();">소감 남기기
                </button>
                <button type="button" id="openPlayingGameBtn" class="btn btn-primary display-none"
                        onclick="openPlayingGame();">게임 보러가기
                </button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
