<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script>
        const openBocTroubleBrewing = () => {
            window.location.href = "/game/trouble-brewing/play";
        }

        const openFruitShop = () => {
            window.location.href = "/game/fruit-shop/play";
        }

        const openCatchAThief = () => {
            window.location.href = "/game/catch-a-thief/play";
        }

        const openFoodChainMagnateCalculator = () => {
            window.location.href = "/game/food-chain-magnate/calculator";
        }

    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp" %>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">게임하기</h1>
                        <p class="text-lead text-light">내가 편하게 하려고 제작함</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="separator separator-bottom separator-skew zindex-100">
            <svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1"
                 xmlns="http://www.w3.org/2000/svg">
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
                            <div class="col-lg-12">
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-primary btn-block" onclick="openBocTroubleBrewing()">
                                블러드 온 더 클락타워 - 트러블 브루잉
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="openFruitShop()">
                                과일가게
                            </button>
                            <button type="button" class="btn btn-primary btn-block" onclick="openCatchAThief()">
                                도둑잡기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openFoodChainMagnateCalculator()">
                                푸드체인거물 계산기
                            </button>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<!-- 새로운 플레이 Modal -->
<div class="modal fade" id="insertPlayModal" role="dialog" aria-labelledby="insertPlayModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="">새로운 플레이</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="insertPlayForm">
                    <input type="hidden" name="hostMmbrNo">
                    <input type="hidden" name="hostNickNm">
                    <input type="hidden" name="clubNo">
                    <div class="row clearfix">
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label class="form-control-label">*플레이이름</label>
                                <input type="text" data-name="플레이이름" name="playNm"
                                       class="form-control form-control-alternative hasValue">
                            </div>
                        </div>
                    </div>
                </form>

                <label class="form-control-label">*플레이어</label>
                <div class="mb-4" id="playJoinMmbrNListDiv"></div>
                <div class="table-responsive">
                    <table class="table align-items-center table-flush" id="playMmbrListTbl">
                        <thead class="thead-light">
                        <tr>
                            <th scope="col">닉네임</th>
                            <th scope="col" colspan="2">세팅</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="insertPlay();">등록</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>

<!-- 회원프로필 -->
<%@ include file="/WEB-INF/jsp/fo/mmbrPrflModal.jsp" %>
<!-- 모임프로필 -->
<%@ include file="/WEB-INF/jsp/fo/clubPrflModal.jsp" %>
<!-- 플레이기록 -->
<%@ include file="/WEB-INF/jsp/fo/playRcrdModal.jsp" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
