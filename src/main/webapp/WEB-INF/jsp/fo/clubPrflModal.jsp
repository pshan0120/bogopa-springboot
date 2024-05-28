<%@ page pageEncoding="utf-8"%>

<script>
	function fn_openClubPrflModal(clubNo) {
		fn_selectClubPrfl(clubNo);
		fn_selectClubMmbrList(1);
		fn_selectClubGameList(1);

		fn_selectClubPlayRecordList(1);
		fn_selectClubPlayImgList(1);
	}

	function fn_selectClubPrfl(clubNo) {
		const comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectClubPrfl' />");
		comAjax.setCallback("fn_selectClubPrflCallback");
		comAjax.addParam("clubNo", clubNo);
		comAjax.ajax();
	}
	
	function fn_selectClubPrflCallback(data) {
		gfn_setDataVal(data.map, "clubPrflForm");
		gfn_setDataVal(data.map, "clubJoinForm");
		
		if(data.map.prflImgFileNm != "") {
			$("#clubPrflImg").attr("src", "https://bogopayo.cafe24.com/img/club/" + data.map.clubNo + "/" + data.map.prflImgFileNm);
		} else {
			$("#clubPrflImg").attr("src", "https://bogopayo.cafe24.com/img/club/default.png");
		}

		$("#showClubJoinBtn").hide();
		$("#quitClubBtn").hide();
		$("#cancelClubJoinBtn").hide();
		$("#dsprsClubBtn").hide();
		if(data.isLogin == true) {
			if(data.map.mstrMmbrYn == "N") {
				if(data.map.mmbrClubJoinIngYn == "N") {
					if(data.map.clubJoinYn != "Y") {
						$("#showClubJoinBtn").show();
					}
					if(data.map.mstrMmbrYn == "N" && data.map.quitClubYn == "Y") {
						$("#quitClubBtn").show();
					}
				} else {
					if(data.map.joinClubIngYn == "Y") {
						$("#cancelClubJoinBtn").show();
					}
				}
			} else {
				$("#dsprsClubBtn").show();
			}
		}
	}

	function fn_selectClubMmbrList(pageNo) {
		const comAjax = new ComAjax("clubPrflForm");
		comAjax.setUrl("<c:url value='/selectClubMmbrList' />");
		comAjax.setCallback("fn_selectClubMmbrListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}
	
	function fn_selectClubMmbrListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubMmbrListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan=\"4\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "clubMmbrListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubMmbrList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<span class=\"avatar avatar-sm rounded-circle mr-3\" >";
				if(value.prflImgFileNm == "default") {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\" class=\"rounded-circle\">";
				} else {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + value.mmbrNo + "/" + value.prflImgFileNm + "\">";
				}
				str += "			</span>";
				str += "			<div class=\"media-body\">";
				str += "				<span class=\"mb-0 text-sm\">" + value.nickNm + "</span>";
				str += "			</div>";
				str += "		</div>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.clubMmbrGrdNm;
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.fromDate;
				str += "	</td>";
				str += "	<td>";
				str += "		" + gfn_comma(value.playCnt);
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
		
		$("#clubPrflModal").modal("show");
	}

	function fn_selectClubGameList(pageNo) {
		const comAjax = new ComAjax("clubPrflForm");
		comAjax.setUrl("<c:url value='/selectClubGameList' />");
		comAjax.setCallback("fn_selectClubGameListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}
	
	function fn_selectClubGameListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubGameListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan=\"3\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "clubGameListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubGameList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		" + value.gameNm;
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.minPlyrCnt + " ~ " + value.maxPlyrCnt;
				str += "	</td>";
				str += "	<td>";
				str += "		" + gfn_comma(value.playCnt);
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
		
		$("#clubPrflModal").modal("show");
	}

	function fn_showClubJoin() {
		$("#clubJoinBtn").show();
		$("#showClubJoinDiv").show();
		$("#showClubJoinBtn").hide();
	}

	function fn_clubJoin() {
		if(gfn_validate("clubJoinForm")) {
			if(confirm("모임에 가입 신청하시겠습니까?")) {
				const comAjax = new ComAjax("clubJoinForm");
				comAjax.setUrl("<c:url value='/clubJoin' />");
				comAjax.setCallback("gfn_defaultCallback");
				comAjax.ajax();
			} else {
				return;
			}
		}
	}

	function fn_cancelClubJoin() {
		if(confirm("가입 신청을 취소하시겠습니까?")) {
			const comAjax = new ComAjax("clubPrflForm");
			comAjax.setUrl("<c:url value='/cancelClubJoin' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}
	
	function fn_quitClub() {
		if(confirm("모임에서 탈퇴하시겠습니까?")) {
			const comAjax = new ComAjax("clubPrflForm");
			comAjax.setUrl("<c:url value='/quitClub' />");
			comAjax.setCallback("gfn_defaultCallback");
			comAjax.ajax();
		} else {
			return;
		}
	}

	function fn_dsprsClub() {
		alert("개발 예정입니다.");
		return;
	}

	function fn_selectClubPlayRecordList(pageNo) {
		const comAjax = new ComAjax("clubPrflForm");
		comAjax.setUrl("<c:url value='/selectMyClubPlayRecordList' />");
		comAjax.setCallback("fn_selectClubPlayRecordListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}

	function fn_selectClubPlayRecordListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubPlayListTbl>tbody");
		body.empty();
		
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan=\"3\" class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "clubPlayListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubPlayRecordList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td>";
				str += "		" + value.playNm;
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.gameNm;
				str += "	</td>";
				str += "	<td>";
				str += "		"+ value.endDt;
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}

	function fn_selectClubPlayImgList(pageNo) {
		const comAjax = new ComAjax("clubPrflForm");
		comAjax.setUrl("<c:url value='/selectMyClubPlayImgList' />");
		comAjax.setCallback("fn_selectClubPlayImgListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 1);
		comAjax.ajax();
	}

	function fn_selectClubPlayImgListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubPlayImgListDiv");
		body.empty();
		var str = "";
		if(cnt == 0) {
			$("#clubPlayImgListPageNav").hide();
			$("#clubPlayImgListDiv").hide();
		} else {
			var params = {
				divId : "clubPlayImgListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubPlayImgList",
				recordCount : 1
			};
			gfn_renderPaging(params);

			str += "<hr class=\"my-4\" />";
			str += "<h5>플레이소감</h5>";
			str += "<div class=\"row clearfix\">";
			$.each(data.map.list, function(key, value) {
				str += "<div class=\"col-lg-12 mb-4\">";
				str += "	<div class=\"card\">";
				str += "		<img src=\"https://bogopayo.cafe24.com/img/play/" + value.seq + "/" + value.fdbckImgFileNm + "\" class=\"card-img-top\">";
				str += "		<div class=\"card-body\">";
				str += "			<p class=\"card-text\">\"" + value.fdbck + "\"</p>";
				str += "			<div class=\"card-text-footer\">" + value.nickNm + ", <cite>" + value.endDt + " " + value.gameNm + " " + value.rsltRnk + "등</cite></div>";
				str += "		</div>";
				str += "	</div>";
				str += "</div>";
			});
			str += "</div>";
			$("#clubPlayImgListDiv").show();
			$("#clubPlayImgListPageNav").show();
		}
		body.append(str);
	}
	
</script>

<!-- 모임프로필 모달 -->
<div class="modal fade" id="clubPrflModal" role="dialog" aria-labelledby="clubPrflModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="clubPrflModalLabel">모임프로필</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="nav-wrapper">
					<ul class="nav nav-pills nav-fill flex-column flex-md-row" role="tablist">
						<li class="nav-item">
							<a class="nav-link active" id="clubPrflTab1A" data-toggle="tab" href="#clubPrflTab1" role="tab" aria-controls="clubPrflTab1" aria-selected="true">
								모임정보
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="clubPrflTab2A" data-toggle="tab" href="#clubPrflTab2" role="tab" aria-controls="clubPrflTab2" aria-selected="false">
								모임회원
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="clubPrflTab3A" data-toggle="tab" href="#clubPrflTab3" role="tab" aria-controls="clubPrflTab3" aria-selected="false">
								보유게임
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link" id="clubPrflTab3A" data-toggle="tab" href="#clubPrflTab4" role="tab" aria-controls="clubPrflTab4" aria-selected="false">
								최근 활동
							</a>
						</li>
					</ul>
				</div>
				<div class="tab-content">
					<div id="clubPrflTab1" class="tab-pane fade show active" role="tabpanel" aria-labelledby="clubPrflTab1A">
						<form id="clubPrflForm">
							<input type="hidden" name="clubNo">
							<div class="row clearfix">
								<div class="col-lg-12">
									<div class="form-group">
										<img src="" id="clubPrflImg" class="img-responsive img-thumbnail m-auto">
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="form-control-label">모임</label>
										<input type="text" name="clubNm" class="form-control form-control-alternative" readonly>
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label class="form-control-label">모임장</label>
										<input type="text" name="mstrMmbrNm" class="form-control form-control-alternative" readonly>
									</div>
								</div>
								<div class="col-lg-6">
									<div class="form-group">
										<label class="form-control-label">등급</label>
										<input type="text" name="clubGrdNm" class="form-control form-control-alternative" readonly>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="form-control-label">연락처</label>
										<input type="text" name="telNo" class="form-control form-control-alternative" readonly>
									</div>
								</div>
								<div class="col-lg-12">
									<div class="form-group">
										<label class="form-control-label">주소</label>
										<input type="text" name="addrs" class="form-control form-control-alternative" readonly>
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
						<div id="showClubJoinDiv" class="display-none">
							<hr class="my-4" />
							<form id="clubJoinForm">
								<input type="hidden" name="clubNo">
								<div class="row clearfix">
									<div class="col-lg-12">
										<div class="form-group">
											<label class="form-control-label">가입질문</label>
											<textarea rows="4" name="joinQstn" class="form-control form-control-alternative" readonly></textarea>
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<label class="form-control-label">답변작성</label>
											<textarea rows="4" name="joinAnswr" class="form-control form-control-alternative hasValue"></textarea>
										</div>
									</div>
								</div>
							</form>
						</div>
					</div>
					
					<div id="clubPrflTab2" class="tab-pane fade" role="tabpanel" aria-labelledby="clubPrflTab2A">
						<div class="table-responsive">
							<table class="table align-items-center table-flush" id="clubMmbrListTbl">
								<thead class="thead-light">
									<tr>
										<th scope="col">닉네임</th>
										<th scope="col">등급</th>
										<th scope="col">가입일</th>
										<th scope="col">플레이횟수</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
						<nav aria-label="">
							<ul class="pagination pagination-sm justify-content-end mb-0" id="clubMmbrListPageNav"></ul>
						</nav>
					</div>
					
					<div id="clubPrflTab3" class="tab-pane fade" role="tabpanel" aria-labelledby="clubPrflTab3A">
						<div class="table-responsive">
							<table class="table align-items-center table-flush" id="clubGameListTbl">
								<thead class="thead-light">
									<tr>
										<th scope="col">게임</th>
										<th scope="col">플레이 가능인원</th>
										<th scope="col">플레이 횟수</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
						<nav aria-label="">
							<ul class="pagination pagination-sm justify-content-end mb-0" id="clubGameListPageNav"></ul>
						</nav>
					</div>
					
					<div id="clubPrflTab4" class="tab-pane fade" role="tabpanel" aria-labelledby="clubPrflTab4A">
						<h5>플레이기록</h5>
						<div class="table-responsive">
							<table class="table align-items-center table-flush" id="clubPlayListTbl">
								<thead class="thead-light">
									<tr>
										<th scope="col">플레이이름</th>
										<th scope="col">게임</th>
										<th scope="col">일시</th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
						<nav aria-label="">
							<ul class="pagination pagination-sm justify-content-end mb-0" id="clubPlayListPageNav"></ul>
						</nav>
						
						<div id="clubPlayImgListDiv"></div>
						<nav aria-label="">
							<ul class="pagination pagination-sm justify-content-end mb-0" id="clubPlayImgListPageNav"></ul>
						</nav>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-info display-none" id="showClubJoinBtn" onclick="fn_showClubJoin();">모임가입</button>
				<button type="button" class="btn btn-primary display-none" id="clubJoinBtn" onclick="fn_clubJoin();">가입요청</button>
				<button type="button" class="btn btn-warning display-none" id="cancelClubJoinBtn" onclick="fn_cancelClubJoin();">가입요청취소</button>
				<button type="button" class="btn btn-danger display-none" id="quitClubBtn" onclick="fn_quitClub();">모임탈퇴</button>
				<button type="button" class="btn btn-danger display-none" id="dsprsClubBtn" onclick="fn_dsprsClub();">모임해체</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
