# Bogopa (Boardgame Portal Application)

Bogopa는 다양한 보드게임을 온라인에서 지원하고 커뮤니티 활동을 할 수 있도록 설계된 **보드게임 포털 애플리케이션**입니다. 특히 'Blood on the Clocktower(BOC)'와 같은 사회적 추리 게임의 온라인 플레이를 지원하는 기능이 핵심입니다.

---

## 🛠 Tech Stack

### Backend
- **Language**: Java 17
- **Framework**: Spring Framework 4.3.25.RELEASE
- **Persistence**: MyBatis 3.2.2
- **Database**: MySQL (Connector 5.1.31)
- **Encryption**: Jasypt (DB 암호화)
- **Build Tool**: Maven

### Frontend
- **View Engine**: JSP, Velocity
- **Library**: JSTL, jQuery, Bootstrap (예상)
- **Features**: QR Code (ZXing), Sound Effects, Real-time Interaction

### Others
- **Communication**: Slack API, Twitter API 연동
- **Automation**: Selenium (웹 크롤링 또는 테스트용)
- **Logging**: SLF4J, Log4j, Log4jdbc (SQL 로깅)

---

## 📂 Project Structure

```text
src/main/java/boardgame
├── bo/         # Back Office (관리자) - 회원, 게임 정보 관리 등
├── fo/         # Front Office (사용자) - 실제 서비스 레이어
│   ├── board/  # 커뮤니티 게시판
│   ├── club/   # 모임/클럽 관리
│   ├── game/   # 보드게임별 로직 (BOC, Becoming a Dictator, Zombie 등)
│   ├── login/  # 인증 (QR 로그인 포함)
│   ├── play/   # 게임 플레이 기록 및 로그 관리
│   └── ...
└── com/        # Common (공통 클래스) - 유틸리티, 세션 리스너 등
```

---

## 🎮 Key Features

1. **Blood on the Clocktower (BOC) 지원**
   - 'Trouble Brewing' 시나리오를 포함한 온라인 플레이 지원
   - 커스텀 설정 및 가이드 제공
2. **다양한 보드게임 모듈**
   - Becoming a Dictator, Catch a Thief, Food Chain Magnate, Fruit Shop, Zombie 등 개별 게임 컨트롤러 및 뷰 구현
3. **커뮤니티 및 클럽**
   - 사용자간 모임을 생성하고 게시판을 통해 소통 가능
4. **게임 기록(Play Log)**
   - 플레이어별 게임 기록 및 승패 데이터 관리
5. **편의 기능**
   - QR 코드를 이용한 간편 로그인
   - 게임 중 사운드 효과 및 메모 도구 제공

---

## 🚀 Getting Started

### Prerequisites
- Java 17 이상
- Maven 3.x
- MySQL Database
- Tomcat 8.5 이상 (WAR 패키징)

### Configuration
1. **Database 설정**: `src/main/resources/jdbc.properties` 파일에서 DB 연결 정보를 수정하세요.
   - 패스워드는 Jasypt로 암호화되어 있습니다. (기본 암호 키: `bogopa`)
2. **Maven Build**:
   ```bash
   mvn clean install
   ```
3. **Deployment**: 생성된 `target/boardgame.war` 파일을 톰캣의 `webapps` 디렉토리에 배포하세요.

---

## 📝 License
이 프로젝트의 라이선스는 프로젝트 소유자에게 있습니다.
