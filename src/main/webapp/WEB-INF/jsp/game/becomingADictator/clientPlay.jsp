<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/becomingADictator/initializationSetting.js'/>"></script>
    <script src="<c:url value='/js/game/becomingADictator/constants.js'/>"></script>
    <script src="<c:url value='/js/game/becomingADictator/fruits.roles.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let playSetting = {};
        let playStatus = {};
        let fruitList = [];
        let playerList = [];
        let auctionByRound = [];

        $(async () => {
            const play = await gfn_readPlayablePlayById(PLAY_ID);
            $("#titleDiv").find("span[name='playName']").text(play.playName);
        });

        const openGuideModal = () => {
            guideModal.open();
        }

        const openFruitShopModal = () => {
            shopListModal.open(PLAY_ID);
        }

        const openAuctionResultModal = () => {
            auctionResultModal.open(PLAY_ID);
        }

    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbar.jsp" %>
    <%--<%@ include file="/WEB-INF/jsp/fo/navbarOnLogin.jsp" %>--%>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">이리하여 나는 독재자가 되었다</h1>
                        <p class="text-lead text-light">플레이어 참조</p>
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
                        플레이어용 참조표
                    </div>
                    <div class="card-body" id="titleDiv">
                        <h2>
                            <span name="playName"></span>
                        </h2>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openGuideModal()">
                                게임 설명
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openFruitShopModal()">
                                플레이어 과일가게 보기
                            </button>
                            <button type="button" class="btn btn-info btn-block" onclick="openAuctionResultModal()">
                                경매 결과 모달 표시
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/jsp/fo/footer.jsp" %>
</div>

<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/shopListModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/auctionResultModal.jspf" %>
<%@ include file="/WEB-INF/jsp/game/becomingADictator/jspf/guideModal.jspf" %>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
