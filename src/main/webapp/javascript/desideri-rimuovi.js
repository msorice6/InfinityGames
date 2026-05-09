function annulla(id) {
    document.getElementById("form-remove" + id).style.display = "none";
    document.getElementById("remove" + id).style.display = "block";

    if (window.innerHeight < 468) {
        document.getElementById("des").style.height = "200px";
    }
}

function rimuovi(id) {
    if (window.innerHeight < 468) {
        document.getElementById("des").style.height = "270px";
    }

    document.getElementById("form-remove" + id).style.display = "block";
    document.getElementById("remove" + id).style.display = "none";
}