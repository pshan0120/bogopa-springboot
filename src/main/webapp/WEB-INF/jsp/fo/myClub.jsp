<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <!-- 다음 주소찾기 적용  -->
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>

    <script>
        $(function () {
            $("#myClubFeeForm select[name='payYn']").val("Y");
            $("#myClubFeeForm select[name='cnfrmYn']").val("N");

            fn_selectMyClub();
            fn_selectMyClubPlayRcrdList(1);
            fn_selectMyClubMmbrList(1);
            fn_selectMyClubBrdList(1);
            fn_selectMyClubPlayImgList(1);
            fn_selectMyClubGameList(1);
            fn_selectMyClubAttndList(1);
            fn_selectMyClubFeeList(1);

            gfn_setOnChange("myClubAttndForm", "fn_selectMyClubAttndList(1)");
            gfn_setOnChange("myClubFeeForm", "fn_selectMyClubFeeList(1)");

            $("[data-toggle='tooltip']").tooltip();
        });

        function fn_selectMyClub() {
            const comAjax = new ComAjax();
            comAjax.setUrl("<c:url value='/selectMyClub' />");
            comAjax.setCallback("fn_selectMyClubCallback");
            comAjax.ajax();
        }

        function fn_selectMyClubCallback(data) {
            gfn_setDataVal(data.map, "myClubInfoForm");

            if (data.map.prflImgFileNm != "") {
                $("#prflImg").attr("src", "https://bogopayo.cafe24.com/img/club/" + data.map.clubNo + "/" + data.map.prflImgFileNm);
                $("#updatePrflImg").attr("src", "https://bogopayo.cafe24.com/img/club/" + data.map.clubNo + "/" + data.map.prflImgFileNm);
            } else {
                $("#prflImg").attr("src", "https://bogopayo.cafe24.com/img/club/default.png");
                $("#updatePrflImg").attr("src", "https://bogopayo.cafe24.com/img/club/default.png");
            }
            $("#myClubAttndForm input[name='attndDate']").val(data.map.attndDateMin);
        }


        // TODO: page API 로 바꿀 것
        function fn_selectMyClubPlayRcrdList(pageNo) {
            const comAjax = new ComAjax("myClubInfoForm");
            comAjax.setUrl("<c:url value='/selectMyClubPlayRcrdList' />");
            comAjax.setCallback("fn_selectMyClubPlayRcrdListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.ajax();
        }

        function fn_selectMyClubPlayRcrdListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#playListTbl>tbody");
            body.empty();

            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan=\"4\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "playListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubPlayRcrdList",
                    recordCount: 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function (key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openPlayRcrdModal('" + value.playNo + "')\" >";
                    str += "			" + value.gameNm;
                    str += "		</a>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.endDt;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		<div class=\"avatar-group\">";
                    var playNickNms = value.playNickNms.split(",");
                    var playMmbrNos = value.playMmbrNos.split(",");
                    var playMmbrPrflImgFileNms = value.playMmbrPrflImgFileNms.split(",");
                    for (var i in playNickNms) {
                        str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm\" onclick=\"openMemberProfileModal('" + playMmbrNos[i] + "')\" data-toggle=\"tooltip\" data-original-title=\"" + playNickNms[i] + "\">";
                        if (playMmbrPrflImgFileNms[i] == "default") {
                            str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\" class=\"rounded-circle\">";
                        } else {
                            str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + playMmbrNos[i] + "/" + playMmbrPrflImgFileNms[i] + "\" class=\"rounded-circle\">";
                        }
                        str += "			</a>";
                    }
                    str += "		</div>";
                    str += "	</td>";
                    str += "	<td>";
                    var bestPlayNickNms = value.bestPlayNickNms.split(",");
                    for (var i in bestPlayNickNms) {
                        if (i == 0) {
                            str += bestPlayNickNms[i];
                        } else {
                            str += ", " + bestPlayNickNms[i];
                        }
                    }
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_selectMyClubMmbrList(pageNo) {
            const comAjax = new ComAjax("myClubInfoForm");
            comAjax.setUrl("<c:url value='/selectMyClubMmbrList' />");
            comAjax.setCallback("fn_selectMyClubMmbrListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.ajax();
        }

        function fn_selectMyClubMmbrListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#myClubMmbrListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "myClubMmbrListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubMmbrList",
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
                    str += "		" + value.clubMmbrGrdNm;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.fromDate;
                    str += "	</td>";
                    str += "	<td>";
                    if (value.feeDate != "") {
                        str += "		" + value.feeDate;
                    }
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);

            cnt = data.joinList.length;
            body = $("#myClubJoinListTbl>tbody");
            body.empty();
            str = "";
            if (data.joinList.length == 0) {
                $("#myClubJoinDiv").hide();
            } else {
                $.each(data.joinList, function (key, value) {
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
                    str += "		<a href=\"javascript:(void(0));\" class=\"btn btn-sm btn-primary\" onclick=\"fn_cnfrmClubJoin('" + value.seq + "', '" + value.mmbrNo + "')\">";
                    str += "			승인";
                    str += "		</a>";
                    str += "		<a href=\"javascript:(void(0));\" class=\"btn btn-sm btn-danger\" onclick=\"fn_rjctClubJoin('" + value.seq + "', '" + value.mmbrNo + "')\">";
                    str += "			거부";
                    str += "		</a>";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.playCnt;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.reqDate;
                    str += "	</td>";
                    str += "</tr>";
                    str += "<tr>";
                    str += "	<td colspan=\"2\">";
                    str += "		<textarea rows=\"4\" class=\"form-control form-control-alternative\" readonly>" + value.joinAnswr + "</textarea>";
                    str += "	</td>";
                    str += "	<td colspan=\"2\">";
                    str += "		<textarea rows=\"4\" class=\"form-control form-control-alternative\" readonly>" + value.intrdctn + "</textarea>";
                    str += "	</td>";
                    str += "</tr>";
                });

                $("#myClubJoinDiv").show();
            }
            body.append(str);
        }

        function fn_selectMyClubBrdList(pageNo) {
            const comAjax = new ComAjax("myClubInfoForm");
            comAjax.setUrl("<c:url value='/selectMyClubBrdList' />");
            comAjax.setCallback("fn_selectMyClubBrdListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.ajax();
        }

        function fn_selectMyClubBrdListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#myClubBrdListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "myClubBrdListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubBrdList",
                    recordCount: 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function (key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		" + value.brdTypeNm;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openClubBrdModal('" + value.seq + "')\">";
                    str += "			" + value.title;
                    str += "		</a>";
                    str += "	</td>";
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
                    str += "		" + value.insDt;
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_selectMyClubPlayImgList(pageNo) {
            const comAjax = new ComAjax("myClubInfoForm");
            comAjax.setUrl("<c:url value='/selectMyClubPlayImgList' />");
            comAjax.setCallback("fn_selectMyClubPlayImgListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 3);
            comAjax.ajax();
        }

        function fn_selectMyClubPlayImgListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#myClubPlayImgListDiv");
            body.empty();
            var str = "";
            if (cnt == 0) {
                $("#myClubPlayImgDiv").hide();
            } else {
                var params = {
                    divId: "myClubPlayImgListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubPlayImgList",
                    recordCount: 3
                };
                gfn_renderPaging(params);

                str += "<div class=\"row clearfix\">";
                $.each(data.map.list, function (key, value) {
                    str += "<div class=\"col-lg-4 mb-2\">";
                    str += "	<div class=\"card\">";
                    str += "		<img src=\"https://bogopayo.cafe24.com/img/play/" + value.seq + "/" + value.fdbckImgFileNm + "\" class=\"card-img-top\">";
                    str += "		<div class=\"card-body\">";
                    str += "			<p class=\"card-text\">\"" + value.fdbck + "\"</p>";
                    str += "			<div class=\"card-text-footer\">" + value.nickNm + ", <cite>" + value.endDate + " " + value.gameNm + " " + value.rsltRnk + "등</cite></div>";
                    str += "		</div>";
                    str += "	</div>";
                    str += "</div>";
                });
                str += "</div>";
                $("#myClubPlayImgDiv").show();
            }
            body.append(str);
        }


        // TODO: page API 로 바꿀 것
        function fn_selectMyClubGameList(pageNo) {
            const comAjax = new ComAjax("myClubInfoForm");
            comAjax.setUrl("<c:url value='/selectClubGameList' />");
            comAjax.setCallback("fn_selectMyClubGameListCallback");
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 5);
            comAjax.ajax();
        }

        function fn_selectMyClubGameListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#myClubGameListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan=\"3\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "myClubGameListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubGameList",
                    recordCount: 5
                };
                gfn_renderPaging(params);

                $.each(data.map.list, function (key, value) {
                    str += "<tr>";
                    str += "	<td>";
                    str += "		" + value.gameNm;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.minPlyrCnt + " ~ " + value.maxPlyrCnt;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + gfn_comma(value.playCnt);
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_selectMyClubAttndList(pageNo) {
            const comAjax = new ComAjax("myClubAttndForm");
            comAjax.setUrl("<c:url value='/selectClubAttndList' />");
            comAjax.setCallback("fn_selectMyClubAttndListCallback");
            comAjax.addParam("clubNo", $("#clubNo").val());
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 10);
            comAjax.ajax();
        }

        function fn_selectMyClubAttndListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#myClubAttndListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan=\"5\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "myClubAttndListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubAttndList",
                    recordCount: 10
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
                    if (value.attndYn == "Y") {
                        if (value.cnfrmYn == "Y") {
                            str += "	<a class=\"btn btn-sm btn-default mr-1 my-1\" href=\"javascript:(void(0));\" >";
                            str += "		확인";
                            str += "	</a>";
                        } else {
                            str += "	<a class=\"btn btn-sm btn-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_updateClubAttndCnfrm('Y', " + value.seq + ", '" + value.mmbrNo + "')\" >";
                            str += "		미확인";
                            str += "	</a>";
                        }
                    }
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.attndDate;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.reqDate;
                    str += "	</td>";
                    str += "	<td>";
                    if (value.attndYn == "Y") {
                        str += "	출석";
                    } else {
                        str += "	미출석";
                    }
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_selectMyClubFeeList(pageNo) {
            const comAjax = new ComAjax("myClubFeeForm");
            comAjax.setUrl("<c:url value='/selectMyClubFeeList' />");
            comAjax.setCallback("fn_selectMyClubFeeListCallback");
            comAjax.addParam("clubNo", $("#clubNo").val());
            comAjax.addParam("pageIndex", pageNo);
            comAjax.addParam("pageRow", 10);
            comAjax.ajax();
        }

        function fn_selectMyClubFeeListCallback(data) {
            var cnt = data.map.cnt;
            var body = $("#myClubFeeListTbl>tbody");
            body.empty();
            var str = "";
            if (cnt == 0) {
                str += "<tr><td colspan=\"6\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
            } else {
                var params = {
                    divId: "myClubFeeListPageNav",
                    pageIndex: "pageIndex",
                    totalCount: cnt,
                    eventName: "fn_selectMyClubFeeList",
                    recordCount: 10
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
                    str += "		" + gfn_comma(value.feeAmt) + " 원";
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.feeTypeNm;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.feeDate;
                    str += "	</td>";
                    str += "	<td>";
                    str += "		" + value.payDate;
                    str += "	</td>";
                    str += "	<td>";
                    if (value.cnfrmYn == "Y") {
                        str += "		" + value.cnfrmDate;
                    } else {
                        if (value.payYn == "Y") {
                            str += "	<a class=\"btn btn-sm btn-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_updateClubFeeCnfrm('Y', " + value.seq + ")\" >";
                            str += "		확인";
                            str += "	</a>";
                        }
                    }
                    str += "	</td>";
                    str += "</tr>";
                });
            }
            body.append(str);
        }

        function fn_updateClub() {
            if (gfn_validate("myClubInfoForm")) {
                const comAjax = new ComAjax("myClubInfoForm");
                comAjax.setUrl("<c:url value='/updateClub' />");
                comAjax.setCallback("gfn_defaultCallback");
                comAjax.ajax();
            }
        }

        function fn_openClubPrflImgModal() {
            $("#updatePrflImgModal").modal("show");
        }

        function fn_updateClubPrflImg() {
            var url = "<c:url value='/updateClubPrflImg'/>";
            var clubNo = $("#clubNo").val();
            $('#updatePrflImgForm').ajaxForm({
                url: url,
                type: 'POST',
                dataType: 'JSON',
                data: {
                    clubNo: clubNo
                },
                success: function (data) {
                    gfn_defaultCallback(data);
                }
            });
            // submit 필수
            $("#updatePrflImgForm").submit();
        }

        function fn_cnfrmClubJoin(seq, mmbrNo) {
            if (confirm("가입 신청을 승인하시겠습니까?")) {
                const comAjax = new ComAjax("myClubInfoForm");
                comAjax.setUrl("<c:url value='/cnfrmClubJoin' />");
                comAjax.addParam("seq", seq);
                comAjax.addParam("mmbrNo", mmbrNo);
                comAjax.setCallback("gfn_defaultCallback");
                comAjax.ajax();
            } else {
                return;
            }
        }

        function fn_rjctClubJoin(seq, mmbrNo) {
            if (confirm("가입 신청을 거부하시겠습니까?")) {
                const comAjax = new ComAjax("myClubInfoForm");
                comAjax.setUrl("<c:url value='/rjctClubJoin' />");
                comAjax.addParam("seq", seq);
                comAjax.addParam("mmbrNo", mmbrNo);
                comAjax.setCallback("gfn_defaultCallback");
                comAjax.ajax();
            } else {
                return;
            }
        }

        function fn_openClubAttndModal() {
            $("#clubAttndForm input[name='attndDate']").val(gfn_getCurrentDateDash());
            $("#clubAttndModal").modal("show");
        }

        function fn_insertClubAttndAll() {
            if (confirm("전체 모임원 대상으로 출석확인을 요청하시겠습니까?")) {
                const comAjax = new ComAjax("clubAttndForm");
                comAjax.setUrl("<c:url value='/insertClubAttndAll' />");
                comAjax.setCallback("gfn_defaultCallback");
                comAjax.addParam("clubNo", $("#clubNo").val());
                comAjax.ajax();
            } else {
                return;
            }
        }

        function fn_deleteClubAttndAll() {
            if (confirm("해당 모임일의 출석을 삭제하시겠습니까?")) {
                const comAjax = new ComAjax("clubAttndForm");
                comAjax.setUrl("<c:url value='/deleteClubAttndAll' />");
                comAjax.setCallback("gfn_defaultCallback");
                comAjax.addParam("clubNo", $("#clubNo").val());
                comAjax.ajax();
            } else {
                return;
            }
        }

        function fn_updateClubAttndCnfrm(cnfrmYn, seq, mmbrNo) {
            const comAjax = new ComAjax();
            comAjax.setUrl("<c:url value='/updateClubAttndCnfrm' />");
            comAjax.setCallback("fn_updateClubAttndCnfrmCallback");
            comAjax.addParam("cnfrmYn", cnfrmYn);
            comAjax.addParam("seq", seq);
            comAjax.addParam("mmbrNo", mmbrNo);
            comAjax.addParam("clubNo", $("#clubNo").val());
            comAjax.ajax();
        }

        function fn_updateClubAttndCnfrmCallback(data) {
            fn_selectMyClubAttndList(1);
        }

        function fn_updateClubFeeCnfrm(cnfrmYn, seq) {
            const comAjax = new ComAjax();
            comAjax.setUrl("<c:url value='/updateClubFeeCnfrm' />");
            comAjax.setCallback("fn_updateClubFeeCnfrmCallback");
            comAjax.addParam("cnfrmYn", cnfrmYn);
            comAjax.addParam("seq", seq);
            comAjax.ajax();
        }

        function fn_updateClubFeeCnfrmCallback(data) {
            fn_selectMyClubFeeList(1);
        }

        const openMemberProfileModal = memberId => {
            memberProfileModal.open(memberId);
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
                        <h1 class="text-white">나도 순정이 있다</h1>
                        <p class="text-lead text-light">젊은 친구들을 다뤄보자</p>
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
            <div class="col-xl-4 order-xl-2 mb-5 mb-xl-0">
                <div class="card card-profile shadow">
                    <div class="card-header">
                        <div class="row clearfix">
                            <div class="col-lg-12">
                                <button type="button" class="btn btn-sm btn-primary float-right"
                                        onclick="fn_updateClub();">정보수정
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body pt-4 pt-md-4">
                        <form id="myClubInfoForm">
                            <input type="hidden" name="clubNo" id="clubNo">
                            <div class="row clearfix">
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <a href="javascrit:void(0);" onclick="fn_openClubPrflImgModal();">
                                            <img src="" id="prflImg" class="img-responsive img-thumbnail m-auto">
                                        </a>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label" for="clubNm">모임이름</label>
                                        <input type="text" data-name="모임" name="clubNm"
                                               class="form-control form-control-alternative" disabled>
                                    </div>
                                </div>
                                <div class="col-sm-12 col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label" for="clubTypeNm">유형</label>
                                        <input type="text" data-name="유형" name="clubTypeNm"
                                               class="form-control form-control-alternative" disabled>
                                    </div>
                                </div>
                                <div class="col-sm-12 col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label" for="clubGrdNm">등급</label>
                                        <input type="text" data-name="등급" name="clubGrdNm"
                                               class="form-control form-control-alternative" disabled>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label" for="prmmFromDate">프리미엄 시작일</label>
                                        <input type="date" data-name="프리미엄 시작일" name="prmmFromDate"
                                               class="form-control form-control-alternative" disabled>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label" for="prmmToDate">프리미엄 종료일</label>
                                        <input type="date" data-name="프리미엄 종료일" name="prmmToDate"
                                               class="form-control form-control-alternative" disabled>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label">*우편번호</label>
                                        <input type="text" data-name="우편번호" id="zipCd" name="zipCd"
                                               class="form-control form-control-alternative" readonly>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group mt-4 pt-2">
                                        <button type="button" class="btn btn-info"
                                                onclick="gfn_findAddr('zipCd', 'addrs1', 'addrs2');">주소검색
                                        </button>
                                    </div>
                                </div>

                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">*주소</label>
                                        <input type="text" data-name="주소" id="addrs1" name="addrs1"
                                               class="form-control form-control-alternative hasValue" readonly>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">*상세주소</label>
                                        <input type="text" data-name="상세주소" id="addrs2" name="addrs2"
                                               class="form-control form-control-alternative hasValue">
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label">회비납부은행</label>
                                        <select data-name="회비납부은행" name="feeAccntBankCd"
                                                class="form-control form-control-alternative">
                                            <option value="">선택하세요.</option>
                                            <c:choose>
                                                <c:when test="${fn:length(bankCdList) > 0}">
                                                    <c:forEach var="row" items="${bankCdList}" varStatus="status">
                                                        <option value="${row.cd}">${row.nm}</option>
                                                    </c:forEach>
                                                </c:when>
                                            </c:choose>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label class="form-control-label">회비계좌명</label>
                                        <input type="text" data-name="회비계좌명" name="feeAccntNm"
                                               class="form-control form-control-alternative">
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">회비계좌번호</label>
                                        <input type="text" data-name="회비계좌번호" name="feeAccntNo"
                                               class="form-control form-control-alternative numberOnly">
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">*회비(1회)</label>
                                        <input type="text" data-name="회비(1회)" name="feeType1Amt"
                                               class="form-control form-control-alternative numberOnly hasValue">
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">*회비(기간)</label>
                                        <input type="text" data-name="회비(기간)" name="feeType2Amt"
                                               class="form-control form-control-alternative numberOnly hasValue">
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">*소개</label>
                                        <textarea rows="4" data-name="소개" name="intrdctn"
                                                  class="form-control form-control-alternative hasValue"></textarea>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label class="form-control-label">가입질문</label>
                                        <textarea rows="4" data-name="가입질문" name="joinQstn"
                                                  class="form-control form-control-alternative"></textarea>
                                    </div>
                                </div>

                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-xl-8 order-xl-1">
                <div class="card shadow">
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-12">
                                <h3 class="mb-0">플레이기록</h3>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="playListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th scope="col">게임</th>
                                    <th scope="col">일시</th>
                                    <th scope="col">플레이어</th>
                                    <th scope="col">최고순위</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0" id="playListPageNav"></ul>
                        </nav>
                    </div>
                </div>

                <div class="card shadow mt-5">
                    <div class="card-header bg-white border-0">
                        <div class="row align-items-center">
                            <div class="col-12">
                                <h3 class="mb-0">모임원</h3>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="myClubMmbrListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th scope="col">회원</th>
                                    <th scope="col">등급</th>
                                    <th scope="col">가입일</th>
                                    <th scope="col">회비(기간)여부</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="myClubMmbrListPageNav"></ul>
                        </nav>
                    </div>

                    <div class="display-none" id="myClubJoinDiv">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table align-items-center table-flush" id="myClubJoinListTbl">
                                    <thead class="thead-light">
                                    <tr>
                                        <th scope="col">회원</th>
                                        <th scope="col">관리</th>
                                        <th scope="col">플레이횟수</th>
                                        <th scope="col">가입신청일</th>
                                    </tr>
                                    <tr>
                                        <th scope="col" colspan="2">가입질문 답변</th>
                                        <th scope="col" colspan="2">소개</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer py-4">
                            <nav aria-label="">
                                <ul class="pagination pagination-sm justify-content-end mb-0"
                                    id="myClubJoinListPageNav"></ul>
                            </nav>
                        </div>
                    </div>
                </div>

                <div class="card shadow mt-5">
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-6">
                                <h3 class="mb-0">모임 게시판</h3>
                            </div>
                            <div class="col-6">
                                <button type="button" class="btn btn-sm btn-info float-right"
                                        onclick="fn_openInsertClubBrdModal();">
                                    게시물 작성
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="myClubBrdListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th scope="col">유형</th>
                                    <th scope="col">제목</th>
                                    <th scope="col">작성자</th>
                                    <th scope="col">작성일시</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="myClubBrdListPageNav"></ul>
                        </nav>
                    </div>
                </div>

                <div class="card shadow mt-5 display-none" id="myClubPlayImgDiv">
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-6">
                                <h3 class="mb-0">모임 플레이사진</h3>
                            </div>
                            <div class="col-6">
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div id="myClubPlayImgListDiv">
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="myClubPlayImgListPageNav"></ul>
                        </nav>
                    </div>
                </div>

                <div class="card shadow mt-5">
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-6">
                                <h3 class="mb-0">모임 보유게임</h3>
                            </div>
                            <div class="col-6">
                                <button type="button" class="btn btn-sm btn-info float-right"
                                        onclick="fn_openClubGameModal();">
                                    모임게임 관리
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="myClubGameListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th scope="col">게임</th>
                                    <th scope="col">플레이 가능인원</th>
                                    <th scope="col">플레이 횟수</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="myClubGameListPageNav"></ul>
                        </nav>
                    </div>
                </div>

                <div class="card shadow mt-5">
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-6">
                                <h3 class="mb-0">모임 출석부</h3>
                            </div>
                            <div class="col-6">
                                <button type="button" class="btn btn-sm btn-info float-right"
                                        onclick="fn_openClubAttndModal();">
                                    출석체크관리
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <form id="myClubAttndForm">
                                <div class="row clearfix">
                                    <div class="col-sm-12 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-control-label" for="attndDate">모임일</label>
                                            <input type="date" name="attndDate"
                                                   class="form-control form-control-alternative onChange">
                                        </div>
                                    </div>
                                    <div class="col-sm-12 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-control-label" for="nickNm">모임원 닉네임</label>
                                            <input type="text" name="nickNm"
                                                   class="form-control form-control-alternative"
                                                   onKeypress="gfn_hitEnter(event, 'fn_selectMyClubAttndList(1)');">
                                        </div>
                                    </div>
                                    <div class="col-sm-12 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-control-label" for="attndYn">출석여부</label>
                                            <select class="form-control form-control-alternative onChange"
                                                    name="attndYn">
                                                <option value="">전체</option>
                                                <option value="Y">출석</option>
                                                <option value="N">미출석</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-sm-12 col-lg-3">
                                        <div class="form-group">
                                            <label class="form-control-label" for="cnfrmYn">확인여부</label>
                                            <select class="form-control form-control-alternative onChange"
                                                    name="cnfrmYn">
                                                <option value="">전체</option>
                                                <option value="Y">확인</option>
                                                <option value="N">미확인</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>
                            <table class="table align-items-center table-flush" id="myClubAttndListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th scope="col">모임원 닉네임</th>
                                    <th scope="col">출석확인여부</th>
                                    <th scope="col">모임일</th>
                                    <th scope="col">출석예정 요청일</th>
                                    <th scope="col">출석예정여부</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="myClubAttndListPageNav"></ul>
                        </nav>
                    </div>
                </div>

                <div class="card shadow mt-5">
                    <div class="card-header bg-white border-0">
                        <div class="row">
                            <div class="col-6">
                                <h3 class="mb-0">모임 회비</h3>
                            </div>
                            <div class="col-6">
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <form id="myClubFeeForm">
                            <div class="row clearfix">
                                <div class="col-sm-12 col-lg-3">
                                    <div class="form-group">
                                        <label class="form-control-label" for="payYn">납입여부</label>
                                        <select class="form-control form-control-alternative onChange" name="payYn">
                                            <option value="">전체</option>
                                            <option value="Y">납입</option>
                                            <option value="N">미납</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-sm-12 col-lg-3">
                                    <div class="form-group">
                                        <label class="form-control-label" for="cnfrmYn">확인여부</label>
                                        <select class="form-control form-control-alternative onChange" name="cnfrmYn">
                                            <option value="">전체</option>
                                            <option value="Y">확인</option>
                                            <option value="N">미확인</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush" id="myClubFeeListTbl">
                                <thead class="thead-light">
                                <tr>
                                    <th scope="col">모임원</th>
                                    <th scope="col">회비</th>
                                    <th scope="col">회비유형</th>
                                    <th scope="col">회비기간</th>
                                    <th scope="col">납입일</th>
                                    <th scope="col">확인일</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <nav aria-label="">
                            <ul class="pagination pagination-sm justify-content-end mb-0"
                                id="myClubFeeListPageNav"></ul>
                        </nav>
                    </div>
                </div>


            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<!-- 프로필이미지 Modal -->
<div class="modal fade" id="updatePrflImgModal" role="dialog" aria-labelledby="updatePrflImgModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">프로필이미지</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="updatePrflImgForm" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-lg-12">
                            <img src="" id="updatePrflImg" class="img-responsive img-thumbnail m-auto">
                        </div>
                    </div>
                    <hr class="my-4"/>
                    <div class="row">
                        <div class="col-lg-12">
                            <input type="file" name="file">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="fn_updateClubPrflImg()">변경</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 출석확인 요청 Modal -->
<div class="modal fade" id="clubAttndModal" role="dialog" aria-labelledby="clubAttndModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">출석확인 요청/삭제</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p class="small">
                    요청시 모든 모임원(모임장 포함)에게 모임일 출석여부 확인이 보여지며, 취소시 해당 모임일의 모든 출석기록이 삭제됩니다.
                </p>
                <form id="clubAttndForm">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="form-control-label" for="attndDate">모임일</label>
                                <input type="date" name="attndDate" class="form-control form-control-alternative">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="fn_insertClubAttndAll()">요청</button>
                <button type="button" class="btn btn-danger" onclick="fn_deleteClubAttndAll()">취소</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 회원프로필 -->
<%@ include file="/WEB-INF/jsp/fo/jspf/memberProfileModal.jspf" %>
<!-- 플레이기록 -->
<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp" %>
<!-- 모임게시물 -->
<%@ include file="/WEB-INF/jsp/fo/clubBrdModal.jsp" %>
<!-- 모임게임 -->
<%@ include file="/WEB-INF/jsp/fo/clubGameModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
