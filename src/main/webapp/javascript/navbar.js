window.addEventListener("resize", function() {

    if (window.innerWidth < 921) {

        // Rimuovi eventi mouseenter dagli elementi con classe accordion
        var accordions = document.querySelectorAll(".accordion");
        accordions.forEach(function(accordion) {
            accordion.removeEventListener("mouseenter", mouseEnterHandler);
        });

        // Aggiungi evento mouseleave agli elementi nav-item
        var navItems = document.querySelectorAll(".nav-item");
        navItems.forEach(function(navItem) {
            navItem.addEventListener("mouseleave", function() {
                var accordionsNext = document.querySelectorAll(".accordion");
                accordionsNext.forEach(function(accordion) {
                    accordion.nextElementSibling.style.display = "none";
                });
            });
        });

        // Aggiungi evento click agli elementi accordion
        accordions.forEach(function(accordion) {
            accordion.addEventListener("click", function() {
                var nextElement = this.nextElementSibling;
                if (nextElement.style.display === "block") {
                    nextElement.style.display = "none";
                } else {
                    nextElement.style.display = "block";
                    nextElement.style.position = "static";
                }
            });
        });

    } else {

        // Imposta position absolute per gli elementi successivi agli accordion
        var accordions = document.querySelectorAll(".accordion");
        accordions.forEach(function(accordion) {
            accordion.nextElementSibling.style.position = "absolute";
        });

        // Rimuovi eventi click esistenti e aggiungi mouseenter
        accordions.forEach(function(accordion) {
            accordion.removeEventListener("click", clickHandler);
            accordion.addEventListener("mouseenter", function() {
                var nextElement = this.nextElementSibling;
                nextElement.style.display = "block";
                nextElement.style.position = "absolute";
            });
        });

        // Gestione mouseleave per nav-item
        var navItems = document.querySelectorAll(".nav-item");
        navItems.forEach(function(navItem) {
            navItem.addEventListener("mouseleave", function() {
                var accordionsNext = document.querySelectorAll(".accordion");
                accordionsNext.forEach(function(accordion) {
                    accordion.nextElementSibling.style.display = "none";
                });
            });
        });
    }
});

// Handler per mouseenter (per poterlo rimuovere)
function mouseEnterHandler() {
    var nextElement = this.nextElementSibling;
    nextElement.style.display = "block";
    nextElement.style.position = "absolute";
}

// Handler per click (per poterlo rimuovere)
function clickHandler() {
    var nextElement = this.nextElementSibling;
    if (nextElement.style.display === "block") {
        nextElement.style.display = "none";
    } else {
        nextElement.style.display = "block";
        nextElement.style.position = "static";
    }
}