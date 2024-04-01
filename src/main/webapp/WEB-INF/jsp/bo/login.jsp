<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/bo/includeHeader.jspf"%>
<%	
	String fromUri = (String) session.getAttribute("fromUri");
%>
<script>
	$(function() {
		$("#userId, #pswrd").keydown(function(key) {
			if(key.keyCode == 13) {
				fn_doLogin();
			}
		});

		var cookieLoginId = gfn_getCookie("loginId");
		if(cookieLoginId != "") {
			$("#userId").val(cookieLoginId);
			$("#saveIdCheckbox").attr("checked", true);
		}

		$("#saveIdCheckbox").on("ifChanged", function() {
			var _this = this;
			var isRemember;
				
			if($(_this).is(":checked")) {
				isRemember = confirm("이 기기에 로그인 정보를 저장하시겠습니까? PC방 등 공공장소에서는 개인정보가 유출될 수 있으니 주의해 주십시오.");
				if(!isRemember) {
					$(_this).attr("checked", false);
				}
			}
		});
	});
	
	function fn_doLogin() {
		if(gfn_validateForm("form")) {
			if($("#saveIdCheckbox").is(":checked")) { // 저장 체크시
				fn_saveLogin("loginId", $("#userId").val());
			} else { // 체크 해제시는 공백
				fn_saveLogin("loginId", "");
			}
			
			var comAjax = new ComAjax("form");
			comAjax.setUrl("<c:url value='/bo/doLogin' />");
			comAjax.setCallback("fn_doLoginCallback");
			comAjax.ajax();
		}
	}

	function fn_doLoginCallback(data) {
		if(data.result) {
			var fromUri = "<%= fromUri %>";
			if(fromUri == "" || fromUri == "null" || fromUri == null) {
				fromUri = "/bo";
			}
			document.location.href = fromUri;
		} else {
			alert(data.resultMsg);
		}
	}

	function fn_saveLogin(name, id) {
		if(id != "") {
			gfn_setCookie(name, id, 7);
		}else{
			gfn_setCookie(name, id, -1);
		}
	}

</script>
</head>

<body class="login">
	<%@ include file="/WEB-INF/include/bo/includeBody.jspf"%>
	
	<div>
		<div class="login_wrapper">
			<div class="animate form login_form">
				<section class="login_content">
					<form id="form">
						<div>
							<input type="text" class="form-control" placeholder="아이디" name="userId" id="userId" />
						</div>
						<div>
							<input type="password" class="form-control" placeholder="비밀번호" name="pswrd" id="pswrd" />
						</div>
						<div class="row">
							<div class="col-xs-6 col-md-6">
								<div class="checkbox text-left">
									<label style="padding-left:0px;">
										<input type="checkbox" class="flat" id="saveIdCheckbox"> 내 아이디 기억하기
									</label>
								</div>
							</div>
							<div class="col-xs-6 col-md-6 text-right">
								<button type="button" class="btn btn-default" onclick="fn_doLogin()">로그인</button>
							</div>
						</div>

						<div class="clearfix"></div>

						<div class="separator">
							<p class="change_link">
								<strong>계정 관련 문의</strong>&nbsp;&nbsp;chandy@zper.io
							</p>

							<div class="clearfix"></div>
							<br />
							<div>
								<p>ⓒ2019 All Rights Reserved.</p>
							</div>
						</div>
					</form>
				</section>
			</div>

		</div>
	</div>
	
	<%@ include file="/WEB-INF/include/bo/includeFooter.jspf"%>
</body>
</html>