<%@ page pageEncoding="utf-8"%>

<script>
	function fn_openClubGameModal() {
		$("#clubGameForm input[name='clubNo']").val($("#clubNo").val());
		fn_selectClubGameHasList(1);
		
		$('#clubGameModal').on('hide.bs.modal', function (e) {
			fn_selectMyClubGameList(1);
		});
		
		$("#clubGameModal").modal("show");
	}

	function fn_selectClubGameHasList(pageNo) {
		fn_selectClubGameHasNList(pageNo);
		fn_selectClubGameHasYList(pageNo);
	}
	
	function fn_selectClubGameHasNList(pageNo) {
		const comAjax = new ComAjax("clubGameForm");
		comAjax.setUrl("<c:url value='/selectClubGameHasList' />");
		comAjax.setCallback("fn_selectClubGameHasNListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.addParam("hasYn", "N");
		comAjax.ajax();
	}
	
	function fn_selectClubGameHasNListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubGameHasNListDiv");
		body.empty();
		var str = "";
		if(cnt > 0) {
			var params = {
				divId : "clubGameHasNListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubGameHasNList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<a class=\"btn btn-sm btn-outline-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_insertClubGame('" + value.gameNo + "')\" >";
				str += "	" + value.gameNm;
				str += "</a>";
			});
		}
		body.append(str);
	}

	function fn_selectClubGameHasYList(pageNo) {
		const comAjax = new ComAjax("clubGameForm");
		comAjax.setUrl("<c:url value='/selectClubGameHasList' />");
		comAjax.setCallback("fn_selectClubGameHasYListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.addParam("hasYn", "Y");
		comAjax.ajax();
	}
	
	function fn_selectClubGameHasYListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubGameHasYListDiv");
		body.empty();
		var str = "";
		if(cnt > 0) {
			var params = {
				divId : "clubGameHasYListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubGameHasYList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<a class=\"btn btn-sm btn-info mr-1 my-1\" href=\"javascript:(void(0));\" onclick=\"fn_deleteClubGame('" + value.gameNo + "')\" >";
				str += "	" + value.gameNm;
				str += "</a>";
			});
		}
		body.append(str);
	}
	
	function fn_insertClubGame(gameNo) {
		const comAjax = new ComAjax("myClubInfoForm");
		comAjax.setUrl("<c:url value='/insertClubGame' />");
		comAjax.setCallback("fn_reloadClubGame");
		comAjax.addParam("gameNo", gameNo);
		comAjax.ajax();
	}
	
	function fn_deleteClubGame(gameNo) {
		const comAjax = new ComAjax("myClubInfoForm");
		comAjax.setUrl("<c:url value='/deleteClubGame' />");
		comAjax.setCallback("fn_reloadClubGame");
		comAjax.addParam("gameNo", gameNo);
		comAjax.ajax();
	}

	function fn_reloadClubGame() {
		fn_selectClubGameHasList(1);
	}
	
</script>

<!-- 모임게임관리 모달 -->
<div class="modal fade" id="clubGameModal" role="dialog" aria-labelledby="clubGameModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="clubGameModalLabel">모임게임 관리</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<form id="clubGameForm" onsubmit="return false;">
					<input type="hidden" name="clubNo">
					<div class="row clearfix">
						<div class="col-lg-6">
							<div class="form-group">
								<label class="form-control-label">게임찾기</label>
								<input type="text" name="gameNm" class="form-control form-control-alternative" 
									onKeypress="gfn_hitEnter(event, 'fn_selectClubGameHasList(1)');" >
							</div>
						</div>
					</div>
				</form>
				<h3>모임 미보유게임</h3>
				<div class="mb-4" id="clubGameHasNListDiv">
				</div>
				<nav aria-label="">
					<ul class="pagination pagination-sm justify-content-end mb-0" id="clubGameHasNListPageNav"></ul>
				</nav>
				<hr class="my-4" />
				
				<h3>모임 보유게임</h3>
				<div class="mb-4" id="clubGameHasYListDiv">
				</div>
				<nav aria-label="">
					<ul class="pagination pagination-sm justify-content-end mb-0" id="clubGameHasYListPageNav"></ul>
				</nav>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
