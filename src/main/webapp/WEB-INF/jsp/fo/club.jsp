<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/include/fo/includeHeader.jspf"%>

<!-- 다음 주소찾기 적용  -->
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<!--  카카오 지도 적용 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=878b101b53e96c7e3a35c4c80a8bf320&libraries=clusterer"></script>

<script>
	var map;
	
	$(function() {
		fn_selectClubList(1);
		fn_selectClubBrdList(1);
		
		$("[data-toggle='tooltip']").tooltip();
	});
	
	function fn_selectClubList(pageNo) {
		var comAjax = new ComAjax("clubForm");
		comAjax.setUrl("<c:url value='/selectClubList' />");
		comAjax.setCallback("fn_selectClubListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}

	function fn_selectClubListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='3' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "clubListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubList",
				recordCount : 5
			};
			gfn_renderPaging(params);
			
			$.each(data.map.list, function(key, value) {
				str += "<tr>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openClubPrflModal('" + value.clubNo + "')\">";
				if(value.prflImgFileNm != "") {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/club/" + value.clubNo + "/" + value.prflImgFileNm + "\">";
				} else {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/club/default.png\">";
				}
				str += "			</a>";
				str += "			<div class=\"media-body\">";
				str += "				<a href=\"javascript:(void(0));\" onclick=\"fn_setMapPanTo(" + value.lat + "," + value.lng + ")\">";
				str += "					<span class=\"mb-0 text-sm\">";
				if(value.myClubYn == "Y") {
					str += "						" + value.clubNm + " <i class=\"small ni ni-shop\"></i>";
				} else {
					str += "						" + value.clubNm;
				}
				str += "					</span>";
				str += "				</a>";
				str += "			</div>";
				str += "		</div>";
				str += "	</td>";
				str += "	<td scope=\"row\">";
				str += "		<div class=\"media align-items-center\">";
				str += "			<a href=\"javascript:(void(0));\" class=\"avatar avatar-sm rounded-circle mr-3\" onclick=\"fn_openMmbrPrflModal('" + value.mstrMmbrNo + "')\">";
				if(value.mstrPrflImgFileNm != "") {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/" + value.mstrMmbrNo + "/" + value.mstrPrflImgFileNm + "\">";
				} else {
					str += "			<img src=\"https://bogopayo.cafe24.com/img/mmbr/default.png\">";
				}
				str += "			</a>";
				str += "			<div class=\"media-body\">";
				str += "				<span class=\"mb-0 text-sm\">" + value.mstrNickNm + "</span>";
				str += "			</div>";
				str += "		</div>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.clubGrdNm;
				str += "	</td>";
				str += "</tr>";
			});

			var positionsArr = new Array();
			$.each(data.mapList, function(key, value) {
				if(value.lat != "" && value.lng != "") {
					var latLngData = new Object();
					latLngData.lat = value.lat;
					latLngData.lng = value.lng;
					var clubDsctn = "<div class=\"mapInfo\">";
					clubDsctn += "	<div class=\"infoImg mt-2\">";
					if(value.prflImgFileNm != "") {
						clubDsctn += "	<img class=\"img-responsive img-thumbnail m-auto\" src=\"https://bogopayo.cafe24.com/img/club/" + value.clubNo + "/" + value.prflImgFileNm + "\">";
					} else {
						clubDsctn += "	<img class=\"img-responsive img-thumbnail m-auto\" src=\"https://bogopayo.cafe24.com/img/club/default.png\">";
					}
					clubDsctn += "	</div>";
					clubDsctn += "	<div class=\"infoTitle\">" + value.clubNm + "</div>";
					clubDsctn += "	<div class=\"infoCntns\">모임원 : " + gfn_comma(value.clubMmbrCnt) + "명</div>";
					clubDsctn += "	<div class=\"infoCntns\">보유게임 : " + gfn_comma(value.clubGameHasYCnt) + "개</div>";
					clubDsctn += "	<div class=\"infoCntns\">최근 모임일 : " + value.clubPlayDateMax + "</div>";
					clubDsctn += "	<div class=\"infoCntns\">주소 : " + value.addrs + "</div>";
					clubDsctn += "	<div class=\"mt-2\"><a href=\"https://map.kakao.com/link/to/" + value.clubNm + "," + value.lat + "," + value.lng + "\" target=\"_blank\" class=\"btn btn-sm btn-info btn-block\">모임 가는 길</a></div>";
					clubDsctn += "</div>";
					latLngData.content = clubDsctn;
					positionsArr.push(latLngData);
				}
			});
			
			fn_setMap(positionsArr);
			
			$("#clubDiv").show();
		}
		body.append(str);
	}

	function fn_setMap(positionsArr) {
		map = new kakao.maps.Map(document.getElementById('map'), { // 지도를 표시할 div
			center : new kakao.maps.LatLng(36.2683, 127.6358), // 지도의 중심좌표
			level : 14 // 지도의 확대 레벨
		});

		// 마커 클러스터러를 생성합니다
		// 마커 클러스터러를 생성할 때 disableClickZoom 값을 true로 지정하지 않은 경우
		// 클러스터 마커를 클릭했을 때 클러스터 객체가 포함하는 마커들이 모두 잘 보이도록 지도의 레벨과 영역을 변경합니다
		// 이 예제에서는 disableClickZoom 값을 true로 설정하여 기본 클릭 동작을 막고
		// 클러스터 마커를 클릭했을 때 클릭된 클러스터 마커의 위치를 기준으로 지도를 1레벨씩 확대합니다
		var clusterer = new kakao.maps.MarkerClusterer({
			map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
			averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
			minLevel: 10, // 클러스터 할 최소 지도 레벨
			disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
		});

		// 데이터를 가져와 마커를 생성하고 클러스터러 객체에 넘겨줍니다
		// 데이터에서 좌표 값을 가지고 마커를 표시합니다
		// 마커 클러스터러로 관리할 마커 객체는 생성할 때 지도 객체를 설정하지 않습니다
		var markers = $(positionsArr).map(function(i, position) {

			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({
				position : new kakao.maps.LatLng(position.lat, position.lng)
			});

			var infowindow = new kakao.maps.InfoWindow({
				removable : true,
				content: positionsArr[i].content // 인포윈도우에 표시할 내용
			});

			// 마커에 이벤트를 등록하는 함수 만들고 즉시 호출하여 클로저를 만듭니다
			// 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
			(function(marker, infowindow) {
				// 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다 
				kakao.maps.event.addListener(marker, "click", function() {
					infowindow.open(map, marker);
				});

				// 마커에 mouseout 이벤트를 등록하고 마우스 아웃 시 인포윈도우를 닫습니다
				/*kakao.maps.event.addListener(marker, "mouseout", function() {
					infowindow.close();
				});*/
			})(marker, infowindow);
			
			return marker;
		});

		// 클러스터러에 마커들을 추가합니다
		clusterer.addMarkers(markers);

		// 마커 클러스터러에 클릭이벤트를 등록합니다
		// 마커 클러스터러를 생성할 때 disableClickZoom을 true로 설정하지 않은 경우
		// 이벤트 헨들러로 cluster 객체가 넘어오지 않을 수도 있습니다
		kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
			
			// 현재 지도 레벨에서 1레벨 확대한 레벨
			var level = map.getLevel()-1;
			
			// 지도를 클릭된 클러스터의 마커의 위치를 기준으로 확대합니다
			map.setLevel(level, {anchor: cluster.getCenter()});
		});
	}
	
	function fn_setMapPanTo(lat, lng) {
		// 이동할 위도 경도 위치를 생성합니다 
		var moveLatLng = new kakao.maps.LatLng(lat, lng);
		
		// 지도 중심을 부드럽게 이동시킵니다
		// 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
		map.panTo(moveLatLng);
	}
	
	function fn_selectClubBrdList(pageNo) {
		var comAjax = new ComAjax();
		comAjax.setUrl("<c:url value='/selectClubBrdList' />");
		comAjax.setCallback("fn_selectClubBrdListCallback");
		comAjax.addParam("pageIndex", pageNo);
		comAjax.addParam("pageRow", 5);
		comAjax.ajax();
	}

	function fn_selectClubBrdListCallback(data) {
		var cnt = data.map.cnt;
		var body = $("#clubBrdListTbl>tbody");
		body.empty();
		var str = "";
		if(cnt == 0) {
			str += "<tr><td colspan='4' class=\"text-center\">조회결과가 없습니다.</td></tr>";
		} else {
			var params = {
				divId : "clubBrdListPageNav",
				pageIndex : "pageIndex",
				totalCount : cnt,
				eventName : "fn_selectClubBrdList",
				recordCount : 5
			};
			gfn_renderPaging(params);

			$.each(data.map.list, function(key, value) {
				str += "<tr>";
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
				str += "		" + value.brdTypeNm;
				str += "	</td>";
				str += "	<td>";
				str += "		<a href=\"javascript:(void(0));\" onclick=\"fn_openClubBrdModal('" + value.seq + "')\">";
				str += "			" + value.title;
				str += "		</a>";
				str += "	</td>";
				str += "	<td>";
				str += "		" + value.insDt;
				str += "	</td>";
				str += "</tr>";
			});
		}
		body.append(str);
	}
	
	function fn_openInsertClubModal() {
		$("#insertClubModal").modal("show");
	}
	
	function fn_insertClub() {
		if(gfn_validate("insertClubForm")) {
			var url = "<c:url value='/insertClub'/>";
			$("#insertClubForm").ajaxForm({
				url: url,
				type : 'POST',
				dataType : 'JSON',
				data : {},
				success: function(data){
					gfn_defaultCallback(data);
				}
			});
			// submit 필수
			$("#insertClubForm").submit();
		}
	}

