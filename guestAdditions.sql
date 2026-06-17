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
                          descrizione VARCHAR(500) NULL,
                          prezzo DECIMAL(10, 2) NOT NULL,
                          quant_vend INT NOT NULL DEFAULT 0,
                          sconto INT NOT NULL DEFAULT 0,
                          images VARCHAR(255) NULL,
                          video VARCHAR(255) NULL
                            FULLTEXT (nome)

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
                          images VARCHAR(255) NULL,
                          quantita INT NOT NULL DEFAULT 1,
                          PRIMARY KEY (idUtente, idProdotto),
                          FOREIGN KEY (idUtente) REFERENCES Utente(id)
                              ON DELETE CASCADE
                              ON UPDATE CASCADE,
                          FOREIGN KEY (idProdotto) REFERENCES Prodotto(id)
                              ON DELETE CASCADE
                              ON UPDATE CASCADE
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
    ('EA FC 26', 'La simulazione di calcio più realistica mai creata! Con licenze ufficiali di tutte le principali leghe, grafica next-gen e gameplay rivoluzionario. Vivi lemozione del calcio con modalità Carriera, Ultimate Team e Volta Football. Nuovi sistemi di intelligenza artificiale e fisica del pallone rendono ogni partita unica.', 69.99, 1000, 10, 'eafc26.jpg', 'eafc26.mp4'),

    ('Red Dead Redemption 2', 'Immergiti nell epopea western più acclamata della storia dei videogiochi. Segui la storia di Arthur Morgan e la banda di Dutch van der Linde nell America del 1899. Un mondo aperto vastissimo, una narrazione profonda e un attenzione ossessiva ai dettagli. Caccia, esplora e sopravvivi nel selvaggio West.', 29.99, 4000, 20, 'rdd2.jpg', 'rdd2.mp4'),

    ('The Last Of Us 2', 'Un viaggio emotivo attraverso un America post-apocalittica devastata da un epidemia fungina. Segui Ellie in una ricerca di vendetta che metterà alla prova la sua umanità. Combattimento intenso, stealth tattico e una narrazione che esplora temi come perdita, amore e redenzione. Grafica mozzafiato e gameplay cinematico.', 39.99, 3500 , 20, 'tlou2.jpg', 'tlou2.mp4'),

    ('Dragon Ball: Sparking Zero!', 'Il ritorno della serie Budokai Tenkaichi! Combattimenti 3D epici con oltre 100 personaggi dell universo Dragon Ball. Mosse speciali iconiche, trasformazioni in tempo reale e distruzione ambientale totale. Modalità Storia completa che ripercorre le saghe dall originale a Super. Online multiplayer per sfidare giocatori da tutto il mondo.', 29.99, 180, 40, 'dbsz.jpg', 'dbsz.mp4'),

    ('Grand Theft Auto 5', 'Vivi tre storie intrecciate nella città di Los Santos, una parodia satirica della Los Angeles moderna. Gioca come Michael, Franklin e Trevor in una epica storia di crimine, tradimento e redenzione. Modalità online GTA Online costantemente aggiornata con nuove missioni, veicoli e attività. Mondo aperto ricco di dettagli e possibilità infinite.', 29.99, 5000, 50, 'gta.jpg', 'gta.mp4'),

    ('Call of Duty: Black Ops 7', 'Torna nello scenario degli operatori neri in una campagna single player mozzafiato che attraversa decenni di conflitti segreti. Multiplayer innovativo con nuovi operatori, mappe e modalità. Zombies mode completamente rinnovata con mappe cooperative e una storyline epica. Grafica di nuova generazione e audio immersivo.', 79.99, 100, 10, 'cod7.jpg', 'cod7.mp4'),

    ('WWE 2K25', 'La simulazione di wrestling più completa e realistica! Con oltre 200 superstar WWE attuali e leggende, crea il tuo percorso nella nuova MyRISE mode. MyGM ti permette di gestire la tua federazione. Grafica fotorealistica, fisica del ring rivoluzionaria e sistema di combattimento profondo. Crea il tuo wrestler con l editor più potente di sempre.', 49.99, 200, 35, 'wwe.jpg', 'wwe.mp4')
;

INSERT INTO Categoria (nome, descrizione)
VALUES ('Avventura', 'Giochi focalizzati su narrazione, esplorazione, risoluzione di enigmi e interazione con personaggi. Include giochi grafici, avventure testuali e action-adventure.'),

       ('Azione', 'Giochi con ritmo veloce, combattimento, esplorazione e missioni. Include giochi open world, stealth, platformer e hack & slash.'),

       ('Picchiaduro', 'Giochi di combattimento uno contro uno o contro più avversari. Include giochi 2D, 3D, anime fighter e giochi di wrestling.'),

       ('Sparatutto', 'Giochi sparatutto in prima persona (FPS) e in terza persona. Include giochi tattici, battle royale, e sparatutto classici con combattimento basato su armi da fuoco.'),

       ('Sportivo', 'Giochi di simulazione sportiva che includono calcio, basket, football americano, tennis, golf e altri sport. Sia realistici che arcade.')
;

INSERT INTO Prodottocategoria (idProdotto,idCategoria) VALUES
                                                           (1,5),
                                                           (2,1),
                                                           (2,2),
                                                           (3,1),
                                                           (3,2),
                                                           (4,3),
                                                           (5,1),
                                                           (5,2),
                                                           (6,2),
                                                           (6,1),
                                                           (6,4),
                                                           (7,5)
;

