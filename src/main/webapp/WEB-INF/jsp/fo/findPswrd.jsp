<%--
***************************************************************************************************
* 업무 그룹명 : F/O
* 서브 업무명 : F/O 로그인
* 설명 : 비밀번호 찾기
* 작성자 : 백승한
* 작성일 : 2019.12.09
* Copyright BoardgameGG. All Right Reserved
***************************************************************************************************
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/fo/includeHeader.jspf"%>

<script>
	$(function() {
		gfn_inputPlaceholder($("#mmbrWrap fieldset"));
	});

	function fn_resetPswrd() {
		if(gfn_validateForm("form")) {
			var comAjax = new ComAjax("form");
			comAjax.setUrl("<c:url value='/resetPswrd' />");
			comAjax.setCallback("fn_resetPswrdCallback");
			comAjax.ajax();
		}
	}

	function fn_resetPswrdCallback(data) {
		alert(data.resultMsg);
		if(data.result) {
			document.location.href = "/";
		}
	}
</script>
</head>

<body>
	<%@ include file="/WEB-INF/include/fo/includeBody.jspf"%>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/fo/header.jsp"%>
		
		<!-- content area -->
		<div id="mainContent">
			<section id="container">
				<div class="container_in">
					<div class="head">
						<h1 class="title">비밀번호 찾기</h1>
						<p class="text">
							가입시 입력하신 이메일로<br/>비밀번호 재설정 안내메일을 보내드립니다.
						</p>
					</div>
				</div>
				
				<div id="mmbrWrap">
					<form id="form" class="validateForm" >
						<fieldset>
							<div class="input">
								<input type="email" class="hasValue emailOnly" id="email" name="email" />
								<label for="email" class="placeholder">이메일</label>
							</div>
						</fieldset>
						
						<div class="button_box">
							<button type="button" class="button" onclick="fn_resetPswrd();">
								확인
							</button>
						</div>
					</form>
				</div>
			</section>
		</div>
		<!-- //content area -->
		
	</div>
	
	<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
</body>
</html>