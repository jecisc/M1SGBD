package hbase;

import org.apache.hadoop.hbase.io.ImmutableBytesWritable;
import org.apache.hadoop.hbase.mapreduce.TableReducer;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;

import java.io.IOException;

/**
 * Created by ferlicotdelbe on 03/12/15.
 */
public class MinMaxCountTableReducer extends TableReducer<IntWritable, Iterable<DoubleWritable>, ImmutableBytesWritable> {

    public void reduce(IntWritable key, Iterable<DoubleWritable> values, Context context) throws IOException, InterruptedException{
        //TODO
    }
}
