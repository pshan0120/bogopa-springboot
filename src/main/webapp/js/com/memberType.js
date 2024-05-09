class MemberType {

    static CLUB_MEMBER = {
        code: "1",
        name: "CLUB_MEMBER",
        title: "모임원"
    };

    static CLUB_MASTER = {
        code: "2",
        name: "CLUB_MASTER",
        title: "모임장",
    };

    static ofCode = code => {
        if (this.CLUB_MEMBER.code === code) return this.CLUB_MEMBER;
        if (this.CLUB_MASTER.code === code) return this.CLUB_MASTER;
    }

}
