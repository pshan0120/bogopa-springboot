<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <%@ include file="/WEB-INF/include/fo/includeHeader.jspf" %>

    <style>
        body {
            font-family: serif, Arial;
            background: black;
            color: white;
            text-align: center;
            margin: 0;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            font-size: 18px;
        }

        .blink {
            animation: blink-animation 1s ease-in-out infinite;
        }

        @keyframes blink-animation {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0;
            }
        }

        #donateBtn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #ffcc00;
            color: #000;
            font-weight: bold;
            border: none;
            border-radius: 25px;
            padding: 12px 18px;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            transition: all 0.2s ease-in-out;
            z-index: 9999;
        }

        #donateBtn:hover {
            background-color: #ffd633;
            transform: scale(1.05);
        }

        /* 모달 배경 */
        .donate-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 10000;
        }

        /* 모달 내용 */
        .donate-modal {
            background: #222;
            color: #fff;
            width: 90%;
            max-width: 400px;
            margin: 10% auto;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            position: relative;
            box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
        }

        .donate-modal h2 {
            margin-top: 0;
            color: #ffcc00;
        }

        .donate-modal img {
            margin: 10px 0;
            border-radius: 8px;
            background: #fff;
        }

        .close-donate-modal {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 20px;
            color: #ccc;
            cursor: pointer;
        }

        .close-donate-modal:hover {
            color: #fff;
        }
    </style>

    <script>
        /*const blindLevels = [
            100, 200, 400, 600, 800,
            1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000,
            11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000,
            21000, 22000, 23000, 24000, 25000, 26000, 27000, 28000, 29000, 30000
        ];*/


        let blindLevels = [];
        let antes = [];

        const BLIND_LEVEL_SLOW = [
            100, 200, 400, 600, 800,
            1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000,
            11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000,
            21000, 22000, 23000, 24000, 25000, 26000, 27000, 28000, 29000, 30000
        ];
        const ANTES_SLOW = [0, 0, 0, 100, 200, 300, 400, 600, 1000, 2000, 4000, 6000, 10000, 20000];

        const BLIND_LEVEL_NORMAL = [100, 200, 300, 500, 700, 1000, 1500, 2000, 3000, 4000, 5000, 6000, 8000, 10000, 15000, 20000, 30000, 50000, 100000];
        const ANTES_NORMAL = [0, 0, 0, 100, 200, 300, 400, 600, 800, 1000, 1500, 2000, 3000, 4000, 5000, 6000, 8000, 10000, 20000];

        const BLIND_LEVEL_FAST = [100, 200, 300, 500, 1000, 1500, 2000, 3000, 5000, 10000, 20000, 30000, 50000, 100000];
        const ANTES_FAST = [0, 0, 0, 100, 200, 300, 400, 600, 1000, 2000, 4000, 6000, 10000, 20000];

        let currentLevel = 1;
        let baseTime = 7 * 60; // seconds
        let blind = 100; // seconds
        let timeLeft = baseTime;
        let timerInterval = null;
        let running = false;

        let playTimerInterval = null;
        let playTime = 0;
        let begun = false;

        let clockInterval = null;
        const audio = new Audio("https://bogopayo.cafe24.com/sound/effect/countdown-10-to-1.mp3");

        $(() => {
            console.log("Document ready - initializing DOM elements");

            const donateBtn = document.getElementById("donateBtn");
            donateBtn.addEventListener("click", () => toggleDonateModal(true));

            // ESC 키 닫기
            document.addEventListener("keydown", e => {
                if (e.key === "Escape") toggleDonateModal(false);
            });

            // 배경 클릭 시 닫기
            const donateModal = document.getElementById("donateModal");
            donateModal.addEventListener("click", e => {
                if (e.target === donateModal) toggleDonateModal(false);
            });

            blindLevels = BLIND_LEVEL_NORMAL;

            setInterval(updateClock, 1000);

            updateClock();
        });

        const toggleDonateModal = show => {
            const donateModal = document.getElementById("donateModal");
            donateModal.style.display = show ? "block" : "none";
        };

        const updateClock = () => {
            const now = new Date();
            const options = {hour12: false};
            const formattedTime = now.toLocaleTimeString('en-US', options);
            document.getElementById("clock").textContent = formattedTime;
        }

        const updateGame = () => {
            console.log("updateGame function");
            currentLevel = parseInt(document.getElementById("currentLevel").value);
            baseTime = parseInt(document.getElementById("baseMinutes").value) * 60;
            blind = parseInt(document.getElementById("baseBlind").value);

            const modeSelected = document.getElementById("modeSelect").value;
            if (modeSelected === "SLOW") {
                blindLevels = BLIND_LEVEL_SLOW;
                antes = ANTES_SLOW;
            } else if (modeSelected === "FAST") {
                blindLevels = BLIND_LEVEL_FAST;
                antes = ANTES_FAST;
            } else {
                blindLevels = BLIND_LEVEL_NORMAL;
                antes = ANTES_NORMAL;
            }

            timeLeft = baseTime;
        }

        const resetGame = () => {
            console.log("restGame function");
            begun = false;
            timeLeft = baseTime;
            playTime = 0;

            stopTimer();
            stopPlayTimer();

            document.getElementById("currentLevel").value = 1;
            document.getElementById("baseMinutes").value = 7;
            document.getElementById("baseBlind").value = 100;

            document.getElementById("level").textContent = document.getElementById("modeSelect").value + " LEVEL 1";
            document.getElementById("blinds").textContent = "- / -";
            document.getElementById("next-level").textContent = "-";
            document.getElementById("next-blinds").textContent = "-";
            document.getElementById("timer").textContent = "--:--";
            document.getElementById("playTimer").textContent = "--:--:--";

            updateGame();
        };

        const toggleTimer = () => {
            console.log("toggleTimer function");

            if (running) {
                stopTimer();
            } else {
                startTimer();
            }
        };

        const stopTimer = () => {
            console.log("stopTimer function");

            document.getElementById("pauseBtn").textContent = "▶";
            running = false;

            clearInterval(timerInterval);

            if (!audio.paused) {
                audio.pause();
            }
        }

        const startTimer = () => {
            // console.log("Entering startTimer function");
            document.getElementById("pauseBtn").textContent = "⏸";
            running = true;

            timerInterval = setInterval(() => {
                if (timeLeft > 0) {
                    timeLeft--;
                    if (timeLeft <= 10 && audio.paused) {
                        playCountSound10to1();
                        document.getElementById("timer").classList.add("blink");
                    }
                    updateDisplay();
                } else {
                    nextLevel();
                }
            }, 1000);

            if (!begun) {
                begun = true;
                startPlayTimer();
            }
        }

        const updateDisplay = () => {
            console.log("Entering updateDisplay function");

            // 레벨 범위 보호
            if (currentLevel < 1) currentLevel = 1;
            if (currentLevel > blindLevels.length) currentLevel = blindLevels.length;

            document.getElementById("level").textContent =
                document.getElementById("modeSelect").value + " LEVEL " + currentLevel;

            document.getElementById("blinds").textContent =
                formatNumberWithComma(blind) + " / " + formatNumberWithComma(blind * 2);

            // 다음 레벨
            if (currentLevel < blindLevels.length) {
                document.getElementById("next-level").textContent = (currentLevel + 1) + "";

                const nextBlind = blindLevels[currentLevel];
                document.getElementById("next-blinds").textContent =
                    formatNumberWithComma(nextBlind) + " / " + formatNumberWithComma(nextBlind * 2);
            } else {
                document.getElementById("next-level").textContent = "-";
                document.getElementById("next-blinds").textContent = "-";
            }

            // 타이머
            const mm = String(Math.floor(timeLeft / 60)).padStart(2, '0');
            const ss = String(timeLeft % 60).padStart(2, '0');
            document.getElementById("timer").textContent = mm + ":" + ss;
        }

        const playCountSound10to1 = () => {
            audio.play();
            return;
        }

        const prevLevel = () => {
            console.log("prevLevel function");

            if (currentLevel < 1) {
                return;
            }

            currentLevel--;
            timeLeft = baseTime;
            blind = blindLevels[currentLevel - 1] || 0;

            if (timerInterval) clearInterval(timerInterval);

            startTimer();
        }

        const nextLevel = () => {
            console.log("nextLevel function");

            if (currentLevel >= blindLevels.length) {
                return;
            }

            currentLevel++;
            timeLeft = baseTime;
            blind = blindLevels[currentLevel - 1] || 0;

            document.getElementById("currentLevel").value = currentLevel;
            document.getElementById("baseBlind").value = blind;
            document.getElementById("timer").classList.remove("blink");

            if (timerInterval) clearInterval(timerInterval);

            startTimer();
        }


        const stopPlayTimer = () => {
            console.log("stopPlayTimer function");

            clearInterval(playTimerInterval);
        }

        const startPlayTimer = () => {
            console.log("Entering startPlayTimer function");

            playTimerInterval = setInterval(() => {
                updatePlayTimerDisplay();
            }, 1000);
        }

        const updatePlayTimerDisplay = () => {
            console.log("Entering updatePlayTimerDisplay function");
            playTime++;

            // 타이머
            const hh = String(Math.floor(playTime / 60 / 60)).padStart(2, '0'); // 시간
            const mm = String(Math.floor((playTime % 3600) / 60)).padStart(2, '0'); // 시간 초과 이후의 분
            const ss = String(playTime % 60).padStart(2, '0'); // 남은 초

            document.getElementById("playTimer").textContent = hh + ":" + mm + ":" + ss;
        };

        const formatNumberWithComma = number => number.toLocaleString();

    </script>
