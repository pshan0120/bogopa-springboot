<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 사용자목록
* 설명 : 사용자 CRUD
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
		gfn_setSortTh("userList", "fn_selectUserList(1)");
		gfn_setOnChange("form", "fn_selectUserList(1)");
		fn_selectUserList(1);
	});
	
	function fn_selectUserList(pageNo) {
		const comAjax = new ComAjax("form");
		comAjax.setUrl("<c:url value='/bo/selectUserList' />");
		comAjax.setCallback("fn_selectUserListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 15);
		comAjax.addParam("orderBy", $('#userListCurOrderBy').val());
		comAjax.ajax();
	}
	
	function fn_selectUserListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#userListTbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='5'>조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectUserList",
				recordCount : 15
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href='javascript:(void(0));' onclick='fn_openUpdateUserModal(\"" + value.userId + "\")'>" + value.userId + "</a>";
				str += "	</td>";
				str += "	<td>" + value.userNm + "</td>";
				str += "	<td>" + gfn_viewTelNo(value.mpNo) + "</td>";
				str += "	<td>" + value.email + "</td>";
				str += "	<td>" + value.useYn + "</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}
	
	function hitEnterKey(event) {
		if(event.keyCode == 13) {
			// 목록 ajax 리로드시 첫번째 페이지로 세팅
			gfv_pageIndex = 1;
			fn_selectUserList(1);
		} else {
			event.keyCode == 0;
			return;
		}
	}
	
	function fn_openInsertUserModal() {
		$('#inserUserModal').modal("show");
	}
	
	function fn_insertUser() {
		var validate = gfn_validateForm("insertForm");
		
		var pswrd = $("#insertForm input[name='pswrd']").val();
		var pswrdRe = $("#insertForm input[name='pswrdRe']").val();
		if(validate && (pswrd != pswrdRe)) {
			alert("재입력된 비밀번호가 일치하지 않습니다.");
			validate = false;
			return;
		}
		
		if(validate && confirm("사용자를 등록하시겠습니까?")) {
			const comAjax = new ComAjax("insertForm");
			comAjax.setUrl("<c:url value='/bo/insertUser' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_openUpdateUserModal(userId) {
		fn_selectUserDetail(userId);
	}
	
	function fn_selectUserDetail(userId) {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/bo/selectUser' />");
		comAjax.addParam("userId", userId);
		comAjax.setCallback("fn_selectUserDetailCallback");
		comAjax.ajax();
	}
	
	function fn_selectUserDetailCallback(data) {
		// 지정된 form 내 모든 dom에서 name값을 찾은 뒤 data.map의 값과 일치하면 자동으로 입력
		// .val()로만 입력하므로, .text()나 .html()등을 사용하는 textarea는 작동하지 않음
		gfn_setDataVal(data.map, "updateForm");
		$('#updateUserModal').modal("show");
	}

	function fn_updateUser() {
		var validate = gfn_validateForm("updateForm");
		if(validate && confirm("사용자정보를 수정하시겠습니까?")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/updateUser' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_deleteUser() {
		if(confirm("사용자정보를 삭제하시겠습니까? 삭제하면 다시 복구되지 않습니다.")) {
			var comAjax = new ComAjax("updateForm");
			comAjax.setUrl("<c:url value='/bo/deleteUser' />");
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
								<h2>사용자목록</h2>
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
									<button type="button" class="btn btn-primary" onclick="fn_openInsertUserModal()">등록</button>
									<button type="button" class="btn btn-info" onclick="fn_selectUserList(1)">조회</button>
								</div>
								<div class="conditionDiv">
									<form class="form" id="form">
										<div class="form-group">
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">사용자ID</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control onChange" name="userId">
											</div>
											<label class="control-label col-md-2 col-sm-2 col-xs-12 text-right">사용자명</label>
											<div class="col-md-2 col-sm-4 col-xs-12">
												<input type="text" class="form-control onChange" name="userNm">
											</div>
											<div class="clearfix"></div>
										</div>
										<input type="hidden" id="userListCurOrderBy">
									</form>
								</div>
								<div class="ln_solid"></div>
								<table class="table table-bordered">
									<colgroup>
										<col width="20%" />
										<col width="20%" />
										<col width="20%" />
										<col width="20%" />
										<col width="20%" />
									</colgroup>
									<thead>
										<tr>
											<th name="userListSortTh" id="sortThuserId">
												사용자ID <span name="userListSort" id="userListSortuserId" class="glyphicon glyphicon-sort-by-attributes"></span>
											</th>
											<th name="userListSortTh" id="sortThuserNm">
												사용자명 <span name="userListSort" id="userListSortuserNm" class="glyphicon"></span>
											</th>
											<th>휴대전화번호</th>
											<th>이메일</th>
											<th>사용여부</th>
										</tr>
									</thead>
									<tbody id="userListTbody">
									</tbody>
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
	
	<!-- 사용자 등록 Modal -->
	<div class="modal fade" id="inserUserModal" role="dialog" aria-labelledby="inserUserModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">사용자 등록</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="insertForm">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">사용자ID*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="userId">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">사용자명*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="userNm">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">휴대전화번호</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="tel" class="form-control mpNoOnly" name="mpNo">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">이메일*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="email" class="form-control hasValue emailOnly" name="email">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비밀번호*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="password" class="form-control hasValue pswdOnly" name="pswrd">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비밀번호 재입력*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="password" class="form-control hasValue pswdOnly" name="pswrdRe">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_insertUser()">등록</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 사용자 수정 Modal -->
	<div class="modal fade" id="updateUserModal" role="dialog" aria-labelledby="updateUserModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">사용자 수정</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal form-label-left input_mask" id="updateForm">
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">사용자ID*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="userId">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">사용자명*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue" name="userNm">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">휴대전화번호</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control mpNoOnly" name="mpNo">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">이메일*</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control hasValue emailOnly" name="email">
							</div>
						</div>
						<div class="form-group">
							<label class="control-label col-md-3 col-sm-3 col-xs-12">비밀번호 오류횟수</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<input type="text" class="form-control numberOnly" name="pswrdErrCnt">
							</div>
							<label class="control-label col-md-3 col-sm-3 col-xs-12">사용여부</label>
							<div class="col-md-3 col-sm-9 col-xs-12">
								<select class="form-control onChange" name="useYn" >
									<option value="Y">사용중</option>
									<option value="N">사용정지</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-warning" onclick="fn_updateUser()">수정</button>
					<button type="button" class="btn btn-danger" onclick="fn_deleteUser()">삭제</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>
