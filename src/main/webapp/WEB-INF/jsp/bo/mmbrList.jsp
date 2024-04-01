<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 회원목록
* 설명 : 회원 CRUD
* 작성자 : 백승한
* 작성일 : 2019.11.25
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
		gfn_setSortTh("mmbrList", "fn_selectMmbrList(1)");
		gfn_setOnChange("form", "fn_selectMmbrList(1)");
		fn_selectMmbrList(1);
	});

	function fn_selectMmbrList(pageNo) {
		var comAjax = new ComAjax("form");
		comAjax.setUrl("<c:url value='/bo/selectMmbrList' />");
		comAjax.setCallback("fn_selectMmbrListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 15);
		comAjax.addParam("orderBy", $('#mmbrListCurOrderBy').val());
		comAjax.ajax();
	}
	
	function fn_selectMmbrListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#mmbrListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='6'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMmbrList",
				recordCount : 15
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateMmbrModal(\"" + value.mmbrNo + "\")'>" + value.mmbrNo + "</a>";
				str += "	</td>";
				str += "	<td>" + value.email + "</td>";
				str += "	<td>" + value.mmbrNm + "</td>";
				str += "	<td>" + value.ceoNm + "</td>";
				str += "	<td>" + value.mngrNm + "</td>";
				str += "	<td>" + value.insDt + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
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
								<h2>회원목록</h2>
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
									<button type="button" class="btn btn-info" onclick="fn_selectMmbrList(1)">조회</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="form">
										<div class="form-group">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">회원 번호</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control onChange" name="mmbrNo" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">회원명</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control onChange" name="mmbrNm" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">이메일</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control onChange" name="email">
											</div>
											<div class="clearfix"></div>
										</div>
										<input type="hidden" id="mmbrListCurOrderBy">
									</form>
								</div>
								<div class="ln_solid"></div>
								<table class="table table-bordered">
									<thead>
										<tr>
											<th>회원 번호</th>
											<th>이메일</th>
											<th name="mmbrListSortTh" id="sortTh_mmbrNm">
												회원명 <span name="mmbrListSort" id="mmbrListSort_mmbrNm" class="glyphicon"></span>
											</th>
											<th>대표자명</th>
											<th>담당자명</th>
											<th>등록일시</th>
										</tr>
									</thead>
									<tbody id="mmbrListTbody"></tbody>
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
	
	<%@ include file="/WEB-INF/jsp/bo/mmbrModal.jsp"%>
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>