function openNav() {
    document.getElementById("myNav").style.width = "230px";
}

function closeNav() {
    document.getElementById("myNav").style.width = "0px";
}

// Chiudi il menu se si clicca fuori (opzionale, ma migliora UX)
document.addEventListener("click", function(event) {
    var nav = document.getElementById("myNav");
    var openButton = document.querySelector(".icon-resp a");

    // Se il menu è aperto e il click non è sul menu né sul bottone che lo apre
    if (nav.style.width === "230px" &&
        !nav.contains(event.target) &&
        !openButton.contains(event.target)) {
        closeNav();
    }
});