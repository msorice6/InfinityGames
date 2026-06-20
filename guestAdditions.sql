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
                          video VARCHAR(255) NULL,
                          FULLTEXT (nome)
);

CREATE TABLE carrello (
                          idUtente INT NOT NULL,
                          idProdotto INT NOT NULL,
                          quantita INT NOT NULL DEFAULT 0,
                          prezzo DOUBLE NOT NULL DEFAULT 0,
                          images VARCHAR(50) NULL,
                          PRIMARY KEY (idUtente, idProdotto),
                          FOREIGN KEY (idUtente) REFERENCES Utente(id) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (idProdotto) REFERENCES Prodotto(id) ON DELETE CASCADE ON UPDATE CASCADE
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
                                 FOREIGN KEY (idOrdine) REFERENCES dettaglio_ordini(idOrd) ON DELETE CASCADE,
                                 FOREIGN KEY (idProdotto) REFERENCES Prodotto(id) ON DELETE NO ACTION
);

CREATE TABLE Prodotto_in_evidenza (
                                      id_evidenza INT NOT NULL,
                                      PRIMARY KEY (id_evidenza),
                                      FOREIGN KEY (id_evidenza) REFERENCES Prodotto(id)
);

CREATE TABLE Prodottocategoria (
                                   idProdotto INT NOT NULL,
                                   idCategoria INT NOT NULL,
                                   PRIMARY KEY (idProdotto, idCategoria),
                                   FOREIGN KEY (idProdotto) REFERENCES Prodotto(id) ON DELETE CASCADE,
                                   FOREIGN KEY (idCategoria) REFERENCES Categoria(id) ON DELETE CASCADE
);

CREATE TABLE utenteprodotti (
                                uid INT NOT NULL,
                                pid INT NOT NULL,
                                data_vis VARCHAR(50) NULL,
                                visual INT NOT NULL DEFAULT 0,
                                data_acq DATETIME NULL,
                                acquisto BOOLEAN NOT NULL DEFAULT FALSE,
                                PRIMARY KEY (uid, pid),
                                FOREIGN KEY (uid) REFERENCES Utente(id) ON DELETE CASCADE,
                                FOREIGN KEY (pid) REFERENCES Prodotto(id) ON DELETE CASCADE
);

