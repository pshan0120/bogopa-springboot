<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 커머스목록
* 설명 : 커머스 CRUD
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
		gfn_setSortTh("cmmrcList", "fn_selectCmmrcList(1)");
		gfn_setOnChange("form", "fn_selectCmmrcList(1)");
		fn_selectCmmrcList(1);
	});

	function fn_selectCmmrcList(pageNo) {
		var comAjax = new ComAjax("form");
		comAjax.setUrl("<c:url value='/bo/selectCmmrcList' />");
		comAjax.setCallback("fn_selectCmmrcListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 15);
		comAjax.addParam("orderBy", $('#cmmrcListCurOrderBy').val());
		comAjax.ajax();
	}
	
	function fn_selectCmmrcListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#cmmrcListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='6'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectCmmrcList",
				recordCount : 15
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateCmmrcModal(\"" + value.cmmrcNo + "\")'>" + value.cmmrcNo + "</a>";
				str += "	</td>";
				str += "	<td>" + value.cmmrcNm + "</td>";
				str += "	<td>" + gfn_comma(value.limitAmt) + "</td>";
				str += "	<td>" + value.dailyCmmtnRate + "</td>";
				str += "	<td>" + value.useYn + "</td>";
				str += "	<td>" + value.insDt + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_openInsertCmmrcModal() {
		$('#inserCmmrcModal').modal("show");
	}
	
	function fn_insertCmmrc() {
		var validate = gfn_validateForm("insertForm");
		
		if(validate && confirm("커머스를 등록하시겠습니까?")) {
			var comAjax = new ComAjax("insertForm");
			comAjax.setUrl("<c:url value='/bo/insertCmmrc' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_openUpdateCmmrcModal(cmmrcNo) {
		fn_selectCmmrcDetail(cmmrcNo);
	}
	
	function fn_selectCmmrcDetail(cmmrcNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/bo/selectCmmrc' />");
		comAjax.addParam("cmmrcNo", cmmrcNo);
		comAjax.setCallback("fn_selectCmmrcDetailCallback");
		comAjax.ajax();
	}
	
	function fn_selectCmmrcDetailCallback(data) {
		gfn_setDataVal(data.map, "updateForm");
		$('#updateCmmrcModal').modal("show");
	}

	function fn_updateCmmrc() {
		var validate = gfn_validateForm("updateForm");
		if(validate && confirm("커머스정보를 수정하시겠습니까?")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/updateCmmrc' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_deleteCmmrc() {
		if(confirm("커머스정보를 삭제하시겠습니까? 삭제하면 다시 복구되지 않습니다.")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/deleteCmmrc' />");
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
								<h2>커머스목록</h2>
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
									<button type="button" class="btn btn-primary" onclick="fn_openInsertCmmrcModal()">등록</button>
									<button type="button" class="btn btn-info" onclick="fn_selectCmmrcList(1)">조회</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="form">
										<div class="form-group">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">커머스명</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="cmmrcNm"
													onKeypress="gfn_hitEnter(event, 'fn_selectCmmrcList(1)');" >
											</div>
											<div class="clearfix"></div>
										</div>
										<input type="hidden" id="cmmrcListCurOrderBy">
									</form>
								</div>
								<div class="ln_solid"></div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th name="cmmrcListSortTh" id="sortTh_cmmrcNo">
												커머스번호 <span name="cmmrcListSort" id="cmmrcListSort_cmmrcNo" class="glyphicon"></span>
											</th>
											<th>커머스명</th>
											<th>한도</th>
											<th>일 수수료율</th>
											<th>사용여부</th>
											<th>등록일시</th>
										</tr>
									</thead>
									<tbody id="cmmrcListTbody"></tbody>
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
	
	<!-- 커머스등록 Modal -->
	<div class="modal fade" id="inserCmmrcModal" role="dialog" aria-labelledby="inserCmmrcModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">커머스등록</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="insertForm">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">커머스명*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="cmmrcNm">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">한도*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly hasValue" name="limitAmt">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">일 수수료율*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control floatOnly hasValue" name="dailyCmmtnRate">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비고</label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<textarea rows="10" class="form-control" cols="20" name="rmrk"></textarea>
							</div>
							<div class="clearfix"></div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_insertCmmrc()">등록</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 커머스수정 Modal -->
	<div class="modal fade" id="updateCmmrcModal" role="dialog" aria-labelledby="updateCmmrcModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">커머스상세</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="updateForm">
						<input type="hidden" name="cmmrcNo">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">커머스명*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="cmmrcNm">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">사용여부*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<select class="form-control hasValue" name="useYn">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">한도*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly hasValue" name="limitAmt">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">일 수수료율*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control floatOnly hasValue" name="dailyCmmtnRate">
							</div>
							<div class="clearfix"></div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비고</label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<textarea rows="10" class="form-control" cols="20" name="rmrk"></textarea>
							</div>
							<div class="clearfix"></div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-warning" onclick="fn_updateCmmrc()">수정</button>
					<button type="button" class="btn btn-danger" onclick="fn_deleteCmmrc()">삭제</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>