<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 코드목록
* 설명 : 코드 CRUD
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
		gfn_setSortTh("cdList", "fn_selectCdList(1)");
		gfn_setOnChange("form", "fn_selectCdList(1)");
		fn_selectCdList(1);
	});

	function fn_selectCdList(pageNo) {
		const comAjax = new ComAjax("form");
		comAjax.setUrl("<c:url value='/bo/selectCdList' />");
		comAjax.setCallback("fn_selectCdListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 15);
		comAjax.addParam("orderBy", $('#cdListCurOrderBy').val());
		comAjax.ajax();
	}
	
	function fn_selectCdListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#cdListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='7'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectCdList",
				recordCount : 15
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>" + value.grpCd + "</td>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateCdModal(\"" + value.grpCd + "\", \"" + value.cd + "\")'>" + value.cd + "</a>";
				str += "	</td>";
				str += "	<td>" + value.nm + "</td>";
				str += "	<td>" + value.ordr + "</td>";
				str += "	<td>" + value.rmrk + "</td>";
				str += "	<td>" + value.updUserNm + "</td>";
				str += "	<td>" + value.updDate + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_openInsertCdModal() {
		$('#inserCdModal').modal("show");
	}
	
	function fn_insertCd() {
		var validate = gfn_validateForm("insertForm");
		
		if(validate && confirm("코드를 등록하시겠습니까?")) {
			const comAjax = new ComAjax("insertForm");
			comAjax.setUrl("<c:url value='/bo/insertCd' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_openUpdateCdModal(grpCd, cd) {
		fn_selectCdDetail(grpCd, cd);
	}
	
	function fn_selectCdDetail(grpCd, cd) {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/bo/selectCd' />");
		comAjax.addParam("grpCd", grpCd);
		comAjax.addParam("cd", cd);
		comAjax.setCallback("fn_selectCdDetailCallback");
		comAjax.ajax();
	}
	
	function fn_selectCdDetailCallback(data) {
		gfn_setDataVal(data.map, "updateForm");
		$('#updateCdModal').modal("show");
	}

	function fn_updateCd() {
		var validate = gfn_validateForm("updateForm");
		if(validate && confirm("코드정보를 수정하시겠습니까?")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/updateCd' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_deleteCd() {
		if(confirm("코드정보를 삭제하시겠습니까? 삭제하면 다시 복구되지 않습니다.")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/deleteCd' />");
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
								<h2>코드목록</h2>
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
									<button type="button" class="btn btn-primary" onclick="fn_openInsertCdModal()">등록</button>
									<button type="button" class="btn btn-info" onclick="fn_selectCdList(1)">조회</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="form">
										<div class="form-group">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">그룹코드</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<select class="form-control onChange" name="grpCd">
													<option value="">전체</option>
													<c:choose>
														<c:when test="${fn:length(grpCdList) > 0}">
															<c:forEach var="row" items="${grpCdList}" varStatus="status">
																<option value="${row.cd}">${row.nm}</option>
															</c:forEach>
														</c:when>
													</c:choose>
												</select>
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">코드</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="cd"
													onKeypress="gfn_hitEnter(event, 'fn_selectCdList(1)');" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">코드명</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="nm"
													onKeypress="gfn_hitEnter(event, 'fn_selectCdList(1)');" >
											</div>
											<div class="clearfix"></div>
										</div>
										<input type="hidden" id="cdListCurOrderBy">
									</form>
								</div>
								<div class="ln_solid"></div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th name="cdListSortTh" id="sortTh_grpCd">
												그룹코드 <span name="cdListSort" id="cdListSort_grpCd" class="glyphicon"></span>
											</th>
											<th>코드</th>
											<th>코드명</th>
											<th>순서</th>
											<th>비고</th>
											<th>수정자</th>
											<th>수정일</th>
										</tr>
									</thead>
									<tbody id="cdListTbody"></tbody>
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
	
	<!-- 코드등록 Modal -->
	<div class="modal fade" id="inserCdModal" role="dialog" aria-labelledby="inserCdModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">코드등록</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="insertForm">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">그룹코드*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<select class="form-control hasValue" name="grpCd">
									<c:choose>
										<c:when test="${fn:length(grpCdList) > 0}">
											<c:forEach var="row" items="${grpCdList}" varStatus="status">
												<option value="${row.cd}">${row.nm}</option>
											</c:forEach>
										</c:when>
									</c:choose>
								</select>
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">순서*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue numberOnly" name="ordr">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">코드*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="cd">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">코드명*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="nm">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비고</label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<input type="text" class="form-control" name="rmrk" maxlength="50">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_insertCd()">등록</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 코드수정 Modal -->
	<div class="modal fade" id="updateCdModal" role="dialog" aria-labelledby="updateCdModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-md">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">코드상세</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="updateForm">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">그룹코드*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<select class="form-control hasValue" name="grpCd">
									<c:choose>
										<c:when test="${fn:length(grpCdList) > 0}">
											<c:forEach var="row" items="${grpCdList}" varStatus="status">
												<option value="${row.cd}">${row.nm}</option>
											</c:forEach>
										</c:when>
									</c:choose>
								</select>
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">순서*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue numberOnly" name="ordr">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">코드*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="cd">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">코드명*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="nm">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비고</label>
							<div class="col-md-9 col-sm-9 col-xs-12">
								<input type="text" class="form-control" name="rmrk" maxlength="50">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-warning" onclick="fn_updateCd()">수정</button>
					<button type="button" class="btn btn-danger" onclick="fn_deleteCd()">삭제</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>
