function categoria(str, pag, ord) {
    var num = globale;
    var dataList = document.getElementById("sottomenu" + num);
    var xmlHttpReq = new XMLHttpRequest();
    xmlHttpReq.responseType = 'json';

    xmlHttpReq.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            // Rimuove gli elementi all'interno del contenitore
            dataList.innerHTML = "";
        }
    }; // Fine di onreadystatechange

    // Questi due comandi ora sono correttamente all'interno della funzione principale
    xmlHttpReq.open("GET", "CategoriaAjax?ricerca=" + encodeURIComponent(num) + "&id=" + encodeURIComponent(str) + "&pag=" + encodeURIComponent(pag) + "&ord=" + encodeURIComponent(ord), true);
    xmlHttpReq.send();
}
/*
var quanti=3;
var i;

    myfunction= function (conta,str) {
        $("#sottomenu" + conta).css("display", "block");
        $("#principale" + conta).css({"color": "white", "background-color": "#214b6b"})
        for (i=1;i<=quanti;i++) {
            if(i!=conta){
                $("#principale"+i).css("color","#000000");
                $("#principale"+i).css("backgroundColor","#7c9ccc");
                $("#sottomenu"+i).css("display","none");
            }
        }
        $("#principale"+conta).click(function(){
            $.ajax({type:"GET", url: "CategoriaAjax", dataType:"JSON", data:"ricerca="+conta+"&"+"id="+str,
                success: function(result){

                }});
        });
    }

*/