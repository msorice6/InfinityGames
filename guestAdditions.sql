-- 1. ELIMINA IL VECCHIO DATABASE (per fare pulizia)
DROP DATABASE IF EXISTS modelloMVC;

-- 2. CREA IL NUOVO DATABASE
CREATE DATABASE modelloMVC;
USE modelloMVC;

-- 3. CREAZIONE TABELLE PRINCIPALI (SENZA DIPENDENZE) --
CREATE TABLE Utente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30) NOT NULL UNIQUE,
    passwordhash CHAR(40) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    adminn BOOLEAN NOT NULL DEFAULT FALSE,
    images VARCHAR(255) NULL
);

CREATE TABLE Categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT NULL
);

CREATE TABLE Prodotto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descrizione TEXT NULL,
    prezzo DECIMAL(10, 2) NOT NULL,
    quant_vend INT NOT NULL DEFAULT 0,
    sconto INT NOT NULL DEFAULT 0,
    images VARCHAR(255) NULL,
    video VARCHAR(255) NULL,
    FULLTEXT(nome)
);

-- 4. CREAZIONE TABELLE DIPENDENTI (CON FOREIGN KEY) --

CREATE TABLE carrello (
    idUtente INT NOT NULL,
    idProdotto INT NOT NULL,
    quantita INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idUtente, idProdotto),
    FOREIGN KEY (idUtente) REFERENCES Utente(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idProdotto) REFERENCES Prodotto(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE dettaglio_ordini (
    idOrd INT AUTO_INCREMENT PRIMARY KEY,
    idUte INT NOT NULL,
    data_acq DATETIME NOT NULL,
    totale DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (idUte) REFERENCES Utente(id)
);

CREATE TABLE prodotto_ordini (
    idOrdine INT NOT NULL,
    idProdotto INT NOT NULL,
    quantita INT NOT NULL,
    prezzo DECIMAL(10, 2) NOT NULL,
    images VARCHAR(255) NULL,
    PRIMARY KEY (idOrdine, idProdotto), 
    FOREIGN KEY (idOrdine) REFERENCES dettaglio_ordini(idOrd)
        ON DELETE CASCADE,
    FOREIGN KEY (idProdotto) REFERENCES Prodotto(id)
        ON DELETE NO ACTION
);

CREATE TABLE Prodottocategoria (
    idProdotto INT NOT NULL,
    idCategoria INT NOT NULL,
    PRIMARY KEY (idProdotto, idCategoria), 
    FOREIGN KEY (idProdotto) REFERENCES Prodotto(id)
        ON DELETE CASCADE,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(id)
        ON DELETE CASCADE
);

CREATE TABLE utenteprodotti (
    uid INT NOT NULL, -- ID Utente
    pid INT NOT NULL, -- ID Prodotto
    data_vis DATETIME NULL,
    visual INT NOT NULL DEFAULT 0,
    data_acq DATETIME NULL,
    acquisto BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (uid, pid),
    FOREIGN KEY (uid) REFERENCES Utente(id)
        ON DELETE CASCADE,
    FOREIGN KEY (pid) REFERENCES Prodotto(id)
        ON DELETE CASCADE
);

-- QUESTA E' LA TABELLA CHE MANCAVA --
CREATE TABLE libreria (
    idUtente INT NOT NULL,
    idProdotto INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    descrizione TEXT NULL,
    images VARCHAR(255) NULL,
    PRIMARY KEY (idUtente, idProdotto),
    FOREIGN KEY (idUtente) REFERENCES Utente(id)
        ON DELETE CASCADE,
    FOREIGN KEY (idProdotto) REFERENCES Prodotto(id)
        ON DELETE CASCADE
);

CREATE TABLE desideri (
    idUtente INT NOT NULL,
    idProdotto INT NOT NULL,
    PRIMARY KEY (idUtente, idProdotto),
    FOREIGN KEY (idUtente) REFERENCES Utente(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idProdotto) REFERENCES Prodotto(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);





-- 5. CREAZIONE VISTE --
CREATE VIEW Popolari AS
SELECT 
    id, nome, descrizione, prezzo, sconto, images, quant_vend AS tot 
FROM Prodotto
WHERE quant_vend > 0
ORDER BY quant_vend DESC;

-- INSERT INTO Utente (username, passwordhash, email, adminn, images)
-- VALUES 
-- ('mrossi', '123456sO', 'mario.rossi@example.com', FALSE, 'uploads/mrossi.png'),
-- ('lbianchi', '123456sO', 'laura.bianchi@example.com', TRUE, NULL),
-- ('gverdi', '123456sO', 'gianni.verdi@example.com', FALSE, 'uploads/gverdi.jpg'),
-- ('aferrari', '123456sO', 'anna.ferrari@example.com', FALSE, NULL),
-- ('admin', '123456sO', 'admin@example.com', TRUE, 'uploads/admin_avatar.png');


-- 6. INSERIMENTO DATI --
 INSERT INTO Utente (id, username, passwordhash, email , adminn, images) 
	VALUES ( 1, 'asdfmovie', '123456sO', 'asdfmovie@asd.it', '3' , NULL );


SELECT DISTINCT id,username,passwordhash FROM Utente; 

