const DOMAIN_MEMBER_IMAGE_URL = DOMAIN_IMAGE_URL + "/mmbr";
const DOMAIN_CLUB_IMAGE_URL = DOMAIN_IMAGE_URL + "/club";

const createMemberImageUrl = (memberId, imageUrl) => {
    return DOMAIN_MEMBER_IMAGE_URL + "/" + memberId + "/" + imageUrl;
};

const createClubImageUrl = (clubId, imageUrl) => {
    return DOMAIN_CLUB_IMAGE_URL + "/" + clubId + "/" + imageUrl;
};
