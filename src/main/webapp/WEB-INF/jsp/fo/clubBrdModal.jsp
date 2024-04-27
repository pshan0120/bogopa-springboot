<%@ page pageEncoding="utf-8"%>

<script>
	function fn_openClubBrdModal(seq) {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectClubBrd' />");
		comAjax.setCallback("fn_openClubBrdModalCallback");
		comAjax.addParam("seq", seq);
		comAjax.ajax();
	}
	
	function fn_openClubBrdModalCallback(data) {
		gfn_setDataVal(data.map, "clubBrdForm");
		
		$("#clubBrdModal").modal("show");
	}

	function fn_openInsertClubBrdModal() {
		$("#insertClubBrdForm input[name='clubNo']").val($("#clubNo").val());
		$("#insertClubBrdModal").modal("show");
	}
	
	function fn_insertClubBrd() {
		if(gfn_validate("insertClubBrdForm")) {
			const comAjax = new ComAjax("insertClubBrdForm");
			comAjax.setUrl("<c:url value='/insertClubBrd' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		}
	}
	
	function fn_openUpdateClubBrdModal(seq) {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectClubBrd' />");
		comAjax.setCallback("openUpdateClubBrdModalCallback");
		comAjax.addParam("seq", seq);
		comAjax.ajax();
	}
	
	function openUpdateClubBrdModalCallback(data) {
		gfn_setDataVal(data.map, "updateClubBrdForm");
		$("#updateClubBrdModal").modal("show");
	}
	
	function fn_updateClubBrd() {
		if(gfn_validate("updateClubBrdForm")) {
			const comAjax = new ComAjax("updateClubBrdForm");
			comAjax.setUrl("<c:url value='/updateClubBrd' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		}
	}
	
</script>

<!-- 모임 게시물 모달 -->
<div class="modal fade" id="clubBrdModal" role="dialog" aria-labelledby="clubBrdModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="clubBrdModalLabel">모임 게시물</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="clubBrdForm">
					<input type="hidden" name="seq">
					<div class="row clearfix">
						<div class="col-lg-6">
							<div class="form-group">
								<label class="form-control-label">작성자</label>
								<input type="text" name="nickNm" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-6">
							<div class="form-group">
								<label class="form-control-label">작성일시</label>
								<input type="text" name="insDt" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*게시물유형</label>
								<select data-name="게시물유형" name="brdTypeCd" class="form-control form-control-alternative" readonly>
									<c:choose>
										<c:when test="${fn:length(clubBrdTypeCdList) > 0}">
											<c:forEach var="row" items="${clubBrdTypeCdList}" varStatus="status">
												<option value="${row.cd}">${row.nm}</option>
											</c:forEach>
										</c:when>
									</c:choose>
								</select>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">제목</label>
								<input type="text" name="title" class="form-control form-control-alternative" readonly>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">내용</label>
								<textarea rows="4" name="cntnts" class="form-control form-control-alternative" readonly></textarea>
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

<!-- 모임 게시물 작성 모달 -->
<div class="modal fade" id="insertClubBrdModal" role="dialog" aria-labelledby="insertClubBrdModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="insertClubBrdModalLabel">모임 게시물 작성</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="insertClubBrdForm">
					<input type="hidden" name="clubNo">
					<div class="row clearfix">
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*게시물유형</label>
								<select data-name="게시물유형" name="brdTypeCd" class="form-control form-control-alternative hasValue" >
									<c:choose>
										<c:when test="${fn:length(clubBrdTypeCdList) > 0}">
											<c:forEach var="row" items="${clubBrdTypeCdList}" varStatus="status">
												<c:if test="${mmbrTypeCd eq '2'}">
													<option value="${row.cd}">${row.nm}</option>
												</c:if>
												<c:if test="${mmbrTypeCd ne '2'}">
													<c:if test="${row.cd ne '1'}">
														<option value="${row.cd}">${row.nm}</option>
													</c:if>
												</c:if>
											</c:forEach>
										</c:when>
									</c:choose>
								</select>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*제목</label>
								<input type="text" data-name="제목" name="title" class="form-control form-control-alternative hasValue" >
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*내용</label>
								<textarea rows="4" data-name="내용" name="cntnts" class="form-control form-control-alternative hasValue" ></textarea>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" onclick="fn_insertClubBrd();">등록</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>

<!-- 모임 게시물 수정 모달 -->
<div class="modal fade" id="updateClubBrdModal" role="dialog" aria-labelledby="updateClubBrdModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="updateClubBrdModalLabel">모임 게시물 수정</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="updateClubBrdForm">
					<input type="hidden" name="seq">
					<div class="row clearfix">
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*게시물유형</label>
								<select data-name="게시물유형" name="brdTypeCd" class="form-control form-control-alternative hasValue" >
									<c:choose>
										<c:when test="${fn:length(clubBrdTypeCdList) > 0}">
											<c:forEach var="row" items="${clubBrdTypeCdList}" varStatus="status">
												<c:if test="${row.cd ne '1'}">
													<option value="${row.cd}">${row.nm}</option>
												</c:if>
											</c:forEach>
										</c:when>
									</c:choose>
								</select>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*제목</label>
								<input type="text" data-name="제목" name="title" class="form-control form-control-alternative hasValue" >
							</div>
						</div>
						<div class="col-lg-12">
							<div class="form-group">
								<label class="form-control-label">*내용</label>
								<textarea rows="4" data-name="내용" name="cntnts" class="form-control form-control-alternative hasValue" ></textarea>
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" onclick="fn_updateClubBrd();">수정</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
