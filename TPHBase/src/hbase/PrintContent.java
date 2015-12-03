package hbase;

import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;

import java.io.IOException;

/**
 * Created by ferlicotdelbe on 03/12/15.
 */
public class PrintContent {

    public static void main(String[] args) throws IOException {
        Connection connect = ConnectionFactory.createConnection();
        Table table = connect.getTable(TableName.valueOf("ferlicotdelbe:repertoire"));
        Scan scan = new Scan();
        ResultScanner scanner = table.getScanner(scan);
        Result result;
        while ((result = scanner.next()) != null) {
            System.out.println(result);
        }
    }
}