</head>

<body class="bg-default">
<!-- Floating Button -->
<button id="donateBtn">☕ 후원하기</button>

<!-- Modal -->
<div class="donate-modal-overlay" id="donateModal">
    <div class="donate-modal">
        <span class="close-donate-modal" onclick="toggleDonateModal(false)">✖</span>
        <h2>개발자에게 커피 한 잔 사주기 ☕</h2>
        <p>이 타이머가 도움이 되셨다면<br>작은 응원이 큰 힘이 됩니다!</p>

        <div style="margin-top:15px;">
            <a href="https://toss.me/yourname" target="_blank"
               style="display:inline-block;background:#0064FF;color:#fff;padding:10px 20px;
                      border-radius:6px;text-decoration:none;font-weight:bold;margin:5px;">
                💙 토스로 후원하기
            </a>
        </div>

        <div style="margin-top:15px;">
            <p style="font-size:14px;color:#ccc;">또는 카카오페이 QR을 스캔해주세요</p>
            <img src="/images/kakaopay_qr.png" alt="카카오페이 후원 QR" width="160">
        </div>
    </div>
</div>
<div class="wrap">
    <div class="row" style="font-size: x-large;">
        <div class="col-12">
            <div class="header">
                <span class="game-name">Friendly Game</span>
                 <span class="level" id="level">NORMAL LEVEL 1</span>
            </div>
        </div>
    </div>

    <div class="row" style="font-size: x-large;margin: 10px 0;">
        <div class="col-12">
            <span class="text-center font-white">
                ROFL
            </span>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <strong id="timer" class="text-center font-white" style="margin: 20px 0; font-size: 100px">
                --:--
            </strong>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <strong class="text-center font-white" style="margin: 10px 0; font-size: 60px">
                BLINDS <span id="blinds" class="text-yellow" style="font-size: 60px">- / -</span>
            </strong>
            <%--<br> Ante <span id="ante">-</span>--%>
        </div>
    </div>

    <hr>

    <div class="row" class="text-center font-white" style="font-size: x-large">
        <div class="col-md-4 col-xs-12">
            <div style="margin: 10px 0;">
                Current Time<br>
                <span id="clock">
                    --:--:--
                </span>
            </div>
        </div>
        <div class="col-md-4 col-xs-12">
            <div style="margin: 10px 0;">
                Next LEVEL <span id="next-level">2</span><br>
                BLINDS <span id="next-blinds">-/-</span><br>
                <%--Ante <span id="next-ante">-</span>--%>
            </div>
        </div>
        <div class="col-md-4 col-xs-12">
            <div style="margin: 10px 0;">
                Play Time<br>
                <span id="playTimer">
                    --:--:--
                </span>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="text-center font-white"
                 style="font-size: 32px; margin: 10px;">
                <button style="background: none; border: none;color: white;cursor: pointer;" onclick="prevLevel()">
                    ⏮
                </button>
                <button style="background: none; border: none;color: white;cursor: pointer;" id="pauseBtn"
                        onclick="toggleTimer()">
                    ▶
                </button>
                <button style="background: none; border: none;color: white;cursor: pointer;" onclick="nextLevel()">
                    ⏭
                </button>
            </div>
        </div>
    </div>

    <hr>

    <div class="row">
        <div class="col-md-2 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">LEVEL</label>
                <input type="number" class="form-control form-control-alternative"
                       id="currentLevel" value="1" min="1">
            </div>
        </div>
        <div class="col-md-2 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">TIME</label>
                <input type="number" class="form-control"
                       id="baseMinutes" value="7" min="1">
            </div>
        </div>
        <div class="col-md-2 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">BLIND</label>
                <input type="number" class="form-control"
                       id="baseBlind" value="100" min="100">
            </div>
        </div>
        <div class="col-md-2 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">MODE</label>
                <select class="form-control" id="modeSelect">
                    <option value="SLOW">SLOW</option>
                    <option value="NORMAL" selected>NORMAL</option>
                    <option value="FAST">FAST</option>
                </select>
            </div>
        </div>
        <div class="col-md-4 col-xs-12">
            <div style="margin-top: 30px;">
                <button type="button" class="btn btn-warning " onclick="updateGame()">UPDATE</button>
                <button type="button" class="btn btn-danger " onclick="resetGame()">RESET</button>
            </div>
        </div>
    </div>

</div>
</body>
</html>