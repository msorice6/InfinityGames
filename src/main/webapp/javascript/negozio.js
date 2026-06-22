
// 1. We must define the function that builds the HTML here so the script knows what to do
function createProductCardWithTemplate(prodotto) {
    var divContieni = document.createElement('div');
    divContieni.className = 'contieni';

    // Format the price based on whether there is a discount
    var prezzoHtml = '';
    if (prodotto.sconto > 0) {
        var prezzo = prodotto.prezzo ? prodotto.prezzo.toFixed(2) : '0.00';
        var prezzoScontato = prodotto.prezzoScontato ? prodotto.prezzoScontato.toFixed(2) : '0.00';
        prezzoHtml = '<span style="color: green">-' + prodotto.sconto + '%</span>' +
            '<h5>Prezzo: <del>' + prezzo + '€</del> ' + prezzoScontato + '€</h5>';
    } else {
        var prezzo = prodotto.prezzo ? prodotto.prezzo.toFixed(2) : '0.00';
        prezzoHtml = '<h5>Prezzo: ' + prezzo + '€</h5>';
    }

    // Safely extract categories and build the links
    var categorieHtml = '';
    if (prodotto.categorie && prodotto.categorie.length > 0) {
        var catLinks = [];
        var currentOrd = document.getElementById("ordineSelect").value;
        for(var i = 0; i < prodotto.categorie.length; i++) {
            var cat = prodotto.categorie[i];
            catLinks.push('<a class="categoria" href="Negozio?categoria=' + cat.id + '&ord=' + currentOrd + '">' + cat.nome + '</a>');
        }
        categorieHtml = catLinks.join(', ');
    }

    // Fallbacks just in case the JSON is missing data
    var images = prodotto.images ? prodotto.images : 'default.png';
    var quantVend = prodotto.quant_vend ? prodotto.quant_vend : 0;
    var nome = prodotto.nome ? prodotto.nome : 'Prodotto Sconosciuto';

    // Inject everything into the template
    divContieni.innerHTML =
        '<div class="img-col">' +
        '<a class="sub-img" href="Prodotto?id=' + encodeURIComponent(prodotto.id) + '">' +
        '<img src="images/prodotti/' + images + '" alt="' + nome + '">' +
        '</a>' +
        '</div>' +
        '<div class="col-2">' +
        '<div class="right-col">' +
        '<div class="name-over">' +
        '<h5>' + nome + '</h5>' +
        '</div>' +
        '<div class="prezzo-down">' +
        '<div class="sub-prezzo">' +
        prezzoHtml +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="col-2-right">' +
        '<div style="float: right">' +
        '<p>Quantità vendute: ' + quantVend + '</p>' +
        '<p>Categorie: ' + categorieHtml + '</p>' +
        '</div>' +
        '</div>';

    return divContieni;
}

// 2. Your main AJAX function
function negozio() {
    var inputElement = document.getElementById("inputText");
    var str = inputElement ? inputElement.value : "";

    var currentOrd = document.getElementById("ordineSelect").value;
    var currentCategoria = document.getElementById("categoriaSelect").value;

    var xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.responseType = 'json';

    xmlHttpReq.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            var menuContainer = document.getElementById("menu");
            if (!menuContainer) return;

            // Empty the container
            menuContainer.innerHTML = "";

            var prodotti = this.response;

            // Handle no products found
            if (!prodotti || prodotti.length === 0) {
                menuContainer.innerHTML = "<h3>NESSUN PRODOTTO TROVATO</h3><p>Prova a cambiare filtro o categoria.</p>";
                return;
            }

            // 3. THIS MUST NOT BE COMMENTED OUT. Loop through the JSON and draw the elements.
            prodotti.forEach(function(prodotto) {
                var newCard = createProductCardWithTemplate(prodotto);
                menuContainer.appendChild(newCard);
            });
        }
    }

    var requestUrl = "NegozioAjax?ord=" + encodeURIComponent(currentOrd) +
        "&categoria=" + encodeURIComponent(currentCategoria) +
        "&q=" + encodeURIComponent(str);

    xmlHttpReq.open("GET", requestUrl, true);
    xmlHttpReq.send();
}