package comn.apps.yalonig.polocal;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ArgbEvaluator;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{

    private Button send,chooseF,chooseT;
    private EditText question,falseAns,trueAns,questionView;
    private String semel,uuid,currentQuestTS;
    private ArrayList<String> allQuests = new ArrayList<>();
    private ArrayList<String> readQuests= new ArrayList<>();
    private View grayScale;
    private ProgressBar loading;
    private TextView rightAns,leftAns,rightPer,leftPer,sent;
    private int btnDis;
    private boolean noQuest = false;
    BottomNavigationView navigation;

    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    questionView.setVisibility(View.VISIBLE);
                    chooseT.setVisibility(View.VISIBLE);
                    chooseF.setVisibility(View.VISIBLE);
                    send.setVisibility(View.GONE);
                    sent.setVisibility(View.GONE);
                    falseAns.setVisibility(View.GONE);
                    trueAns.setVisibility(View.GONE);
                    question.setVisibility(View.GONE);
                    rightAns.setVisibility(View.VISIBLE);
                    leftAns.setVisibility(View.VISIBLE);
                    if(noQuest)changeQuest();

                    return true;
                case R.id.navigation_dashboard:
                    questionView.setVisibility(View.GONE);
                    send.setVisibility(View.VISIBLE);
                    falseAns.setVisibility(View.VISIBLE);
                    trueAns.setVisibility(View.VISIBLE);
                    question.setVisibility(View.VISIBLE);
                    chooseT.setVisibility(View.GONE);
                    chooseF.setVisibility(View.GONE);
                    rightAns.setVisibility(View.GONE);
                    leftAns.setVisibility(View.GONE);
                    grayScale.setVisibility(View.GONE);
                    leftPer.setVisibility(View.GONE);
                    rightPer.setVisibility(View.GONE);
                    return true;
                case R.id.navigation_myQuests:
                    sent.setVisibility(View.GONE);
                    questionView.setVisibility(View.GONE);
                    send.setVisibility(View.GONE);
                    falseAns.setVisibility(View.GONE);
                    trueAns.setVisibility(View.GONE);
                    question.setVisibility(View.GONE);
                    chooseT.setVisibility(View.GONE);
                    chooseF.setVisibility(View.GONE);
                    rightAns.setVisibility(View.GONE);
                    leftAns.setVisibility(View.GONE);
                    grayScale.setVisibility(View.GONE);
                    leftPer.setVisibility(View.GONE);
                    rightPer.setVisibility(View.GONE);
                    return true;
            }
            return false;
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        SharedPreferences prefs = getApplication().getSharedPreferences("school", Context.MODE_PRIVATE);
        semel = prefs.getString("semel",null);
        uuid = prefs.getString("uuid",null);
        System.out.println(semel+"  "+uuid);
        questionView = findViewById(R.id.questionView);
        questionView.setEnabled(false);
        send = findViewById(R.id.send);
        chooseF = findViewById(R.id.chooseF);
        chooseT= findViewById(R.id.chooseT);
        falseAns = findViewById(R.id.falseAns);
        trueAns = findViewById(R.id.trueAns);
        grayScale = findViewById(R.id.bulbul);
        question = findViewById(R.id.addQuest);
        send.setVisibility(View.GONE);
        falseAns.setVisibility(View.GONE);
        trueAns.setVisibility(View.GONE);
        sent = findViewById(R.id.sent);
        loading = findViewById(R.id.loadinganim);
        question.setVisibility(View.GONE);
        chooseF.setOnClickListener(this);
        chooseT.setOnClickListener(this);
        rightAns = findViewById(R.id.rightAns);
        leftAns = findViewById(R.id.leftAns);
        rightPer = findViewById(R.id.rightpercent);
        leftPer= findViewById(R.id.leftpercent);
        grayScale.setVisibility(View.GONE);
        leftPer.setVisibility(View.GONE);
        rightPer.setVisibility(View.GONE);
        sent.setVisibility(View.GONE);
        loading.setVisibility(View.GONE);

        send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                postAPost();
            }
        });


        navigation = (BottomNavigationView) findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
        changeQuest();

        navigation.setClickable(false);





    }

    private long getUnix(){return System.currentTimeMillis()/1000;}
    private void postAPost(){
        FirebaseDatabase database = FirebaseDatabase.getInstance();
        DatabaseReference postRef = database.getReference("Posts").child(semel);
        String falseAns,trueAns,question;
        falseAns = this.falseAns.getText().toString();
        trueAns= this.trueAns.getText().toString();
        question = this.question.getText().toString();
        postRef.child(getUnix()+"").child("falseAnswer").setValue(falseAns);
        postRef.child(getUnix()+"").child("trueAnswer").setValue(trueAns);
        postRef.child(getUnix()+"").child("question").setValue(question);
        postRef.child(getUnix()+"").child("timestamp").setValue(getUnix()+"");
        postRef.child(getUnix()+"").child("answers").child("false").setValue(0+"");
        postRef.child(getUnix()+"").child("answers").child("true").setValue(0+"");
        sent.setVisibility(View.VISIBLE);
        this.trueAns.setText("תשובה 1");
        this.question.setText("כתוב שאלה");
        this.falseAns.setText("תשובה 2");

    }
    private void ansQuest(final boolean ans){


        final FirebaseDatabase database = FirebaseDatabase.getInstance();
        final DatabaseReference ref = database.getReference("Posts").child(semel).child(currentQuestTS).child("answers");

        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                int  trueAnswers = Integer.parseInt(dataSnapshot.child("true").getValue().toString());
                int  falseAnswers = Integer.parseInt(dataSnapshot.child("false").getValue().toString());
                if(ans) {

                    ref.child("true").setValue(++trueAnswers+"");
                }else{


                    ref.child("false").setValue(++falseAnswers+"");
                }
                showAns(trueAnswers,falseAnswers);


            }

            @Override
            public void onCancelled(DatabaseError databaseError) {


            }
        });
    }
    private void changeQuest(){
        loading.setVisibility(View.VISIBLE);
        chooseF.setClickable(false);
        chooseT.setClickable(false);

        FirebaseDatabase database = FirebaseDatabase.getInstance();
        final DatabaseReference ref = database.getReference();

        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {

                for(DataSnapshot readPosts : dataSnapshot.child(uuid).child("readPosts").getChildren()){
                    readQuests.add(readPosts.getValue().toString());
                }
                for (DataSnapshot allPosts : dataSnapshot.child("Posts").child(semel).getChildren()) {
                    if(!readQuests.contains(allPosts.getKey().toString())) {
                        currentQuestTS=allPosts.getKey().toString();
                        questionView.setText(allPosts.child("question").getValue().toString());
                        ref.child(uuid).child("readPosts").child(currentQuestTS).setValue(currentQuestTS);
                        leftAns.setText(allPosts.child("falseAnswer").getValue().toString());
                        rightAns.setText(allPosts.child("trueAnswer").getValue().toString());
                        chooseF.setClickable(true);
                        chooseT.setClickable(true);
                        noQuest=false;
                        loading.setVisibility(View.GONE);
                        break;
                    }
                    leftAns.setText("באסה");
                    rightAns.setText("איזה");
                    questionView.setText("אין יותר שאלות");
                    loading.setVisibility(View.GONE);
                    noQuest = true;



                }


            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                System.out.println("The read failed: " + databaseError.getCode());
            }
        });
    }


    @Override
    public void onClick(View view) {
        if(view.equals(chooseF))
            ansQuest(false);
        if(view.equals(chooseT))
            ansQuest(true);
    }
    private void showAns(final int t, final int f){
        final ViewGroup.LayoutParams params=grayScale.getLayoutParams();
        btnDis =  (int)((chooseT.getX()+chooseT.getWidth())-chooseF.getX());
            System.out.println(btnDis*f/(f+t));

        int maxValue=0;
        if(f>=t){ maxValue= btnDis*f/(f+t) ;}
        if(t>f){ maxValue= btnDis*t/(f+t) ;}
        grayScale.setVisibility(View.VISIBLE);

        ValueAnimator animator = ValueAnimator.ofInt(10,maxValue );
        animator.setDuration(3000);
        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation){
                if(f>t){
                    grayScale.setX(chooseF.getX());
                }else{
                    grayScale.setX(chooseT.getX()+chooseT.getWidth()-grayScale.getWidth());
                }
                params.width=(Integer)animation.getAnimatedValue();
                grayScale.setLayoutParams(params);
            }
        });
        animator.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                grayScale.setVisibility(View.GONE);
                leftPer.setVisibility(View.GONE);
                rightPer.setVisibility(View.GONE);
                questionView.setText("");
                leftAns.setText("");
                rightAns.setText("");
                navigation.setClickable(true);
                changeQuest();
            }
        });
       animator.start();
        rightPer.setVisibility(View.VISIBLE);
        leftPer.setVisibility(View.VISIBLE);
       leftPer.setText(100*f/(f+t)+"%");
        rightPer.setText((100-100*f/(f+t))+"%");




    }
    }

