<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/fo/includeHeader.jspf"%>

<!-- 다음 주소찾기 적용  -->
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>

<script>
	var sttng1Str = "";
	var sttng2Str = "";
	var sttng3Str = "";
	var minPlyrCnt = 0;
	var maxPlyrCnt = 0;
	var joinPlyrCnt = 0;
	var playGameNo = 0;
	
	$(function() {
		gfn_setSortTh("playRcrd1List", "fn_selectPlayRcrd1List(1)");
		gfn_setSortTh("playRcrd2List", "fn_selectPlayRcrd2List(1)");
		gfn_setSortTh("playRcrd3List", "fn_selectPlayRcrd3List(1)");
		gfn_setSortTh("playRcrd4List", "fn_selectPlayRcrd4List(1)");
		
		$("#tabList a").click(function(e) {
			//e.preventDefault();
			//$(this).tab('show');
			$("#playRcrd1ListPageNav").val(1);
			$("#playRcrd2ListPageNav").val(1);
			$("#playRcrd3ListPageNav").val(1);
			$("#playRcrd4ListPageNav").val(1);
			
			var tabId = $(this).attr('id');
			if(tabId == "playRcrdTab1A") {
				fn_selectPlayRcrd1List(1);
			} else if(tabId == "playRcrdTab2A") {
				fn_selectPlayRcrd2List(1);
			} else if(tabId == "playRcrdTab3A") {
				fn_selectPlayRcrd3List(1);
			} else if(tabId == "playRcrdTab4A") {
				fn_selectPlayRcrd4List(1);
			}
		});
		
		$("#insertPlayForm select[name='gameNo']").on("change", function() {
			$("#playMmbrListTbl>tbody").empty();
			$("div[name='sttngCntrlDiv']").empty();
			playGameNo = this.value;
			minPlyrCnt = $("#insertPlayForm select[name='gameNo'] option:selected").data("minplyrcnt");
			maxPlyrCnt = $("#insertPlayForm select[name='gameNo'] option:selected").data("maxplyrcnt");
			joinPlyrCnt = 0;

			fn_selectPlayJoinMmbrList(1);
			fn_setPlayNm($("#insertPlayForm select[name='gameNo'] option:selected").text());
			fn_selectGameSttngList($("#insertPlayForm select[name='gameNo'] option:selected").val());
		});
		
		$("[data-toggle='tooltip']").tooltip();

		fn_selectPlayRcrd1List(1);
	});


	function fn_selectPlayRcrd1List(pageNo) {
		var comAjax = new ComAjax("playRcrd1Form");
		comAjax.setUrl("<c:url value='/selecPlayRcrdByAllList' />");
		comAjax.setCallback("fn_selectPlayRcrd1ListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.addParam("orderBy", $('#playRcrd1ListCurOrderBy').val());
		comAjax.ajax();
	}

	function fn_selectPlayRcrd1ListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#playRcrd1ListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "playRcrd1ListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectPlayRcrd1List",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openPlayRcrdModal('" + value.playNo + "')\" >";
				str += "			" + value.playNm;
				str += "		</a>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.gameNm;
				str += "	</td>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
				if(value.clubPrflImgFileNm != "") {
					str += "			<img src=\"http://203.245.28.115/img/club/" + value.clubNo + "/" + value.clubPrflImgFileNm + "\">";
				} else {
					str += "			<img src=\"http://203.245.28.115/img/club/default.png\">";
				}
				str += "			</a>";
				str += "			<div class=\"media-body\">";
				str += "				<span class=\"mb-0 text-sm\">" + value.clubNm + "</span>";
				str += "			</div>";
				str += "		</div>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.strtDt + " ~ ";
				if(value.endDt != "") {
					str += value.endDt;
				}
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}
	
	function fn_selectPlayRcrd2List(pageNo) {
		var comAjax = new ComAjax("playRcrd2Form");
		comAjax.setUrl("<c:url value='/selecPlayRcrdByClubList' />");
		comAjax.setCallback("fn_selectPlayRcrd2ListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.addParam("orderBy", $('#playRcrd2ListCurOrderBy').val());
		comAjax.ajax();
	}

	function fn_selectPlayRcrd2ListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#playRcrd2ListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='5' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "playRcrd2ListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectPlayRcrd2List",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
				if(value.prflImgFileNm != "") {
					str += "			<img src=\"http://203.245.28.115/img/club/" + value.clubNo + "/" + value.prflImgFileNm + "\">";
				} else {
					str += "			<img src=\"http://203.245.28.115/img/club/default.png\">";
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

	function fn_selectPlayRcrd3List(pageNo) {
		var comAjax = new ComAjax("playRcrd3Form");
		comAjax.setUrl("<c:url value='/selecPlayRcrdByMmbrList' />");
		comAjax.setCallback("fn_selectPlayRcrd3ListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.addParam("orderBy", $('#playRcrd3ListCurOrderBy').val());
		comAjax.ajax();
	}
	
	function fn_selectPlayRcrd3ListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#playRcrd3ListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "playRcrd3ListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectPlayRcrd3List",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openMmbrPrflModal('" + value.mmbrNo + "')\">";
				if(value.prflImgFileNm != "") {
					str += "			<img src=\"http://203.245.28.115/img/mmbr/" + value.mmbrNo + "/" + value.prflImgFileNm + "\">";
				} else {
					str += "			<img src=\"http://203.245.28.115/img/mmbr/default.png\">";
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

	function fn_selectPlayRcrd4List(pageNo) {
		var comAjax = new ComAjax("playRcrd4Form");
		comAjax.setUrl("<c:url value='/selecPlayRcrdByGameList' />");
		comAjax.setCallback("fn_selectPlayRcrd4ListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.addParam("orderBy", $('#playRcrd4ListCurOrderBy').val());
		comAjax.ajax();
	}
	
	function fn_selectPlayRcrd4ListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#playRcrd4ListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "playRcrd4ListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectPlayRcrd4List",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
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
				for(var i in mostPlay3NickNms) {
					str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm\" onclick=\"fn_openMmbrPrflModal('" + mostPlay3MmbrNos[i] + "')\" data-toggle=\"tooltip\" data-original-title=\"" + mostPlay3NickNms[i] + "\">";
					if(mostPlay3MmbrPrflImgFileNms[i] == "default") {
						str += "			<img src=\"http://203.245.28.115/img/mmbr/default.png\" class=\"rounded-circle\">";
					} else {
						str += "			<img src=\"http://203.245.28.115/img/mmbr/" + mostPlay3MmbrNos[i] + "/" + mostPlay3MmbrPrflImgFileNms[i]  + "\" class=\"rounded-circle\">";
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
		$("#insertPlayForm input[name='hostMmbrNo']").val("<c:out value="${mmbrNo}" />");
		$("#insertPlayForm input[name='hostNickNm']").val("<c:out value="${nickNm}" />");
		$("#insertPlayForm input[name='clubNo']").val("<c:out value="${clubNo}" />");
		$("#insertPlayForm input[name='playNm']").val("");
		fn_selectGameNoList();
		
		$("#insertPlayModal").modal("show");
	}
	
	function fn_selectGameNoList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectGameNoList' />");
		comAjax.setCallback("fn_selectGameNoListCallback");
		comAjax.addParam("gameNm", $("#insertPlayForm input[name='gameNm']").val());
		comAjax.ajax();
	}
	
	function fn_selectGameNoListCallback(data) {
		var cnt = data.list.length;
		var body = $("#insertPlayForm select[name='gameNo']");
		body.empty();
		var str = "";
		if(cnt > 0) {
			str += "<option value=\"\">선택하세요.</option>";
			$.each(data.list, function(key, value) {
				str += "<option value=" + value.gameNo + " data-minPlyrCnt=" + value.minPlyrCnt + " data-maxPlyrCnt=" + value.maxPlyrCnt + ">" + value.gameNm + "</option>";
			});
		}
		body.append(str);
	}
	
	function fn_setPlayNm(gameNm) {
		$("#insertPlayForm input[name='playNm']").val("'" + "<c:out value="${nickNm}" />" + "'의 " + gameNm);
	};

	function fn_selectGameSttngList(gameNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectGameSttngList' />");
		comAjax.setCallback("fn_selectGameSttngListCallback");
		comAjax.addParam("gameNo", gameNo);
		comAjax.ajax();
	};
	
	function fn_selectGameSttngListCallback(data) {
		var sttngCntrlSame1str = "";
		var sttngCntrlSame2str = "";
		var sttngCntrlSame3str = "";
		
		sttng1Str = "";
		$.each(data.sttng1List, function(key, value) {
			sttng1Str += "	<option value=\"" + value.cd + "\">" + value.nm + "</option>";
			
			sttngCntrlSame1str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_setSameGameSttng('1', '" + value.cd + "')\" >";
			sttngCntrlSame1str += "	" + value.nm;
			sttngCntrlSame1str += "</a>";
		});
		if(sttng1Str != "") {
			sttngCntrlSame1str += "<a class=\"btn btn-sm btn-outline-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_setRndmGameSttng('1')\" >";
			sttngCntrlSame1str += "	랜덤으로 고르기";
			sttngCntrlSame1str += "</a>";
		}

		sttng2Str = "";
		$.each(data.sttng2List, function(key, value) {
			sttng2Str += "	<option value=\"" + value.cd + "\">" + value.nm + "</option>";

			sttngCntrlSame2str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_setSameGameSttng('2', '" + value.cd + "')\" >";
			sttngCntrlSame2str += "	" + value.nm;
			sttngCntrlSame2str += "</a>";
		});
		if(sttng2Str != "") {
			sttngCntrlSame2str += "<a class=\"btn btn-sm btn-outline-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_setRndmGameSttng('2')\" >";
			sttngCntrlSame2str += "	랜덤으로 고르기";
			sttngCntrlSame2str += "</a>";
		}
		
		
		sttng3Str = "";
		$.each(data.sttng3List, function(key, value) {
			sttng3Str += "	<option value=\"" + value.cd + "\">" + value.nm + "</option>";

			sttngCntrlSame3str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_setSameGameSttng('3', '" + value.cd + "')\" >";
			sttngCntrlSame3str += "	" + value.nm;
			sttngCntrlSame3str += "</a>";
		});
		if(sttng3Str != "") {
			sttngCntrlSame3str += "<a class=\"btn btn-sm btn-outline-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_setRndmGameSttng('3')\" >";
			sttngCntrlSame3str += "	랜덤으로 고르기";
			sttngCntrlSame3str += "</a>";
		}
		
		fn_addPlayMmbr("<c:out value="${mmbrNo}" />", "<c:out value="${nickNm}" />");
		
		if(sttng1Str != "") {
			$("#sttngCntrl1Div").append(sttngCntrlSame1str);
			$("#gameSttng1Div").show();
		}

		if(sttng2Str != "") {
			$("#sttngCntrl2Div").append(sttngCntrlSame2str);
			$("#gameSttng2Div").show();
		}

		if(sttng3Str != "") {
			$("#sttngCntrl3Div").append(sttngCntrlSame3str);
			$("#gameSttng3Div").show();
		}
		
		return true;
	}

	function fn_setSameGameSttng(grpCd, cd) {
		$("#playMmbrListTbl select[name='sttng" + grpCd + "Cd']").val(cd);
	}
		
	function fn_setRndmGameSttng(grpCd) {
		var sttngCdArr = new Array();
		$("#playMmbrListTbl > tbody > tr:nth-child(1) select[name='sttng" + grpCd + "Cd'] option").each(function() {
			sttngCdArr.push(this.value);
		});
		
		var cdCnt = sttngCdArr.length - 1;
		var playMmbrNoArr = new Array();
		$("#playMmbrListTbl > tbody > tr").each(function() {
			var rndmIdx = Math.round(Math.random() * cdCnt);
			$("#" + this.id + " select[name='sttng" + grpCd + "Cd']").val(sttngCdArr[rndmIdx]);
			sttngCdArr.splice(rndmIdx, 1);
			cdCnt--;
		});
	}
	
	function fn_addPlayMmbr(mmbrNo, nickNm) {
		if(joinPlyrCnt < maxPlyrCnt) {
			var body = $("#playMmbrListTbl>tbody");
			var str = "";
			str += "<tr name=\"addPlayMmbrTr\" id=\"addPlayMmbrTr" + mmbrNo + "\">";
			str += "	<td>";
			str += "		" + nickNm;
			str += "	</td>";
			str += "	<td>";
			if(sttng1Str != "") {
				str += "	<select class=\"form-control hasValue\" name=\"sttng1Cd\">";
				str += "	" + sttng1Str;
				str += "	</select>";
			}
			if(sttng2Str != "") {
				str += "	<select class=\"form-control hasValue\" name=\"sttng2Cd\">";
				str += "	" + sttng2Str;
				str += "	</select>";
			}
			if(sttng3Str != "") {
				str += "	<select class=\"form-control hasValue\" name=\"sttng3Cd\">";
				str += "	" + sttng3Str;
				str += "	</select>";
			}
			str += "	</td>";
			str += "	<td>";
			if(mmbrNo == "<c:out value="${mmbrNo}" />") {
				str += "	호스트";
			} else {
				str += "	<a class=\"btn btn-sm btn-outline-warning\" href=\"javascript:(void(0));\" onclick=\"fn_removePlayMmbr('" + mmbrNo + "','" + nickNm + "')\">제외</a>";
			}
			str += "	</td>";
			str += "</tr>";
			body.append(str);

			$("#playJoinMmbrNListDiv a").each(function () {
				var playJoinNickNm = $(this).text().trim();
				if(playJoinNickNm == nickNm) {
					$(this).remove();
				}
			});

			joinPlyrCnt++;
		} else {
			alert("최대 플레이 가능인원은 " + maxPlyrCnt + "명까지입니다.");
			return false;
		}
	}

	function fn_removePlayMmbr(mmbrNo, nickNm) {
		var body = $("#playJoinMmbrNListDiv");
		var str = "";
		str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_addPlayMmbr('" + mmbrNo + "', '" + nickNm + "')\" >";
		str += "	" + nickNm;
		str += "</a>";
		body.append(str);
		
		$("#playMmbrListTbl td:nth-child(1)").each(function () {
			var playJoinNickNm = $(this).text().trim();
			if(playJoinNickNm == nickNm.trim()) {
				$("#addPlayMmbrTr" + mmbrNo).remove();
				joinPlyrCnt--;
			}
		});
	}
	
	function fn_selectPlayJoinMmbrList(pageNo) {
		var comAjax = new ComAjax("insertPlayForm");
		comAjax.setUrl("<c:url value='/selectPlayJoinMmbrList' />");
		comAjax.setCallback("fn_selectPlayJoinMmbrListCallback");
		comAjax.ajax();
	}
	
	function fn_selectPlayJoinMmbrListCallback(data) {
		var cnt = data.list.length;
		var body = $("#playJoinMmbrNListDiv");
		body.empty();
		var str = "";
		if(cnt > 0) {
			$.each(data.list, function(key, value) {
				var isRun = true;
				$("#playMmbrListTbl td:nth-child(1)").each(function () {
					var playJoinNickNm = $(this).text().trim();
					if(playJoinNickNm != $("#hostMmbrNo").val() && playJoinNickNm == value.nickNm) {
						isRun = false;
					}
				});
				if(isRun) {
					str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_addPlayMmbr('" + value.mmbrNo + "', '" + value.nickNm + "')\" >";
					str += "	" + value.nickNm;
					str += "</a>";
				}
			});
		}
		body.append(str);
	}
	
	function fn_insertPlay() {
		if(joinPlyrCnt < minPlyrCnt) {
			alert("선택된 플레이어가 최소 플레이어수보다 적습니다.");
			return false;
		}

		if(joinPlyrCnt > maxPlyrCnt) {
			alert("선택된 플레이어가 최대 플레이어수보다 많습니다.");
			return false;
		}

		var joinMmbrNoArr = new Array();
		var sttngCd1Arr = new Array();
		var sttngCd2Arr = new Array();
		var sttngCd3Arr = new Array();
		
		$("#playMmbrListTbl > tbody > tr").each(function() {
			joinMmbrNoArr.push(this.id.replace("addPlayMmbrTr", ""));
		});
		$("#playMmbrListTbl > tbody > tr select[name='sttng1Cd'] option:selected").each(function() {
			sttngCd1Arr.push(this.value);
		});
		$("#playMmbrListTbl > tbody > tr select[name='sttng2Cd'] option:selected").each(function() {
			sttngCd2Arr.push(this.value);
		});
		$("#playMmbrListTbl > tbody > tr select[name='sttng3Cd'] option:selected").each(function() {
			sttngCd3Arr.push(this.value);
		});
		
		if(gfn_validate("insertPlayForm")) {
			if(confirm("바로 플레이를 시작됩니다. 진행하시겠습니까?")) {
				var comAjax = new ComAjax("insertPlayForm");
				comAjax.setUrl("<c:url value='/insertPlay' />");
				comAjax.setCallback("gfn_defaultCallback");
				comAjax.addParam("joinMmbrNoArr", joinMmbrNoArr);
				comAjax.addParam("sttngCd1Arr", sttngCd1Arr);
				comAjax.addParam("sttngCd2Arr", sttngCd2Arr);
				comAjax.addParam("sttngCd3Arr", sttngCd3Arr);
				comAjax.ajax();
			} else {
				return;
			}
		}
	}

</script>
</head>

<body class="bg-default">
	<%@ include file="/WEB-INF/include/fo/includeBody.jspf"%>
	<div class="main-content">
		<%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp"%>
		
		<!-- Header -->
		<div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
			<div class="container">
				<div class="header-body text-center mb-7">
					<div class="row justify-content-center">
						<div class="col-lg-8 col-md-8">
							<h1 class="text-white">신사답게 기록해</h1>
							<p class="text-lead text-light">그리고 너 다음에 한판 더 해</p>
						</div>
					</div>
				</div>
			</div>
			<div class="separator separator-bottom separator-skew zindex-100">
				<svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1" xmlns="http://www.w3.org/2000/svg">
					<polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
				</svg>
			</div>
		</div>
		<!-- Page content -->
		<div class="container mt--7">
			<div class="row">
				<div class="col-xl-12 mb-5 mb-xl-0">
					<div class="card shadow mt-5">
						<div class="nav-wrapper">
							<ul class="nav nav-pills nav-fill flex-column flex-md-row mx-3" role="tablist" id="tabList">
								<li class="nav-item px-1">
									<a class="nav-link active" id="playRcrdTab1A" data-toggle="tab" href="#playRcrdTab1" role="tab" aria-controls="playRcrdTab1" aria-selected="true">
										전체
									</a>
								</li>
								<li class="nav-item px-1">
									<a class="nav-link" id="playRcrdTab2A" data-toggle="tab" href="#playRcrdTab2" role="tab" aria-controls="playRcrdTab2" aria-selected="true">
										모임별
									</a>
								</li>
								<li class="nav-item px-1">
									<a class="nav-link" id="playRcrdTab3A" data-toggle="tab" href="#playRcrdTab3" role="tab" aria-controls="playRcrdTab3" aria-selected="false">
										회원별
									</a>
								</li>
								<li class="nav-item px-1">
									<a class="nav-link" id="playRcrdTab4A" data-toggle="tab" href="#playRcrdTab4" role="tab" aria-controls="playRcrdTab4" aria-selected="false">
										게임별
									</a>
								</li>
							</ul>
						</div>
						
						<div class="tab-content">
							<!-- 전체 탭 컨텐츠 -->
							<div id="playRcrdTab1" class="tab-pane fade show active" role="tabpanel" aria-labelledby="playRcrdTab1A">
								<div class="card-header bg-white border-0">
									<div class="row">
										<div class="col-6 col-lg-6">
										</div>
									</div>
								</div>
								<div class="card-body">
									<form id="playRcrd1Form" onsubmit="return false;">
										<input type="hidden" id="playRcrd1ListCurOrderBy">
										<div class="row clearfix">
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">플레이찾기</label>
													<input type="text" name="srchText" class="form-control form-control-alternative" 
														onKeypress="gfn_hitEnter(event, 'fn_selectPlayRcrd1List(1)');" placeholder="플레이이름">
												</div>
											</div>
											<div class="col-lg-6 mb-3">
											<c:if test="${clubNo ne ''}">
												<button type="button" class="btn btn-sm btn-primary float-right" onclick="fn_openInsertPlayModal();">새로운 플레이</button>
											</c:if>
											</div>
										</div>
									</form>
									<div class="table-responsive">
										<table class="table align-items-center table-flush" id="playRcrd1ListTbl">
											<thead class="thead-light">
												<tr>
													<th name="playRcrd1ListSortTh" id="sortTh_playNm">
														플레이이름 <span name="playRcrd1ListSort" id="playRcrd1ListSort_playNm" class="fa"></span>
													</th>
													<th name="playRcrd1ListSortTh" id="sortTh_gameNm">
														게임 <span name="playRcrd1ListSort" id="playRcrd1ListSort_gameNm" class="fa"></span>
													</th>
													<th scope="col">모임</th>
													<th scope="col">플레이시간</th>
												</tr>
											</thead>
											<tbody></tbody>
										</table>
									</div>
								</div>
								<div class="card-footer py-4">
									<nav aria-label="">
										<ul class="pagination pagination-sm justify-content-end mb-0" id="playRcrd1ListPageNav"></ul>
									</nav>
								</div>
							</div>
							<!-- 모임별 탭 컨텐츠 -->
							<div id="playRcrdTab2" class="tab-pane fade" role="tabpanel" aria-labelledby="playRcrdTab2A">
								<div class="card-header bg-white border-0">
									<div class="row">
										<div class="col-6 col-lg-6">
										</div>
									</div>
								</div>
								<div class="card-body">
									<form id="playRcrd2Form" onsubmit="return false;">
										<input type="hidden" id="playRcrd2ListCurOrderBy">
										<div class="row clearfix">
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">모임찾기</label>
													<input type="text" name="srchText" class="form-control form-control-alternative" 
														onKeypress="gfn_hitEnter(event, 'fn_selectPlayRcrd2List(1)');" placeholder="모임이름, 가장 많이 플레이된 게임">
												</div>
											</div>
											<div class="col-lg-6 mb-3">
												<c:if test="${clubNo ne ''}">
													<button type="button" class="btn btn-sm btn-primary float-right" onclick="fn_openInsertPlayModal();">새로운 플레이</button>
												</c:if>
											</div>
										</div>
									</form>
									<div class="table-responsive">
										<table class="table align-items-center table-flush" id="playRcrd2ListTbl">
											<thead class="thead-light">
												<tr>
													<th name="playRcrd2ListSortTh" id="sortTh_clubNm">
														모임 <span name="playRcrd2ListSort" id="playRcrd2ListSort_clubNm" class="fa"></span>
													</th>
													<th name="playRcrd2ListSortTh" id="sortTh_clubGrdNm">
														등급 <span name="playRcrd2ListSort" id="playRcrd2ListSort_clubGrdNm" class="fa"></span>
													</th>
													<th name="playRcrd2ListSortTh" id="sortTh_clubMmbrCnt">
														모임원수 <span name="playRcrd2ListSort" id="playRcrd2ListSort_clubMmbrCnt" class="fa"></span>
													</th>
													<th name="playRcrd2ListSortTh" id="sortTh_clubPlayCnt">
														플레이횟수 <span name="playRcrd2ListSort" id="playRcrd2ListSort_clubPlayCnt" class="fa"></span>
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
										<ul class="pagination pagination-sm justify-content-end mb-0" id="playRcrd2ListPageNav"></ul>
									</nav>
								</div>
							</div>
							<!-- 회원별 탭 컨텐츠 -->
							<div id="playRcrdTab3" class="tab-pane fade" role="tabpanel" aria-labelledby="playRcrdTab3A">
								<div class="card-header bg-white border-0">
									<div class="row">
										<div class="col-lg-12">
										</div>
									</div>
								</div>
								<div class="card-body">
									<form id="playRcrd3Form" onsubmit="return false;">
										<input type="hidden" id="playRcrd3ListCurOrderBy">
										<div class="row clearfix">
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">회원찾기</label>
													<input type="text" name="srchText" class="form-control form-control-alternative" 
														onKeypress="gfn_hitEnter(event, 'fn_selectPlayRcrd3List(1)');" placeholder="닉네임, 가장 많이 플레이된 게임">
												</div>
											</div>
											<div class="col-lg-6 mb-3">
												<c:if test="${clubNo ne ''}">
													<button type="button" class="btn btn-sm btn-primary float-right" onclick="fn_openInsertPlayModal();">새로운 플레이</button>
												</c:if>
											</div>
										</div>
									</form>
									<div class="table-responsive">
										<table class="table align-items-center table-flush" id="playRcrd3ListTbl">
											<thead class="thead-light">
												<tr>
													<th name="playRcrd3ListSortTh" id="sortTh_nickNm">
														회원 <span name="playRcrd3ListSort" id="playRcrd3ListSort_nickNm" class="fa"></span>
													</th>
													<th name="playRcrd3ListSortTh" id="sortTh_rsltPntAvg">
														평균승점 <span name="playRcrd3ListSort" id="playRcrd3ListSort_rsltPntAvg" class="fa"></span>
													</th>
													<th name="playRcrd3ListSortTh" id="sortTh_playCnt">
														플레이횟수 <span name="playRcrd3ListSort" id="playRcrd3ListSort_playCnt" class="fa"></span>
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
										<ul class="pagination pagination-sm justify-content-end mb-0" id="playRcrd3ListPageNav"></ul>
									</nav>
								</div>
							</div>
							<!-- 게임별 탭 컨텐츠 -->
							<div id="playRcrdTab4" class="tab-pane fade" role="tabpanel" aria-labelledby="playRcrdTab4A">
								<div class="card-header bg-white border-0">
									<div class="row">
										<div class="col-lg-12">
										</div>
									</div>
								</div>
								<div class="card-body">
									<form id="playRcrd4Form" onsubmit="return false;">
										<input type="hidden" id="playRcrd4ListCurOrderBy">
										<div class="row clearfix">
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">플레이찾기</label>
													<input type="text" name="srchText" class="form-control form-control-alternative" 
														onKeypress="gfn_hitEnter(event, 'fn_selectPlayRcrd4List(1)');" placeholder="게임이름(한글, 영어)">
												</div>
											</div>
											<div class="col-lg-6 mb-3">
												<c:if test="${clubNo ne ''}">
													<button type="button" class="btn btn-sm btn-primary float-right" onclick="fn_openInsertPlayModal();">새로운 플레이</button>
												</c:if>
											</div>
										</div>
									</form>
									<div class="table-responsive">
										<table class="table align-items-center table-flush" id="playRcrd4ListTbl">
											<thead class="thead-light">
												<tr>
													<th name="playRcrd4ListSortTh" id="sortTh_gameNm">
														게임 <span name="playRcrd4ListSort" id="playRcrd4ListSort_gameNm" class="fa"></span>
													</th>
													<th name="playRcrd4ListSortTh" id="sortTh_playCnt">
														플레이횟수 <span name="playRcrd4ListSort" id="playRcrd4ListSort_playCnt" class="fa"></span>
													</th>
													<th name="playRcrd4ListSortTh" id="sortTh_mostPlayClubNm">
														가장 많이 플레이한 모임 <span name="playRcrd4ListSort" id="playRcrd4ListSort_mostPlayClubNm" class="fa"></span>
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
										<ul class="pagination pagination-sm justify-content-end mb-0" id="playRcrd4ListPageNav"></ul>
									</nav>
								</div>
							</div>
						</div>
						
					</div>
					
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
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
									<label class="form-control-label">게임찾기</label>
									<input type="text" name="gameNm" class="form-control form-control-alternative"
										onKeypress="gfn_hitEnter(event, 'fn_selectGameNoList(1)');" >
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*플레이 할 게임</label>
									<select data-name="게임" name="gameNo" class="form-control form-control-alternative hasValue" >
									</select>
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*플레이이름</label>
									<input type="text" data-name="플레이이름" name="playNm" class="form-control form-control-alternative hasValue" >
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
					
					<div class="mb-4 display-none" id="gameSttng1Div">
						<h4>모든 첫번째 세팅을..</h4>
						<div name="sttngCntrlDiv" id="sttngCntrl1Div"></div>
					</div>
					
					<div class="mb-4 display-none" id="gameSttng2Div">
						<h4>모든 두번째 세팅을..</h4>
						<div name="sttngCntrlDiv" id="sttngCntrl2Div"></div>
					</div>
					
					<div class="mb-4 display-none" id="gameSttng3Div">
						<h3>모든 세번째 세팅을..</h3>
						<div name="sttngCntrlDiv" id="sttngCntrl3Div"></div>
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
	<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp"%>
	<!-- 모임프로필 -->
	<%@ include file="/WEB-INF/jsp/fo/clubPrflModal.jsp"%>
	<!-- 플레이기록 -->
	<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp"%>
	
	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
	
</body>
</html>