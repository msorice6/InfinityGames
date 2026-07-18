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
function negozio(paginaRichiesta) {
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

            var pagProdottoCategoria;
            // 3. THIS MUST NOT BE COMMENTED OUT. Loop through the JSON and draw the elements.
            prodotti.forEach(function(prodotto) {
                var newCard = createProductCardWithTemplate(prodotto);
                menuContainer.appendChild(newCard);
                pagProdottoCategoria = prodotto.npag;
            });

            if(currentCategoria > 0)
                alert("num Pagine del prodotto: "+ pagProdottoCategoria);
            aggiornaPaginazione(pagProdottoCategoria);
        }
    }

    var requestUrl = "NegozioAjax?ord=" + encodeURIComponent(currentOrd) +
        "&categoria=" + encodeURIComponent(currentCategoria) +
        "&q=" + encodeURIComponent(str);

    xmlHttpReq.open("GET", requestUrl, true);
    xmlHttpReq.send();
}

function cambiaPagina(pag) {
    // 1. Leggi i valori attualmente selezionati
    var currentOrd = document.getElementById("ordineSelect").value;
    var currentCategoria = document.getElementById("categoriaSelect").value;

    // Leggi anche la barra di ricerca, se esiste
    var inputElement = document.getElementById("inputText");
    var currentQ = inputElement ? inputElement.value : "";

    // 2. Costruisci l'URL verso la Servlet classica (Negozio)
    var url = "Negozio?categoria=" + encodeURIComponent(currentCategoria) +
        "&ord=" + encodeURIComponent(currentOrd) +
        "&q=" + encodeURIComponent(currentQ) +
        "&pag=" + encodeURIComponent(pag) +
        "&perpag=12";

    // 3. Esegui il reindirizzamento
    window.location.href = url;
}

function aggiornaPaginazione(npag, pagCorrente = 1) {
//    var container = document.querySelector('.paginazione');
    var container = document.getElementById('paginazione');
    if (!container) return;

    // Svuota il contenitore prima di aggiornarlo
    container.innerHTML = '';

    // Assicurati che npag sia un intero
    npag = parseInt(npag);

    // Se c'è una sola pagina (o zero), non mostrare la barra di paginazione
    if (isNaN(npag) || npag <= 1) {
        return;
    }

    var html = '';

    // Genera il link "precedente" se non siamo alla prima pagina
    if (pagCorrente > 1) {
        html += '<a href="#" onclick="cambiaPagina(' + (pagCorrente - 1) + '); return false;">&larr; precedente</a>&emsp;';
    }

    // Genera i numeri delle pagine
    for (var i = 1; i <= npag; i++) {
        if (i === pagCorrente) {
            html += '<b>' + i + '</b>&emsp;'; // Pagina attiva non cliccabile
        } else {
            html += '<a href="#" onclick="cambiaPagina(' + i + '); return false;">' + i + '</a>&emsp;';
        }
    }

    // Genera il link "successiva" se non siamo all'ultima pagina
    if (pagCorrente < npag) {
        html += '<a href="#" onclick="cambiaPagina(' + (pagCorrente + 1) + '); return false;">successiva &rarr;</a>';
    }

    // Inserisce il nuovo HTML nel contenitore
    container.innerHTML = html;
}
