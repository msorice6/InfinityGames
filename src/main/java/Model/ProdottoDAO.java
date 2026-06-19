package Model;

import Controller.GestioneUtente.MyServletException;

import java.sql.*;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class ProdottoDAO {

    public static void setQuantita(int id, int quantita) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("UPDATE Prodotto SET quant_vend=quant_vend+? where id=?;");
            ps.setInt(2, id);
            ps.setInt(1, quantita);

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    public ArrayList<Prodotto> doRetrieveEvidenzaAll(int offset, int limit) {

        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  id,nome, descrizione,prezzo,sconto,images FROM Prodotto LIMIT ?, ?");
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            ArrayList<Prodotto> list = new ArrayList<Prodotto>();
            while (rs.next()) {

                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ArrayList<Prodotto> doRetrieveEvidenzaAll_forTesting() {
        ArrayList<Prodotto> list = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT id_evidenza FROM Prodotto_in_evidenza");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(doRetrieveById(rs.getInt(1)).getNome());
                p.setDescrizione(doRetrieveById(rs.getInt(1)).getDescrizione());
                p.setPrezzo(doRetrieveById(rs.getInt(1)).getPrezzo());
                p.setSconto(doRetrieveById(rs.getInt(1)).getSconto());
                p.setImages(doRetrieveById(rs.getInt(1)).getImages());
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;

    }

    public void doRmEvidenza() {
        try (Connection con = ConPool.getConnection()) {

            PreparedStatement psa = con.prepareStatement("TRUNCATE TABLE Prodotto_in_evidenza");
            psa.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdateEvidenza(Prodotto prodotto) {
        try (Connection con = ConPool.getConnection()) {


            PreparedStatement ps = con
                    .prepareStatement("INSERT INTO Prodotto_in_evidenza (id_evidenza) VALUES (?)");

            ps.setInt(1, prodotto.getId());

            int updated = ps.executeUpdate();
            if (updated != 1) {
                throw new RuntimeException("INSERT INTO Prodotto_in_evidenza failed.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ArrayList<Prodotto> doRetrieveAll(int offset, int limit) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  id,nome, descrizione,prezzo,sconto,images FROM Prodotto LIMIT ?, ?");
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            ArrayList<Prodotto> list = new ArrayList<Prodotto>();
            while (rs.next()) {

                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSave(Prodotto prodotto) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO Prodotto (nome, descrizione, prezzo,quant_vend,sconto,images,video) VALUES(?,?,?,0,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getDescrizione());
            ps.setDouble(3, prodotto.getPrezzo());
            ps.setInt(4, prodotto.getSconto());
            ps.setString(5, prodotto.getImages());
            ps.setString(6,prodotto.getVideo());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }
            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            int id = rs.getInt(1);
            prodotto.setId(id);

            PreparedStatement psCa = con
                    .prepareStatement("INSERT INTO Prodottocategoria (idProdotto, idCategoria) VALUES (?, ?)");
            for (Categoria c : prodotto.getCategorie()) {
                psCa.setInt(1, id);
                psCa.setInt(2, c.getId());
                psCa.addBatch();
            }
            psCa.executeBatch();


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doUpdate(Prodotto prodotto) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con
                    .prepareStatement("UPDATE Prodotto SET nome=?, descrizione=?, prezzo=?, sconto=?,images=?,video=? WHERE id=?");
            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getDescrizione());
            ps.setDouble(3, prodotto.getPrezzo());
            ps.setInt(4, prodotto.getSconto());
            ps.setString(5, prodotto.getImages());
            ps.setString(6,prodotto.getVideo());
            ps.setInt(7, prodotto.getId());
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");

            }

            if (prodotto.getCategorie().isEmpty()) {
                PreparedStatement psCaDel = con.prepareStatement("DELETE FROM Prodottocategoria WHERE idProdotto=?");
                psCaDel.setInt(1, prodotto.getId());
                psCaDel.executeUpdate();
            } else {
                PreparedStatement psCaDel = con
                        .prepareStatement("DELETE FROM Prodottocategoria WHERE idProdotto=? AND idCategoria NOT IN ("
                                + prodotto.getCategorie().stream().map(c -> String.valueOf(c.getId()))
                                .collect(Collectors.joining(","))
                                + ")");
                psCaDel.setInt(1, prodotto.getId());
                psCaDel.executeUpdate();

                PreparedStatement psCa = con.prepareStatement(
                        "INSERT IGNORE INTO Prodottocategoria (idProdotto, idCategoria) VALUES (?, ?)");
                for (Categoria c : prodotto.getCategorie()) {
                    psCa.setInt(1, prodotto.getId());
                    psCa.setInt(2, c.getId());
                    psCa.addBatch();
                }
                psCa.executeBatch();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDelete(int id) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM Prodotto WHERE id=?");
            ps.setInt(1, id);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Prodotto doRetrieveById(int id) {

        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  id, nome, descrizione, prezzo,sconto,quant_vend,images,video FROM Prodotto " +
                            " WHERE  id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();


            if (rs.next()) {

                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setQuant_vend(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setVideo(rs.getString(8));

                p.setCategorie(getCategorie(con, p.getId()));
                return p;

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Prodotto doRetrieveProdottoByNome(String nomeProdotto) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT id, nome, descrizione, prezzo, sconto,images FROM Prodotto WHERE nome=?");
            ps.setString(1, nomeProdotto);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                return p;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    static List<Categoria> getCategorie(Connection con, int idProdotto) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
                "SELECT id, nome, descrizione FROM Categoria LEFT JOIN prodottocategoria ON id=idCategoria WHERE idProdotto=?");
        ps.setInt(1, idProdotto);
        ArrayList<Categoria> categorie = new ArrayList<>();
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Categoria c = new Categoria();
            c.setId(rs.getInt(1));
            c.setNome(rs.getString(2));
            c.setDescrizione(rs.getString(3));
            categorie.add(c);
        }
        return categorie;
    }


    public int[] doRetrieveVisAll(int id) {
        int[] vis = new int[100];
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  pid FROM utenteprodotti " +
                            " WHERE  uid=?");
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            int i = 0;
            while (rs.next()) {
                vis[i] = rs.getInt(1);
                i++;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vis;

    }

    public void setDataVis(int id, int idp, String s) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("UPDATE utenteprodotti SET data_vis=?,visual=visual+1 WHERE uid=? AND pid=?");
            ps.setInt(2, id);
            ps.setInt(3, idp);
            ps.setString(1, s);


            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ArrayList<Prodotto> doRetrieveAllSconto() {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  id,nome, descrizione,prezzo,sconto,images FROM Prodotto WHERE sconto>0");
            ResultSet rs = ps.executeQuery();
            ArrayList<Prodotto> list = new ArrayList<Prodotto>();
            while (rs.next()) {

                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int countBySconto() {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con
                    .prepareStatement("SELECT COUNT(*) FROM Prodotto WHERE sconto>0");

            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean isPresenteInLibreria(int idProdotto, int idUtente) {
        boolean presente = false;
        String sql = "SELECT * FROM libreria WHERE idProdotto = ? AND idUtente = ?";

        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idProdotto);
            ps.setInt(2, idUtente);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                presente = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return presente;
    }

    // METODO AGGIORNATO - SENZA descrizione
    public void doSaveInLibreria(Prodotto p, int id, int quantita) {
        try (Connection con = ConPool.getConnection()) {
            // Verifica se il prodotto è già presente in libreria
            PreparedStatement psCheck = con.prepareStatement(
                    "SELECT quantita FROM libreria WHERE idUtente = ? AND idProdotto = ?"
            );
            psCheck.setInt(1, id);
            psCheck.setInt(2, p.getId());
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Prodotto già presente: aggiorna la quantità
                int nuovaQuantita = rs.getInt(1) + quantita;
                PreparedStatement psUpdate = con.prepareStatement(
                        "UPDATE libreria SET quantita = ? WHERE idUtente = ? AND idProdotto = ?"
                );
                psUpdate.setInt(1, nuovaQuantita);
                psUpdate.setInt(2, id);
                psUpdate.setInt(3, p.getId());
                psUpdate.executeUpdate();
            } else {
                // Prodotto nuovo: inserisci
                PreparedStatement psInsert = con.prepareStatement(
                        "INSERT INTO libreria(idUtente, idProdotto, nome, images, quantita) VALUES (?, ?, ?, ?, ?)"
                );
                psInsert.setInt(1, id);
                psInsert.setInt(2, p.getId());
                psInsert.setString(3, p.getNome());
                psInsert.setString(4, p.getImages());
                psInsert.setInt(5, quantita);
                psInsert.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doDeleteLibreria(int id) {
        try (Connection con = ConPool.getConnection()) {

            PreparedStatement ps =
                    con.prepareStatement("DELETE  FROM libreria WHERE idUtente=?");
            ps.setInt(1, id);
            if (ps.executeUpdate() == 0) {
                throw new RuntimeException("DELETE error.");
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Prodotto> doRetrieveByPopolareForCat(int idCat, OrderBy orderBy, int offset, int limit) {
        ArrayList<Prodotto> list = new ArrayList<Prodotto>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT id,nome,descrizione,prezzo,sconto,images FROM Popolari LEFT JOIN Prodottocategoria ON id=idProdotto WHERE idCategoria=? " + orderBy.sql + " LIMIT ?, ?");

            ps.setInt(1, idCat);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }


    public enum OrderByAlfabetico {
        DEFAULT(""), PREZZO_ASC("ORDER BY nome ASC"), PREZZO_DESC("ORDER BY nome DESC");
        private String sql;

        private OrderByAlfabetico(String sql) {
            this.sql = sql;
        }
    }

    // METODO AGGIORNATO - SENZA descrizione nella SELECT
    public List<Prodotto> doRetrieveByLibreria(OrderByAlfabetico order, int id, int i, int perpag) {
        ArrayList<Prodotto> list = new ArrayList<Prodotto>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT idProdotto, nome, images, quantita FROM libreria WHERE idUtente=? " + order.sql + " LIMIT ?, ?"
            );
            ps.setInt(1, id);
            ps.setInt(2, i);
            ps.setInt(3, perpag);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setImages(rs.getString(3));
                p.setQuantitaPosseduta(rs.getInt(4));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public enum OrderBySconto {
        DEFAULT(""), PREZZO_ASC("ORDER BY sconto ASC"), PREZZO_DESC("ORDER BY sconto DESC");
        private String sql;

        private OrderBySconto(String sql) {
            this.sql = sql;
        }
    }

    public List<Prodotto> doRetrieveBySconto(OrderBySconto orderBy, int i, int perpag) {
        ArrayList<Prodotto> list = new ArrayList<Prodotto>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  id,nome,descrizione,prezzo,quant_vend,sconto,images FROM Prodotto WHERE sconto>0 " + orderBy.sql + "  LIMIT ?, ?");
            ps.setInt(1, i);
            ps.setInt(2, perpag);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setQuant_vend(rs.getInt(5));
                p.setSconto(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<Prodotto> doRetrieveByPopolare() {
        ArrayList<Prodotto> list = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT id,nome,descrizione,prezzo,sconto,images FROM Prodotto");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));

                list.add(p);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public enum OrderByPopolari {
        DEFAULT(""), PREZZO_ASC("ORDER BY quant_vend ASC"), PREZZO_DESC("ORDER BY quant_vend DESC");
        private String sql;

        private OrderByPopolari(String sql) {
            this.sql = sql;
        }
    }

    public enum OrderByNegozio {
        ALFABETICO_ASC("ORDER BY p.nome ASC"),
        ALFABETICO_DESC("ORDER BY p.nome DESC"),
        PREZZO_ASC("ORDER BY (prezzo - (prezzo * sconto / 100)) ASC"),
        PREZZO_DESC("ORDER BY (prezzo - (prezzo * sconto / 100)) DESC"),
        VENDUTI_ASC("ORDER BY p.quant_vend ASC"),
        VENDUTI_DESC("ORDER BY p.quant_vend DESC");

        private String sql;

        private OrderByNegozio(String sql) {
            this.sql = sql;
        }

        public String getSql() {
            return sql;
        }
    }

    public List<Prodotto> doRetrieveByPopolareLimit(OrderByPopolari order, int i, int perpag) {
        ArrayList<Prodotto> list = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT id,nome,descrizione,prezzo,sconto,images FROM Prodotto "
                            +
                            order.sql +
                            " LIMIT ?,?;");

            ps.setInt(1, i);
            ps.setInt(2, perpag);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));

                list.add(p);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Recupera tutti i prodotti per il negozio con ordinamento e paginazione
     */
    public List<Prodotto> doRetrieveByNegozioLimit(OrderByNegozio ord, int offset, int limit) {
        ArrayList<Prodotto> list = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT p.id, p.nome, p.descrizione, p.prezzo, p.quant_vend, p.sconto, p.images, p.video FROM Prodotto p " +
                            ord.getSql() + " LIMIT ?, ?"
            );
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setQuant_vend(rs.getInt(5));
                p.setSconto(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setVideo(rs.getString(8));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Recupera prodotti per categoria specifica con ordinamento e paginazione
     */
    public List<Prodotto> doRetrieveByCategoriaLimit(int categoriaId, OrderByNegozio ord, int offset, int limit) {
        ArrayList<Prodotto> list = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT p.id, p.nome, p.descrizione, p.prezzo, p.quant_vend, p.sconto, p.images, p.video " +
                            "FROM Prodotto p " +
                            "JOIN Prodottocategoria pc ON p.id = pc.idProdotto " +
                            "WHERE pc.idCategoria = ? " +
                            ord.getSql() + " LIMIT ?, ?"
            );
            ps.setInt(1, categoriaId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setQuant_vend(rs.getInt(5));
                p.setSconto(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setVideo(rs.getString(8));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Conta tutti i prodotti
     */
    public int countAllProdotti() {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM Prodotto");
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int countByVenduti() {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con
                    .prepareStatement("SELECT COUNT(*) FROM Prodotto  where quant_vend>0");

            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public enum OrderByVenduti {
        DEFAULT(""), PREZZO_ASC("ORDER BY quant_vend ASC"), PREZZO_DESC("ORDER BY quant_vend DESC");
        private String sql;

        private OrderByVenduti(String sql) {
            this.sql = sql;
        }
    }

    public ArrayList<Prodotto> doRetrieveByVenduti(OrderByVenduti ord, int offset, int limit) {
        ArrayList<Prodotto> list = new ArrayList<Prodotto>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  id,nome,descrizione,prezzo,quant_vend,sconto,images FROM Prodotto WHERE quant_vend>0 " + ord.sql + " LIMIT ?,?");

            ps.setInt(1, offset);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setQuant_vend(rs.getInt(5));
                p.setSconto(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public enum OrderBy {
        DEFAULT(""),
        PREZZO_ASC("ORDER BY (prezzo - (prezzo * sconto / 100)) ASC;"),
        PREZZO_DESC("ORDER BY (prezzo - (prezzo * sconto / 100)) DESC;");
//        PREZZO_ASC("ORDER BY prezzo ASC"),
//        PREZZO_DESC("ORDER BY prezzo DESC");
        private String sql;

        private OrderBy(String sql) {
            this.sql = sql;
        }
    }

    public int countByCategoria(int categoria) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con
                    .prepareStatement("SELECT COUNT(*) FROM Prodotto LEFT JOIN Prodottocategoria ON id=idProdotto WHERE idCategoria=?");
            ps.setInt(1, categoria);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Prodotto> doRetrieveByIdCat(int categoriaID, OrderBy orderBy, int offset, int limit) {

        ArrayList<Prodotto> list = new ArrayList<Prodotto>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("SELECT  p.id,p.nome, p.descrizione,p.prezzo,p.quant_vend,p.sconto,p.images FROM Prodotto p, Categoria c, Prodottocategoria pc" +
                            " WHERE p.id=pc.idProdotto AND c.id=pc.idCategoria AND c.id=? " + orderBy.sql + " LIMIT ?, ?");
            ps.setInt(1, categoriaID);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setQuant_vend(rs.getInt(5));
                p.setSconto(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void setAcquisto(String date, int uid, int pid) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps =
                    con.prepareStatement("UPDATE utenteprodotti SET data_acq=?,acquisto=true WHERE uid=? AND pid=?");
            ps.setInt(2, uid);
            ps.setInt(3, pid);
            ps.setString(1, date);


            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("UPDATE error.");
            }


        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doSaveProdotto(int uID, int pID, String data_vis) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement("INSERT INTO utenteprodotti (uid, pid, data_vis, visual) VALUES (?, ?, ?, 1)");
            ps.setInt(1, uID);
            ps.setInt(2, pID);
            ps.setString(3, data_vis);

            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("INSERT error.");
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public ArrayList<Prodotto> doRetrieveByIdForUtente(int id) {

        ArrayList<Prodotto> list = new ArrayList<Prodotto>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement("select p.id,p.nome,p.descrizione\n" +
                    "                    from Prodotto p, prodotto_ordini up, dettaglio_ordini ord\n" +
                    "where p.id=up.idProdotto and ord.idUte=?");
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Prodotto p = new Prodotto();

                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                list.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Prodotto> doRetrieveByNome(String against, OrderBy ord, int offset, int limit) {
        ArrayList<Prodotto> prodotti = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = null;
            if(ord != null) {
                ps= con.prepareStatement(
                        "SELECT id, nome, descrizione, prezzo,sconto,images FROM prodotto WHERE MATCH(nome) AGAINST(? IN BOOLEAN MODE) " + ord.sql + " LIMIT ?, ?");
                ps.setString(1, against);
                ps.setInt(2, offset);
                ps.setInt(3, limit);
            }else{
                ps= con.prepareStatement(
                        "SELECT id, nome, descrizione, prezzo,sconto,images FROM prodotto WHERE nome LIKE ? LIMIT ?, ?");
                ps.setString(1, "%" + against + "%");
                ps.setInt(2, offset);
                ps.setInt(3, limit);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getLong(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));
                prodotti.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prodotti;
    }

    public List<Prodotto> doRetrieveByNomeRicerca(String against, OrderBy ord,int offset, int limit) {
        ArrayList<Prodotto> prodotti = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = null;
            if(ord != null) {
                ps= con.prepareStatement(
                        "SELECT id, nome, descrizione, prezzo,sconto,images FROM prodotto WHERE MATCH(nome) AGAINST(? IN BOOLEAN MODE) " + ord.sql + " LIMIT ?, ?");
                ps.setString(1, against);
                ps.setInt(2, offset);
                ps.setInt(3, limit);
            }else{
                ps= con.prepareStatement(
                        "SELECT id, nome, descrizione, prezzo,sconto,images FROM prodotto WHERE MATCH(nome) AGAINST(? IN BOOLEAN MODE) LIMIT ?, ?");
                ps.setString(1, against);
                ps.setInt(2, offset);
                ps.setInt(3, limit);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getLong(4));
                p.setSconto(rs.getInt(5));
                p.setImages(rs.getString(6));
                p.setCategorie(getCategorie(con, p.getId()));
                prodotti.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return prodotti;
    }



    public void doDeleteByNomeForTesting(String nomeProdotto){
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement("DELETE FROM Prodotto WHERE nome=?");
            ps.setString(1, nomeProdotto);
            if (ps.executeUpdate() != 1) {
                throw new RuntimeException("DELETE error.");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // ========== Metodi per la ricerca FULLTEXT con ordinamento completo ==========

    public int countByNomeFullText(String against) {
        try (Connection con = ConPool.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(*) FROM Prodotto WHERE MATCH(nome) AGAINST(? IN BOOLEAN MODE)"
            );
            ps.setString(1, against);
            ResultSet rs = ps.executeQuery();
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Prodotto> doRetrieveByNomeFullText(String against, OrderByNegozio ord, int offset, int limit) {
        ArrayList<Prodotto> list = new ArrayList<>();
        try (Connection con = ConPool.getConnection()) {
            String sql = "SELECT p.id, p.nome, p.descrizione, p.prezzo, p.quant_vend, p.sconto, p.images, p.video " +
                    "FROM Prodotto p WHERE MATCH(nome) AGAINST(? IN BOOLEAN MODE) " +
                    ord.getSql() + " LIMIT ?, ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, against);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prodotto p = new Prodotto();
                p.setId(rs.getInt(1));
                p.setNome(rs.getString(2));
                p.setDescrizione(rs.getString(3));
                p.setPrezzo(rs.getDouble(4));
                p.setQuant_vend(rs.getInt(5));
                p.setSconto(rs.getInt(6));
                p.setImages(rs.getString(7));
                p.setVideo(rs.getString(8));
                p.setCategorie(getCategorie(con, p.getId()));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}