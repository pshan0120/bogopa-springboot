<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/fo/includeHeader.jspf"%>

<script>
	$(function() {
		$("#myClubFeePayForm select[name='payYn']").val("N");
		gfn_setOnChange("myClubFeePayForm", "fn_selectMyClubFeePayList(1)");
		
		fn_selectMyPage();
		fn_selectMyPlayRcrdList(1);
		fn_selectMyClubMmbrList(1);
		fn_selectMyClubBrdList(1);
		fn_selectMyClubPlayImgList(1);
		fn_selectMyClubAttndNotCnfrmList();
		fn_selectMyClubFeePayList(1);
		
		$("[data-toggle='tooltip']").tooltip();
		
		$("#copy_btn").click(function(){
			$("#copy_text_input").select();
			document.execCommand("copy");
			alert("복사완료");
		});
		
	});

	function fn_selectMyPage() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectMyPage' />");
		comAjax.setCallback("fn_selectMyPageCallback");
		comAjax.ajax();
	}

	function fn_selectMyPageCallback(data) {
		gfn_setDataVal(data.map, "myInfoForm");
		
		if(data.map.prflImgFileNm != "") {
			$("#prflImg").attr("src", "https://bogopayo.cafe24.com/img/mmbr/" + data.map.mmbrNo + "/" + data.map.prflImgFileNm);
			$("#updatePrflImg").attr("src", "https://bogopayo.cafe24.com/img/mmbr/" + data.map.mmbrNo + "/" + data.map.prflImgFileNm);
		} else {
			$("#prflImg").attr("src", "https://bogopayo.cafe24.com/img/mmbr/default.png");
			$("#updatePrflImg").attr("src", "https://bogopayo.cafe24.com/img/mmbr/default.png");
		}
		
		if(data.map.clubNo != "") {
			$("#myClubDiv").show();
		}
		
		$("#openMyClubBtn").hide();
		if(data.map.mstrMmbrYn == "Y") {
			$("#openMyClubBtn").show();
		}
		
		if(data.map.clubNo != "" && data.map.myClubFee2Yn == "N" && data.map.feeType2Amt != "") {
			$("#insertMyClubFee2Form input[name='feeAmt']").val(gfn_comma(data.map.feeType2Amt));
			$("#openInsertMyClubFee2Btn").show();
		}
	}

	function fn_selectMyPlayRcrdList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectMyPlayRcrdList' />");
		comAjax.setCallback("fn_selectMyPlayRcrdListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}

	function fn_selectMyPlayRcrdListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#playListTbl>tbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan=\"5\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "playListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMyPlayRcrdList",
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
				if(value.endDt != "") {
					str += value.endDt;
				} else {
					if(value.sttsCd == "1") {
						str += "<a class=\"btn btn-sm btn-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_openUpdatePlayRcrdModal('" + value.playNo + "')\" >";
						str += "	결과입력";
						str += "</a>";
					}
				}
				str += "	</td>";
				str += "	<td>";
				if(value.rsltRnk != "") {
					str += value.rsltRnk + "등";
					if(value.rsltPnt != "") {
						str += " / " + value.rsltPnt + "p";
					}
				} else {
					str += "-";
				}
				str += "	</td>";
				str += "	<td>";
				str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openPlayRcrdModal('" + value.playNo + "')\" >";
				str += "			" + value.gameNm;
				str += "		</a>";
				str += "	</td>";
				
				str += "	<td>";
				str += "		<div class=\"avatar-group\">";
				var playNickNms = value.playNickNms.split(",");
				var playMmbrNos = value.playMmbrNos.split(",");
				var playMmbrPrflImgFileNms = value.playMmbrPrflImgFileNms.split(",");
				for(var i in playNickNms) {
					str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm\" onclick=\"fn_openMmbrPrflModal('" + playMmbrNos[i] + "')\" data-toggle=\"tooltip\" data-original-title=\"" + playNickNms[i] + "\">";
					if(playMmbrPrflImgFileNms[i] == "default") {
						str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\" class=\"rounded-circle\">";
					} else {
						str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + playMmbrNos[i] + "/" + playMmbrPrflImgFileNms[i]  + "\" class=\"rounded-circle\">";
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

	function fn_selectMyClubMmbrList(pageNo) {
		var comAjax = new ComAjax("myInfoForm");
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
		if(cnt == 0) {
			$("#myClubMmbrDiv").hide();
		} else {
			var params = {
				divId : "myClubMmbrListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMyClubMmbrList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openMmbrPrflModal('" + value.mmbrNo + "')\">";
				if(value.prflImgFileNm != "") {
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
				str += "		" + gfn_comma(value.playCnt);
				str += "	</td>";
				str += "</tr>";
			});
			
			$("#myClubMmbrDiv").show();
		}
		body.append(str);
	}

	function fn_updateMmbr() {
		if(gfn_validate("myInfoForm")) {
			var comAjax = new ComAjax("myInfoForm");
			comAjax.setUrl("<c:url value='/updateMmbr' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		}
	}

	function fn_selectMyClubBrdList(pageNo) {
		var comAjax = new ComAjax("myInfoForm");
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
		if(cnt == 0) {
			str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "myClubBrdListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMyClubBrdList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		" + value.brdTypeNm;
				str += "	</td>";
				str += "	<td>";
				if(value.wrtrYn == "Y") {
					str += "	<a href=\"javascript:(void(0));\" onclick=\"fn_openUpdateClubBrdModal('" + value.seq + "')\">";
				} else {
					str += "	<a href=\"javascript:(void(0));\" onclick=\"fn_openClubBrdModal('" + value.seq + "')\">";
				}
				str += "			" + value.title;
				str += "		</a>";
				str += "	</td>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openMmbrPrflModal('" + value.mmbrNo + "')\">";
				if(value.prflImgFileNm != "") {
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
		var comAjax = new ComAjax("myInfoForm");
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
		if(cnt == 0) {
			$("#myClubPlayImgDiv").hide();
		} else {
			var params = {
				divId : "myClubPlayImgListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMyClubPlayImgList",
				recordCount : 3
			};
			gfn_renderPaging(params);

			str += "<div class=\"row clearfix\">";
			$.each(data.map.list, function(key, value) {
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

	function fn_selectMyClubAttndNotCnfrmList() {
		var comAjax = new ComAjax("myInfoForm");
		comAjax.setUrl("<c:url value='/selectMyClubAttndNotCnfrmList' />");
		comAjax.setCallback("fn_selectMyClubAttndNotCnfrmListCallback");
		comAjax.ajax();
	}

	function fn_selectMyClubAttndNotCnfrmListCallback(data) {
		var cnt = data.list.length;
		var body = $("#attndNotCnfrmListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			$("#myClubAttndDiv").hide();
		} else {
			$.each(data.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
				if(value.prflImgFileNm != "") {
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
				if(value.attndYn == "Y") {
					str += "	<a class=\"btn btn-sm btn-success mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_updateClubAttnd('N', " + value.seq + ")\" >";
					str += "		출석";
					str += "	</a>";
				} else {
					str += "	<a class=\"btn btn-sm btn-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_updateClubAttnd('Y', " + value.seq + ")\" >";
					str += "		미출석";
					str += "	</a>";
				}
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.attndDate;
				str += "	</td>";
				str += "</tr>";
			});
			
			$("#myClubAttndDiv").show();
		}
		body.append(str);
	}

	function fn_updateClubAttnd(attndYn, seq) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/updateClubAttnd' />");
		comAjax.setCallback("fn_selectMyClubAttndNotCnfrmList");
		comAjax.addParam("attndYn", attndYn);
		comAjax.addParam("seq", seq);
		comAjax.ajax();
	}
	
	function fn_selectMyClubFeePayList(pageNo) {
		var comAjax = new ComAjax("myClubFeePayForm");
		comAjax.setUrl("<c:url value='/selectMyClubFeePayList' />");
		comAjax.setCallback("fn_selectMyClubFeePayListCallback");
		comAjax.addParam("mmbrNo", $("#mmbrNo").val());
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}

	function fn_selectMyClubFeePayListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#feePayListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			$("#myClubFeeDiv").hide();
		} else {
			var params = {
				divId : "feePayListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMyClubFeePayList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
				if(value.prflImgFileNm != "") {
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
				if(value.payYn == "Y") {
					if(value.cnfrmYn == "Y") {
						str += "<a class=\"btn btn-sm btn-outline-dark\" href=\"javascript:(void(0));\">";
						str += "	납입완료";
						str += "</a>";
					} else {
						str += "<a class=\"btn btn-sm btn-outline-light\" href=\"javascript:(void(0));\">";
						str += "	납입확인중";
						str += "</a>";
					}
				} else {
					str += "	<a class=\"btn btn-sm btn-warning mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_updateClubFeePay(" + value.seq + ")\" >";
					str += "		미납";
					str += "	</a>";
				}
				str += "	</td>";
				str += "	<td>";
				str += "		" + gfn_comma(value.feeAmt);
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.feeTypeNm;
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.feeDate;
				str += "	</td>";
				str += "</tr>";
			});
			
			$("#myClubFeeDiv").show();
		}
		body.append(str);
	}
	
	function fn_updateClubFeePay(seq) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/updateClubFeePay' />");
		comAjax.setCallback("fn_selectMyClubFeePayList");
		comAjax.addParam("seq", seq);
		comAjax.ajax();
	}
	
	function fn_openMmbrPrflImgModal() {
		$("#updatePrflImgModal").modal("show");
	}
	
	function fn_updateMmbrPrflImg() {
		var url = "<c:url value='/updateMmbrPrflImg'/>";
		var mmbrNo = $("#mmbrNo").val();
		$('#updatePrflImgForm').ajaxForm({
			url: url,
			type : 'POST',
			dataType : 'JSON',
			data : {
				mmbrNo : mmbrNo
			},
			success: function(data){
				gfn_defaultCallback(data);
			}
		});
		// submit 필수
		$("#updatePrflImgForm").submit();
	}

	function fn_openInsertMyClubFee2() {
		$("#insertMyClubFee2Modal").modal("show");
	}
	
	function fn_insertMyClubFee2() {
		if(confirm("소속된 모임의 기간회비 납입을 확인 요청하시겠습니까?")) {
			var comAjax = new ComAjax("insertMyClubFee2Form");
			comAjax.setUrl("<c:url value='/insertMyClubFee2' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("clubNo", $("#clubNo").val());
			comAjax.addParam("mmbrNo", $("#mmbrNo").val());
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_openMyClub() {
		document.location.href = "/myClub";
	}
	
	function fn_openUpdatePlayRcrdModal(playNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectPlayRcrd' />");
		comAjax.setCallback("fn_openUpdatePlayRcrdModalCallback");
		comAjax.addParam("playNo", playNo);
		comAjax.ajax();
	}

	function fn_openUpdatePlayRcrdModalCallback(data) {
		gfn_setDataVal(data.map, "updatePlayRcrdForm");
		$("#updatePlayRcrdModalLabel").text(data.map.playNm);
		
		var body = $("#updatePlayRcrdListTbl>tbody");
		body.empty();
		var str = "";
		
		if(data.list.length == 0) {
			str += "<tr><td colspan=\"3\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var isFrstFdbckImg = false;
			var mmbrNo = "<c:out value="${mmbrNo}" />";
			$.each(data.list, function(key, value) {
				str += "<tr name=\"playRcrdTr\" id=\"playRcrdTr" + value.mmbrNo + "\" >";
				str += "	<td>";
				str += "		<input type=\"hidden\" name=\"seq\" value=\"" + value.seq + "\" />";
				str += "		<input type=\"hidden\" name=\"playPnt\" value=\"" + value.playPnt + "\" />";
				str += "		<input type=\"hidden\" name=\"rsltRnk\" />";
				str += "		"+ value.nickNm;
				str += "	</td>";
				str += "	<td>";
				for(var i=1;i<=data.map.playMmbrCnt;i++) {
					str += "	<a class=\"badge badge-pill badge-secondary\" href=\"javascript:(void(0));\" name=\"rsltRnk" + i + "\" onclick=\"fn_setUpdatePlayRcrdRsltRnk(" + i + ", '" + value.mmbrNo + "');\" >";
					str += "		" + i;
					str += "	</a>";
				}
				str += "	</td>";
				str += "	<td>";
				str += "		<input type=\"number\" class=\"form-control form-control-alternative\" name=\"rsltScr\" value=\"0\" />";
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);

		fn_setUpdatePlayRcrdRsltRnk();
		
		$("#updatePlayRcrdModal").modal({
			//escapeClose: false,
			//clickClose: false,
			//showClose: false,
			//closeExisting: false
		});
	}
	
	function fn_setUpdatePlayRcrdRsltRnk(rnk, mmbrNo) {
		var rsltRnkAll = $("#playRcrdTr" + mmbrNo + " a");
		rsltRnkAll.removeClass("badge-secondary");
		rsltRnkAll.removeClass("badge-default");
		rsltRnkAll.addClass("badge-secondary");

		$("#playRcrdTr" + mmbrNo + " input[name='rsltRnk']").val(rnk);
		$("#playRcrdTr" + mmbrNo + " a[name='rsltRnk" + rnk + "']").removeClass("badge-secondary");
		$("#playRcrdTr" + mmbrNo + " a[name='rsltRnk" + rnk + "']").addClass("badge-default");
	}

	function fn_updatePlayRcrd() {
		var isRun = true;
		var seqArr = new Array();
		$("#updatePlayRcrdListTbl > tbody > tr input[name='seq']").each(function() {
			seqArr.push(this.value);
		});
		
		var playPntArr = new Array();
		$("#updatePlayRcrdListTbl > tbody > tr input[name='playPnt']").each(function() {
			playPntArr.push(this.value);
		});
		
		var rsltRnkArr = new Array();
		$("#updatePlayRcrdListTbl > tbody > tr input[name='rsltRnk']").each(function() {
			if(isRun && this.value == "") {
				alert("순위가 선택되지 않은 플레이어가 있습니다.");
				isRun = false;
			} else {
				rsltRnkArr.push(this.value);
			}
		});
		
		var rsltScrArr = new Array();
		$("#updatePlayRcrdListTbl > tbody > tr input[name='rsltScr']").each(function() {
			if(isRun && this.value == "") {
				alert("점수가 입력되지 않은 플레이어가 있습니다.");
				isRun = false;
			} else {
				rsltScrArr.push(this.value);
			}
		});
		
		if(isRun && confirm("입력된 내용으로 결과 등록하시겠습니까?")) {
			var comAjax = new ComAjax("updatePlayRcrdForm");
			comAjax.setUrl("<c:url value='/updatePlayRcrd' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("seqArr", seqArr);
			comAjax.addParam("playPntArr", playPntArr);
			comAjax.addParam("rsltRnkArr", rsltRnkArr);
			comAjax.addParam("rsltScrArr", rsltScrArr);
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_openQckSrvcGuide() {
		var url = window.location.protocol + "//" + window.location.host + "/";
		var mmbrScrtKey = $("#mmbrScrtKey").val();
		var str = "";
		str += "* 내 활동 바로가기\n";
		str += url + "myPage/" + mmbrScrtKey + "\n\n";
		str += "* 플레이 바로가기\n";
		str += url + "play/" + mmbrScrtKey + "\n\n";
		str += "* 모임 바로가기\n";
		str += url + "club/" + mmbrScrtKey + "\n\n";
		if($("#clubNo").val() != "") {
			str += "* 모임 초대하기(회원가입 후 동일모임 즉시 가입신청)\n";
			str += url + "join/" + mmbrScrtKey + "";
		}
		$("#qckUrlText").val(str);
		$("#qckSrvcGuideModal").modal({
			//escapeClose: false,
			//clickClose: false,
			//showClose: false,
			//closeExisting: false
		});
	}

	function fn_copyQckUrlText() {
		$("#qckUrlText").select();
		document.execCommand("copy");
		alert("복사되었습니다.");
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
							<h1 class="text-white">나의 패턴은 강강약 강중약</h1>
							<p class="text-lead text-light">이젠 정말 보드게임뿐이야..</p>
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
				<div class="col-xl-4 order-xl-2 mb-5 mb-xl-0">
					<div class="card card-profile shadow">
						<div class="card-header">
							<div class="row clearfix">
								<div class="col-lg-12">
									<button type="button" class="btn btn-sm btn-info" onclick="fn_openQckSrvcGuide();">퀵서비스 안내</button>
									<button type="button" class="btn btn-sm btn-primary float-right" onclick="fn_updateMmbr();">정보수정</button>
									<!-- 
									<button type="button" class="btn btn-sm btn-info float-right" onclick="fn_openMmbrMsg();">쪽지함</button>
									 -->
								</div>
							</div>
						</div>
						<div class="card-body pt-4 pt-md-4">
							<form id="myInfoForm">
								<input type="hidden" name="mmbrNo" id="mmbrNo">
								<input type="hidden" name="mmbrScrtKey" id="mmbrScrtKey">
								<input type="hidden" name="clubNo" id="clubNo">
								<div class="row clearfix">
									<div class="col-lg-12">
										<div class="form-group">
											<a href="javascrit:void(0);" onclick="fn_openMmbrPrflImgModal();">
												<img src="" id="prflImg" class="img-responsive img-thumbnail m-auto" >
											</a>
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label class="form-control-label" for="mmbrClubNm">모임</label>
											<input type="text" data-name="모임" name="mmbrClubNm" 
												class="form-control form-control-alternative" readonly>
										</div>
									</div>
									
									<div class="col-lg-6">
										<div class="form-group">
											<label class="form-control-label" for="mmbrTypeNm">등급</label>
											<input type="text" data-name="등급" name="mmbrTypeNm"
												class="form-control form-control-alternative" readonly>
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label class="form-control-label" for="playCnt">플레이횟수</label>
											<input type="text" data-name="이메일" name="playCnt" 
												class="form-control form-control-alternative" readonly>
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label class="form-control-label" for="email">이메일</label>
											<input type="email" data-name="이메일" name="email" id="email"
												class="form-control form-control-alternative" disalbed>
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label class="form-control-label" for="username">닉네임</label>
											<input type="text" data-name="닉네임" name="nickNm" id="nickNm"
												class="form-control form-control-alternative hasValue" >
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label class="form-control-label" for="intrdctn">내 소개</label>
											<textarea rows="4" data-name="내 소개" name="intrdctn" id="intrdctn"
												class="form-control form-control-alternative hasValue" placeholder="다른 회원들을 위해 간단한 자기 소개를 적어주세요."></textarea>
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
											<th scope="col">플레이이름</th>
											<th scope="col">종료일시</th>
											<th scope="col">결과</th>
											<th scope="col">게임</th>
											<th scope="col">플레이어</th>
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
					
					<div class="card shadow display-none mt-5" id="myClubMmbrDiv">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-6">
									<h3 class="mb-0">모임원</h3>
								</div>
								<div class="col-6">
									<button type="button" class="btn btn-sm btn-primary float-right display-none" id="openMyClubBtn" onclick="fn_openMyClub();">내 모임관리</button>
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
											<th scope="col">플레이횟수</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
						<div class="card-footer py-4">
							<nav aria-label="">
								<ul class="pagination pagination-sm justify-content-end mb-0" id="myClubMmbrListPageNav"></ul>
							</nav>
						</div>
					</div>
					
					<div class="card shadow mt-5 display-none" id="myClubDiv">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-6">
									<h3 class="mb-0">모임 게시판</h3>
								</div>
								<div class="col-6">
									<button type="button" class="btn btn-sm btn-info float-right" onclick="fn_openInsertClubBrdModal();">
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
								<ul class="pagination pagination-sm justify-content-end mb-0" id="myClubBrdListPageNav"></ul>
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
								<ul class="pagination pagination-sm justify-content-end mb-0" id="myClubPlayImgListPageNav"></ul>
							</nav>
						</div>
					</div>
					
					<div class="card shadow display-none mt-5" id="myClubAttndDiv">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-6">
									<h3 class="mb-0">모임출석</h3>
								</div>
								<div class="col-6">
								</div>
							</div>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table align-items-center table-flush" id="attndNotCnfrmListTbl">
									<thead class="thead-light">
										<tr>
											<th scope="col">모임</th>
											<th scope="col">출석여부</th>
											<th scope="col">모임일</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
						<div class="card-footer py-4">
							<nav aria-label="">
								<ul class="pagination pagination-sm justify-content-end mb-0" id="attndNotCnfrmListPageNav"></ul>
							</nav>
						</div>
					</div>
					
					<div class="card shadow display-none mt-5" id="myClubFeeDiv">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-6">
									<h3 class="mb-0">모임회비</h3>
								</div>
								<div class="col-6">
									<button type="button" class="btn btn-sm btn-info float-right display-none" id="openInsertMyClubFee2Btn" onclick="fn_openInsertMyClubFee2();">기간회비 납입</button>
								</div>
							</div>
						</div>
						<div class="card-body">
							<form id="myClubFeePayForm">
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
								<table class="table align-items-center table-flush" id="feePayListTbl">
									<thead class="thead-light">
										<tr>
											<th scope="col">모임</th>
											<th scope="col">납부확인</th>
											<th scope="col">회비</th>
											<th scope="col">회비유형</th>
											<th scope="col">회비기간</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
						<div class="card-footer py-4">
							<nav aria-label="">
								<ul class="pagination pagination-sm justify-content-end mb-0" id="feePayListPageNav"></ul>
							</nav>
						</div>
					</div>
					
					
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
	</div>
	
	<!-- 프로필이미지 Modal -->
	<div class="modal fade" id="updatePrflImgModal" role="dialog" aria-labelledby="updatePrflImgModalLabel" aria-hidden="true">
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
						<hr class="my-4" />
						<div class="row">
							<div class="col-lg-12">
								<input type="file" name="file">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_updateMmbrPrflImg()">변경</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 기간회비 납입 Modal -->
	<div class="modal fade" id="insertMyClubFee2Modal" role="dialog" aria-labelledby="insertMyClubFee2ModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="">기간회비 납입</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p class="small">
						* 회비 입금 후 모임장으로부터 확인받기 위한 기능입니다.<br>
						* 기간 회비는 모임에서 설정한 금액입니다.<br>
						* 기간 설정에 대해서는 모임 공지를 참고하거나 모임장에게 문의하세요.
					</p>
					<form id="insertMyClubFee2Form">
						<div class="row clearfix">
							<div class="col-lg-6">
								<div class="form-group">
									<label class="form-control-label">*기간 회비</label>
									<input type="text" name="feeAmt" class="form-control form-control-alternative hasValue">
								</div>
							</div>
						</div>
						<div class="row clearfix">
							<div class="col-lg-6">
								<div class="form-group">
									<label class="form-control-label">*시작일</label>
									<input type="date" name="feeFromDate" class="form-control form-control-alternative hasValue">
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group">
									<label class="form-control-label">*종료일</label>
									<input type="date" name="feeToDate" class="form-control form-control-alternative hasValue">
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_insertMyClubFee2()">납입확인 요청</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 플레이 결과입력 Modal -->
	<div class="modal fade" id="updatePlayRcrdModal" role="dialog" aria-labelledby="updatePlayRcrdModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="updatePlayRcrdModalLabel"></h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="updatePlayRcrdForm">
						<input type="hidden" name="playNo">
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
									<label class="form-control-label">호스트</label>
									<input type="text" name="hostMmbrNm" class="form-control form-control-alternative" readonly>
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">게임</label>
									<input type="text" name="gameNm" class="form-control form-control-alternative" readonly>
								</div>
							</div>
							<div class="col-lg-3">
								<div class="form-group">
									<label class="form-control-label">플레이인원</label>
									<input type="text" name="playMmbrCnt" class="form-control form-control-alternative" readonly>
								</div>
							</div>
							<div class="col-lg-9">
								<div class="form-group">
									<label class="form-control-label">시작일시</label>
									<input type="text" name="strtDt" class="form-control form-control-alternative" readonly>
								</div>
							</div>
						</div>
					</form>
					<div class="table-responsive">
						<table class="table align-items-center table-flush" id="updatePlayRcrdListTbl">
							<thead class="thead-light">
								<tr>
									<th scope="col">플레이어</th>
									<th scope="col">*순위</th>
									<th scope="col">점수</th>
								</tr>
							</thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_updatePlayRcrd();">입력</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 퀵서비스 안내 Modal -->
	<div class="modal fade" id="qckSrvcGuideModal" role="dialog" aria-labelledby="qckSrvcGuideModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">퀵서비스 안내</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p></p>
					<div class="pl-lg-4">
						<div class="form-group focused">
							<div class="h4">
								아래 텍스트를 복사해서 카카오톡 메신저의 내 자신과의 대화에 붙여넣고 공지로 지정하면 편하게 이용하실 수 있습니다.
							</div>
							<p class="text-warning">
								타인에게 노출되지 않도록 각별히 주의해 주세요.
							</p>
							<textarea rows="18" id="qckUrlText" class="form-control form-control-alternative" readonly></textarea>
						</div>
					</div>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" onclick="fn_copyQckUrlText();">클립보드에 복사</button>
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
	<!-- 모임게시물 -->
	<%@ include file="/WEB-INF/jsp/fo/clubBrdModal.jsp"%>
	<!-- 플레이기록 -->
	<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp"%>
	
	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
	
</body>
</html>
