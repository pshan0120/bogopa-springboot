<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>뇌 측정 리포트</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }

        p {
            font-size: 1.1rem; /* 폰트 크기를 기존보다 약간 증가 */
        }

        .container {
            width: 80%;
            margin: 2rem auto;
            background: #fff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .container h1, h2, h3 {
            color: #333;
        }

        .container.cover-page {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            height: 100vh;
            /*background: radial-gradient(circle, #00254d, #004780); !* 방사형 그라데이션 *!*/
            /*color: #ffffff;*/
            position: relative;
        }

        /* 표지 제목 */
        .container.cover-page .report-title {
            font-size: 3rem; /* 기존보다 폰트 크기 확대 */
            font-weight: 300;
            color: #333;
            text-align: center;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            margin-top: 80px;
            margin-bottom: 10px; /* 실선과의 간격 추가 */

            /* 하단 실선 */
            position: relative; /* 선을 위한 위치 기준 설정 */
        }

        .container.cover-page .report-title::after {
            content: ''; /* 하단 실선 생성 */
            display: block;
            width: 100%; /* 텍스트 폭 기준으로 반 크기의 선 */
            height: 2px; /* 실선 두께 */
            background-color: #333; /* 선 색상 */
            margin: 10px auto 0; /* 위쪽 여백 포함, 중앙 정렬 */
        }

        /* 연구소 로고 및 이름 */
        .container.cover-page .logo-container {
            position: absolute;
            bottom: 40px; /* 부모 div 하단 레이아웃 */
            left: 40px; /* 왼쪽 배치 */
            display: flex;
            align-items: center; /* 이미지와 텍스트 높이 맞춤 */
        }

        .container.cover-page .logo {
            width: 40px; /* 기존보다 작은 크기 */
            height: auto;
            margin-right: 10px; /* 로고와 텍스트 간 간격 */
            filter: drop-shadow(0px 4px 6px rgba(0, 0, 0, 0.3));
        }

        .container.cover-page .logo-text {
            font-size: 1.5rem; /* 기존보다 큰 크기 */
            color: #333;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            font-weight: 300;
            text-align: left;
            white-space: nowrap; /* 텍스트 줄 바꿈 방지 */
        }

        /* 대상자 정보 */
        .container.cover-page .details {
            position: absolute;
            bottom: 40px; /* 부모 div 하단 레이아웃 */
            right: 40px; /* 오른쪽 배치 */
            text-align: right;
            font-size: 1.2rem;
            line-height: 1.8;
        }

        .container.cover-page .details .detail-item {
            margin: 5px 0;
        }

        /* 강조 효과 (highlight) */
        .container.cover-page .highlight {
            font-weight: bold; /* 텍스트 굵게 */
            color: #ffcc00; /* 강조를 위한 노란색 */
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.6); /* 강조 효과 */
        }

        section {
            margin-bottom: 2rem;
        }

        canvas {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
    </style>
</head>
<body>

<div class="container cover-page">
    <!-- 표지 제목 -->
    <h1 class="report-title">뇌 측정 리포트</h1>

    <!-- 연구소 로고 및 이름 -->
    <div class="logo-container">
        <img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fyt3.googleusercontent.com%2FpCc1W-AuvJsbEsJdDUI-UHHcI4n3DuZLsQLBOScDOOBJXM3IJnJYiLahbi37888IsB-OOzwwOA%3Ds900-c-k-c0x00ffffff-no-rj&type=sc960_832"
             alt="뇌건강 연구소 로고"
             class="logo">
        <div class="logo-text">뇌건강 연구소</div>
    </div>

    <!-- 대상자 정보 -->
    <div class="details">
        <div class="detail-item">측정 대상자: <span id="clientName" class="highlight"></span></div>
        <div class="detail-item">측정 일시: <span id="analysisDatetime" class="highlight"></span></div>
    </div>
</div>

<div class="container">
    <section>
        <h2>📝 개요</h2>
        <p>이 리포트는 fNIRS 기기를 사용하여 측정된 데이터를 기반으로 합니다. 데이터는 좌우 뇌반구에서의 산소화 헤모글로빈(OxyHb)과 탈산소화 헤모글로빈(SO2) 수준을 포함합니다. 이는
            클라이언트의 뇌 활동과 그에 따른 심리적 반응의 상태를 분석하는 데 중요한 지표입니다.</p>
    </section>

    <section>
        <h2>📈 측정 결과</h2>

        <div>
            <h3>✔️ 스트레스 수준</h3>
            <canvas id="stressChart" width="600" height="150"></canvas>
        </div>

        <div>
            <h3>✔️ 좌/우측 뇌 혈류 활성도</h3>
            <canvas id="brainFlowChart"></canvas>
        </div>

        <div>
            <h3>✔️ 좌/우측 뇌 산소포화도</h3>
            <canvas id="oxygenChart"></canvas>
        </div>
    </section>
</div>

<div class="container">
    <section>
        <h2>🔍 결과 분석</h2>
        <h3>✔️ 스트레스 관련 문진 결과</h3>
        <ul>
            <li>문진검사 결과, 곽혜란님은 스트레스 점수가 높게 나타났습니다. 이는 뇌 활성화 데이터의 우뇌 변동성과 연결될 가능성이 있습니다.</li>
        </ul>
        <h3>✔️ 뇌 활성화 정도</h3>
        <ul>
            <li>우뇌의 활성화 변화가 좌뇌보다 더 크며, 이는 창의적 사고와 감정 처리에서 강한 반응을 보였음을 나타냅니다.</li>
            <li>또한, 우뇌의 활동 진폭 변동성이 크며, 이는 정서적 자극이나 스트레스와 연관된 반응일 수 있습니다.</li>
            <li>좌뇌는 논리적 사고와 계획 능력에 있어 꾸준히 활성화되었으며 비교적 안정적인 변화를 보였습니다.</li>
        </ul>
        <h3>✔️ 뇌 연결성 과제 (상상운동)</h3>
        <ul>
            <li>상상운동 과제 동안 좌우 뇌반구 간의 연결성이 관찰되었습니다.</li>
            <li>좌뇌는 꾸준히 활성화되며 논리적 사고와 계획 능력을 지원하였습니다.</li>
            <li>우뇌는 감정 처리와 창의적 사고를 담당하며, 상상운동 중 변동성이 더 크게 나타났습니다. 이는 상상운동 과제가 뇌의 연결성을 강화하는 데 긍정적인 역할을 했음을 보여줍니다.</li>
        </ul>
        <h3>✔️ 뇌의 산소 사용량 (SO₂)</h3>
        <ul>
            <li>좌측 뇌반구의 산소포화도는 전반적으로 안정적인 패턴을 유지했습니다.</li>
            <li>반면, 우측 뇌반구의 산소포화도는 낮은 수준에서 변동성이 크며 안정성이 떨어지는 경향을 보였습니다. 이는 심리적 스트레스나 특정 정서적 자극에 민감하게 반응하는 우뇌의 특성과 관련될 수
                있습니다.
            </li>
        </ul>
    </section>

    <section>
        <h2>💡 개인 맞춤 추천 사항</h2>
        <h3>✔️ 스트레스 관리 기법</h3>
        <ul>
            <li>명상과 심호흡: 하루 10분 이상 명상을 통해 마음을 안정시키고 스트레스를 완화하세요.</li>
            <li>가벼운 운동: 산책이나 요가 같은 활동은 긴장을 줄이고 심리적 안정을 높이는 데 효과적입니다.</li>
        </ul>
        <h3>✔️ 긍정적 정서 활동</h3>
        <ul>
            <li>행복했던 순간을 떠올리는 연습을 통해 긍정적인 정서를 유도하세요.</li>
            <li>가족과 시간을 보내거나 좋아하는 취미 활동(예: 그림 그리기, 음악 감상)을 통해 스트레스를 완화하세요.</li>
        </ul>
        <h3>✔️ 우뇌 활성화 및 안정 활동</h3>
        <ul>
            <li>음악 감상 및 연주: 클래식 음악 감상 또는 간단한 악기(예: 우쿨렐레, 피아노) 연주를 추천합니다.</li>
            <li>미술 활동: 색칠하기나 간단한 수채화 그리기를 통해 창의성을 자극하세요.</li>
            <li>스토리텔링: 자신의 경험을 바탕으로 이야기를 구성하고 글로 표현해보세요.</li>
        </ul>
        <h3>✔️ 정기적인 뇌 건강 점검</h3>
        <ul>
            <li>뇌 활성화 상태와 산소포화도의 변화를 지속적으로 모니터링하기 위해 1~2개월 간격으로 fNIRS 검사를 추천드립니다.</li>
        </ul>
    </section>

    <section>
        <h2>🎯 결론</h2>
        <p>곽혜란님의 분석 결과, 전반적으로 안정된 뇌 활성화 상태를 유지하고 있으나, 높은 스트레스 점수와 우뇌 안정성 저하가 관찰되었습니다. 또한, 상상운동 과제를 통해 뇌의 연결성이 잘 유지되고 있음을 확인하였습니다. 스트레스 관리 활동과 우뇌 안정화를 위한 활동을 실천하신 후, 뇌 상태 변화를 추적하기 위해 재검사를 권장드립니다.</p>
        <p>이 리포트가 뇌 건강 관리와 심리적 안정성 유지에 유용한 지침이 되기를 바랍니다.</p>
    </section>
</div>

<script>
    // 스트레스 정도 챠트
    const ctx = document.getElementById('stressChart').getContext('2d');

    // 그라데이션 설정
    const gradient = ctx.createLinearGradient(0, 0, ctx.canvas.width, 0);
    gradient.addColorStop(0, 'green'); // 좌측 녹색
    gradient.addColorStop(0.5, 'yellow'); // 중간 노란색
    gradient.addColorStop(1, 'red'); // 우측 빨간색

    // 차트 데이터 설정
    const data = {
        labels: ['스트레스 지수'], // 단일 라벨로 표시
        datasets: [{
            label: '스트레스 정도',
            data: [75], // 스트레스 정도: 0~100
            backgroundColor: gradient, // 그라데이션 적용
            borderColor: 'rgba(0, 0, 0, 0.1)', // 외곽선 색상
            borderWidth: 1
        }]
    };

    // 차트 생성
    new Chart(ctx, {
        type: 'bar', // 차트 유형을 막대형으로 지정
        data: data,
        options: {
            indexAxis: 'y', // 막대를 가로 방향으로 변경
            responsive: true,
            plugins: {
                legend: {
                    display: false // 범례 숨김
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: '스트레스 점수 (0 ~ 100)'
                    },
                    min: 0,
                    max: 100
                },
                y: {
                    grid: {
                        display: false // 가로선 제거
                    }
                }
            }
        }
    });


    // 좌우측 뇌 혈류 활성도 챠트
    const brainFlowCtx = document.getElementById('brainFlowChart').getContext('2d');
    new Chart(brainFlowCtx, {
        type: 'line',
        data: {
            labels: Array.from({length: 72}, (_, i) => i * 100),
            datasets: [
                {
                    label: '좌뇌 활성도',
                    data: Array.from({length: 72}, () => Math.random() * 0.00025 - 0.0001),
                    borderColor: 'red',
                    fill: false,
                    tension: 0.1,
                    pointRadius: 0
                },
                {
                    label: '우뇌 활성도',
                    data: Array.from({length: 72}, () => Math.random() * 0.00025 - 0.0001),
                    borderColor: 'blue',
                    fill: false,
                    tension: 0.1,
                    pointRadius: 0
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                x: {title: {display: true, text: '시간(초)'}},
                y: {title: {display: true, text: '변화량'}}
            }
        }
    });

    // 좌우측 뇌 산소포화도 챠트
    const oxygenCtx = document.getElementById('oxygenChart').getContext('2d');
    new Chart(oxygenCtx, {
        type: 'line',
        data: {
            labels: Array.from({length: 72}, (_, i) => i * 100),
            datasets: [
                {
                    label: '좌측 산소포화도',
                    data: Array.from({length: 72}, () => Math.random() * 20 + 65),
                    borderColor: 'red',
                    fill: false,
                    tension: 0.1,
                    pointRadius: 0
                },
                {
                    label: '우측 산소포화도',
                    data: Array.from({length: 72}, () => Math.random() * 20 + 65),
                    borderColor: 'blue',
                    fill: false,
                    tension: 0.1,
                    pointRadius: 0
                }
            ]
        },
        options: {
            responsive: true,
            //aspectRatio: 8,
            scales: {
                x: {title: {display: true, text: '시간(초)'}},
                y: {
                    title: {
                        display: true,
                        text: '산소포화도(%)'
                    },
                    ticks: {
                        stepSize: 1, // y축 눈금 간격
                    }
                }
            }
        }
    });

    // "상담 일시"와 "상담 결과" 데이터를 서버에서 받아온다고 가정
    const clientData = {
        datetime: '2025.01.06 17:40', // 상담 일시
        name: '곽혜란' // 상담자의 결과
    };

    // DOM 요소에 값 삽입
    document.getElementById('analysisDatetime').innerText = clientData.datetime;
    document.getElementById('clientName').innerText = clientData.name;
</script>
</body>
</html>