CREATE TABLE libreria (
                          idUtente INT NOT NULL,
                          idProdotto INT NOT NULL,
                          nome VARCHAR(255) NOT NULL,
                          images VARCHAR(255) NULL,
                          quantita INT NOT NULL DEFAULT 1,
                          PRIMARY KEY (idUtente, idProdotto),
                          FOREIGN KEY (idUtente) REFERENCES Utente(id) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (idProdotto) REFERENCES Prodotto(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE desideri (
                          idUtente INT NOT NULL,
                          idProdotto INT NOT NULL,
                          PRIMARY KEY (idUtente, idProdotto),
                          FOREIGN KEY (idUtente) REFERENCES Utente(id) ON DELETE CASCADE ON UPDATE CASCADE,
                          FOREIGN KEY (idProdotto) REFERENCES Prodotto(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Utenti
INSERT INTO Utente (username, passwordhash, email, adminn, images)
VALUES
    ('mattone', '5ea345ab330cf29f81d8de9bf5466f508fe351e1', 'mario.rossi@example.com', FALSE, NULL),
    ('mattoneAdmin', '5ea345ab330cf29f81d8de9bf5466f508fe351e1', 'marioAdmin.rossi@example.com', TRUE, NULL);

-- Prodotti (26 giochi, dal 1 al 26) – TUTTI con ID YouTube reali/corretti
INSERT INTO Prodotto (id, nome, descrizione, prezzo, quant_vend, sconto, images, video) VALUES
                                                                                            (1, 'EA FC 26', 'La simulazione di calcio più realistica mai creata! Con licenze ufficiali di tutte le principali leghe, grafica next-gen e gameplay rivoluzionario. Vivi lemozione del calcio con modalità Carriera, Ultimate Team e Volta Football. Nuovi sistemi di intelligenza artificiale e fisica del pallone rendono ogni partita unica.', 69.99, 1000, 10, 'eafc26.jpg', 'TSi0iJYSQ24'),
                                                                                            (2, 'Red Dead Redemption 2', 'Immergiti nell epopea western più acclamata della storia dei videogiochi. Segui la storia di Arthur Morgan e la banda di Dutch van der Linde nell America del 1899. Un mondo aperto vastissimo, una narrazione profonda e un attenzione ossessiva ai dettagli. Caccia, esplora e sopravvivi nel selvaggio West.', 29.99, 4000, 20, 'rdd2.jpg', 'eaW0tYpxyp0'),
                                                                                            (3, 'The Last Of Us 2', 'Un viaggio emotivo attraverso un America post-apocalittica devastata da un epidemia fungina. Segui Ellie in una ricerca di vendetta che metterà alla prova la sua umanità. Combattimento intenso, stealth tattico e una narrazione che esplora temi come perdita, amore e redenzione. Grafica mozzafiato e gameplay cinematico.', 39.99, 3500, 20, 'tlou2.jpg', 'IwUtqHUWt-A'),
                                                                                            (4, 'Dragon Ball: Sparking Zero!', 'Il ritorno della serie Budokai Tenkaichi! Combattimenti 3D epici con oltre 100 personaggi dell universo Dragon Ball. Mosse speciali iconiche, trasformazioni in tempo reale e distruzione ambientale totale. Modalità Storia completa che ripercorre le saghe dall originale a Super. Online multiplayer per sfidare giocatori da tutto il mondo.', 29.99, 180, 40, 'dbsz.jpg', 'XTvBSY0YMyg'),
                                                                                            (5, 'Grand Theft Auto 5', 'Vivi tre storie intrecciate nella città di Los Santos, una parodia satirica della Los Angeles moderna. Gioca come Michael, Franklin e Trevor in una epica storia di crimine, tradimento e redenzione. Modalità online GTA Online costantemente aggiornata con nuove missioni, veicoli e attività. Mondo aperto ricco di dettagli e possibilità infinite.', 29.99, 5000, 50, 'gta.jpg', 'QkkoHAzjnUs'),
                                                                                            (6, 'Call of Duty: Black Ops 7', 'Torna nello scenario degli operatori neri in una campagna single player mozzafiato che attraversa decenni di conflitti segreti. Multiplayer innovativo con nuovi operatori, mappe e modalità. Zombies mode completamente rinnovata con mappe cooperative e una storyline epica. Grafica di nuova generazione e audio immersivo.', 79.99, 100, 10, 'cod7.jpg', 'GYQvNuyde-U'),
                                                                                            (7, 'WWE 2K25', 'La simulazione di wrestling più completa e realistica! Con oltre 200 superstar WWE attuali e leggende, crea il tuo percorso nella nuova MyRISE mode. MyGM ti permette di gestire la tua federazione. Grafica fotorealistica, fisica del ring rivoluzionaria e sistema di combattimento profondo. Crea il tuo wrestler con l editor più potente di sempre.', 49.99, 200, 35, 'wwe.jpg', 'Kr3IpZtvhAo'),
                                                                                            (8, 'Cyberpunk 2077', 'Un RPG open-world futuristico ambientato a Night City. Vesti i panni di V, un mercenario alla ricerca di un impianto cibernetico che promette l’immortalità. Scegli il tuo percorso, combatti in prima persona e modella la trama con le tue decisioni. Grafica mozzafiato e colonna sonora elettronica.', 49.99, 1200, 30, 'cyberpunk.jpg', 'qIcTM8WXFjk'),
                                                                                            (9, 'God of War Ragnarok', 'Il seguito dell’acclamato God of War. Kratos e Atreus attraversano i Nove Regni per fermare il Ragnarok. Combattimento epico, puzzle ambientali e una storia toccante sulla paternità. Grafica next-gen e doppiaggio stellare.', 59.99, 800, 15, 'gowr.jpg', 'GPBi7EoYyck'),
                                                                                            (10, 'Elden Ring', 'Il nuovo capolavoro di FromSoftware in collaborazione con George R.R. Martin. Esplora le Terre Intermedie in un open-world oscuro e punitivo. Combattimento strategico, boss memorabili e una libertà di esplorazione senza precedenti.', 59.99, 700, 20, 'eldenring.jpg', '_vnjEfqGC3U'),
                                                                                            (11, 'Hogwarts Legacy', 'Vivi la tua avventura nell’universo di Harry Potter, prima degli eventi dei libri. Esplora Hogwarts, impara incantesimi, crea pozioni e affronta creature magiche. Un RPG open-world che cattura l’essenza della saga.', 69.99, 500, 25, 'hogwarts.jpg', 'eFDZipIBBds'),
                                                                                            (12, 'Starfield', 'Il nuovo universo di Bethesda. Esplora migliaia di pianeti, combatti spaziali, costruisci astronavi e scopri i segreti della galassia. Un RPG sci-fi open-world con una libertà di azione totale.', 59.99, 400, 10, 'starfield.jpg', 'X1-lUm2CcUg'),
                                                                                            (13, 'Resident Evil 4 Remake', 'Il remake del survival horror capolavoro. Leon S. Kennedy deve salvare la figlia del presidente da una setta in un villaggio spagnolo infestato da los iluminados. Grafica aggiornata, gameplay moderno e tensione costante.', 39.99, 300, 20, 're4r.jpg', 'j5Xv2lM9wes'),
                                                                                            (14, 'Final Fantasy XVI', 'Un action RPG dark fantasy. Clive Rosfield combatte per vendicare il fratello e fermare le guerre tra regni. Grafica spettacolare, combattimento in tempo reale e una storia che mescola politica e magia.', 69.99, 200, 15, 'ff16.jpg', 'gV5rIW1Qums'),
                                                                                            (15, 'Spider-Man 2', 'Il sequel del gioco di Insomniac. Peter Parker e Miles Morales affrontano nuovi nemici, tra cui Venom. Esplorazione in volo, combattimenti acrobatici e una trama che approfondisce il legame tra i due Spider-Man.', 69.99, 350, 10, 'spiderman2.jpg', '-3wBItLQDJY'),
                                                                                            (16, 'The Legend of Zelda: Tears of the Kingdom', 'Il seguito di Breath of the Wild. Link esplora un Hyrule mutato, con nuove abilità come il costruire oggetti e il manipolare il tempo. Enigmi creativi, combattimenti e un mondo open-air da scoprire.', 69.99, 900, 0, 'zelda.jpg', 'LjkjJAtcKbA'),
                                                                                            (17, 'Baldur\'s Gate 3', 'Il GDR isometrico basato su D&D 5e. Crea il tuo eroe, recluta compagni e intraprendi un’epica avventura contro una minaccia mind flayer. Dialoghi profondi, combattimenti a turni e scelte con conseguenze.', 59.99, 600, 20, 'bg3.jpg', '1T22wNvoNiU'),
(18, 'Death Stranding 2', 'Il sequel del titolo di Kojima. Sam Porter Bridges torna in un mondo ancora più ostile, con nuove meccaniche e una trama surreale. Consegne, costruzioni e connessioni in un paesaggio post-apocalittico.', 59.99, 150, 30, 'ds2.jpg', 'etOOO9Sq7u8'),
(19, 'Horizon Forbidden West', 'Aloy viaggia verso l’ovest per fermare una minaccia che potrebbe distruggere la Terra. Combattimenti contro macchine giganti, esplorazione subacquea e una storia che amplia il mondo di Horizon.', 49.99, 600, 20, 'hfw.jpg', 'XLZN63UxAOM'),
(20, 'Ghost of Yotei', 'Seguito ideale del leggendario action game. Jin Sakai affronta nuove sfide in un Giappone minacciato da invasori e tradimenti. Combattimento samurai, bellezza paesaggistica e una narrazione epica.', 59.99, 200, 25, 'goy.jpg', '7z7kqwuf0a8'),
(21, 'Diablo IV', 'Il ritorno del celebre ARPG. Esplora l’inferno di Sanctuary, combatti orde di demoni e personalizza il tuo eroe. Grafica cupa, multiplayer online e stagioni di contenuti.', 69.99, 400, 30, 'diablo4.jpg', 'Ro26B394ZBM'),
(22, 'Assassin\'s Creed Mirage', 'Un ritorno alle origini della serie. Basim, un ladro di Baghdad, si unisce agli Assassini per combattere i Templari. Stealth, parkour e combattimenti in una città rinascimentale.', 49.99, 300, 15, 'acm.jpg', 'x55lAlFtXmw'),
                                                                                            (23, 'Gran Turismo 7', 'Il simulatore di guida per eccellenza. Centinaia di auto, circuiti reali e un’esperienza di guida iper-realistica. Gare, tuning e collezionismo.', 59.99, 250, 15, 'gt7.jpg', '-orQ2kldCys'),
                                                                                            (24, 'Mortal Kombat 1', 'Il reboot della serie di combattimento. Personaggi iconici, fatalità brutali e una storia che ricostruisce l’universo di Mortal Kombat. Grafica next-gen e gameplay tecnico.', 69.99, 200, 20, 'mk1.jpg', 'UZ6eFEjFfJ0'),
                                                                                            (25, 'Sea of Thieves', 'Avventura piratesca in un mare aperto. Gioca in coop, cerca tesori, combatti navi e sopravvivi a tempeste. Un multiplayer online ricco di eventi.', 39.99, 180, 25, 'sot.jpg', 'r5JIBaasuE8'),
                                                                                            (26, 'Hades II', 'Il seguito del roguelike acclamato dalla critica. Esplora gli inferi con nuove armi e divinità, in un action frenetico con storia e dialoghi brillanti.', 29.99, 100, 30, 'hades2.jpg', 'MawBCULz4vE');

-- Categorie (invariate)
INSERT INTO Categoria (id, nome, descrizione) VALUES
                                                  (1, 'Avventura', 'Giochi focalizzati su narrazione, esplorazione, risoluzione di enigmi e interazione con personaggi. Include giochi grafici, avventure testuali e action-adventure.'),
                                                  (2, 'Azione', 'Giochi con ritmo veloce, combattimento, esplorazione e missioni. Include giochi open world, stealth, platformer e hack & slash.'),
                                                  (3, 'Picchiaduro', 'Giochi di combattimento uno contro uno o contro più avversari. Include giochi 2D, 3D, anime fighter e giochi di wrestling.'),
                                                  (4, 'Sparatutto', 'Giochi sparatutto in prima persona (FPS) e in terza persona. Include giochi tattici, battle royale, e sparatutto classici con combattimento basato su armi da fuoco.'),
                                                  (5, 'Sportivo', 'Giochi di simulazione sportiva che includono calcio, basket, football americano, tennis, golf e altri sport. Sia realistici che arcade.');

-- Associazione prodotto-categoria (aggiornata per i 26 prodotti, FIFA 24 rimossa)
INSERT INTO Prodottocategoria (idProdotto, idCategoria) VALUES
-- 1: EA FC 26 -> Sportivo
(1, 5),
-- 2: RDR2 -> Avventura, Azione
(2, 1), (2, 2),
-- 3: TLOU2 -> Avventura, Azione
(3, 1), (3, 2),
-- 4: Dragon Ball Sparking Zero -> Picchiaduro
(4, 3),
-- 5: GTA V -> Avventura, Azione
(5, 1), (5, 2),
-- 6: COD BO7 -> Azione, Sparatutto, Avventura
(6, 2), (6, 4), (6, 1),
-- 7: WWE 2K25 -> Sportivo, Picchiaduro
(7, 5), (7, 3),
-- 8: Cyberpunk 2077 -> Avventura, Azione, Sparatutto
(8, 1), (8, 2), (8, 4),
-- 9: God of War Ragnarok -> Avventura, Azione
(9, 1), (9, 2),
-- 10: Elden Ring -> Avventura, Azione
(10, 1), (10, 2),
-- 11: Hogwarts Legacy -> Avventura, Azione
(11, 1), (11, 2),
-- 12: Starfield -> Avventura, Azione, Sparatutto
(12, 1), (12, 2), (12, 4),
-- 13: Resident Evil 4 Remake -> Avventura, Azione, Sparatutto
(13, 1), (13, 2), (13, 4),
-- 14: Final Fantasy XVI -> Avventura, Azione
(14, 1), (14, 2),
-- 15: Spider-Man 2 -> Avventura, Azione
(15, 1), (15, 2),
-- 16: Zelda Tears of the Kingdom -> Avventura, Azione
(16, 1), (16, 2),
-- 17: Baldur's Gate 3 -> Avventura, Azione
(17, 1), (17, 2),
-- 18: Death Stranding 2 -> Avventura, Azione
(18, 1), (18, 2),
-- 19: Horizon Forbidden West -> Avventura, Azione
(19, 1), (19, 2),
-- 20: Ghost of Tsushima 2 -> Avventura, Azione
(20, 1), (20, 2),
-- 21: Diablo IV -> Azione, Avventura
(21, 2), (21, 1),
-- 22: Assassin's Creed Mirage -> Avventura, Azione
(22, 1), (22, 2),
-- 23: Gran Turismo 7 -> Sportivo
(23, 5),
-- 24: Mortal Kombat 1 -> Picchiaduro
(24, 3),
-- 25: Sea of Thieves -> Avventura, Azione
(25, 1), (25, 2),
-- 26: Hades II -> Azione
(26, 2);