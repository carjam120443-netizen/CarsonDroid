package com.carsondroid.files;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView view = new TextView(this);
        view.setText("Carson Files\n\nFile manager foundation for CarsonDroid.");
        view.setTextSize(20f);
        view.setPadding(48, 48, 48, 48);
        setContentView(view);
    }
}
