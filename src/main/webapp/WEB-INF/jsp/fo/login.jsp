<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>
    <%
        String fromUri =
                session.getAttribute("fromUri") == null || "null".equals(String.valueOf(session.getAttribute("fromUri")))
                        ? "/"
                        : String.valueOf(session.getAttribute("fromUri"));
    %>
    <script>
        const login = async () => {
            await gfn_validateInputsInForm($("#form"));

            const $form = $("#form");
            const jsonData = {
                email: $form.find("input[name='email']").val(),
                password: $form.find("input[name='password']").val(),
            }

            gfn_callPostApi("/fo/api/login", jsonData)
                .then(() => location.replace("<%= fromUri %>"))
                .catch(response => {
                    console.log('response', response);
                    const errorMessage = response.responseJSON.message ?? "로그인 중 오류가 발생했습니다.";
                    alert(errorMessage);
                })
        }

        /*function fn_doLogin() {
            if (gfn_validateForm("form")) {
                const comAjax = new ComAjax("form");
                // comAjax.setUrl("<c:url value='/doLogin' />");
                comAjax.setUrl("<c:url value='/fo/api/login' />");
                comAjax.setCallback("fn_doLoginCallback");
                comAjax.ajax();
            }
        }

        function fn_doLoginCallback(data) {
            if (data.result) {
                var fromUri = "<%= fromUri %>";
                if (fromUri == "" || fromUri == "null" || fromUri == null) {
                    fromUri = "/";
                }
                document.location.href = fromUri;
            } else {
                alert(data.resultMsg);
            }
        }*/

        function fn_saveLogin(name, id) {
            if (id != "") {
                gfn_setCookie(name, id, 7);
            } else {
                gfn_setCookie(name, id, -1);
            }
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
                    <div class="col-lg-5 col-md-6">
                        <h1 class="text-white">들어올 땐 마음대로</h1>
                        <p class="text-lead text-light">나갈 땐 아니란다</p>
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
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="card bg-secondary shadow border-0">
                    <div class="card-body px-lg-5 py-lg-5">
                        <form role="form" id="form">
                            <div class="form-group mb-3">
                                <div class="input-group input-group-alternative">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="ni ni-email-83"></i></span>
                                    </div>
                                    <input class="form-control hasValue emailOnly" placeholder="이메일" type="email"
                                           name="email" onKeypress="gfn_hitEnter(event, 'login()');"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-group input-group-alternative">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text"><i class="ni ni-lock-circle-open"></i></span>
                                    </div>
                                    <input class="form-control hasValue pswrdOnly" placeholder="비밀번호" type="password"
                                           name="password" onKeypress="gfn_hitEnter(event, 'login()');"/>
                                </div>
                            </div>
                            <div class="text-center">
                                <button type="button" class="btn btn-primary btn-block" onclick="login();">
                                    로그인
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-6">
                        <a href="/findPswrd" class="text-light"><small>비밀번호 찾기</small></a>
                    </div>
                    <div class="col-6 text-right">
                        <a href="/join" class="text-light"><small>회원가입</small></a>
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
