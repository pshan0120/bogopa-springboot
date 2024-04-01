<%--
***************************************************************************************************
* 업무 그룹명 : F/O
* 서브 업무명 : F/O 마이페이지
* 설명 : 구매내역
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
		// 현금영수증 체크 시 박스 보임
		$('#cashReceiptChk').each(function () {
			$(this).on('click', function () {
				fn_cashReceiptChk();
			});
			$(this).parent().find('.checkBox_style').click(function () {
				fn_cashReceiptChk();
			});
		});

		// 현금영수증, 세금계산서 체크
		$('.check_Box_deduction').each(function () {
			$(this).find('.radio_box .radio_input[name="deductionChk"], .radio_box .checkBox_style').on(
				'click',
				function () {
					var $list = $('.select_box_list .list');

					if ($(this).hasClass("deduction")) {
						$list.addClass('none');
						$('.select_box_list .list.deductionList').removeClass('none');
					} else if ($(this).hasClass("expense")) {
						$list.addClass('none');
						$('.select_box_list .list.expenseList').removeClass('none');
					}
				});
		});
		
		fn_selectMyHistory(1);
	});
	
	function fn_selectMyHistory(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectMyHistory' />");
		comAjax.setCallback("fn_selectMyHistoryCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 10);
		comAjax.ajax();
	}
	
	function fn_selectMyHistoryCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#dpsReqListTbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='5' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "pageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectMyHistory",
				recordCount : 10
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr class=\"pList\">";
				str += "	<td>";
				str += "		<span class=\"type\">" + value.planTypeNm + "</span>";
				str += "	</td>";
				str += "	<td>";
				str += "		<span class=\"price\">" + gfn_comma(value.reqAmt) + "</span>원";
				str += "	</td>";
				str += "	<td>";
				str += "		<span class=\"req_date\">" + value.reqDate + "</span>";
				str += "	</td>";
				str += "	<td>";
				if(value.cnfrmYn == "Y") {
					str += "		<span class=\"period\">" + value.cnfrmFromDate + " ~ " + value.cnfrmToDate + "</span>";
				} else {
					str += "		<span class=\"period\">입금확인 중</span>";
				}
				str += "	</td>";
				str += "	<td>";
				if(value.evdncCd == "1") {	// 미요청
					str += "		<button type=\"button\" class=\"button mini\" onclick='fn_openDpstReqModal(" + value.seq + ")'>요청</button>";
				} else {	// 요청
					if(value.evdncIssYn == "Y") {	// 발급완료
						str += "	<span>발급일 : " + value.evdncIssDate + "</span>";
					} else {
						str += "	<button type=\"button\" class=\"button mini end\">요청완료</button>";
					}
				}
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_openDpstReqModal(seq) {
		$("#evdncIssReqModal input[name='seq']").val(seq);
		$("#evdncIssReqModal").modal({
			escapeClose: false,
			clickClose: false,
			showClose: false
		});
	}

	function fn_evdncIssReq() {
		var seq = $("#evdncIssReqModal input[name='seq']").val();
		var evdncCd = "";
		var evdncMmbrNm = "";
		var evdncMpNo = "";
		var evdncBizNm = "";
		var evdncCeoNm = "";
		var evdncBizNo = "";
		
		if($("#deduction").prop("checked")) {
			evdncCd = "2";	// 증빙 현금영수증
			evdncMmbrNm = $("#evdncMmbrNm").val();
			evdncMpNo = $("#evdncMpNo").val();
			if(gfn_isEmpty(evdncMmbrNm)) {
				alert("필수 항목을 입력해 주세요.[이름]");
				$("#evdncMmbrNm").focus();
				return;
			}
			if(gfn_isEmpty(evdncMpNo)) {
				alert("필수 항목을 입력해 주세요.[휴대전화번호]");
				$("#evdncMpNo").focus();
				return;
			}
			if(!gfn_isMpNo(evdncMpNo)) {
				alert("휴대전화번호 형식이 맞지 않습니다.");
				$("#evdncMpNo").focus();
				return;
			}
		} else {
			evdncCd = "3";	// 증빙 세금계산서
			evdncBizNm = $("#evdncBizNm").val();
			evdncCeoNm = $("#evdncCeoNm").val();
			evdncBizNo = $("#evdncBizNo").val();
			if(gfn_isEmpty(evdncBizNm)) {
				alert("필수 항목을 입력해 주세요.[상호]");
				$("#evdncBizNm").focus();
				return;
			}
			if(gfn_isEmpty(evdncCeoNm)) {
				alert("필수 항목을 입력해 주세요.[대표자명]");
				$("#evdncCeoNm").focus();
				return;
			}
			if(gfn_isEmpty(evdncBizNo)) {
				alert("필수 항목을 입력해 주세요.[사업자번호]");
				$("#evdncBizNo").focus();
				return;
			}
			if(!gfn_isBizNo(evdncBizNo)) {
				alert("사업자번호 형식이 맞지 않습니다.");
				$("#evdncBizNo").focus();
				return;
			}
		}
		
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/updateDpstReq' />");
		comAjax.setCallback("fn_evdncIssReqCallback");
		comAjax.addParam("seq", seq);
		comAjax.addParam("evdncCd", evdncCd);
		if(evdncCd == "2") {
			comAjax.addParam("evdncMmbrNm", evdncMmbrNm);
			comAjax.addParam("evdncMpNo", evdncMpNo);
		} else if(evdncCd == "3") {
			comAjax.addParam("evdncBizNm", evdncBizNm);
			comAjax.addParam("evdncCeoNm", evdncCeoNm);
			comAjax.addParam("evdncBizNo", evdncBizNo);
		}
		comAjax.ajax();
	}

	function fn_evdncIssReqCallback(data) {
		if(data.result) {
			document.location.href = "/myHistory";
		} else {
			alert(data.resultMsg);
		}
	}
	
</script>
</head>

<body>
	<%@ include file="/WEB-INF/include/fo/includeBody.jspf"%>
	<div id="wrap">
		<%@ include file="/WEB-INF/jsp/fo/headerOnLogin.jsp"%>
		
		<!-- content area -->
		<div id="mainContent">
			<section id="container">
				<div class="container_in">
					<div class="head">
						<h1 class="title">마이페이지</h1>
					</div>

					<div id="myPageWrap">
						<nav class="menuTab">
							<div class="list">
								<a href="/myPage" class="link">내 정보</a>
								<a href="/myHistory" class="link active">구매내역</a>
								<a href="/myPswrdChange" class="link">비밀번호 변경</a>
							</div>
						</nav>

						<div class="myHistory_table">
							<table id="boraTableList" class="table">
								<colgroup>
									<col width="18%" span="3">
									<col width="20%" span="*">
								</colgroup>
								<thead>
									<tr>
										<th>플랜</th>
										<th>입금금액</th>
										<th>요청일</th>
										<th>기간</th>
										<th>증빙요청</th>
									</tr>
								</thead>
								<tbody id="dpsReqListTbody"></tbody>
							</table>
							<div class="text-center"><ul class="pagination pagination-sm" id="pageNav"></ul></div>
						</div>
					</div>
				</div>
			</section>
		</div>
		<!-- //content area -->
		
	</div>
	
	<!-- 증빙요청 Modal -->
	<article id="evdncIssReqModal" class="modal">
		<a href="" rel="modal:close" class="close-x-btn"><img src="../images/fo/ic_close.svg" alt="ic_close"></a>
		<section class="head">
			<h2>현금영수증, 세금계산서 요청</h2>
		</section>
		<section class="body scroll">
			<input type="hidden" name="seq" />
			<div class="cashReceipt_wrap">
				<div class="check_Box_deduction">
					<div class="radio_box">
						<input type="radio" id="deduction" name="deductionChk"
							class="radio_input deduction" checked />
						<div class="checkBox_style deduction">
							<span class="ic_chk"><i class="fas fa-check"></i></span>
						</div>
						<label for="deduction">현금영수증</label>
					</div>
					<div class="radio_box">
						<input type="radio" id="expense" name="deductionChk"
							class="radio_input expense" />
						<div class="checkBox_style expense">
							<span class="ic_chk"><i class="fas fa-check"></i></span>
						</div>
						<label for="expense">세금계산서</label>
					</div>
				</div>
				
				<ul class="select_box_list">
					<li class="list deductionList">
						<div class="input">
							<input type="text" id="evdncMmbrNm" placeholder="이름" maxlength="50" />
						</div>
						<div class="input">
							<input type="text" id="evdncMpNo" placeholder="휴대전화번호('-'제외)" maxlength="11" />
						</div>
					</li>
					<li class="list expenseList none">
						<div class="input">
							<input type="text" id="evdncBizNm" placeholder="상호" maxlength="50" />
						</div>
						<div class=" input">
							<input type="text" id="evdncCeoNm" placeholder="대표자명" maxlength="20" />
						</div>
						<div class="input">
							<input type="text" id="evdncBizNo" placeholder="사업자번호('-'제외)" maxlength="10" />
						</div>
					</li>
				</ul>

				<p class="text">
					현금영수증 발급을 위해 수집되는 정보로써 입금확인요청 시 5년간 처리 및 보관에 동의하는 것으로 간주합니다.
				</p>
				<div class="button_box">
					<button type="button" class="button join_button" onclick="fn_evdncIssReq();">
						요청
					</button>
				</div>
			</div>
		</section>
	</article>
	
	<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
</body>
</html>