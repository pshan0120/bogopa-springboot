/* ---- 공통 기본 Ajax ---- */
function gfn_callPostApi(url) {
    return gfn_callPostApi(url, {})
};

function gfn_callPostApi(url, jsonData) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: stringifyJsonIfExists(jsonData),
            type: "POST",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
}

const gfn_callPostApiByJsonDataAndFileDataArray = (url, jsonData, fileDataArray) => {
    const formData = new FormData();
    formData.append("jsonData", new Blob([JSON.stringify(jsonData)], {type: "application/json"}));
    $.each(fileDataArray, (index, fileData) => {
        $.each(fileData.list, (index, file) => {
            formData.append(fileData.name, file);
        });
    });

    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: formData,
            type: "POST",
            contentType: false,
            enctype: "multipart/form-data",
            processData: false,
            cache: false,
            timeout: 600000,
            async: false,
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
};

const gfn_callPatchApiByJsonDataAndFileDataArray = (url, jsonData, fileDataArray) => {
    const formData = new FormData();
    formData.append("jsonData", new Blob([JSON.stringify(jsonData)], {type: "application/json"}));
    $.each(fileDataArray, (index, fileData) => {
        $.each(fileData.list, (index, file) => {
            formData.append(fileData.name, file);
        });
    });

    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: formData,
            type: "PATCH",
            contentType: false,
            enctype: "multipart/form-data",
            processData: false,
            cache: false,
            timeout: 600000,
            async: false,
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
};

function gfn_callGetApi(url) {
    return gfn_callGetApi(url, {})
};

function gfn_callGetApi(url, jsonData) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            type: "GET",
            data: jsonData,
            contentType: "application/json; charset=utf-8",
            traditional: true,
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
}

const gfn_callPublicGetApi = (url, jsonData) => {
    return gfn_callGetApi(`${PUBLIC_API_URL}${url}`, jsonData)
};

const gfn_callPutApi = (url, jsonData) => {
    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: stringifyJsonIfExists(jsonData),
            type: "PUT",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
}

const gfn_callPatchApi = (url, jsonData) => {
    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: stringifyJsonIfExists(jsonData),
            type: "PATCH",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
}

const gfn_callDeleteApi = (url, jsonData) => {
    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: stringifyJsonIfExists(jsonData),
            type: "DELETE",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                resolve(result);
            },
            error: function (result) {
                reject(result);
            }
        })
    })
}

const gfn_callDownloadApi = (url, jsonData) => {
    return new Promise((resolve, reject) => {
        $.ajax({
            url,
            data: stringifyJsonIfExists(jsonData),
            type: 'POST',
            contentType: "application/json; charset=utf-8",
            cache: false,
            xhrFields: {
                responseType: "blob",
            },
            success: result => {
                resolve(result);
            },
            error: result => {
                reject(result);
            }
        })
            .done((blob, status, xhr) => {
                let fileName = "";
                const disposition = xhr.getResponseHeader("Content-Disposition");

                if (disposition && disposition.indexOf("attachment") !== -1) {
                    const filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                    const matches = filenameRegex.exec(disposition);

                    if (matches != null && matches[1]) {
                        fileName = decodeURI(matches[1].replace(/['"]/g, ""));
                    }
                }

                // for IE
                if (window.navigator && window.navigator.msSaveOrOpenBlob) {
                    window.navigator.msSaveOrOpenBlob(blob, fileName);
                } else {
                    const URL = window.URL || window.webkitURL;
                    const downloadUrl = URL.createObjectURL(blob);

                    if (fileName) {
                        const a = document.createElement("a");

                        // for safari
                        if (a.download === undefined) {
                            window.location.href = downloadUrl;
                        } else {
                            a.href = downloadUrl;
                            a.download = fileName;
                            document.body.appendChild(a);
                            a.click();
                        }
                    } else {
                        window.location.href = downloadUrl;
                    }
                }
            });
    })
}

const stringifyJsonIfExists = jsonData => jsonData ? JSON.stringify(jsonData) : {};
