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
                          quantita INT NOT NULL DEFAULT 0,
                          prezzo DOUBLE NOT NULL DEFAULT 0,
                          images VARCHAR(50) NULL,
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
                                data_vis VARCHAR(50) NULL,
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





INSERT INTO Utente (username, passwordhash, email, adminn, images)
VALUES  ('mattone', '5ea345ab330cf29f81d8de9bf5466f508fe351e1', 'mario.rossi@example.com', FALSE, NULL),
        ('mattoneAdmin', '5ea345ab330cf29f81d8de9bf5466f508fe351e1', 'marioAdmin.rossi@example.com', TRUE, NULL);

INSERT INTO Prodotto (nome, descrizione, prezzo, images, video)
VALUES
    ('call of duty', 'sparatutto', 45.00,'3.jpg', 'cod.mp4'),
    ('pes 2020', 'sparatutto', 90.00,'4.jpg', 'pes20.mp4')
;

INSERT INTO Categoria (nome, descrizione)
VALUES ('sparatutto', 'giochi sparatutto in prima persona');

-- INSERT INTO libreria (idUtente, idProdotto, nome, descrizione, images)
-- VALUES (1, 1,'rainbow6', 'sparatutto', 'rainbow.jpg' );



SELECT * FROM Carrello;

SELECT DISTINCT id,username,passwordhash FROM Utente;
SELECT id,nome FROM Prodotto WHERE id = 1;
Select idProdotto FROM Carrello;

-- Ab123456









































































































































