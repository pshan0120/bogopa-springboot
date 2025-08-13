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
    </style>

    <script>
        const blindLevels = [
            100, 200, 400, 600, 800,
            1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000,
            11000, 12000, 13000, 14000, 15000, 16000, 17000, 18000, 19000, 20000,
            21000, 22000, 23000, 24000, 25000, 26000, 27000, 28000, 29000, 30000
        ];
        let currentLevel = 1;
        let baseTime = 7 * 60; // seconds
        let blind = 100; // seconds
        let timeLeft = baseTime;
        let timerInterval = null;
        let running = false;
        const audio = new Audio("https://bogopayo.cafe24.com/sound/countdown-10-to-1.mp3");

        $(() => {
            console.log("Document ready - initializing DOM elements");
        });

        function updateGame() {
            console.log("updateGame function");
            currentLevel = parseInt(document.getElementById("currentLevel").value);
            baseTime = parseInt(document.getElementById("baseMinutes").value) * 60;
            blind = parseInt(document.getElementById("baseBlind").value);
            timeLeft = baseTime;
        }

        function resetGame() {
            console.log("restGame function");
            stopTimer();

            document.getElementById("currentLevel").value = 1;
            document.getElementById("baseMinutes").value = 7;
            document.getElementById("baseBlind").value = 100;

            document.getElementById("level").textContent = "LEVEL 1";
            document.getElementById("blinds").textContent = "-/-";
            document.getElementById("next-level").textContent = "-";
            document.getElementById("next-blinds").textContent = "-";
            document.getElementById("timer").textContent = "--:--";

            updateGame();
        }

        function toggleTimer() {
            console.log("toggleTimer function");

            if (running) {
                stopTimer();
            } else {
                startTimer();
            }
        }

        const stopTimer = () => {
            console.log("stopTimer function");

            document.getElementById("pauseBtn").textContent = "▶";
            running = false;

            clearInterval(timerInterval);

            if (!audio.paused) {
                audio.pause();
            }
        }

        function startTimer() {
            console.log("Entering startTimer function");

            document.getElementById("pauseBtn").textContent = "⏸";
            running = true;

            timerInterval = setInterval(() => {
                if (timeLeft > 0) {
                    timeLeft--;
                    if (timeLeft <= 10 && audio.paused) {
                        playCountSound10to1();
                    }
                    updateDisplay();
                } else {
                    nextLevel();
                }
            }, 1000);
        }

        function updateDisplay() {
            console.log("Entering updateDisplay function");

            // 레벨 범위 보호
            if (currentLevel < 1) currentLevel = 1;
            if (currentLevel > blindLevels.length) currentLevel = blindLevels.length;

            document.getElementById("level").textContent = "LEVEL " + currentLevel;

            // const blind = blindLevels[currentLevel - 1] || 0;
            document.getElementById("blinds").textContent = blind + "/" + (blind * 2);

            // 다음 레벨
            if (currentLevel < blindLevels.length) {
                document.getElementById("next-level").textContent = (currentLevel + 1) + "";

                const nextBlind = blindLevels[currentLevel];
                document.getElementById("next-blinds").textContent = nextBlind + "/" + (nextBlind * 2);
            } else {
                document.getElementById("next-level").textContent = "-";
                document.getElementById("next-blinds").textContent = "-";
            }

            // 타이머
            const mm = String(Math.floor(timeLeft / 60)).padStart(2, '0');
            const ss = String(timeLeft % 60).padStart(2, '0');
            document.getElementById("timer").textContent = mm + ":" + ss;
        }

        function playCountSound10to1() {
            audio.play();
            return;
        }

        function prevLevel() {
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

        function nextLevel() {
            console.log("nextLevel function");

            if (currentLevel >= blindLevels.length) {
                return;
            }

            currentLevel++;
            timeLeft = baseTime;
            blind = blindLevels[currentLevel - 1] || 0;

            document.getElementById("currentLevel").value = currentLevel;
            document.getElementById("baseBlind").value = blind;

            if (timerInterval) clearInterval(timerInterval);

            startTimer();
        }
    </script>
</head>

<body class="bg-default">
<div class="wrap">
    <div class="row">
        <div class="col-12">
            <div class="header">
                <span class="game-name">Friendly Game</span>
                <span class="level" id="level">LEVEL 1</span>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <span class="text-center font-white" style="margin: 10px 0; font-size: 24px">
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
            <div class="text-center font-white" style="margin-top: 10px; font-size: 24px">
                <strong>
                    BLINDS <span id="blinds">-/-</span>
                </strong>
                <%--<br> Ante <span id="ante">-</span>--%>
            </div>
        </div>
    </div>

    <hr>

    <div class="row">
        <div class="col-12">
            <div class="text-center font-white" style="font-size: 20px">
                Next LEVEL <span id="next-level">2</span><br>
                BLINDS <span id="next-blinds">-/-</span><br>
                <%--Ante <span id="next-ante">-</span>--%>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="text-center font-white"
                 style="font-size: 32px; margin: 10px;">
                <button style="background: none; border: none;color: white;cursor: pointer;" onclick="prevLevel()">⏮
                </button>
                <button style="background: none; border: none;color: white;cursor: pointer;" id="pauseBtn"
                        onclick="toggleTimer()">▶
                </button>
                <button style="background: none; border: none;color: white;cursor: pointer;" onclick="nextLevel()">⏭
                </button>
            </div>
        </div>
    </div>

    <hr>

    <div class="row">
        <div class="col-md-3 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">LEVEL</label>
                <input type="number" class="form-control form-control-alternative"
                       id="currentLevel" value="1" min="1">
            </div>
        </div>
        <div class="col-md-3 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">TIME</label>
                <input type="number" class="form-control"
                       id="baseMinutes" value="7" min="1">
            </div>
        </div>
        <div class="col-md-3 col-sm-4 col-xs-4">
            <div class="form-group">
                <label class="form-control-label text-gray" style="float: left">BLIND</label>
                <input type="number" class="form-control"
                       id="baseBlind" value="100" min="100">
            </div>
        </div>
        <div class="col-md-3 col-xs-12">
            <div style="margin-top: 30px;">
                <button type="button" class="btn btn-warning " onclick="updateGame()">UPDATE</button>
                <button type="button" class="btn btn-danger " onclick="resetGame()">RESET</button>
            </div>
        </div>
    </div>

</div>
</body>
</html>
