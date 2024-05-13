const DOMAIN_MEMBER_IMAGE_URL = DOMAIN_IMAGE_URL + "/mmbr";
const DOMAIN_CLUB_IMAGE_URL = DOMAIN_IMAGE_URL + "/club";
const DOMAIN_PLAY_IMAGE_URL = DOMAIN_IMAGE_URL + "/play";

const createMemberImageUrl = (memberId, imageUrl) => {
    if (!imageUrl) {
        return DOMAIN_MEMBER_IMAGE_URL + "/default.png";
    }
    // https://bogopayo.cafe24.com/img/mmbr/default.png

    return DOMAIN_MEMBER_IMAGE_URL + "/" + memberId + "/" + imageUrl;
};

const createClubImageUrl = (clubId, imageUrl) => {
    if (!imageUrl) {
        return DOMAIN_CLUB_IMAGE_URL + "/default.png";
    }

    return DOMAIN_CLUB_IMAGE_URL + "/" + clubId + "/" + imageUrl;
};

const createPlayImageUrl = (playMemberId, imageUrl) => {
    if (!imageUrl) {
        // return DOMAIN_PLAY_IMAGE_URL + "/default.png";
        // TODO: DOMAIN_PLAY_IMAGE_URL 이미지 업로드
        return DOMAIN_CLUB_IMAGE_URL + "/default.png";
    }

    return DOMAIN_PLAY_IMAGE_URL + "/" + playMemberId + "/" + imageUrl;
};

// htmlString += "		<img src=\"https://bogopayo.cafe24.com/img/play/" + value.seq + "/" + value.fdbckImgFileNm + "\" class=\"card-img-top\">";
