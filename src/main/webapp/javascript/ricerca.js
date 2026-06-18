function ricerca(query) {
    var datalist = document.getElementById("ricerca-datalist");
    // Clear the datalist if the search box is emptied
    if (query.trim() === "") {
        datalist.innerHTML = "";
        return;
    }

    // Make the AJAX request to the Servlet
    fetch("RicercaAjax?q=" + encodeURIComponent(query))
        .then(function(response) {
            if (!response.ok) {
                throw new Error("Errore nella risposta della rete");
            }
            return response.json();
        })
        .then(function(data) {
            // Clear existing options
            datalist.innerHTML = "";

            // data is now an array of objects: [{id: 1, nome: "Prodotto"}, ...]
            data.forEach(function(prodotto) {
                var option = document.createElement("option");

                // Set the value to the name so only the name appears in the datalist
                option.value = prodotto.nome;
                // Store the ID as a data attribute in case it is needed later
                option.setAttribute("data-id", prodotto.id);
                var prodottoId = prodotto.id;
                datalist.appendChild(option);
            });
        })
        .catch(function(error) {
            console.error("Errore durante la fetch:", error);
        });
    function forzaReindirizzamento(query) {
        alert("hai cliccato");
        // 1. Blocca l'invio standard del form che genererebbe "?id=testo_digitato"
        query.preventDefault();

        // 2. Reindirizza manualmente forzando l'URL esatto
        window.location.href = "Prodotto?id=jasmine";
    }

}