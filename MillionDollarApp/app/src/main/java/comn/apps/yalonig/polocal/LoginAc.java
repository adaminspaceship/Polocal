package comn.apps.yalonig.polocal;


import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.renderscript.ScriptGroup;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.os.AsyncTask;

import android.util.Log;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import java.util.ArrayList;

import java.util.HashMap;

import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.UUID;

import static android.provider.AlarmClock.EXTRA_MESSAGE;

public class LoginAc extends AppCompatActivity {
    private EditText school;
    private ListView schoolist;
    ArrayList<String> arrayList = new ArrayList<>();
    public static final String EXTRA_MESSAGE= "hey";



    private Button enter ;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        final SharedPreferences prefs = getApplication().getSharedPreferences("school", Context.MODE_PRIVATE);

        if(null != prefs.getString("semel",null)){
            Intent intent = new Intent(getApplicationContext(), MainActivity.class);
            startActivity(intent);
        }
       getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);

        school = findViewById(R.id.school);

        enter = findViewById(R.id.start);
        enter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                prefs.edit().putString("semel",school.getText().toString()).apply();
                prefs.edit().putString("uuid",UUID.randomUUID().toString()).apply();
                startActivity(intent);

            }
        });

        schoolist = findViewById(R.id.schoolist);
        schoolist.setVisibility(View.INVISIBLE);
        school.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                schoolist.setVisibility(View.VISIBLE);

            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        schoolist.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

                String s = schoolist.getItemAtPosition(i).toString();

                school.setText(s);
                schoolist.setVisibility(View.GONE);
                InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(school.getWindowToken(), 0);


            }
        });




    }



}

