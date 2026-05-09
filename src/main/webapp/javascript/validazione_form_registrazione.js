var borderOk = '2px solid #080';
var borderNo = '2px solid #f00';
var usernameOk = false;
var passwordOk = false;
var emailOk = false;

function validaUsername() {
    var input = document.forms['registrazione']['username'];

    if (input && input.value && input.value.length >= 6 && input.value.match(/^[0-9a-zA-Z]+$/)) {
        // verifica se esiste un utente con lo stesso username
        var xmlHttpReq = new XMLHttpRequest();
        xmlHttpReq.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200 && this.responseText == '<ok/>') {
                usernameOk = true;
                input.style.border = borderOk;
            } else if (this.readyState == 4) {
                usernameOk = false;
                input.style.border = borderNo;
            }
            cambiaStatoRegistrami();
        }
        xmlHttpReq.open("GET", "VerificaUsername?username=" + encodeURIComponent(input.value), true);
        xmlHttpReq.send();
    } else {
        if (input) input.style.border = borderNo;
        usernameOk = false;
        cambiaStatoRegistrami();
    }
}

function validaPassword() {
    var inputpw = document.forms['registrazione']['password'];
    var inputpwconf = document.forms['registrazione']['passwordConferma'];

    if (!inputpw || !inputpwconf) {
        passwordOk = false;
        cambiaStatoRegistrami();
        return;
    }

    var password = inputpw.value;

    if (password && password.length >= 8 &&
        password.toUpperCase() != password &&
        password.toLowerCase() != password &&
        /[0-9]/.test(password)) {

        inputpw.style.border = borderOk;

        if (password == inputpwconf.value) {
            inputpwconf.style.border = borderOk;
            passwordOk = true;
        } else {
            inputpwconf.style.border = borderNo;
            passwordOk = false;
        }
    } else {
        inputpw.style.border = borderNo;
        if (inputpwconf) inputpwconf.style.border = borderNo;
        passwordOk = false;
    }

    cambiaStatoRegistrami();
}

function validaEmail() {
    var input = document.forms['registrazione']['email'];

    if (!input) {
        emailOk = false;
        cambiaStatoRegistrami();
        return;
    }

    if (input.value && input.value.match(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w+)+$/)) {
        var xmlHttpReq = new XMLHttpRequest();
        xmlHttpReq.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200 && this.responseText == '<ok/>') {
                emailOk = true;
                input.style.border = borderOk;
            } else if (this.readyState == 4) {
                emailOk = false;
                input.style.border = borderNo;
            }
            cambiaStatoRegistrami();
        }
        xmlHttpReq.open("GET", "VerificaEmail?email=" + encodeURIComponent(input.value), true);
        xmlHttpReq.send();
    } else {
        input.style.border = borderNo;
        emailOk = false;
        cambiaStatoRegistrami();
    }
}

function cambiaStatoRegistrami() {
    var registramiBtn = document.getElementById('registrami');
    var messaggioEl = document.getElementById('registramimessaggio');

    if (usernameOk && passwordOk && emailOk) {
        registramiBtn.disabled = false;
        messaggioEl.innerHTML = '';
    } else {
        registramiBtn.disabled = true;
        messaggioEl.innerHTML = 'Verifica che tutti i campi siano in verde.';
    }
}