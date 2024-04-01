<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 신청목록
* 설명 : 신청 CRUD
* 작성자 : 백승한
* 작성일 : 2019.12.11
* Copyright BoardgameGG. All Right Reserved
***************************************************************************************************
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/bo/includeHeader.jspf"%>

<script>
	$(function() {
		$('.emptyModal').on('hide.bs.modal', function (e) {
			$("div.modal-footer > button").addClass("display-none");
			$("#updateReqBtn").removeClass("display-none");
		});
		
		gfn_setSortTh("reqList", "fn_selectReqList(1)");
		gfn_setOnChange("form", "fn_selectReqList(1)");
		fn_selectReqList(1);
	});

	function fn_selectReqList(pageNo) {
		var comAjax = new ComAjax("form");
		comAjax.setUrl("<c:url value='/bo/selectReqList' />");
		comAjax.setCallback("fn_selectReqListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 15);
		comAjax.addParam("orderBy", $("#reqListCurOrderBy").val());
		comAjax.ajax();
	}
	
	function fn_selectReqListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#reqListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='9'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectReqList",
				recordCount : 15
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateReqModal(\"" + value.reqNo + "\")'>" + value.reqNo + "</a>";
				str += "	</td>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateMmbrModal(\"" + value.mmbrNo + "\")'>" + value.mmbrNm + "</a>";
				str += "	</td>";
				str += "	<td>" + value.cmmrcNm + "</td>";
				str += "	<td>" + value.sttsNm + "</td>";
				str += "	<td>" + value.clcltDate + "</td>";
				str += "	<td>" + gfn_comma(value.clcltAmt) + "</td>";
				str += "	<td>" + value.prepayDate + "</td>";
				str += "	<td>" + gfn_comma(value.prepayAmt) + "</td>";
				str += "	<td>" + value.insDt + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_openUpdateReqModal(reqNo) {
		fn_selectReqDetail(reqNo);
	}
	
	function fn_selectReqDetail(reqNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/bo/selectReq' />");
		comAjax.addParam("reqNo", reqNo);
		comAjax.setCallback("fn_selectReqDetailCallback");
		comAjax.ajax();
	}
	
	function fn_selectReqDetailCallback(data) {
		gfn_setDataVal(data.map, "updateForm");
		var sttsCd = $("#updateForm input[name='sttsCd']").val();
		if(sttsCd == "01") {
			$("#scrapCmmrcBtn").removeClass("display-none");
			$("#evltnAccptBtn").removeClass("display-none");
		} else if(sttsCd == "02") {
			$("#scrapCmmrcBtn").removeClass("display-none");
			$("#evltnBtn").removeClass("display-none");
		} else if(sttsCd == "03") {
			$("#srvcCntrctSendBtn").removeClass("display-none");
		} else if(sttsCd == "05") {
			$("#srvcCntrctBtn").removeClass("display-none");
			$("#srvcCntrctFailBtn").removeClass("display-none");
		} else if(sttsCd == "06") {
			$("#trnsfrCntrctReqBtn").removeClass("display-none");
		} else if(sttsCd == "08") {
			$("#trnsfrCntrctBtn").removeClass("display-none");
			$("#trnsfrCntrctFailBtn").removeClass("display-none");
		} else if(sttsCd == "09") {
			$("#prepayBtn").removeClass("display-none");
		}
		
		$("#updateReqModal").modal("show");
	}

	function fn_updateReq() {
		var validate = gfn_validateForm("updateForm");
		if(validate && confirm("신청정보를 수정하시겠습니까?")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_deleteReq() {
		if(confirm("신청정보를 삭제하시겠습니까? 삭제하면 다시 복구되지 않습니다.")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/deleteReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_scrapCmmrc() {
		var comAjax = new ComAjax("updateForm");
		comAjax.setUrl("<c:url value='/bo/scrapCmmrc' />");
		comAjax.setCallback("fn_scrapCmmrcCallback");
		comAjax.ajax();
	}

	function fn_scrapCmmrcCallback(data) {
		gfn_setDataVal(data.map, "updateForm");
	}

	function fn_evltnAccpt() {
		if(confirm("해당 신청을 심사접수하시겠습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "evltnAccpt");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_openEvltnModal() {
		var clcltDate = $("#updateForm input[name='clcltDate']").val();
		if(clcltDate == "") {
			alert("정산일 정보가 입력되지 않아 심사 처리가 불가능합니다.");
			$("#evltnModal").modal("hide");
			$("#updateForm input[name='clcltDate']").focus();
			return;
		}
		
		var clcltAmt = $("#updateForm input[name='clcltAmt']").val();
		if(clcltAmt == "") {
			alert("정산액 정보가 입력되지 않아 심사 처리가 불가능합니다.");
			$("#evltnModal").modal("hide");
			$("#updateForm input[name='clcltAmt']").focus();
			return;
		} else {
			clcltAmt = parseInt(clcltAmt.replace(/,/g, ""));
		}

		var cmmrcRestLimitAmt = parseInt($("#updateForm input[name='cmmrcRestLimitAmt']").val().replace(/,/g, ""));
		if(cmmrcRestLimitAmt == 0) {
			alert("커머스 한도가 부족하여 심사 처리가 불가능합니다.");
			$("#evltnModal").modal("hide");
			$("#updateForm input[name='cmmrcRestLimitAmt']").focus();
			return;
		}
		
		var extra1Amt = $("#updateForm input[name='extra1Amt']").val();
		if(extra1Amt == "") {
			extra1Amt = 0;
		} else {
			extra1Amt = parseInt(extra1Amt.replace(/,/g, ""));
		}
		var extra2Amt = $("#updateForm input[name='extra2Amt']").val();
		if(extra2Amt == "") {
			extra2Amt = 0;
		} else {
			extra2Amt = parseInt(extra2Amt.replace(/,/g, ""));
		}
		
		var extra3Amt = $("#updateForm input[name='extra3Amt']").val();
		if(extra3Amt == "") {
			extra3Amt = 0;
		} else {
			extra3Amt = parseInt(extra3Amt.replace(/,/g, ""));
		}
		var evltnAmt = parseInt((clcltAmt - extra1Amt - extra2Amt - extra3Amt) * 0.8);
		if(cmmrcRestLimitAmt < evltnAmt) {
			evltnAmt = cmmrcRestLimitAmt;
		}
		$("#evltnForm input[name='evltnAmt']").val(evltnAmt);
		
		$("#evltnForm input[name='reqNo']").val($("#updateForm input[name='reqNo']").val());
		$("#evltnModal").modal("show");
	}

	function fn_evltnApprvl() {
		var clcltDate = $("#updateForm input[name='clcltDate']").val();
		if(clcltDate == "") {
			alert("정산일 정보가 입력되지 않아 심사 처리가 불가능합니다.");
			$("#evltnModal").modal("hide");
			$("#updateForm input[name='clcltDate']").focus();
			return;
		}
		
		var clcltAmt = $("#updateForm input[name='clcltAmt']").val();
		if(clcltAmt == "") {
			alert("정산액 정보가 입력되지 않아 심사 처리가 불가능합니다.");
			$("#evltnModal").modal("hide");
			$("#updateForm input[name='clcltAmt']").focus();
			return;
		} else {
			clcltAmt = parseInt(clcltAmt.replace(/,/g, ""));
		}

		var cmmrcRestLimitAmt = parseInt($("#updateForm input[name='cmmrcRestLimitAmt']").val().replace(/,/g, ""));
		if(cmmrcRestLimitAmt == 0) {
			alert("커머스 한도가 부족하여 심사 처리가 불가능합니다.");
			$("#evltnModal").modal("hide");
			$("#updateForm input[name='cmmrcRestLimitAmt']").focus();
			return;
		}
		
		var extra1Amt = $("#updateForm input[name='extra1Amt']").val();
		if(extra1Amt == "") {
			extra1Amt = 0;
		} else {
			extra1Amt = parseInt(extra1Amt.replace(/,/g, ""));
		}
		
		var extra2Amt = $("#updateForm input[name='extra2Amt']").val();
		if(extra2Amt == "") {
			extra2Amt = 0;
		} else {
			extra2Amt = parseInt(extra2Amt.replace(/,/g, ""));
		}
		
		var extra3Amt = $("#updateForm input[name='extra3Amt']").val();
		if(extra3Amt == "") {
			extra3Amt = 0;
		} else {
			extra3Amt = parseInt(extra3Amt.replace(/,/g, ""));
		}
		
		var evltnAmt = parseInt($("#evltnForm input[name='evltnAmt']").val().replace(/,/g, ""));
		if(evltnAmt == "" || !gfn_isNumeric(evltnAmt, "5")) {
			alert("심사한도를 정확히 입력해 주세요.");
			$("#evltnForm input[name='evltnAmt']").focus();
			return;
		}
		
		if(clcltAmt - extra1Amt - extra2Amt - extra3Amt < evltnAmt) {
			alert("심사한도는 예상 회수가능금액(정산액 - 비용)보다 클 수 없습니다.");
			$("#evltnForm input[name='evltnAmt']").focus();
			return;
		}

		if(cmmrcRestLimitAmt < evltnAmt) {
			alert("심사한도는 커머스 한도보다 클 수 없습니다.");
			$("#evltnForm input[name='evltnAmt']").focus();
			return;
		}

		var validate = gfn_validateForm("evltnForm");
		if(validate && confirm("해당 신청건을 심사 승인하시겠습니까?")) {
			var comAjax = new ComAjax("evltnForm");
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("mode", "evltnApprvl");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_evltnRjct() {
		if(confirm("해당 신청건을 심사 거부하시겠습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#evltnForm input[name='reqNo']").val());
			comAjax.addParam("mode", "evltnRjct");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_srvcCntrctSend() {
		if(confirm("서비스계약서를 송부하셨습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "srvcCntrctSend");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_srvcCntrct() {
		if(confirm("서비스계약이 완료되었습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "srvcCntrct");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_srvcCntrctFail() {
		if(confirm("서비스계약을 실패 처리하시겠습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "srvcCntrctFail");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_trnsfrCntrctReq() {
		if(confirm("채권양도계약을 신청하셨습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "trnsfrCntrctReq");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_trnsfrCntrct() {
		if(confirm("채권양도계약이 완료되었습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "trnsfrCntrct");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_trnsfrCntrctFail() {
		if(confirm("채권양도계약을 실패 처리하시겠습니까?")) {
			var comAjax = new ComAjax();
			comAjax.setUrl("<c:url value='/bo/updateReq' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("reqNo", $("#updateForm input[name='reqNo']").val());
			comAjax.addParam("mode", "trnsfrCntrctFail");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_openPrepayModal() {
		var evltnAmt = $("#updateForm input[name='evltnAmt']").val();
		if(evltnAmt == "") {
			alert("심사한도가 입력되지 않아 지급완료 처리가 불가능합니다.");
			$("#updateForm input[name='evltnAmt']").focus();
			return;
		}
		$("#prepayForm input[name='prepayAmt']").val(parseInt(evltnAmt.replace(/,/g, "")));
		$("#prepayForm input[name='reqNo']").val($("#updateForm input[name='reqNo']").val());
		$("#prepayModal").modal("show");
	}

	function fn_prepay() {
		var evltnAmt = $("#updateForm input[name='evltnAmt']").val();
		if(evltnAmt == "" || !gfn_isNumeric(evltnAmt, "5")) {
			alert("심사한도를 정확히 입력해 주세요.");
			$("#prepayModal").modal("hide");
			$("#updateForm input[name='evltnAmt']").focus();
			return;
		} else {
			evltnAmt = parseInt(evltnAmt.replace(/,/g, ""));
		}
		var prepayAmt = $("#prepayForm input[name='prepayAmt']").val();
		if(prepayAmt == "" || !gfn_isNumeric(prepayAmt, "5")) {
			alert("선정산 지급금액을 정확히 입력해 주세요.");
			$("#prepayForm input[name='prepayAmt']").focus();
			return;
		} else {
			prepayAmt = parseInt(prepayAmt.replace(/,/g, ""));
		}
		
		if(evltnAmt < prepayAmt) {
			alert("지급금액은 심사한도보다 클 수 없습니다.");
			$("#prepayForm input[name='prepayAmt']").val(evltnAmt);
			$("#prepayForm input[name='prepayAmt']").focus();
			return;
		}
		
		if(confirm("선정산금액을 회원에게 지급하셨습니까? 처리 후 상환일정이 생성됩니다.")) {
			var comAjax = new ComAjax("prepayForm");
			comAjax.setUrl("<c:url value='/bo/prepay' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.addParam("mode", "prepay");
			comAjax.ajax();
		} else {
			return;
		}
	}
</script>
</head>

<body class="nav-md">
	<%@ include file="/WEB-INF/include/bo/includeBody.jspf"%>
	<div class="container body">
		<div class="main_container">
			<div class="col-md-3 left_col">
				<%@ include file="/WEB-INF/jsp/bo/sideNav.jsp"%>
			</div>
			<%@ include file="/WEB-INF/jsp/bo/topNav.jsp"%>

			<!-- page content -->
			<div class="right_col" role="main">
				<div class="row">
					<div class="col-md-12 col-sm-12 col-xs-12">
						<div class="x_panel">
							<div class="x_title">
								<h2>신청목록</h2>
								<ul class="nav navbar-right panel_toolbox">
									<li>
										<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
									</li>
									<li class="dropdown">
										<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
											<i class="fa fa-wrench"></i>
										</a>
										<ul class="dropdown-menu" role="menu">
											<li><a href="#">설정 1</a></li>
											<li><a href="#">설정 2</a></li>
										</ul>
									</li>
									<li>
										<a class="close-link"><i class="fa fa-close"></i></a>
									</li>
								</ul>
								<div class="clearfix"></div>
							</div>
							<div class="x_content">
								<div class="btnDiv">
									<button type="button" class="btn btn-info" onclick="fn_selectReqList(1)">조회</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="form">
										<div class="form-group">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">회원 번호</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="mmbrNo"
													onKeypress="gfn_hitEnter(event, 'fn_selectReqList(1)');" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">회원명</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="mmbrNm"
													onKeypress="gfn_hitEnter(event, 'fn_selectReqList(1)');" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">신청상태</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<select class="form-control onChange" name="sttsCd">
													<option value="">전체</option>
													<c:choose>
														<c:when test="${fn:length(sttsCdList) > 0}">
															<c:forEach var="row" items="${sttsCdList}" varStatus="status">
																<option value="${row.cd}">${row.nm}</option>
															</c:forEach>
														</c:when>
													</c:choose>
												</select>
											</div>
											<div class="clearfix"></div>
										</div>
										<input type="hidden" id="reqListCurOrderBy">
									</form>
								</div>
								<div class="ln_solid"></div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th name="reqListSortTh" id="sortTh_reqNo">
												신청번호 <span name="reqListSort" id="reqListSort_reqNo" class="glyphicon"></span>
											</th>
											<th>신청회원</th>
											<th>커머스</th>
											<th>신청상태</th>
											<th>정산일</th>
											<th>정산액</th>
											<th>선지급일</th>
											<th>선지급액</th>
											<th>등록일시</th>
										</tr>
									</thead>
									<tbody id="reqListTbody"></tbody>
								</table>
								<div class="text-center"><ul class="pagination pagination-sm" id="pageNav"></ul></div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /page content -->
			
			<!-- footer content -->
			<%@ include file="/WEB-INF/jsp/bo/footer.jsp"%>
			<!-- /footer content -->
		</div>
	</div>
	
	<!-- 신청수정 Modal -->
	<div class="modal fade emptyModal" id="updateReqModal" role="dialog" aria-labelledby="updateReqModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">신청상세</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="updateForm">
						<input type="hidden" name="mmbrNo">
						<input type="hidden" name="cmmrcNo">
						<input type="hidden" name="sttsCd">
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">신청번호*</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="reqNo" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">신청회원*</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="mmbrNm" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">신청상태*</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="sttsNm" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">커머스*</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="cmmrcNm" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">정산액</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="clcltAmt">
							</div>
							<label class="control-label col-md-1 col-sm-3 col-xs-12">정산일</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="clcltDate">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">비용1</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="extra1Amt">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">비용2</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="extra2Amt">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">비용3</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="extra3Amt">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">환불률</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control floatOnly" name="rfndRate">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">커머스 일 수수료율</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control floatOnly" name="dailyCmmtnRate" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">커머스 잔여한도</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="cmmrcRestLimitAmt" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">심사자</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control" name="evltnUserId" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">심사일</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="evltnDate" readonly>
							</div>
							<label class="control-label col-md-1 col-sm-3 col-xs-12">심사한도</label>
							<div class="col-md-2 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="evltnAmt" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">서비스계약송부일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="srvcCntrctSendDate" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">서비스계약일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="srvcCntrctDate" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">양도계약신청일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="trnsfrCntrctReqDate" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">양도계약일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="trnsfrCntrctDate" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">선지급액</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="prepayAmt" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">선지급일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="prepayDate" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">비고</label>
							<div class="col-md-10 col-sm-9 col-xs-12">
								<textarea rows="10" class="form-control" cols="20" name="rmrk"></textarea>
							</div>
							<div class="clearfix"></div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="scrapCmmrcBtn" class="btn btn-info display-none" onclick="fn_scrapCmmrc()">커머스 스크래핑</button>
					<button type="button" id="evltnAccptBtn" class="btn btn-primary display-none" onclick="fn_evltnAccpt()">심사접수</button>
					<button type="button" id="evltnBtn" class="btn btn-primary display-none" onclick="fn_openEvltnModal()">심사처리</button>
					<button type="button" id="srvcCntrctSendBtn" class="btn btn-primary display-none" onclick="fn_srvcCntrctSend()">서비스계약서송부</button>
					<button type="button" id="srvcCntrctBtn" class="btn btn-primary display-none" onclick="fn_srvcCntrct()">서비스계약완료</button>
					<button type="button" id="srvcCntrctFailBtn" class="btn btn-warning display-none" onclick="fn_srvcCntrctFail()">서비스계약실패</button>
					<button type="button" id="trnsfrCntrctReqBtn" class="btn btn-primary display-none" onclick="fn_trnsfrCntrctReq()">채권양도계약신청</button>
					<button type="button" id="trnsfrCntrctBtn" class="btn btn-primary display-none" onclick="fn_trnsfrCntrct()">채권양도계약완료</button>
					<button type="button" id="trnsfrCntrctFailBtn" class="btn btn-warning display-none" onclick="fn_trnsfrCntrctFail()">채권양도계약실패</button>
					<button type="button" id="prepayBtn" class="btn btn-primary display-none" onclick="fn_openPrepayModal()">선정산지급처리</button>
					<button type="button" id="updateReqBtn" class="btn btn-warning" onclick="fn_updateReq()">수정</button>
					<button type="button" id="deleteReqBtn" class="btn btn-danger display-none" onclick="fn_deleteReq()">삭제</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 심사 Modal -->
	<div class="modal fade" id="evltnModal" role="dialog" aria-labelledby="evltnModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">심사처리</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="evltnForm">
						<input type="hidden" name="reqNo">
						<div class="form-group">
							<label class="control-label col-md-4 col-sm-3 col-xs-12">심사한도*</label>
							<div class="col-md-8 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly hasValue" name="evltnAmt">
							</div>
							<div class="clearfix"></div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" onclick="fn_evltnApprvl()">심사승인</button>
					<button type="button" class="btn btn-warning" onclick="fn_evltnRjct()">심사거부</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 선정산지급 Modal -->
	<div class="modal fade" id="prepayModal" role="dialog" aria-labelledby="prepayModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">선정산지급처리</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="prepayForm">
						<input type="hidden" name="reqNo">
						<div class="form-group">
							<label class="control-label col-md-4 col-sm-3 col-xs-12">지급금액*</label>
							<div class="col-md-8 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly hasValue" name="prepayAmt">
							</div>
							<div class="clearfix"></div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" onclick="fn_prepay()">선정산지급완료</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<%@ include file="/WEB-INF/jsp/bo/mmbrModal.jsp"%>
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>