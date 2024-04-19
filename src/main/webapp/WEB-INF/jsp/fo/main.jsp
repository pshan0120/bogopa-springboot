<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/fo/includeHeader.jspf"%>
<script>
	$(function() {
		fn_selectMain();
	});

	function fn_selectMain() {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectMain' />");
		comAjax.setCallback("fn_selectMainCallback");
		comAjax.ajax();
	}

	function fn_selectMainCallback(data) {
		var body = $("#playListTbl>tbody");
		body.empty();
		
		var str = "";
		if(data.playRcrdList.length == 0) {
			str += "<tr><td colspan=\"5\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			$.each(data.playRcrdList, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openPlayRcrdModal('" + value.playNo + "')\" >";
				str += "			" + value.playNm;
				str += "		</a>";
				str += "	</td>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
				if(value.clubPrflImgFileNm != "") {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/club/" + value.clubNo + "/" + value.clubPrflImgFileNm + "\">";
				} else {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/club/default.png\">";
				}
				str += "			</a>";
				str += "			<div class=\"media-body\">";
				str += "				<span class=\"mb-0 text-sm\">" + value.clubNm + "</span>";
				str += "			</div>";
				str += "		</div>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.gameNm;
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.strtDt + " ~ ";
				if(value.endDt != "") {
					str += value.endDt;
				}
				str += "	</td>";
				str += "	<td>";
				str += "		<div class=\"avatar-group\">";
				var playNickNms = value.playNickNms.split(",");
				var playMmbrNos = value.playMmbrNos.split(",");
				var playMmbrPrflImgFileNms = value.playMmbrPrflImgFileNms.split(",");
				for(var i in playNickNms) {
					str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm\" onclick=\"fn_openMmbrPrflModal('" + playMmbrNos[i] + "')\" data-toggle=\"tooltip\" data-original-title=\"" + playNickNms[i] + "\">";
					if(playMmbrPrflImgFileNms[i] == "default") {
						str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\" class=\"rounded-circle\">";
					} else {
						str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + playMmbrNos[i] + "/" + playMmbrPrflImgFileNms[i]  + "\" class=\"rounded-circle\">";
					}
					str += "			</a>";
				}
				str += "		</div>";
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);

		body = $("#clubBrdListTbl>tbody");
		body.empty();
		
		str = "";
		if(data.clubBrdList.length == 0) {
			str += "<tr><td colspan=\"4\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			$.each(data.clubBrdList, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		" + value.brdTypeNm;
				str += "	</td>";
				str += "	<td>";
				str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openClubBrdModal('" + value.seq + "')\">";
				str += "			" + value.title;
				str += "		</a>";
				str += "	</td>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openMmbrPrflModal('" + value.mmbrNo + "')\">";
				if(value.prflImgFileNm != "") {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + value.mmbrNo + "/" + value.prflImgFileNm + "\">";
				} else {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\">";
				}
				str += "			</a>";
				str += "			<div class=\"media-body\">";
				str += "				<span class=\"mb-0 text-sm\">" + value.nickNm + "</span>";
				str += "			</div>";
				str += "		</div>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.insDt;
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
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
						<div class="col-lg-5 col-md-6">
							<h1 class="text-white">
								보<span class="small">드게임 하</span>고파
							</h1>
							<p class="text-lead text-light">
								보드게임.. 하고 갈래요?
							</p>
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
		<div class="container mt--7">
			<div class="row">
				<div class="col">
					<div class="card shadow">
						<div class="card-header bg-white border-0">
							<h3 class="mb-0">최근 등록된 플레이</h3>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table align-items-center table-flush" id="playListTbl">
									<thead class="thead-light">
										<tr>
											<th scope="col">플레이</th>
											<th scope="col">모임</th>
											<th scope="col">게임</th>
											<th scope="col">일시</th>
											<th scope="col">플레이어</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row mt-5">
				<div class="col">
					<div class="card shadow">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-12">
									<h3 class="mb-0">새로운 게시글</h3>
								</div>
							</div>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table align-items-center table-flush" id="clubBrdListTbl">
									<thead class="thead-light">
										<tr>
											<th scope="col">유형</th>
											<th scope="col">제목</th>
											<th scope="col">작성자</th>
											<th scope="col">작성일시</th>
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
		<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
	</div>
	
	<!-- 플레이기록 -->
	<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp"%>
	<!-- 모임게시물 -->
	<%@ include file="/WEB-INF/jsp/fo/clubBrdModal.jsp"%>
	<!-- 회원프로필 -->
	<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp"%>
	<!-- 모임프로필 -->
	<%@ include file="/WEB-INF/jsp/fo/clubPrflModal.jsp"%>
		
	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
	
</body>
</html>
