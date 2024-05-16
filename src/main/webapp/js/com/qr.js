const gfn_openQrImage = () => {
    window.open("/qr?url=" + encodeURIComponent(document.URL), "_blank");
};
