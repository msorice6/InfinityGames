document.addEventListener("DOMContentLoaded", function() {

    var dropElements = document.querySelectorAll(".drop");

    dropElements.forEach(function(element) {
        element.addEventListener("click", function() {
            var nextElement = this.nextElementSibling;

            if (nextElement.offsetHeight == 0) {
                if (nextElement.className == "dropdown-content") {
                    nextElement.style.height = "130px";
                } else {
                    nextElement.style.height = "230px";
                }
            } else {
                nextElement.style.height = "0px";
            }
        });
    });

});