<%@ page pageEncoding="utf-8" %>

<%
    String fromUri =
            session.getAttribute("fromUri") == null || "null".equals(String.valueOf(session.getAttribute("fromUri")))
                    ? "/"
                    : String.valueOf(session.getAttribute("fromUri"));
%>

<script>
    $(function () {
        // gfn_inputPlaceholder($("#loginForm fieldset"));
    });

    function fn_openLoginModal() {
        $("#loginModal").modal({
            escapeClose: false,
            clickClose: false,
            showClose: false
        });
    }

    const login = async () => {
        await gfn_validateInputsInForm($("#loginForm"));

        const $form = $("#loginForm");
        const jsonData = {
            email: $form.find("input[name='email']").val(),
            pswrd: $form.find("input[name='pswrd']").val(),
        }

        gfn_callPostApi("/fo/api/login", jsonData)
            .then(() => location.replace("<%= fromUri %>"))
            .catch((response) => {
                const errorMessage = response.responseJSON.message ?? "로그인 중 오류가 발생했습니다.";
                alert(errorMessage);
            })
    }

</script>

<!-- 로그인 모달 -->
<article id="loginModal" class="modal">
    <a href="" rel="modal:close" class="close-x-btn">
        <img src="<c:url value='/images/fo/ic_close.svg'/>" alt="ic_close">
    </a>
    <section class="head">
        <h1 class="title">로그인</h1>
    </section>
    <section class="body">
        <form id="loginForm" class="validateLoginForm">
            <fieldset class="login_fieldset">
                <div class="input">
                    <input type="email" class="hasValue emailOnly" id="email" name="email"/>
                    <label for="email" class="placeholder">이메일</label>
                </div>
                <div class="input">
                    <input type="password" class="hasValue pswrdOnly" id="pswrd" name="pswrd"/>
                    <label for="pswrd" class="placeholder">비밀번호</label>
                </div>
            </fieldset>
            <div class="link_box clearfix">
                <a class="findPswrd" href="/findPswrd">비밀번호 찾기</a>
                <a class="join" href="/join">회원가입</a>
            </div>
            <div class="button_box">
                <button type="button" class="button login_button" onclick="login();">
                    로그인
                </button>
            </div>
        </form>
    </section>
</article>
