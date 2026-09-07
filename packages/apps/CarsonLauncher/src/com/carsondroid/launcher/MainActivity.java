package com.carsondroid.launcher;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView view = new TextView(this);
        view.setText("CarsonDroid\n\nWelcome to CarsonDroid");
        view.setTextSize(28f);
        view.setPadding(64, 64, 64, 64);
        setContentView(view);
    }
}
