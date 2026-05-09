document.addEventListener("DOMContentLoaded", function() {

    var infoElements = document.querySelectorAll(".info");

    infoElements.forEach(function(element) {
        element.addEventListener("click", function() {
            var nextElement = this.nextElementSibling;

            if (nextElement.offsetHeight == 0) {
                nextElement.style.height = "auto";
                nextElement.style.padding = "10px";
                nextElement.style.border = "solid";
            } else {
                nextElement.style.height = "0px";
                nextElement.style.padding = "0px";
                nextElement.style.border = "none";
            }
        });
    });

});