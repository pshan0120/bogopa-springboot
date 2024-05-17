<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script>
        const BASIC_PRICE = 10;

        $(() => {
            $("#inputDiv").find("input").on("change", () => {
                calculate();
            });
        });

        const calculate = () => {
            const burgerSoldQuantity = $("#burgerSoldQuantity").val();
            const pizzaSoldQuantity = $("#pizzaSoldQuantity").val();
            const beverageSoldQuantity = $("#beverageSoldQuantity").val();
            const additionalDiscountPrice = $("#additionalDiscountPrice").val();
            const advancedStrategy = $("#advancedStrategy").is(":checked");
            const discountMilestone = $("#discountMilestone").is(":checked");
            const gardenIncluded = $("#gardenIncluded").is(":checked");
            const burgerMilestone = $("#burgerMilestone").is(":checked");
            const pizzaMilestone = $("#pizzaMilestone").is(":checked");
            const beverageMilestone = $("#beverageMilestone").is(":checked");
            const waitressMilestone = $("#waitressMilestone").is(":checked");
            const numberOfWaitress = $("#numberOfWaitress").val();
            const cfoHired = $("#cfoHired").is(":checked");

            const soldQuantity = Number(burgerSoldQuantity) + Number(pizzaSoldQuantity) + Number(beverageSoldQuantity);
            $("#soldQuantity").val(soldQuantity);

            const saleRevenue = soldQuantity
                * (BASIC_PRICE
                    - Number(additionalDiscountPrice)
                    + (advancedStrategy ? 10 : 0)
                    - (discountMilestone ? 1 : 0)
                )
                * (gardenIncluded ? 2 : 1);
            $("#saleRevenue").val(saleRevenue);

            const milestoneRevenue =
                (burgerMilestone ? burgerSoldQuantity * 5 : 0)
                + (pizzaMilestone ? pizzaSoldQuantity * 5 : 0)
                + (beverageMilestone ? beverageSoldQuantity * 5 : 0)
                + numberOfWaitress * (waitressMilestone ? 5 : 3);

            const bonusRevenue = milestoneRevenue
                + Math.ceil((saleRevenue + milestoneRevenue) * (cfoHired ? 0.5 : 0));
            $("#bonusRevenue").val(bonusRevenue);

            const totalRevenue = saleRevenue + bonusRevenue;
            $("#totalRevenue").val(totalRevenue);
        }

    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <%@ include file="/WEB-INF/jsp/fo/navbar.jsp" %>

    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="container">
            <div class="header-body text-center mb-7">
                <div class="row justify-content-center">
                    <div class="col-lg-8 col-md-8">
                        <h1 class="text-white">푸드체인거물 수익계산기</h1>
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
                        <div id="inputDiv">
                            <div class="form-group">
                                <label class="form-control-label">버거 판매량</label>
                                <input type="number" id="burgerSoldQuantity"
                                       class="form-control form-control-alternative">
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">피자 판매량</label>
                                <input type="number" id="pizzaSoldQuantity"
                                       class="form-control form-control-alternative">
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">음료 판매량</label>
                                <input type="number" id="beverageSoldQuantity"
                                       class="form-control form-control-alternative">
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">추가 할인가</label>
                                <input type="number" id="additionalDiscountPrice"
                                       class="form-control form-control-alternative">
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="advancedStrategy" type="checkbox">
                                    <label class="custom-control-label" for="advancedStrategy">
                                        <span class="form-control-label">고급화 전략 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="discountMilestone" type="checkbox">
                                    <label class="custom-control-label" for="discountMilestone">
                                        <span class="form-control-label">최초 할인 마일스톤 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="gardenIncluded" type="checkbox">
                                    <label class="custom-control-label" for="gardenIncluded">
                                        <span class="form-control-label">정원 포함 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="burgerMilestone" type="checkbox">
                                    <label class="custom-control-label" for="burgerMilestone">
                                        <span class="form-control-label">최초 버거 홍보 마일스톤 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="pizzaMilestone" type="checkbox">
                                    <label class="custom-control-label" for="pizzaMilestone">
                                        <span class="form-control-label">최초 피자 홍보 마일스톤 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="beverageMilestone" type="checkbox">
                                    <label class="custom-control-label" for="beverageMilestone">
                                        <span class="form-control-label">최초 음료 홍보 마일스톤 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="waitressMilestone" type="checkbox">
                                    <label class="custom-control-label" for="waitressMilestone">
                                        <span class="form-control-label">최초 웨이트리스 플레이 마일스톤 적용</span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">웨이트리스 수</label>
                                <input type="number" id="numberOfWaitress" class="form-control form-control-alternative">
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-control-alternative custom-checkbox">
                                    <input class="custom-control-input" id="cfoHired" type="checkbox">
                                    <label class="custom-control-label" for="cfoHired">
                                        <span class="form-control-label">CFO 보너스 적용</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div id="outputDiv">
                            <div class="form-group">
                                <label class="form-control-label">판매 상품수</label>
                                <input type="number" id="soldQuantity" class="form-control form-control-alternative"
                                       readonly>
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">판매 수익</label>
                                <input type="number" id="saleRevenue" class="form-control form-control-alternative"
                                       readonly>
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">보너스 수익</label>
                                <input type="number" id="bonusRevenue" class="form-control form-control-alternative"
                                       readonly>
                            </div>
                            <div class="form-group">
                                <label class="form-control-label">총 수익</label>
                                <input type="number" id="totalRevenue" class="form-control form-control-alternative"
                                       readonly>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer py-4">
                        <div name="buttonDiv">
                            <button type="button" class="btn btn-primary btn-block" onclick="calculate()">
                                계산하기
                            </button>
                            <button type="button" class="btn btn-default btn-block" onclick="gfn_openQrImage()">
                                QR 이미지로 공유
                            </button>
                        </div>
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
