<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 상환목록
* 설명 : 상환 CRUD
* 작성자 : 백승한
* 작성일 : 2019.12.13
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
		gfn_setSortTh("repayList", "fn_selectRepayList(1)");
		gfn_setOnChange("form", "fn_selectRepayList(1)");
		fn_selectRepayList(1);
	});

	function fn_selectRepayList(pageNo) {
		const comAjax = new ComAjax("form");
		comAjax.setUrl("<c:url value='/bo/selectRepayList' />");
		comAjax.setCallback("fn_selectRepayListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 15);
		comAjax.addParam("orderBy", $("#repayListCurOrderBy").val());
		comAjax.ajax();
	}
	
	function fn_selectRepayListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#repayListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='10'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectRepayList",
				recordCount : 15
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateRepayModal(\"" + value.reqNo + "\", \"" + value.rnd +"\")'>" + value.reqNo + "</a>";
				str += "	</td>";
				str += "	<td>" + value.rnd + "</td>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateMmbrModal(\"" + value.mmbrNo + "\")'>" + value.mmbrNm + "</a>";
				str += "	</td>";
				str += "	<td>" + value.sttsNm + "</td>";
				str += "	<td>" + value.expctRepayDate + "</td>";
				str += "	<td>" + gfn_comma(value.expctRepayAmt) + "</td>";
				str += "	<td>" + value.realRepayDate + "</td>";
				str += "	<td>" + gfn_comma(value.realRepayAmt) + "</td>";
				str += "	<td>" + gfn_comma(value.restRepayAmt) + "</td>";
				str += "	<td>" + gfn_comma(value.cmmtnAmt) + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_openUpdateRepayModal(reqNo, rnd) {
		fn_selectRepayDetail(reqNo, rnd);
	}
	
	function fn_selectRepayDetail(reqNo, rnd) {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/bo/selectRepay' />");
		comAjax.addParam("reqNo", reqNo);
		comAjax.addParam("rnd", rnd);
		comAjax.setCallback("fn_selectRepayDetailCallback");
		comAjax.ajax();
	}
	
	function fn_selectRepayDetailCallback(data) {
		gfn_setDataVal(data.map, "updateForm");
		$("#updateRepayModal").modal("show");
	}

	function fn_updateRepay() {
		var validate = gfn_validateForm("updateForm");
		if(validate && confirm("상환정보를 수정하시겠습니까?")) {
			const comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/updateRepay' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_deleteRepay() {
		if(confirm("상환정보를 삭제하시겠습니까? 삭제하면 다시 복구되지 않습니다.")) {
			const comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/deleteRepay' />");
			comAjax.setCallback("gfn_defaultCallback");
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
								<h2>상환목록</h2>
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
									<button type="button" class="btn btn-info" onclick="fn_selectRepayList(1)">조회</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="form">
										<div class="form-group">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">회원 번호</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="mmbrNo"
													onKeypress="gfn_hitEnter(event, 'fn_selectRepayList(1)');" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">회원명</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="mmbrNm"
													onKeypress="gfn_hitEnter(event, 'fn_selectRepayList(1)');" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">상환상태</label>
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
										<input type="hidden" id="repayListCurOrderBy">
									</form>
								</div>
								<div class="ln_solid"></div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th name="repayListSortTh" id="sortTh_reqNo">
												신청번호 <span name="repayListSort" id="repayListSort_reqNo" class="glyphicon"></span>
											</th>
											<th>회차</th>
											<th>신청회원</th>
											<th name="repayListSortTh" id="sortTh_sttsCd">
												상환상태 <span name="repayListSort" id="repayListSort_sttsCd" class="glyphicon"></span>
											</th>
											<th name="repayListSortTh" id="sortTh_expctRepayDate">
												예상 상환일 <span name="repayListSort" id="repayListSort_expctRepayDate" class="glyphicon"></span>
											</th>
											<th>예상 상환액</th>
											<th name="repayListSortTh" id="sortTh_realRepayDate">
												실 상환일 <span name="repayListSort" id="repayListSort_realRepayDate" class="glyphicon"></span>
											</th>
											<th>실 상환액</th>
											<th>잔여 상환액</th>
											<th>수수료</th>
										</tr>
									</thead>
									<tbody id="repayListTbody"></tbody>
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
	
	<!-- 상환수정 Modal -->
	<div class="modal fade emptyModal" id="updateRepayModal" role="dialog" aria-labelledby="updateRepayModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">상환상세</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="updateForm">
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">신청번호*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="reqNo" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">회차*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="rnd" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">회원 번호*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="mmbrNo" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">회원명*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="mmbrNm" readonly>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">커머스*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="cmmrcNm" readonly>
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">일 수수료율*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="dailyCmmtnRate" readonly>
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">사용일수</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly hasValue" name="useDay">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">상환상태*</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="sttsNm" readonly>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">예상 상환일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="expctRepayDate">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">예상 상환액</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="expctRepayAmt">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">실 상환일</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="date" class="form-control" name="realRepayDate">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">실 상환액</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="realRepayAmt">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-2 col-sm-3 col-xs-12">잔여 상환액</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="restRepayAmt">
							</div>
							<label class="control-label col-md-2 col-sm-3 col-xs-12">수수료</label>
							<div class="col-md-4 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="cmmtnAmt">
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
					<button type="button" id="trnsfrCntrctRepayBtn" class="btn btn-primary display-none" onclick="fn_trnsfrCntrctRepay()">채권양도계약상환</button>
					<button type="button" id="trnsfrCntrctBtn" class="btn btn-primary display-none" onclick="fn_trnsfrCntrct()">채권양도계약완료</button>
					<button type="button" id="trnsfrCntrctFailBtn" class="btn btn-warning display-none" onclick="fn_trnsfrCntrctFail()">채권양도계약실패</button>
					<button type="button" id="prepayBtn" class="btn btn-primary display-none" onclick="fn_openPrepayModal()">선정산지급처리</button>
					<button type="button" id="updateRepayBtn" class="btn btn-warning" onclick="fn_updateRepay()">수정</button>
					<button type="button" id="deleteRepayBtn" class="btn btn-danger display-none" onclick="fn_deleteRepay()">삭제</button>
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
