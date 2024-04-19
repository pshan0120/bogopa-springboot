<%@ page pageEncoding="utf-8"%>

<script>
	function fn_openMmbrPrflModal(mmbrNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectMmbrPrfl' />");
		comAjax.setCallback("fn_openMmbrPrflModalCallback");
		comAjax.addParam("mmbrNo", mmbrNo);
		comAjax.ajax();
	}
	
	function fn_openMmbrPrflModalCallback(data) {
		gfn_setDataVal(data.map, "mmbrPrflForm");
		
		if(data.map.prflImgFileNm != "") {
			$("#mmbrPrflImg").attr("src", "https://bogopayo.cafe24.com/img/mmbr/" + data.map.mmbrNo + "/" + data.map.prflImgFileNm);
		} else {
			$("#mmbrPrflImg").attr("src", "https://bogopayo.cafe24.com/img/mmbr/default.png");
		}
		
		$("#mmbrPrflModal").modal("show");
	}
</script>

<!-- 회원프로필 모달 -->
<div class="modal fade" id="mmbrPrflModal" role="dialog" aria-labelledby="mmbrPrflModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="mmbrPrflModalLabel">회원프로필</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="mmbrPrflForm">
					<input type="hidden" name="mmbrNo">
					<div class="row clearfix">
						<div class="col-lg-12">
							<div class="form-group">
								<img src="" id="mmbrPrflImg" class="img-responsive img-thumbnail m-auto">
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">모임</label>
								<input type="text" name="mmbrClubNm" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-6">
							<div class="form-group">
								<label class="form-control-label">등급</label>
								<input type="text" name="mmbrTypeNm" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-6">
							<div class="form-group">
								<label class="form-control-label">플레이횟수</label>
								<input type="text" name="playCnt" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">닉네임</label>
								<input type="text" name="nickNm" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">소개</label>
								<textarea rows="4" name="intrdctn" class="form-control form-control-alternative" readonly></textarea>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