</script>
</head>

<body class="bg-default">
	<%@ include file="/WEB-INF/include/fo/includeBody.jspf"%>
	<div class="main-content">
		<%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp"%>
		
		<!-- Header -->
		<div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
			<div class="container">
				<div class="header-body text-center mb-7">
					<div class="row justify-content-center">
						<div class="col-lg-8 col-md-8">
							<h1 class="text-white">너! 내 모임원이 되라!</h1>
							<p class="text-lead text-light">곧 세상은 대 보겜시대를 맞는다</p>
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
			<div class="row">
				<div class="col-xl-12 mb-5 mb-xl-0">
					<div class="card shadow mt-5">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-lg-6">
									<h3 class="mb-0">활동중인 모임</h3>
								</div>
								<div class="col-lg-6">
								<c:if test="${mmbrTypeCd eq '1' and clubNo eq ''}">
									<button type="button" class="btn btn-sm btn-primary float-right" onclick="fn_openInsertClubModal();">모임만들기</button>
								</c:if>
								</div>
							</div>
						</div>
						<div class="card-body">
							<div class="row clearfix">
								<div class="col-lg-5">
									<form id="clubForm" onsubmit="return false;">
										<div class="form-group">
											<label class="form-control-label">모임찾기</label>
											<input type="text" name="srchText" class="form-control form-control-alternative" 
												onKeypress="gfn_hitEnter(event, 'fn_selectClubList(1)');" placeholder="모임이름, 모임장이름, 주소">
										</div>
									</form>
								</div>
							</div>
							<div class="row clearfix">
								<div class="col-lg-5">
									<div class="table-responsive">
										<table class="table align-items-center table-flush" id="clubListTbl">
											<thead class="thead-light">
												<tr>
													<th scope="col">모임</th>
													<th scope="col">모임장</th>
													<th scope="col">등급</th>
												</tr>
											</thead>
											<tbody></tbody>
										</table>
									</div>
								</div>
								
								<div class="col-lg-7">
									<div id="map" style="width: 100%; height: 400px;"></div>
								</div>
							</div>
						</div>
						<div class="card-footer py-4">
							<nav aria-label="">
								<ul class="pagination pagination-sm justify-content-end mb-0" id="clubListPageNav"></ul>
							</nav>
						</div>
					</div>
					
					<div class="card shadow mt-5">
						<div class="card-header bg-white border-0">
							<div class="row">
								<div class="col-12">
									<h3 class="mb-0">전체 모임 게시물</h3>
								</div>
							</div>
						</div>
						<div class="card-body">
							<div class="table-responsive">
								<table class="table align-items-center table-flush" id="clubBrdListTbl">
									<thead class="thead-light">
										<tr>
											<th scope="col">작성자</th>
											<th scope="col">유형</th>
											<th scope="col">제목</th>
											<th scope="col">작성일시</th>
										</tr>
									</thead>
									<tbody></tbody>
								</table>
							</div>
						</div>
						<div class="card-footer py-4">
							<nav aria-label="">
								<ul class="pagination pagination-sm justify-content-end mb-0" id="clubBrdListPageNav"></ul>
							</nav>
						</div>
					</div>
					
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/jsp/fo/footer.jsp"%>
	</div>
	
	<!-- 모임만들기 Modal -->
	<div class="modal fade" id="insertClubModal" role="dialog" aria-labelledby="insertClubModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="">모임만들기</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id="insertClubForm" enctype="multipart/form-data">
						<div class="row clearfix">
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*모임이름</label>
									<input type="text" data-name="모임이름" name="clubNm" class="form-control form-control-alternative hasValue"
										placeholder="모임이름은 변경할 수 없으니 신중히 입력해 주세요.">
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">연락처</label>
									<input type="text" data-name="연락처" name="telNo" class="form-control form-control-alternative mpNoOnly">
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group">
									<label class="form-control-label">*우편번호</label>
									<input type="text" data-name="우편번호" id="zipCd" name="zipCd" class="form-control form-control-alternative" readonly>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group mt-4 pt-2">
									<button type="button" class="btn btn-info"
										onclick="gfn_findAddr('zipCd', 'addrs1', 'addrs2');">주소검색</button>
								</div>
							</div>
							
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*주소</label>
									<input type="text" data-name="주소" id="addrs1" name="addrs1" class="form-control form-control-alternative hasValue" readonly>
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*상세주소</label>
									<input type="text" data-name="상세주소" id="addrs2" name="addrs2" class="form-control form-control-alternative hasValue">
								</div>
							</div>
							
							<div class="col-lg-6">
								<div class="form-group">
									<label class="form-control-label">회비납부은행</label>
									<select data-name="회비납부은행" name="feeAccntBankCd" class="form-control form-control-alternative" >
										<option value="">선택하세요.</option>
										<c:choose>
											<c:when test="${fn:length(bankCdList) > 0}">
												<c:forEach var="row" items="${bankCdList}" varStatus="status">
													<option value="${row.cd}">${row.nm}</option>
												</c:forEach>
											</c:when>
										</c:choose>
									</select>
								</div>
							</div>
							<div class="col-lg-6">
								<div class="form-group">
									<label class="form-control-label">회비계좌명</label>
									<input type="text" data-name="회비계좌명" name="feeAccntNm" class="form-control form-control-alternative">
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">회비계좌번호</label>
									<input type="text" data-name="회비계좌번호" name="feeAccntNo" class="form-control form-control-alternative numberOnly">
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*회비(1회)</label>
									<input type="text" data-name="회비(1회)" name="feeType1Amt" value="0"
										class="form-control form-control-alternative numberOnly hasValue">
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*회비(기간)</label>
									<input type="text" data-name="회비(기간)" name="feeType2Amt" value="0"
										class="form-control form-control-alternative numberOnly hasValue">
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">*소개</label>
									<textarea rows="4" data-name="소개" name="intrdctn" class="form-control form-control-alternative hasValue"></textarea>
								</div>
							</div>
							<div class="col-lg-12">
								<div class="form-group">
									<label class="form-control-label">프로필이미지</label>
									<input type="file" data-name="프로필이미지" name="file" class="form-control form-control-alternative">
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary" onclick="fn_insertClub();">등록</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- 회원프로필 -->
	<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp"%>
	<!-- 모임프로필 -->
	<%@ include file="/WEB-INF/jsp/fo/clubPrflModal.jsp"%>
	<!-- 플레이기록 -->
	<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp"%>
	<!-- 모임게시물 -->
	<%@ include file="/WEB-INF/jsp/fo/clubBrdModal.jsp"%>
	
	<%@ include file="/WEB-INF/include/fo/includeFooter.jspf"%>
	
</body>
</html>
