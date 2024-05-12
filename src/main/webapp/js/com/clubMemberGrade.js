class ClubMemberGrade {

    static ASSOCIATE = {
        code: "1",
        name: "ASSOCIATE",
        title: "준회원"
    };

    static REGULAR = {
        code: "2",
        name: "REGULAR",
        title: "정회원",
    };

    static EXCELLENT = {
        code: "3",
        name: "EXCELLENT",
        title: "우수회원",
    };

    static STAFF = {
        code: "4",
        name: "STAFF",
        title: "운영진",
    };

    static MASTER = {
        code: "5",
        name: "MASTER",
        title: "모임장",
    };

    static ofCode = code => {
        if (this.ASSOCIATE.code == code) return this.ASSOCIATE;
        if (this.REGULAR.code == code) return this.REGULAR;
        if (this.EXCELLENT.code == code) return this.EXCELLENT;
        if (this.STAFF.code == code) return this.STAFF;
        if (this.MASTER.code == code) return this.MASTER;
    };

}
