function negozio() {
    alert("chiamoMEtoedo");
    var dataList = document.getElementById("ricerca-datalist");

//    if (str.length === 0) {
//        dataList.innerHTML = "";
//        return;
//    }
    var str = "";
    // Retrieve the current selected values from the dropdowns in negozio.jsp
    var currentOrd = document.getElementById("ordineSelect").value;
    var currentCategoria = document.getElementById("categoriaSelect").value;

    var xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.responseType = 'json';
    xmlHttpReq.onreadystatechange = function () {

        if (this.readyState == 4 && this.status == 200) {

            for (var i in this.response) {
                var option = document.createElement('option');
                if(i == 0){
                    alert ("thisponseNOme: " + this.response[i].nome);
                }
                option.value = this.response[i].nome;

                globalVar.push({
                    nome: this.response[i].nome,
                    id: this.response[i].id
                });

            }
        }
    }

    var requestUrl = "NegozioAjax?ord=" + encodeURIComponent(currentOrd) +
        "&categoria=" + encodeURIComponent(currentCategoria) +
        "&q=" + encodeURIComponent(str);

    xmlHttpReq.open("GET", requestUrl, true);
    xmlHttpReq.send();
}