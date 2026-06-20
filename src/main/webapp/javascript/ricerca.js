
var globalVar = [];
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

            for (var i in this.response) {
                var option = document.createElement('option');

                option.value = this.response[i].nome;

                globalVar.push({
                    nome: this.response[i].nome,
                    id: this.response[i].id
                });

                dataList.appendChild(option);
            }
        }
    }

    xmlHttpReq.open("GET", "RicercaAjax?q=" + encodeURIComponent(str), true);
    xmlHttpReq.send();
}

function forzaReindirizzamento(idToRedirect) {

    window.location.href = "Prodotto?id=" + encodeURIComponent(idToRedirect);
}

const inputField = document.getElementById('inputText');

inputField.addEventListener('input', function(event) {
    if (event.inputType === 'insertReplacementText') {

        myCustomFunction(this.value);

    } else if (event.inputType === undefined) {
            myCustomFunction(this.value);
    }
});

function myCustomFunction(selectedValue) {

    if (!globalVar || globalVar.length === 0) {
        console.log("Nessun dato memorizzato in globalVar.");
        return;
    }

    for (var i = 0; i < globalVar.length; i++) {
        if(globalVar[i].nome === selectedValue) {
            selectedValue = globalVar[i].id;
            break;
        }
    }

    forzaReindirizzamento(selectedValue);
}

