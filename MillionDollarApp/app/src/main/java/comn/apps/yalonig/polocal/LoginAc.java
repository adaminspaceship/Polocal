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
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.UUID;

import static android.provider.AlarmClock.EXTRA_MESSAGE;

public class LoginAc extends AppCompatActivity {
    private EditText school;
    private ListView schoolist;
    private TextView fail;
    ArrayList<String> items = new ArrayList<>();
    ArrayList<String> currentitems = new ArrayList<>();
    ArrayAdapter<String> adapter;

    JSONObject jsonObject;



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
        fail = findViewById(R.id.fail);
        fail.setVisibility(View.GONE);
        enter = findViewById(R.id.start);
        enter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String semel= getSemel(school.getText().toString());
                if(semel==null){
                    fail.setVisibility(View.VISIBLE);
                    return;
                }
                Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                prefs.edit().putString("semel",semel).apply();
                prefs.edit().putString("uuid",UUID.randomUUID().toString()).apply();
                startActivity(intent);

            }
        });

        schoolist = findViewById(R.id.schoolist);
        schoolist.setVisibility(View.GONE);
        school.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                schoolist.setVisibility(View.VISIBLE);
                currentitems = changeList( charSequence.toString());
                adapter.notifyDataSetChanged();
                for (String s:currentitems) {
                    System.out.println(s);

                }
                adapter = new ArrayAdapter<String>(getApplicationContext(), android.R.layout.simple_list_item_1, currentitems);
                schoolist.setAdapter(adapter);

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

        String jsonData = loadJsonFromAsset();
       items = parseJson(jsonData);

         adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, items);

        schoolist.setAdapter(adapter);




    }

    private ArrayList parseJson(String jsonData) {

        ArrayList<String> items = new ArrayList<>();
        if (jsonData != null) {
            try {
                 jsonObject = new JSONObject(jsonData);
                Iterator<String> keys = jsonObject.keys();

                while(keys.hasNext()) {
                    String key = keys.next();
                    items.add(jsonObject.get(key).toString());
                    if (jsonObject.get(key) instanceof JSONObject) {


                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }


        return items;
    }


    private String loadJsonFromAsset() {
        InputStream stream;
        try {
            stream = getBaseContext().getAssets().open("school.txt");
            if (stream != null) {
                int size = stream.available();
                byte[] buffer = new byte[size];
                stream.read(buffer);
                stream.close();

                if (buffer != null) {
                    return new String(buffer);
                }
            }
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        return "";
    }
    private String getSemel(String value) {
        if (items.contains(value)) {
            Iterator<String> keys = jsonObject.keys();

            while (keys.hasNext()) {
                String key = keys.next();
                try {
                    if (jsonObject.get(key).equals(value)) {
                        System.out.println("key");
                        return key;
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }


            }
        }
        return null;
    }
    private ArrayList changeList(String sub){
        ArrayList<String> newList = new ArrayList<>();
        for (String s:items) {
            if(s.contains(sub))
                newList.add(s);
        }
        return newList;
    }

}

