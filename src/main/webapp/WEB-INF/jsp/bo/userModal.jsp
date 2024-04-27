<%--
***************************************************************************************************
* 업무 그룹명 : B/O
* 서브 업무명 : B/O 사용자 모달
* 설명 : 사용자 CRUD
* 작성자 : 백승한
* 작성일 : 2019.12.11
* Copyright BoardgameGG. All Right Reserved
***************************************************************************************************
--%>
<%@ page pageEncoding="utf-8"%>

<script>
	function fn_openUserInfoModal() {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/bo/selectUser' />");
		comAjax.addParam("userId", "<c:out value='${userId}'/>");
		comAjax.setCallback("fn_openUserInfoModalCallback");
		comAjax.ajax();
	}
	
	function fn_openUserInfoModalCallback(data) {
		// 지정된 form 내 모든 dom에서 name값을 찾은 뒤 data.map의 값과 일치하면 자동으로 입력
		// .val()로만 입력하므로, .text()나 .html()등을 사용하는 textarea는 작동하지 않음
		gfn_setDataVal(data.map, "userProfileForm");
		$("#userProfileModal").modal("show");
	}
</script>

<!-- 사용자 정보 Modal -->
<div class="modal fade" id="userProfileModal" data-backdrop="static" role="dialog" aria-labelledby="userProfileModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title">사용자 정보</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal form-label-left input_mask" id="userProfileForm">
					<div class="form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12">사용자ID</label>
						<div class="col-md-9 col-sm-9 col-xs-12">
							<input type="text" class="form-control" name="userId" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12">사용자명</label>
						<div class="col-md-9 col-sm-9 col-xs-12">
							<input type="text" class="form-control" name="userNm" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12">이메일</label>
						<div class="col-md-9 col-sm-9 col-xs-12">
							<input type="text" class="form-control" name="email" readonly>
						</div>
					</div>
					<div class="form-group">
						<label class="control-label col-md-3 col-sm-3 col-xs-12">휴대전화번호</label>
						<div class="col-md-9 col-sm-9 col-xs-12">
							<input type="text" class="form-control" name="mpNo" readonly>
						</div>
					</div>
				</form>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
