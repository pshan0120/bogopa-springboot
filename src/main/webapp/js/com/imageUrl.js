const DOMAIN_MEMBER_IMAGE_URL = DOMAIN_IMAGE_URL + "/mmbr";
const DOMAIN_CLUB_IMAGE_URL = DOMAIN_IMAGE_URL + "/club";

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
