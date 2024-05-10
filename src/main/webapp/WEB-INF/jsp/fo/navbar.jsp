<%@ page import="boardgame.com.util.SessionUtils" %>
<%@ page pageEncoding="utf-8" %>
<%
    //request.setCharacterEncoding("euc-kr");
    Long mmbrNo = (Long) session.getAttribute("mmbrNo");
    String nickNm = (String) session.getAttribute("nickNm");
    Integer clubNo = (Integer) session.getAttribute("clubNo");
    String mmbrTypeCd = (String) session.getAttribute("mmbrTypeCd");

    boolean loggedIn = SessionUtils.isMemberLogin();
    boolean adminMemberLoggedIn = SessionUtils.isAdminMemberLogin();
%>

<c:set var="mmbrNo" value="<%= mmbrNo %>"/>
<c:set var="nickNm" value="<%= nickNm %>"/>
<c:set var="clubNo" value="<%= clubNo %>"/>
<c:set var="mmbrTypeCd" value="<%= mmbrTypeCd %>"/>
<c:set var="adminMemberLoggedIn" value="<%= adminMemberLoggedIn %>"/>

<script>
</script>
<!-- Navbar -->
<nav class="navbar navbar-top navbar-horizontal navbar-expand-md navbar-dark">
    <div class="container px-4">
        <a class="navbar-brand" href="/">
            <!--
			<img src="<c:url value='/vendors/argon/img/brand/white.png'/>" />
			 -->
            BOGOPA
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar-collapse-main"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbar-collapse-main">
            <!-- Collapse header -->
            <div class="navbar-collapse-header d-md-none">
                <div class="row">
                    <div class="col-6 collapse-brand">
                        <a href="/">
                            <!--
							<img src="<c:url value='/vendors/argon/img/brand/blue.png'/>">
							 -->
                            BOGOPA
                        </a>
                    </div>
                    <div class="col-6 collapse-close">
                        <button type="button" class="navbar-toggler" data-toggle="collapse"
                                data-target="#navbar-collapse-main" aria-controls="sidenav-main" aria-expanded="false"
                                aria-label="Toggle sidenav">
                            <span></span>
                            <span></span>
                        </button>
                    </div>
                </div>
            </div>
            <!-- Navbar items -->
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/guide">
                        <i class="ni ni-map-big"></i>
                        <span class="nav-link-inner--text">이용안내</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/club">
                        <i class="ni ni-planet"></i>
                        <span class="nav-link-inner--text">모임</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/play">
                        <i class="ni ni-watch-time"></i>
                        <span class="nav-link-inner--text">플레이기록</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/game">
                        <i class="ni ni-controller"></i>
                        <span class="nav-link-inner--text">게임하기</span>
                    </a>
                </li>
                <% if (loggedIn) { %>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/myPage">
                        <i class="ni ni-single-02"></i>
                        <span class="nav-link-inner--text">내 활동</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/logout">
                        <i class="ni ni-user-run"></i>
                        <span class="nav-link-inner--text">로그아웃</span>
                    </a>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/join">
                        <i class="ni ni-circle-08"></i>
                        <span class="nav-link-inner--text">회원가입</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link nav-link-icon" href="/login">
                        <i class="ni ni-key-25"></i>
                        <span class="nav-link-inner--text">로그인</span>
                    </a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
