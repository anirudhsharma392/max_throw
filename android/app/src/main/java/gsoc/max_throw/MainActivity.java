package gsoc.max_throw;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.concurrent.TimeUnit;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.reactivex.Observable;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;


public class MainActivity extends FlutterActivity implements SensorEventListener {

    public static final String TAG = "eventchannel";
    public static final String STREAM = "com.gsoc.eventchannel/stream";

    //make sure to deactivate it after disposing
    private SensorManager sensorManager;
    private Sensor accelerometer;
    //use this for subscribing to an event
    private Disposable subscription;
    //contains sensor coordinates
    private double sensorCoordinates;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);


        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STREAM).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink events) {
                        Log.w(TAG, "adding listener");

                        //initializes TYPE_ACCELEROMETER sensor
                        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
                        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
                        sensorManager.registerListener(MainActivity.this, accelerometer, SensorManager.SENSOR_DELAY_GAME);

                        //starts timer subscription which returns a stream of data and passes it into flutter
                        subscription = Observable
                                .interval(0, 200, TimeUnit.MILLISECONDS)
                                .observeOn(AndroidSchedulers.mainThread())
                                .subscribe(
                                        (Long timer) -> {
                                            events.success(sensorCoordinates);
                                        },
                                        (Throwable error) -> {
                                            Log.e(TAG, "error in subscription", error);
                                            events.error("STREAM", "Error in processing observable", error.getMessage());
                                        },
                                        () -> Log.w(TAG, "closing the subscription")
                                );
                    }

                    @Override
                    public void onCancel(Object args) {
                        //dispose anything here
                        Log.w(TAG, "cancelling subscription");
                        if (subscription != null) {
                            //disposes subscription and sensor
                            subscription.dispose();
                            sensorManager.unregisterListener(MainActivity.this);
                            subscription = null;
                        }
                    }
                }
        );
    }


    @Override
    public void onSensorChanged(SensorEvent event) {

        Log.w(TAG, "\n\nx : " + event.values[0] + "\ny : " + event.values[1] + "\nz : " + event.values[2]);

        //it computes a total magnitude of an acceleration recorded
        //magnitude =  √( x² + y² + z²)

        double squareSum = (event.values[0] * event.values[0] + event.values[1] * event.values[1] + event.values[2] * event.values[2]);
        sensorCoordinates = Math.sqrt(squareSum);

    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {

    }
}