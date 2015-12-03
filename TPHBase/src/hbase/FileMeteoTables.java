package hbase;

import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.util.Bytes;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

/**
 * Created by ferlicotdelbe on 03/12/15.
 */
public class FileMeteoTables {

    public static void main(String[] args) throws IOException {
        Connection connect = ConnectionFactory.createConnection();
        Table stations = connect.getTable(TableName.valueOf("ferlicotdelbe:stations"));
        Table donnees = connect.getTable(TableName.valueOf("ferlicotdelbe:donnees"));
        fileStations(stations);
        fileDonnees(donnees);
        stations.close();
        donnees.close();
    }

    public static void fileStations(Table stations) throws IOException {
        File fichier = new File("ressources/postesSynop.csv"); // on lit le fichier csv
        BufferedReader br = new BufferedReader(new FileReader(fichier));

        // on passe la premiere ligne avec les entetes des colonnes
        br.readLine();
        for (String ligne = br.readLine(); ligne != null; ligne = br.readLine()) {
            String[] ligneDecoupee = ligne.split(";");
            Put put = new Put(Bytes.toBytes(ligneDecoupee[0]));
            put.addColumn(Bytes.toBytes("station"), Bytes.toBytes("id"), Bytes.toBytes(ligneDecoupee[0]));
            put.addColumn(Bytes.toBytes("station"), Bytes.toBytes("Nom"), Bytes.toBytes(ligneDecoupee[1]));
            put.addColumn(Bytes.toBytes("station"), Bytes.toBytes("Latitude"), Bytes.toBytes(ligneDecoupee[2]));
            put.addColumn(Bytes.toBytes("station"), Bytes.toBytes("Longitude"), Bytes.toBytes(ligneDecoupee[3]));
            put.addColumn(Bytes.toBytes("station"), Bytes.toBytes("Altitude"), Bytes.toBytes(ligneDecoupee[4]));
            stations.put(put);
        }
        System.out.println("Stations inserted");
    }

    public static void fileDonnees(Table donnees) throws IOException {
        File fichier = new File("ressources/synop.201510.csv"); // on lit le fichier csv
        BufferedReader br = new BufferedReader(new FileReader(fichier));

        // on passe la premiere ligne avec les entetes des colonnes
        br.readLine();
        for (String ligne = br.readLine(); ligne != null; ligne = br.readLine()) {
            String[] ligneDecoupee = ligne.split(";");
            Put put = new Put(Bytes.toBytes(ligneDecoupee[0] + ligneDecoupee[1]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("number_station"), Bytes.toBytes(ligneDecoupee[0]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("date"), Bytes.toBytes(ligneDecoupee[1]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("t"), Bytes.toBytes(ligneDecoupee[7]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("td"), Bytes.toBytes(ligneDecoupee[8]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("tn12"), Bytes.toBytes(ligneDecoupee[24]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("tn24"), Bytes.toBytes(ligneDecoupee[25]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("tx12"), Bytes.toBytes(ligneDecoupee[26]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("tx24"), Bytes.toBytes(ligneDecoupee[27]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("tminsol"), Bytes.toBytes(ligneDecoupee[28]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("sw"), Bytes.toBytes(ligneDecoupee[29]));
            put.addColumn(Bytes.toBytes("donnee"), Bytes.toBytes("tw"), Bytes.toBytes(ligneDecoupee[30]));
            donnees.put(put);
        }
        System.out.println("Donnees inserted");
    }
}
