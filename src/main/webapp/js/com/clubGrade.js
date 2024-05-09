class ClubGrade {

    static BRONZE = {
        code: "1",
        name: "BRONZE",
        title: "브론즈"
    };

    static SILVER = {
        code: "2",
        name: "SILVER",
        title: "실버",
    };

    static GOLD = {
        code: "3",
        name: "GOLD",
        title: "골드",
    };

    static ofCode = code => {
        if (this.BRONZE.code === code) return this.BRONZE;
        if (this.SILVER.code === code) return this.SILVER;
        if (this.GOLD.code === code) return this.GOLD;
    };

}
