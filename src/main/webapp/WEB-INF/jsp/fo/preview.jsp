<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>보고파 - Premium Portal</title>
                <link rel="stylesheet" href="<c:url value='/css/fo/bogopa-style.css'/>">
                <link href="<c:url value='/vendors/argon/js/plugins/@fortawesome/fontawesome-free/css/all.min.css'/>"
                    rel="stylesheet" />
                <script src="<c:url value='/vendors/argon/js/plugins/jquery/dist/jquery.min.js'/>"></script>
            </head>

            <body>

                <div class="preview-container">
                    <nav class="modern-nav">
                        <a href="#" class="logo">BOGO<span>PA</span></a>
                        <button class="menu-toggle" id="mobileMenuBtn">
                            <i class="fas fa-bars"></i>
                        </button>
                        <div class="nav-links" id="navLinks">
                            <a href="#"><i class="fas fa-info-circle"></i> 이용안내</a>
                            <a href="#"><i class="fas fa-users"></i> 모임</a>
                            <a href="#"><i class="fas fa-history"></i> 플레이기록</a>
                            <a href="#"><i class="fas fa-gamepad"></i> 게임하기</a>
                            <a href="#"><i class="fas fa-user-plus"></i> 회원가입</a>
                            <a href="#"><span style="color:var(--accent-color)">로그인</span></a>
                        </div>
                    </nav>

                    <header class="hero-section">
                        <h1 class="hero-title">보<span>드게임 하</span>고파</h1>
                        <p class="hero-subtitle">보드게임.. 하고 갈래요?</p>
                    </header>

                    <!-- Recent PlaysSection -->
                    <section>
                        <div class="section-header">
                            <h2 class="section-title">최근 등록된 플레이</h2>
                            <a href="#" style="color:var(--accent-color); font-size: 0.8rem; text-decoration:none;">전체보기
                                <i class="fas fa-chevron-right"></i></a>
                        </div>

                        <div class="modern-grid">
                            <c:choose>
                                <c:when test="${empty playRecordList}">
                                    <div class="premium-card"
                                        style="grid-column: 1 / -1; text-align: center; padding: 4rem;">
                                        <p style="color: var(--text-dim);">조회결과가 없습니다.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="play" items="${playRecordList}">
                                        <div class="premium-card">
                                            <div class="card-tag">${play.gameNm}</div>
                                            <h3 class="card-title">${play.playNm}</h3>
                                            <div
                                                style="font-size: 0.85rem; color: var(--text-dim); margin-bottom: 0.5rem;">
                                                <i class="far fa-calendar-alt mr-1"></i> ${play.strtDt}
                                            </div>

                                            <div class="club-info">
                                                <div class="avatar-sm">
                                                    <c:choose>
                                                        <c:when test="${not empty play.clubPrflImgFileNm}">
                                                            <img
                                                                src="https://bogopayo.cafe24.com/img/club/${play.clubNo}/${play.clubPrflImgFileNm}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://bogopayo.cafe24.com/img/club/default.png">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <span style="font-weight: 500;">${play.clubNm}</span>
                                            </div>

                                            <div class="card-footer">
                                                <span style="font-size: 0.8rem; font-weight: 600;">참여 인원</span>
                                                <div class="player-avatars">
                                                    <c:forEach begin="1"
                                                        end="${play.playMmbrCnt > 4 ? 4 : play.playMmbrCnt}">
                                                        <div class="avatar-sm">
                                                            <img src="https://bogopayo.cafe24.com/img/mmbr/default.png">
                                                        </div>
                                                    </c:forEach>
                                                    <c:if test="${play.playMmbrCnt > 4}">
                                                        <div class="avatar-sm"
                                                            style="background:#21262d; display:flex; align-items:center; justify-content:center; font-size:0.6rem; color:var(--accent-color); font-weight:bold;">
                                                            +${play.playMmbrCnt - 4}
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <!-- New Posts Section -->
                    <section style="margin-top: 6rem;">
                        <div class="section-header">
                            <h2 class="section-title">새로운 게시글</h2>
                            <a href="#" style="color:var(--accent-color); font-size: 0.8rem; text-decoration:none;">더보기
                                <i class="fas fa-chevron-right"></i></a>
                        </div>

                        <div class="modern-list">
                            <c:choose>
                                <c:when test="${empty clubBrdList}">
                                    <div style="padding: 4rem; text-align: center; color: var(--text-dim);">조회결과가 없습니다.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="brd" items="${clubBrdList}">
                                        <div class="list-item">
                                            <div class="type-badge">${brd.brdTypeNm}</div>
                                            <a href="#" class="item-title">${brd.title}</a>
                                            <div class="item-nick">
                                                <div class="avatar-sm" style="width:24px; height:24px;">
                                                    <c:choose>
                                                        <c:when test="${not empty brd.prflImgFileNm}">
                                                            <img
                                                                src="https://bogopayo.cafe24.com/img/mmbr/${brd.mmbrNo}/${brd.prflImgFileNm}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://bogopayo.cafe24.com/img/mmbr/default.png">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                ${brd.nickNm}
                                            </div>
                                            <div class="item-date">${brd.insDt}</div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <footer>
                        <p>&copy; 2026 BOGOPA THEATER. All Operations Classified.</p>
                        <p style="margin-top: 0.5rem; opacity: 0.5;">섬마을제이드 | pshan0120@naver.com</p>
                    </footer>
                </div>

                <script>
                    $(document).ready(function () {
                        $('#mobileMenuBtn').click(function () {
                            $('#navLinks').toggleClass('active');
                        });
                    });
                </script>

            </body>

            </html>