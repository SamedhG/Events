import $ from "jquery"

function invited(data, status, _xhr) {
    console.log("updated", status, data);
    $("#invite-list").append(`<tr><td>${data.data.email}</td><td>${data.data.response}</td></tr>`)
}

function invite(event_id, email) {
    let body = {event_id, email};
    $.ajax("/api/invites", {
        method: "post",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify(body),
        headers: {
            'x-auth': window.userToken,
        },
        success: invited,
        error: console.log,
    });
}

function responded(data, status, _xhr) {
    console.log("updated", status, data);
    $("#invite-list").children().each((_i, e) => {
        if (e.firstElementChild.innerText == data.data.email)
            e.lastElementChild.innerText = data.data.response
    })
}

function respond(event_id, response) {
    let body = {event_id, response};
    $.ajax("/api/invites/0", {
        method: "patch",
        dataType: "json",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify(body),
        headers: {
            'x-auth': window.userToken,
        },
        success: responded,
        error: console.log,
    });
}


function setup() {
    $("#invite-btn").click(() => {
        let id = $("#invite-btn").data('event-id')
        let email = $("#invite-email").val()
        invite(id, email)
    })
    $("#response").click((e) => {
        $("#invite-no").removeClass("active")
        $("#invite-yes").removeClass("active")
        $("#invite-maybe").removeClass("active")
        $(e.target).addClass("active")
        let response = e.target.id.split("-")[1]
        let id = $("#response").data('event-id')
        respond(id, response)
    })
}

$(setup);
