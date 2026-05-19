-- 1. ELIMINA IL VECCHIO DATABASE (per fare pulizia)
DROP DATABASE IF EXISTS modelloMVC;

-- 2. CREA IL NUOVO DATABASE
CREATE DATABASE modelloMVC;
USE modelloMVC;

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
                           descrizione VARCHAR(200) NULL
);

CREATE TABLE Prodotto (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          nome VARCHAR(255) NOT NULL,
                          descrizione VARCHAR(100) NULL,
                          prezzo DECIMAL(10, 2) NOT NULL,
                          quant_vend INT NOT NULL DEFAULT 0,
                          sconto INT NOT NULL DEFAULT 0,
                          images VARCHAR(255) NULL,
                          video VARCHAR(255) NULL
);

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

CREATE TABLE Prodotto_in_evidenza (
                                      id_evidenza INT NOT NULL ,
                                      PRIMARY KEY (id_evidenza),
                                      FOREIGN KEY (id_evidenza) REFERENCES Prodotto(id)
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

CREATE TABLE libreria (
                          idUtente INT NOT NULL,
                          idProdotto INT NOT NULL,
                          nome VARCHAR(255) NOT NULL,
                          descrizione VARCHAR(100) NULL,
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
ALTER TABLE Prodotto ADD FULLTEXT(nome);
-- INSERT INTO Utente (username, passwordhash, email, adminn, images)
-- VALUES
-- ('mrossi', '123456sO', 'mario.rossi@example.com', FALSE, 'uploads/mrossi.png'),
-- ('lbianchi', '123456sO', 'laura.bianchi@example.com', TRUE, NULL),
-- ('gverdi', '123456sO', 'gianni.verdi@example.com', FALSE, 'uploads/gverdi.jpg'),
-- ('aferrari', '123456sO', 'anna.ferrari@example.com', FALSE, NULL),
-- ('admin', '123456sO', 'admin@example.com', TRUE, 'uploads/admin_avatar.png');



INSERT INTO Utente (username, passwordhash, email, adminn, images)
VALUES  ('mattone', '5ea345ab330cf29f81d8de9bf5466f508fe351e1', 'mario.rossi@example.com', FALSE, NULL),
        ('mattoneAdmin', '5ea345ab330cf29f81d8de9bf5466f508fe351e1', 'marioAdmin.rossi@example.com', TRUE, NULL);

INSERT INTO Prodotto (nome, descrizione, prezzo, quant_vend, sconto, images, video)
VALUES
-- ('call of duty', 'sparatutto', 45.00,'3.jpg', 'cod.mp4'),
('call of duty', 'sparatutto', 45.00, 100, 10 , '3.jpg', 'cod.mp4'),
('pes 2020', 'sport', 90.00, 200, 0 ,'4.jpg', 'pes20.mp4'),
('rocket league', 'corsa', 45.00, 937, 0 ,'5.jpg', 'rocket.mp4'),
('metal slug 5', 'azione', 20, 100, 75 ,'2.jpg', 'metal.mp4'),
('fifa 2020', 'sport', 90, 1200, 0 ,'1.jpg', 'fifa20.mp4')

;
INSERT INTO Prodotto_in_evidenza (id_evidenza)
VALUES  (1) /*call of duty*/ , (2) /* pes 2020 */, (3) /* rocket league */, (4) /* metal slug 5*/  ;


INSERT INTO Categoria (nome, descrizione)
VALUES ('sparatutto', 'giochi sparatutto in prima persona');

INSERT INTO Prodottocategoria (idProdotto,idCategoria) VALUES
                                                           (1,1),
                                                           (2,1)
;

-- INSERT INTO libreria (idUtente, idProdotto, nome, descrizione, images)
-- VALUES (1, 1,'rainbow6', 'sparatutto', 'rainbow.jpg' );

SELECT * FROM Carrello;
SELECT * FROM Prodotto;

SELECT * FROM dettaglio_ordini;
SELECT * FROM prodotto_ordini;

SELECT * FROM Prodotto_in_evidenza;

-- SELECT * FROM Prodotto WHERE MATCH("metal slug 5");
SELECT * FROM Prodotto WHERE nome LIKE '%metal s%';
-- TRUNCATE TABLE Prodotto_in_evidenza;

-- DELETE FROM Prodotto_in_evidenza WHERE id_evidenza BETWEEN 1 AND 4;



-- Ab123456