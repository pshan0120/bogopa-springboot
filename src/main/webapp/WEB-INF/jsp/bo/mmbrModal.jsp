<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 회원 모달
* 설명 : 회원 CRUD
* 작성자 : 백승한
* 작성일 : 2019.12.11
* Copyright BoardgameGG. All Right Reserved
***************************************************************************************************
--%>
<%@ page pageEncoding="utf-8"%>
<script>
	function fn_openUpdateMmbrModal(mmbrNo) {
		$("#updateMmbrModal input[name='mmbrNo']").val(mmbrNo);
		
		fn_selectMmbrDetail();
		fn_selectMmbrCmmrcList(1);
		fn_selectMmbrRepayList(1);
		fn_selectMmbrLogList(1);
		fn_selectEmailHisList(1);

		gfn_setOnChange("repayForm", "fn_selectMmbrRepayList(1)");
	}
	
	function fn_selectMmbrDetail() {
		const comAjax = new ComAjax("updateMmbrForm");
		comAjax.setUrl("<c:url value='/bo/selectMmbr' />");
		comAjax.setCallback("fn_selectMmbrDetailCallback");
		comAjax.ajax();
	}
	
	function fn_selectMmbrDetailCallback(data) {
		gfn_setDataVal(data.map, "updateMmbrForm");
		gfn_setDataVal(data.map, "repayForm");
		$("#updateMmbrModal").modal("show");
	}
	
	function fn_updateMmbr() {
		var validate = gfn_validateForm("updateMmbrForm");
		if(validate && confirm("회원정보를 수정하시겠습니까?")) {
			const comAjax = new ComAjax("updateMmbrForm");
			comAjax.setUrl("<c:url value='/bo/updateMmbr' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_deleteMmbr() {
		if(confirm("회원정보를 삭제하시겠습니까? 삭제하면 다시 복구되지 않습니다.")) {
			const comAjax = new ComAjax("updateMmbrForm");
			comAjax.setUrl("<c:url value='/bo/deleteMmbr' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_selectMmbrCmmrcList(pageNo) {
		const comAjax = new ComAjax("updateMmbrForm");
		comAjax.setUrl("<c:url value='/bo/selectMmbrCmmrcList' />");
		comAjax.setCallback("fn_selectMmbrCmmrcListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 10);
		comAjax.ajax();
	}
	
	function fn_selectMmbrCmmrcListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#mmbrCmmrcListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='6'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "mmbrCmmrcListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMmbrCmmrcList",
				recordCount : 10
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.cmmrcNm + "</td>";
				str += "	<td>" + value.sllrId + "</td>";
				str += "	<td>" + value.sllrPswrd + "</td>";
				str += "	<td>" + value.bankNm + "</td>";
				str += "	<td>" + value.accntNo + "</td>";
				str += "	<td>" + value.accntNm + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}
	
	function fn_selectMmbrRepayList(pageNo) {
		const comAjax = new ComAjax("repayForm");
		comAjax.setUrl("<c:url value='/bo/selectMmbrRepayList' />");
		comAjax.setCallback("fn_selectMmbrRepayListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 10);
		comAjax.ajax();
	}
	
	function fn_selectMmbrRepayListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#repayListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='5'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "repayListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMmbrRepayList",
				recordCount : 10
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.seq + "</td>";
				str += "	<td>" + value.planTypeNm + "</td>";
				str += "	<td>" + gfn_comma(value.reqAmt) + "</td>";
				str += "	<td>";
				if(value.cnfrmYn == "Y") {	// 입금확인완료
					str += value.cnfrmFromDate + " ~ " + value.cnfrmToDate;
				} else {
					str += "미확인";
				}
				str += "	</td>";
				str += "	<td>";
				if(value.evdncCd == "1") {	// 미요청
					str += "	미요청";
				} else {	// 요청
					if(value.evdncIssYn == "Y") {	// 발급완료
						str += "<span>발급일 : " + value.evdncIssDate + "</span>";
					} else {
						str += "미발급";
					}
				}
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}
	
	function fn_selectMmbrLogList(pageNo) {
		const comAjax = new ComAjax("updateMmbrForm");
		comAjax.setUrl("<c:url value='/bo/selectMmbrLogList' />");
		comAjax.setCallback("fn_selectMmbrLogListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 10);
		comAjax.ajax();
	}
	
	function fn_selectMmbrLogListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#mmbrLogListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='2'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "mmbrLogListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMmbrLogList",
				recordCount : 10
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.mmbrIp + "</td>";
				str += "	<td>" + value.logDt + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_selectEmailHisList(pageNo) {
		const comAjax = new ComAjax("updateMmbrForm");
		comAjax.setUrl("<c:url value='/bo/selectEmailHisList' />");
		comAjax.setCallback("fn_selectEmailHisListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 10);
		comAjax.ajax();
	}
	
	function fn_selectEmailHisListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#emailHisListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='3'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "emailHisListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectEmailHisList",
				recordCount : 10
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.seq + "</td>";
				str += "	<td>" + value.title + "</td>";
				str += "	<td>" + value.insDt + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}
</script>

<!-- 회원상세 Modal -->
<div class="modal fade" id="updateMmbrModal" role="dialog" aria-labelledby="updateMmbrModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title">회원상세</h4>
			</div>
			<div class="modal-body">
				<div class="" role="tabpanel" data-example-id="togglable-tabs">
					<ul id="updateMmbrTab" class="nav nav-tabs bar_tabs" role="tablist">
						<li role="presentation" class="active">
							<a href="#mmbrTabContent" id="mmbrTab" role="tab" data-toggle="tab" aria-expanded="true">
								기본정보
							</a>
						</li>
						<li role="presentation">
							<a href="#mmbrCmmrcTabContent" id="mmbrCmmrcTab" role="tab" data-toggle="tab" aria-expanded="false">
								커머스정보
							</a>
						</li>
						<li role="presentation" class="">
							<a href="#repayTabContent" role="tab" id="repayTab" data-toggle="tab" aria-expanded="false">
								상환일정
							</a>
						</li>
						<li role="presentation" class="">
							<a href="#etcTabContent" role="tab" id="etcTab" data-toggle="tab" aria-expanded="false">
								기타정보
							</a>
						</li>
					</ul>
					<div id="tabContent" class="tab-content">
						<div role="tabpanel" class="tab-pane fade active in" id="mmbrTabContent" aria-labelledby="mmbrTab">
							<div class="btnDiv">
								<button type="button" class="btn btn-warning" onclick="fn_updateMmbr()">수정</button>
								<button type="button" class="btn btn-danger" onclick="fn_deleteMmbr()">삭제</button>
							</div>
							<form class="form-horizontal form-label-left input_mask" id="updateMmbrForm">
								<div class="form-group">
									<label class="control-label col-md-2 col-sm-3 col-xs-12">회원 번호*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control" name="mmbrNo" readonly>
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">이메일*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="email" class="form-control hasValue emailOnly" name="email" maxlength="50">
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">회원명*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control hasValue" name="mmbrNm" maxlength="50">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2 col-sm-3 col-xs-12">대표자명*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control hasValue" name="ceoNm" maxlength="50">
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">대표자 휴대전화번호*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control hasValue mpNoOnly" name="ceoMpNo" maxlength="11">
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">사업자등록번호*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control hasValue bizNoOnly" name="bizNo" maxlength="10">
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2 col-sm-3 col-xs-12">담당자명*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control hasValue" name="mngrNm" maxlength="50">
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">담당자 휴대전화번호*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control hasValue mpNoOnly" name="mngrMpNo" maxlength="11">
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">비밀번호 오류횟수</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<input type="text" class="form-control" name="pswrdErrCnt" readonly>
									</div>
								</div>
								<div class="form-group">
									<label class="control-label col-md-2 col-sm-3 col-xs-12">마케팅여부*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<select class="form-control hasValue" name="mrtngYn">
											<option value="Y">동의</option>
											<option value="N">미동의</option>
										</select>
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">서류확인여부*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<select class="form-control hasValue" name="dcmntYn">
											<option value="Y">확인</option>
											<option value="N">미확인</option>
										</select>
									</div>
									<label class="control-label col-md-2 col-sm-3 col-xs-12">사용여부*</label>
									<div class="col-md-2 col-sm-9 col-xs-12">
										<select class="form-control hasValue" name="useYn">
											<option value="Y">사용</option>
											<option value="N">미사용</option>
										</select>
									</div>
								</div>
							</form>
						</div>
						
						<div role="tabpanel" class="tab-pane fade in" id="mmbrCmmrcTabContent" aria-labelledby="mmbrCmmrcTab">
							<table class="table table-bordered">
								<thead>
									<tr>
										<th>커머스</th>
										<th>셀러계정</th>
										<th>셀러비밀번호</th>
										<th>은행명</th>
										<th>계좌번호</th>
										<th>예금주</th>
									</tr>
								</thead>
								<tbody id="mmbrCmmrcListTbody"></tbody>
							</table>
							<div class="text-center"><ul class="pagination pagination-sm" id="mmbrCmmrcListPageNav"></ul></div>
						</div>
						
						<div role="tabpanel" class="tab-pane fade" id="repayTabContent" aria-labelledby="repayTab">
							<div class="btnDiv">
								<button type="button" class="btn btn-info" onclick="fn_selectMmbrRepayList(1)">조회</button>
							</div>
							<form class="form-horizontal form-label-left input_mask" id="repayForm">
								<input type="hidden" name="mmbrNo" >
								<div class="form-group">
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
							</form>
							<div class="ln_solid"></div>
							<table class="table table-bordered">
								<thead>
									<tr>
										<th>순번</th>
										<th>플랜유형</th>
										<th>확인요청금액</th>
										<th>입금확인</th>
										<th>증빙요청확인</th>
									</tr>
								</thead>
								<tbody id="repayListTbody"></tbody>
							</table>
							<div class="text-center"><ul class="pagination pagination-sm" id="repayListPageNav"></ul></div>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="etcTabContent" aria-labelledby="etcTab">
							<div class="row">
								<div class="col-md-4 col-sm-12 col-xs-12">
									<h4>접속정보</h4>
									<table class="table table-bordered">
										<colgroup>
											<col width="50%" />
											<col width="50%" />
										</colgroup>
										<thead>
											<tr>
												<th>접속IP</th>
												<th>접속일시</th>
											</tr>
										</thead>
										<tbody id="mmbrLogListTbody">
										</tbody>
									</table>
									<div class="text-center"><ul class="pagination pagination-sm" id="mmbrLogListPageNav"></ul></div>
								</div>
								<div class="col-md-8 col-sm-12 col-xs-12">
									<h4>이메일 발송이력</h4>
									<table class="table table-bordered">
										<colgroup>
											<col width="15%" />
											<col width="*%" />
											<col width="20%" />
										</colgroup>
										<thead>
											<tr>
												<th>순번</th>
												<th>제목</th>
												<th>발송일시</th>
											</tr>
										</thead>
										<tbody id="emailHisListTbody">
										</tbody>
									</table>
									<div class="text-center"><ul class="pagination pagination-sm" id="emailHisListPageNav"></ul></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
