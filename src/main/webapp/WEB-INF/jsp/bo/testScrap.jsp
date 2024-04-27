<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 스크랩 테스트
* 설명 : 스크랩 테스트
* 작	성	자 : 백승한
* 작	성	일 : 2019.09.23
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
	});
	
	function fn_test(apiId) {
		if(gfn_validateForm(apiId + "Form")) {
			const comAjax = new ComAjax(apiId + "Form");
			comAjax.setUrl("<c:url value='/bo/doTest' />");
			comAjax.setCallback("fn_testCallback");
			comAjax.addParam("userId", "admin");
			comAjax.addParam("apiId", apiId);
			comAjax.ajax();
		}
	}
	
	function fn_testCallback(data) {
		gfn_setDataVal(data.map, data.map.apiId + "Form");
		if(data.map.apiId == "boardlife") {
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
								<h2>스크랩 테스트</h2>
								<ul class="nav navbar-right panel_toolbox">
									<li>
										<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
									</li>
									<li class="dropdown">
										<a href="#" class="dropdown-toggle"
											data-toggle="dropdown" role="button" aria-expanded="false">
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
								<div class="alert alert-info alert-dismissible fade in" role="alert">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<span aria-hidden="true">×</span>
									</button>
									보드라이프 수집
								</div>
								<div class="btnDiv">
									<button type="button" class="btn btn-primary" onclick="fn_test('boardlife')">Send</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="boardlifeForm" onsubmit="return false;">
										<div class="form-group clearfix">
										</div>
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">결과코드</label>
											<div class="col-md-4 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="rsltCd" readonly>
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">요청번호</label>
											<div class="col-md-4 col-sm-4 col-xs-12">
												<input type="text" class="form-control" name="rsltMsg" readonly>
											</div>
										</div>
									</form>
								</div>
								
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
	
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>
