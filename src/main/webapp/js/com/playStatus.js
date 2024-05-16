class PlayStatus {

    static STAND_BY = {
        code: "4",
        name: "STAND_BY",
        title: "대기"
    };

    static PLAYING = {
        code: "1",
        name: "PLAYING",
        title: "진행중"
    };

    static FINISHED = {
        code: "2",
        name: "FINISHED",
        title: "종료",
    };

    static ABNORMAL = {
        code: "3",
        name: "ABNORMAL",
        title: "비정상",
    };

    static ofCode = code => {
        if (this.STAND_BY.code == code) return this.STAND_BY;
        if (this.PLAYING.code == code) return this.PLAYING;
        if (this.FINISHED.code == code) return this.FINISHED;
        if (this.ABNORMAL.code == code) return this.ABNORMAL;
    }

}
