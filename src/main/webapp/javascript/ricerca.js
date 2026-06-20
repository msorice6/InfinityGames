
var globalVar;
function ricerca(str) {
    var dataList = document.getElementById("ricerca-datalist");

    if (str.length === 0) {
        dataList.innerHTML = "";
        return;
    }

    var xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.responseType = 'json';
    xmlHttpReq.onreadystatechange = function () {

        if (this.readyState == 4 && this.status == 200) {
            dataList.innerHTML = "";
            var responseArray = this.response;

            for (var i in this.response) {
                var prodotto = responseArray[i];

                var option = document.createElement('option');

                option.value = this.response[i];

                globalVar = option.value;

                dataList.appendChild(option);
                document.getElementById("risultati").textContent = prodotto.id;


            }
        }
    }

    xmlHttpReq.open("GET", "RicercaAjax?q=" + encodeURIComponent(str), true);
    xmlHttpReq.send();
}

// 5. Update the function to accept the ID directly
function forzaReindirizzamento(idToRedirect) {
    alert("idToredirect"+idToRedirect);
    // We do not need event.preventDefault() here because we are doing a manual JS redirect
    window.location.href = "Prodotto?id=" + encodeURIComponent(idToRedirect);
}


const inputField = document.getElementById('inputText');

inputField.addEventListener('input', function(event) {
    // Check if the input was caused by selecting a datalist option
    if (event.inputType === 'insertReplacementText') {

        // Call your function and pass the selected value
        myCustomFunction(this.value);

    } else if (event.inputType === undefined) {
        // Fallback for older browsers: check if the typed value exactly matches an option
            myCustomFunction(this.value);
    }
});

function myCustomFunction(selectedValue) {
    forzaReindirizzamento(globalVar);
}