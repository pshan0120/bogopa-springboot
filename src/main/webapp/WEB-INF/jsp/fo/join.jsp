<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/fo/includeHeader.jspf"%>
<script>
	$(function() {
		var invtMmbrNo = "<c:out value='${invtMap.mmbrNo}'/>";
		if(invtMmbrNo != "") {
			$("#showClubJoinDiv").show();
		}
	});

	function fn_doJoin() {
		if(gfn_validate("form")) {
			var invtMmbrNo = "<c:out value='${invtMap.mmbrNo}'/>";
			var clubNo = "<c:out value='${clubMap.clubNo}'/>";
			var joinAnswr = $("#showClubJoinDiv textarea[name='joinAnswr']").val();
			if(invtMmbrNo != "" && joinAnswr == "") {
				alert("필수 항목을 입력해 주세요.[가입질문 답변]");
				return;
			}
			
			var comAjax = new ComAjax("form");
			comAjax.setUrl("<c:url value='/doJoin' />");
			comAjax.setCallback("fn_doJoinCallback");
			if(invtMmbrNo != "") {
				comAjax.addParam("invtMmbrNo", invtMmbrNo);
				comAjax.addParam("clubNo", clubNo);
			}
			comAjax.ajax();
		}
	}

	function fn_doJoinCallback(data) {
		if(data.result) {
			alert(data.resultMsg);
			document.location.href = "/";
		} else {
			alert(data.resultMsg);
		}
	}
	
	function fn_openUseTrmsModal() {
		$("#useTrmsModal").modal("show");
	}
	
</script>
</head>

<body class="bg-default">
	<%@ include file="/WEB-INF/include/fo/includeBody.jspf"%>
	<div class="main-content">
		<%@ include file="/WEB-INF/jsp/fo/navbar.jsp"%>
		
		<!-- Header -->
		<div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
			<div class="container">
				<div class="header-body text-center mb-7">
					<div class="row justify-content-center">
						<div class="col-lg-8 col-md-8">
							<h1 class="text-white">반갑다 소년!</h1>
							<p class="text-lead text-light">웰컴 투 더 보겜월드</p>
						</div>
					</div>
				</div>
			</div>
			<div class="separator separator-bottom separator-skew zindex-100">
				<svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1" xmlns="http://www.w3.org/2000/svg">
					<polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
				</svg>
			</div>
		</div>
		<!-- Page content -->
		<div class="container mt--7">
			<div class="row justify-content-center">
				<div class="col-lg-5 col-md-7">
					<div class="card bg-secondary shadow border-0">
						<div class="card-body px-lg-5 py-lg-5">
							<form role="form" id="form">
								<div class="form-group mb-3">
									<div class="input-group input-group-alternative">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="ni ni-email-83"></i></span>
										</div>
										<input class="form-control hasValue emailOnly" name="email" data-name="이메일" placeholder="이메일" type="email" >
									</div>
								</div>
								<div class="form-group">
									<div class="input-group input-group-alternative mb-3">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="ni ni-hat-3"></i></span>
										</div>
										<input class="form-control hasValue" name="nickNm" data-name="닉네임" placeholder="닉네임" type="text">
									</div>
								</div>
								<div class="form-group">
									<div class="input-group input-group-alternative">
										<div class="input-group-prepend">
											<span class="input-group-text"><i class="ni ni-lock-circle-open"></i></span>
										</div>
										<input class="form-control hasValue pswrdOnly" name="pswrd" data-name="비밀번호" placeholder="비밀번호" type="password">
									</div>
								</div>
								
								<div id="showClubJoinDiv" class="display-none">
									<hr class="my-4" />
									<div class="row clearfix">
										<div class="col-lg-12">
											<div class="form-group">
												<label class="form-control-label">[<c:out value='${clubMap.clubNm}'/>] 소개</label>
												<textarea rows="4" name="intrdctn" class="form-control form-control-alternative" readonly>
													<c:out value='${clubMap.intrdctn}'/>
												</textarea>
											</div>
										</div>
										<div class="col-lg-12">
											<div class="form-group">
												<label class="form-control-label">가입질문</label>
												<textarea rows="4" name="joinQstn" class="form-control form-control-alternative" readonly>
													<c:out value='${clubMap.joinQstn}'/>
												</textarea>
											</div>
										</div>
										<div class="col-lg-12">
											<div class="form-group">
												<label class="form-control-label">답변작성</label>
												<textarea rows="4" name="joinAnswr" class="form-control form-control-alternative"></textarea>
											</div>
										</div>
									</div>
								</div>
								
								<div class="row my-4">
									<div class="col-12">
										<div class="custom-control custom-control-alternative custom-checkbox">
											<input class="custom-control-input hasValue" data-name="이용약관 동의" id="customCheckRegister" type="checkbox">
											<label class="custom-control-label" for="customCheckRegister">
												<span class="text-muted"><a href="javascript:(void(0));" onclick="fn_openUseTrmsModal();" >이용약관</a>에 동의합니다.</span>
											</label>
										</div>
									</div>
								</div>
								<div class="text-center">
									<button type="button" class="btn btn-primary btn-block" onclick="fn_doJoin();">
										가입하기
									</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
	</div>
	
	<!-- 이용약관 모달 -->
	<div class="modal fade" id="useTrmsModal" role="dialog" aria-labelledby="useTrmsModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="useTrmsModalLabel">이용약관</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<p>
						약관은 우리 마음속에 있는 거죠?
					</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>

	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
	
</body>
</html>