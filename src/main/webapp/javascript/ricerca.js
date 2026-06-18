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

            for (var i = 0; i < responseArray.length; i++) {
                var prodotto = responseArray[i];

                var option = document.createElement('option');

                option.value = prodotto.nome;


                dataList.appendChild(option);
                document.getElementById("risultati").textContent = prodotto.id;

            }
        }
    }

    xmlHttpReq.open("GET", "RicercaAjax?q=" + encodeURIComponent(str), true);
    xmlHttpReq.send();
}

function forzaReindirizzamento(event) {
    event.preventDefault();
    let contenutoP = document.getElementById("risultati").textContent;
    window.location.href = "Prodotto?id=" + encodeURIComponent(contenutoP.trim());
}

function dropClick(){
    alert("ID TROVATO");
}