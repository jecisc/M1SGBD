package hbase;

import com.kenai.jaffl.struct.Struct;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableMapReduceUtil;
import org.apache.hadoop.hbase.mapreduce.TableMapper;
import org.apache.hadoop.hbase.mapreduce.TableReducer;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Job;

import java.io.IOException;

/**
 * Created by ferlicotdelbe on 03/12/15.
 */
public class InfoMeteoParStation {

    public static class MinCountTableMapper extends TableMapper<IntWritable, DoubleWritable> {

        public void map(ImmutableBytesWritable row, Result value, Context context) throws InterruptedException, IOException {
            byte[] bytes =value.getValue(Bytes.toBytes("donnee"), Bytes.toBytes("tx24"));
            if(!bytes.toString().equals("mq")) {
                IntWritable key = new IntWritable(java.nio.ByteBuffer.wrap(value.getValue(Bytes.toBytes("donnee"), Bytes.toBytes("id"))).getInt());
                DoubleWritable val = new DoubleWritable(java.nio.ByteBuffer.wrap(bytes).getDouble());

                if (key != null && value != null) {
                    context.write(key, val);
                }
            }
        }

    }

    public static class MinCountTableReducer extends TableReducer<IntWritable, Iterable<DoubleWritable>, ImmutableBytesWritable> {

        public void reduce(IntWritable key, Iterable<DoubleWritable> values, Context context) throws IOException, InterruptedException {
            double min = 10000;
            for (DoubleWritable d : values) {
                min = Double.min(min, d.get());
            }

            Put put = new Put(Bytes.toBytes(key.toString()));
            put.addColumn(Bytes.toBytes("station"), Bytes.toBytes("temp_min"), Bytes.toBytes(((Double) min).toString()));
            context.write(null, put);
        }
    }

    public static void main(String args[]) throws Exception {
        Configuration config = HBaseConfiguration.create();
        Job job = Job.getInstance(config, "Températures stations météo");
        job.setJarByClass(InfoMeteoParStation.class);     // class that contains mapper and reducer

        Scan scan = new Scan();
        scan.setCaching(500);        // 1 is the default in Scan, which will be bad for MapReduce jobs
        scan.setCacheBlocks(false);  // don't set to true for MR jobs

        System.out.println("------------------------------");
        System.out.println("initialisation");
        TableMapReduceUtil.initTableMapperJob(
                "ferlicotdelbe:donnees",        // input table
                scan,               // Scan instance to control CF and attribute selection
                MinCountTableMapper.class,     // mapper class
                IntWritable.class,         // mapper output key
                DoubleWritable.class,  // mapper output value
                job);
        TableMapReduceUtil.initTableReducerJob(
                "ferlicotdelbe:stations",        // output table
                MinCountTableReducer.class,    // reducer class
                job);
        job.setNumReduceTasks(1);   // at least one, adjust as required

        System.out.println("job démarré");
        boolean b = job.waitForCompletion(true);
        if (!b) {
            throw new IOException("error with job!");
        }
        System.out.println("job terminé");
        System.out.println("------------------------------");

    }
}