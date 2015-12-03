package hbase;

import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableMapper;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;

import java.io.IOException;

/**
 * Created by ferlicotdelbe on 03/12/15.
 */
public class MinMaxCountTableMapper extends TableMapper<IntWritable, DoubleWritable> {
    public void map(ImmutableBytesWritable row, Result value, Context context) throws InterruptedException, IOException {
        Integer key;
        Double val;

        //TODO

        context.write(new IntWritable(key), new DoubleWritable(val));
    }

}
