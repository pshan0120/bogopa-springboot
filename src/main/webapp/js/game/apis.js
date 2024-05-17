const gfn_readPlayablePlayById = async playId => {
    const play = await readPlayById(playId);
    console.log('play', play);

    if (!play) {
        alert("존재하지 않는 플레이입니다.");
        location.href = "/play";
    }

    const statusCode = PlayStatus.ofCode(play.statusCode);
    if (statusCode === PlayStatus.STAND_BY) {
        location.href = "/play/waiting-room/" + playId;
    }

    if (statusCode === PlayStatus.FINISHED
        || statusCode === PlayStatus.ABNORMAL) {
        location.href = "/play";
    }

    return play;
};

const gfn_readBeginablePlayById = async playId => {
    const play = await readPlayById(playId);
    console.log('play', play);

    if (!play) {
        alert("존재하지 않는 플레이입니다.");
        location.href = "/play";
    }

    const statusCode = PlayStatus.ofCode(play.statusCode);
    if (statusCode === PlayStatus.PLAYING) {
        location.href = "/game/" + play.playUri + "/play/" + PLAY_ID;
    }

    if (statusCode === PlayStatus.FINISHED
        || statusCode === PlayStatus.ABNORMAL) {
        location.href = "/play";
    }

    return play;
};

const readPlayById = async playId => {
    return await gfn_callGetApi("/api/play", {playId})
        .then(data => data)
        .catch(response => console.error('error', response));
};
