package com.carsondroid.settings;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView view = new TextView(this);
        view.setText("Carson Settings\n\nCarsonDroid 0.1.0-dev\nAndroid 17\nx86_64");
        view.setTextSize(20f);
        view.setPadding(48, 48, 48, 48);
        setContentView(view);
    }
}
