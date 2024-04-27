<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 크립토 백테스트
* 설명 : 크립토 백테스트
* 작	성	자 : 백승한
* 작	성	일 : 2021.04.25
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
		$("#moveAvgLine1Div input[name='fromDate'").val(gfn_getDateDash(-1000));
		$("#moveAvgLine1Div input[name='toDate'").val(gfn_getCurrentDateDash());

		$("#moveAvgLine2Div input[name='fromDate'").val(gfn_getDateDash(-1000));
		$("#moveAvgLine2Div input[name='toDate'").val(gfn_getCurrentDateDash());
	});
	
	function fn_test(apiId) {
		if(gfn_validateForm(apiId + "Form")) {
			const comAjax = new ComAjax(apiId + "Form");
			comAjax.setUrl("<c:url value='/bo/doCryptoBackTest' />");
			comAjax.setCallback("fn_testCallback");
			comAjax.addParam("apiId", apiId);
			comAjax.ajax();
		}
	}
	
	function fn_testCallback(data) {
		gfn_setDataVal(data.map, data.map.apiId + "ResultDiv");
		if(data.map.apiId == "moveAvgLine1") {
			fn_setMoveAvgLine1(data);
		} else if(data.map.apiId == "moveAvgLine2") {
			fn_setMoveAvgLine2(data);
		}
	}

	function fn_setMoveAvgLine1(data) {
		var list = data.map.list;
		var cnt = data.map.list.length;
		
		var body = $("#moveAvgLine1Div div.resultDiv table > tbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='11'>수집결과가 없습니다.</td></tr>";
		} else {
			$.each(list, function(key, value) {
				if(value.own) {
					str += "<tr style=\"background-color:yellow\">";
				} else {
					str += "<tr>";
				}
				str += "	<td>" + value.tickDt + "</td>";
				str += "	<td>" + value.tradePrice + "</td>";
				str += "	<td>" + value.tradeVol + "</td>";
				if(value.bnftRate > 0) {
					str += "<td class=\"font-red\">" + value.bnftRate + "</td>";
				} else if(value.bnftRate < 0) {
					str += "<td class=\"font-blue\">" + value.bnftRate + "</td>";
				} else {
					str += "<td>" + value.bnftRate + "</td>";
				}
				str += "	<td>" + value.shortLine + "</td>";
				str += "	<td>" + value.longLine + "</td>";
				if(value.lineStts == "1") {
					str += "<td class=\"font-red\">▲</td>";
				} else if(value.lineStts == "-1") {
					str += "<td class=\"font-blue\">▼</td>";
				} else {
					str += "<td></td>";
				}
				if(value.actn == "1") {
					str += "<td class=\"font-red\">매수</td>";
				} else if(value.actn == "-1") {
					str += "<td class=\"font-blue\">매도</td>";
				} else {
					str += "<td></td>";
				}
				if(value.own) {
					str += "<td>○</td>";
				} else {
					str += "<td></td>";
				}
				if(value.hldngBnftRate > 100) {
					str += "<td class=\"font-red\">" + value.hldngBnftRate + "</td>";
				} else if(value.hldngBnftRate < 100) {
					str += "<td class=\"font-blue\">" + value.hldngBnftRate + "</td>";
				} else {
					str += "<td>" + value.hldngBnftRate + "</td>";
				}
				if(value.strtgyBnftRate > 100) {
					str += "<td class=\"font-red\">" + value.strtgyBnftRate + "</td>";
				} else if(value.strtgyBnftRate < 100) {
					str += "<td class=\"font-blue\">" + value.strtgyBnftRate + "</td>";
				} else {
					str += "<td>" + value.strtgyBnftRate + "</td>";
				}
				str += "</tr>";
			});
		}
		body.append(str);
	}
	
	function fn_setMoveAvgLine2(data) {
		var list = data.map.list;
		var cnt = data.map.list.length;
		
		var body = $("#moveAvgLine2Div div.resultDiv table > tbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='11'>수집결과가 없습니다.</td></tr>";
		} else {
			$.each(list, function(key, value) {
				if(value.own) {
					str += "<tr style=\"background-color:yellow\">";
				} else {
					str += "<tr>";
				}
				str += "	<td>" + value.candleDtKst + "</td>";
				str += "	<td>" + value.tradePrice + "</td>";
				str += "	<td>" + value.accTradeVol + "</td>";
				if(value.bnftRate > 0) {
					str += "<td class=\"font-red\">" + value.bnftRate + "</td>";
				} else if(value.bnftRate < 0) {
					str += "<td class=\"font-blue\">" + value.bnftRate + "</td>";
				} else {
					str += "<td>" + value.bnftRate + "</td>";
				}
				str += "	<td>" + value.shortMoveLine + "</td>";
				str += "	<td>" + value.middleMoveLine + "</td>";
				str += "	<td>" + value.longMoveLine + "</td>";
				if(value.lineStts == "1") {
					str += "<td class=\"font-red\">▲</td>";
				} else if(value.lineStts == "-1") {
					str += "<td class=\"font-blue\">▼</td>";
				} else {
					str += "<td></td>";
				}
				if(value.actn == "1") {
					str += "<td class=\"font-red\">매수</td>";
				} else if(value.actn == "-1") {
					str += "<td class=\"font-blue\">매도</td>";
				} else {
					str += "<td></td>";
				}
				if(value.own == "1") {
					str += "<td>○</td>";
				} else {
					str += "<td></td>";
				}
				if(value.hldngBnftRate > 100) {
					str += "<td class=\"font-red\">" + value.hldngBnftRate + "</td>";
				} else if(value.hldngBnftRate < 100) {
					str += "<td class=\"font-blue\">" + value.hldngBnftRate + "</td>";
				} else {
					str += "<td>" + value.hldngBnftRate + "</td>";
				}
				if(value.strtgyBnftRate > 100) {
					str += "<td class=\"font-red\">" + value.strtgyBnftRate + "</td>";
				} else if(value.strtgyBnftRate < 100) {
					str += "<td class=\"font-blue\">" + value.strtgyBnftRate + "</td>";
				} else {
					str += "<td>" + value.strtgyBnftRate + "</td>";
				}
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
								<h2>크립토 백테스트</h2>
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
							<div class="x_content" id="moveAvgLine1Div">
								<div class="alert alert-info alert-dismissible fade in" role="alert">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<span aria-hidden="true">×</span>
									</button>
									이평선 전략1 백테스트
								</div>
								<div class="btnDiv">
									<button type="button" class="btn btn-primary" onclick="fn_test('moveAvgLine1')">Send</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="moveAvgLine1Form" onsubmit="return false;">
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*챠트유형</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<select class="form-control onChange hasValue" name="chartTypeCd">
													<c:choose>
														<c:when test="${fn:length(chartTypeCdList) > 0}">
															<c:forEach var="row" items="${chartTypeCdList}" varStatus="status">
																<option value="${row.cd}">${row.nm}</option>
															</c:forEach>
														</c:when>
													</c:choose>
												</select>
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*마켓코드</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<select class="form-control onChange hasValue" name="mrktCd">
													<c:choose>
														<c:when test="${fn:length(mrktCdList) > 0}">
															<c:forEach var="row" items="${mrktCdList}" varStatus="status">
																<option value="${row.cd}">${row.nm}</option>
															</c:forEach>
														</c:when>
													</c:choose>
												</select>
											</div>
										</div>
										
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*테스트시작일</label>
											<div class="col-md-3 col-sm-4 col-xs-12">
												<input type="date" class="form-control hasValue" name="fromDate" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*테스트종료일</label>
											<div class="col-md-3 col-sm-4 col-xs-12">
												<input type="date" class="form-control hasValue" name="toDate" >
											</div>
										</div>
										
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*단기이평선 수</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="number" class="form-control hasValue" name="shortLineCnt" value="5">
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*장기이평선 수</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="number" class="form-control hasValue" name="longLineCnt" value="20">
											</div>
										</div>
									</form>
								</div>
								<div class="resultDiv" id="moveAvgLine1ResultDiv">
									<div class="form-group clearfix">
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">결과메세지</label>
										<div class="col-md-10 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="resultMsg" readonly>
										</div>
									</div>
									
									<div class="form-group clearfix">
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">홀딩 총 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="hldngTotalBnftRate" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">홀딩 보유횟수</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="hldngOwnCnt" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">홀딩 일평균 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="hldngDayAvgBnftRate" readonly>
										</div>
									</div>
									
									<div class="form-group clearfix">
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">전략 총 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="strtgyTotalBnftRate" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">전략 보유횟수</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="strtgyOwnCnt" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">전략 일평균 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="strtgyDayAvgBnftRate" readonly>
										</div>
									</div>
									
									<div class="form-group clearfix">
										<div class="col-md-12 col-sm-10 col-xs-12">
											<table class="table table-bordered">
												<thead>
													<tr>
														<th>틱</th>
														<th>종가</th>
														<th>거래량</th>
														<th>수익률</th>
														<th>단기이평선</th>
														<th>장기이평선</th>
														<th>상태</th>
														<th>매매신호</th>
														<th>보유여부</th>
														<th>홀딩 수익률</th>
														<th>전략 수익률</th>
													</tr>
												</thead>
												<tbody></tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
							
							
							<div class="x_content" id="moveAvgLine2Div">
								<div class="alert alert-info alert-dismissible fade in" role="alert">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<span aria-hidden="true">×</span>
									</button>
									이평선 전략2 백테스트
								</div>
								<div class="btnDiv">
									<button type="button" class="btn btn-primary" onclick="fn_test('moveAvgLine2')">Send</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="moveAvgLine2Form" onsubmit="return false;">
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*챠트유형</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<select class="form-control onChange hasValue" name="chartTypeCd">
													<c:choose>
														<c:when test="${fn:length(chartTypeCdList) > 0}">
															<c:forEach var="row" items="${chartTypeCdList}" varStatus="status">
																<option value="${row.cd}">${row.nm}</option>
															</c:forEach>
														</c:when>
													</c:choose>
												</select>
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*마켓코드</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<select class="form-control onChange hasValue" name="mrktCd">
													<c:choose>
														<c:when test="${fn:length(mrktCdList) > 0}">
															<c:forEach var="row" items="${mrktCdList}" varStatus="status">
																<option value="${row.cd}">${row.nm}</option>
															</c:forEach>
														</c:when>
													</c:choose>
												</select>
											</div>
										</div>
										
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*테스트시작일</label>
											<div class="col-md-3 col-sm-4 col-xs-12">
												<input type="date" class="form-control hasValue" name="fromDate" >
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*테스트종료일</label>
											<div class="col-md-3 col-sm-4 col-xs-12">
												<input type="date" class="form-control hasValue" name="toDate" >
											</div>
										</div>
										
										<div class="form-group clearfix">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*단기이평선 수</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="number" class="form-control hasValue" name="shortLineCnt" value="5">
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*중기이평선 수</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="number" class="form-control hasValue" name="middleLineCnt" value="20">
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">*장기이평선 수</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="number" class="form-control hasValue" name="longLineCnt" value="60">
											</div>
										</div>
									</form>
								</div>
								<div class="resultDiv" id="moveAvgLine2ResultDiv">
									<div class="form-group clearfix">
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">결과메세지</label>
										<div class="col-md-10 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="resultMsg" readonly>
										</div>
									</div>
									
									<div class="form-group clearfix">
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">홀딩 총 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="hldngTotalBnftRate" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">홀딩 보유횟수</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="hldngOwnCnt" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">홀딩 일평균 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="hldngDayAvgBnftRate" readonly>
										</div>
									</div>
									
									<div class="form-group clearfix">
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">전략 총 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="strtgyTotalBnftRate" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">전략 보유횟수</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="strtgyOwnCnt" readonly>
										</div>
										<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">전략 일평균 수익률</label>
										<div class="col-md-2 col-sm-4 col-xs-12">
											<input type="text" class="form-control" name="strtgyDayAvgBnftRate" readonly>
										</div>
									</div>
									
									<div class="form-group clearfix">
										<div class="col-md-12 col-sm-10 col-xs-12">
											<table class="table table-bordered">
												<thead>
													<tr>
														<th>틱</th>
														<th>종가</th>
														<th>거래량</th>
														<th>수익률</th>
														<th>단기이평선</th>
														<th>중기이평선</th>
														<th>장기이평선</th>
														<th>상태</th>
														<th>매매신호</th>
														<th>보유여부</th>
														<th>홀딩 수익률</th>
														<th>전략 수익률</th>
													</tr>
												</thead>
												<tbody></tbody>
											</table>
										</div>
									</div>
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
