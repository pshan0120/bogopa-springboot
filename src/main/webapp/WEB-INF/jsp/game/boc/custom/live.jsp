<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <script src="<c:url value='/js/game/boc/constants.js'/>"></script>
    <script src="<c:url value='/js/game/boc/character.js'/>"></script>
    <script src="<c:url value='/js/game/boc/initializationSetting.js'/>"></script>

    <script>
        const PLAY_ID = ${playId};
        let selectedEditionId = null;
        let selectedCharacterList = [];
        let playedCharacterList = [];
        let playerList = [];
        let playStatus = {};
        let playerSetting = {};

        $(async () => {
            await initialize();

            setInterval(function () {
                loadAndRenderTown();
            }, 5000);
        });

        const initialize = async () => {
            await loadGameStatus();

            if (Object.keys(playStatus).length === 0) {
                alert("게임이 시작되지 않았습니다.");
                return;
            }

            const $townDiv = $("#townDiv");

            playerSetting = initializationSetting.player
                .find(player => playerList.length === player.townsFolk + player.outsider + player.minion + player.demon);

            if (Object.keys(playStatus).length === 0) {
                const htmlString = `게임이 시작되지 않았습니다.`;
                $townDiv.append(htmlString);
                return;
            }

            window.addEventListener("resize", renderTown);

            renderTown();
        }

        const loadGameStatus = async () => {
            const lastPlayLog = await readLastPlayLog(PLAY_ID);
            if (!lastPlayLog) {
                return;
            }

            const lastPlayLogJson = JSON.parse(lastPlayLog);
            console.log('lastPlayLogJson', lastPlayLogJson);

            playerList = JSON.parse(lastPlayLogJson.playerList);
            selectedCharacterList = JSON.parse(lastPlayLogJson.selectedCharacterList);
            selectedJinxList = JSON.parse(lastPlayLogJson.selectedJinxList);
            playStatus = JSON.parse(lastPlayLogJson.playStatus);

            console.log('game status loaded !!');
        }

        const readLastPlayLog = playId => {
            return gfn_callGetApi("/api/play/log/last", {playId})
                .then(data => {
                    // console.log('data', data);
                    return data?.log;
                })
                .catch(response => console.error('error', response));
        }

        const loadAndRenderTown = async () => {
            await loadGameStatus();
            console.log('playStatus', playStatus);

            const $townDiv = $("#townDiv");
            const $settingDiv = $townDiv.find("div[name='settingDiv']");

            // await $settingDiv.find("span[name='daySpan']").text(createDaySpanText());

            if (playStatus.isDay) {
                await renderTown();
            }
        }

        const renderTown = () => {
            playerList.sort((prev, next) => prev.seatNumber - next.seatNumber);

            const canvas = document.getElementById("townCanvas");
            const ctx = canvas.getContext("2d");

            const rect = canvas.getBoundingClientRect();
            canvas.width = rect.width * window.devicePixelRatio;
            canvas.height = rect.height * window.devicePixelRatio;
            ctx.scale(window.devicePixelRatio, window.devicePixelRatio);

            const width = canvas.clientWidth;
            const height = canvas.clientHeight;
            const centerX = width / 2;
            const centerY = height / 2;
            const radius = width * 0.35;
            const seatRadius = width * 0.06;

            // 배경 그라데이션
            const gradient = ctx.createLinearGradient(0, 0, width, height);
            gradient.addColorStop(0, "#462556");
            gradient.addColorStop(1, "#270432");
            ctx.fillStyle = gradient;
            ctx.fillRect(0, 0, width, height);

            // 하단 공백 각도 계산
            const totalSeats = playerList.length;
            const gapAngle = Math.PI / 6; // 30도 공백
            const anglePerSeat = (2 * Math.PI - gapAngle) / totalSeats;
            const startAngle = Math.PI / 2 + gapAngle; // 6시 방향 공백 시작

            for (let i = 0; i < totalSeats; i++) {
                const player = playerList[i];
                const angle = startAngle + i * anglePerSeat;

                const x = centerX + radius * Math.cos(angle);
                const y = centerY + radius * Math.sin(angle);

                // 원의 입체감
                const gradient = ctx.createRadialGradient(x - 10, y - 10, 5, x, y, seatRadius);
                if (player.died) {
                    gradient.addColorStop(0, "#b49494");
                    gradient.addColorStop(1, "#af3a3a");
                } else {
                    gradient.addColorStop(0, "#fff");
                    gradient.addColorStop(1, "#ccc");
                }

                // 원 (좌석)
                ctx.beginPath();
                ctx.arc(x, y, seatRadius, 0, 2 * Math.PI);
                ctx.fillStyle = gradient;
                ctx.fill();
                ctx.lineWidth = player.votable ? 5 : 1;
                ctx.strokeStyle = player.votable ? "#fff" : "#888";
                ctx.stroke();
                ctx.closePath();

                // nickname
                ctx.font = (seatRadius * 0.45) + "px bold sans-serif";
                ctx.fillStyle = "#000";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillText(player.nickname, x, y - seatRadius * 0.2);

                // 아이콘 (원 안 하단)
                let icons = "";
                if (player.nominating) icons += "🫵";
                if (player.nominated) icons += "🙅";

                ctx.font = (seatRadius * 0.4) + "px sans-serif";
                ctx.fillText(icons, x, y + seatRadius * 0.35);
            }

            const img = new Image();
            img.src = "<c:url value='/images/fo/boc/logo.png'/>";
            img.onload = () => {
                const imgSize = width * 0.18;

                const imgX = centerX - imgSize / 2;
                const imgY = centerY - imgSize * 1.0;

                ctx.drawImage(img, imgX, imgY, imgSize, imgSize);

                ctx.font = "bold " + (width * 0.04) + "px sans-serif";
                ctx.fillStyle = "#fff";
                ctx.textAlign = "center";
                ctx.textBaseline = "top";
                let currentY = imgY + imgSize + 5;
                ctx.fillText(playStatus.edition.name_kr, centerX, currentY);

                ctx.font = (width * 0.025) + "px sans-serif";
                ctx.fillStyle = "#ddd";
                ctx.textAlign = "center";
                ctx.textBaseline = "top";
                currentY += width * 0.06;
                ctx.fillText("(" + playStatus.edition.name + ")", centerX, currentY);

                ctx.font = (width * 0.035) + "px sans-serif";
                ctx.fillStyle = "#ddd";
                ctx.textAlign = "center";
                ctx.textBaseline = "top";
                currentY += width * 0.06 + 1;

                const roleInitializationText = `\${playerSetting.townsFolk} / \${playerSetting.outsider} / \${playerSetting.minion} / \${playerSetting.demon}`;
                ctx.fillText(roleInitializationText, centerX, currentY);

                ctx.font = (width * 0.035) + "px sans-serif";
                ctx.fillStyle = playStatus.isDay ? "#fddb01" : "#9d8909";
                ctx.textAlign = "center";
                ctx.textBaseline = "top";
                currentY += width * 0.06 + 2;

                ctx.fillText(createDaySpanText(), centerX, currentY);
            };
        }

        const createDaySpanText = () => createDayCountText() + " " + createDayAndNightEmoji();

        const createDayCountText = () => (playStatus.dayCount ?? "-") + "번째";

        const createDayAndNightEmoji = () => playStatus.isDay ? "낮" : "밤";
    </script>
</head>

<body class="bg-default">
<%@ include file="/WEB-INF/include/fo/includeBody.jspf" %>
<div class="main-content">
    <!-- Header -->
    <div class="header bg-gradient-primary pb-5 pt-7 pt-md-8">
        <div class="separator separator-bottom separator-skew zindex-100">
            <svg x="0" y="0" viewBox="0 0 2560 100" preserveAspectRatio="none" version="1.1"
                 xmlns="http://www.w3.org/2000/svg">
                <polygon class="fill-default" points="2560 0 2560 100 0 100"></polygon>
            </svg>
        </div>
    </div>
    <!-- Page content -->
    <div class="container mt--7">
        <div style="width: 100%; aspect-ratio: 1 / 1; position: relative; justify-content: center; display: flex;">
            <canvas id="townCanvas"
                    style="width: 100%; max-width: 900px; height: 100%; max-height: 900px; display: block;"></canvas>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/fo/includeFooter.jspf" %>

</body>
</html>
