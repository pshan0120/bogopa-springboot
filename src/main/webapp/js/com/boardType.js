class BoardType {

    static NOTICE = {
        code: "1",
        name: "NOTICE",
        title: "공지사항"
    };

    static FAQ = {
        code: "2",
        name: "FAQ",
        title: "FAQ",
    };

    static ofCode = code => {
        if (this.NOTICE.code == code) return this.NOTICE;
        if (this.FAQ.code == code) return this.FAQ;
    }

}
