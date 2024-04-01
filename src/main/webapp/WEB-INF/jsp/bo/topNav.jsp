<%@ page pageEncoding="utf-8"%>
<!-- top navigation -->
<div class="top_nav">
	<div class="nav_menu">
		<nav>
			<div class="nav toggle">
				<a id="menu_toggle"><i class="fa fa-bars"></i></a>
			</div>

			<ul class="nav navbar-nav navbar-right">
				<li class="">
					<a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
						<c:out value='${userNm}'/></span>
						<span class=" fa fa-angle-down"></span>
					</a>
					<ul class="dropdown-menu dropdown-usermenu pull-right">
						<li><a href="javascript:;" onclick="fn_openUserInfoModal()">사용자정보</a></li>
						<li><a href="/bo/logout"><i class="fa fa-sign-out pull-right"></i> 로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</nav>
	</div>
</div>
<!-- /top navigation -->

<%@ include file="/WEB-INF/jsp/bo/userModal.jsp"%>