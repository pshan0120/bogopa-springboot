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

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
