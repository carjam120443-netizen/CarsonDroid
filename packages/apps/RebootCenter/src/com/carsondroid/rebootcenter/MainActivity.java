package com.carsondroid.rebootcenter;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView view = new TextView(this);
        view.setText("Reboot Center\n\nSystem restart controls will live here.\n\nThe initial build intentionally keeps reboot actions out until the privileged system integration is implemented.");
        view.setTextSize(20f);
        view.setPadding(48, 48, 48, 48);
        setContentView(view);
    }
}
