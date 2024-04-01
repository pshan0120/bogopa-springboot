<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 메인
* 설명 : 로그인 후 첫 화면, 대시보드
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
	});
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
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="x_panel">
							<div class="x_title">
								<h2>대시보드 <small>소제목</small></h2>
								<ul class="nav navbar-right panel_toolbox">
									<li>
										<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
									</li>
									<li>
										<a class="close-link"><i class="fa fa-close"></i></a>
									</li>
								</ul>
								<div class="clearfix"></div>
							</div>
							<div class="x_content">
								<table class="table table-striped">
									<thead>
										<tr>
											<th>#</th>
											<th>컬럼1</th>
											<th>컬럼2</th>
											<th>컬럼3</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th scope="row">1</th>
											<td>데이터1</td>
											<td>데이터2</td>
											<td>데이터3</td>
										</tr>
										<tr>
											<th scope="row">2</th>
											<td>데이터1</td>
											<td>데이터2</td>
											<td>데이터3</td>
										</tr>
										<tr>
											<th scope="row">3</th>
											<td>데이터1</td>
											<td>데이터2</td>
											<td>데이터3</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="col-md-6 col-sm-6 col-xs-12">
						<div class="x_panel">
							<div class="x_title">
								<h2>대시보드 <small>소제목</small></h2>
								<ul class="nav navbar-right panel_toolbox">
									<li>
										<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
									</li>
									<li>
										<a class="close-link"><i class="fa fa-close"></i></a>
									</li>
								</ul>
								<div class="clearfix"></div>
							</div>
							<div class="x_content">
								<table class="table table-striped">
									<thead>
										<tr>
											<th>#</th>
											<th>컬럼1</th>
											<th>컬럼2</th>
											<th>컬럼3</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th scope="row">1</th>
											<td>데이터1</td>
											<td>데이터2</td>
											<td>데이터3</td>
										</tr>
										<tr>
											<th scope="row">2</th>
											<td>데이터1</td>
											<td>데이터2</td>
											<td>데이터3</td>
										</tr>
										<tr>
											<th scope="row">3</th>
											<td>데이터1</td>
											<td>데이터2</td>
											<td>데이터3</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /page content -->

			<!-- footer content -->
			<footer>
				<div class="pull-right">
					Gentelella - Bootstrap Admin Template by <a href="https://colorlib.com">Colorlib</a>
				</div>
				<div class="clearfix"></div>
			</footer>
			<!-- /footer content -->
		</div>
	</div>
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>
