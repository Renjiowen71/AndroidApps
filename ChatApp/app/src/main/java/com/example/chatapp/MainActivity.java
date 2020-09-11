package com.example.chatapp;


import android.os.Bundle;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.math.BigInteger;


public class MainActivity extends AppCompatActivity {
    FirebaseDatabase database = FirebaseDatabase.getInstance();
    RelativeLayout activity_main;
    Switch RSA;
    Switch MCC;
    DatabaseReference message = database.getReference("Message");
    DatabaseReference user = database.getReference("User");



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        activity_main = findViewById(R.id.activity_main);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        RSA = findViewById(R.id.switchRSA);
        MCC = findViewById(R.id.switchMCC);

        //button Generatekey
        findViewById(R.id.buttongen).setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(android.view.View v) {

                BigInteger key[] = Libraries.getkey();
                EditText pri = findViewById(R.id.prkey);
                EditText pub = findViewById(R.id.pukey);
                EditText n = findViewById(R.id.nkey);
                pub.setText(key[0].toString());
                pri.setText(key[1].toString());
                n.setText(key[2].toString());

            }
        });

        //button Encrypt
        findViewById(R.id.buttonen).setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(android.view.View v) {
                EditText input = findViewById(R.id.input);
                EditText pub = findViewById(R.id.pukey);
                EditText n = findViewById(R.id.nkey);
                EditText key = findViewById(R.id.key);
                BigInteger temp;
                long start,mid,end;
                TextView timelog = findViewById(R.id.timeView);
                if(MCC.isChecked()){
                    start = System.nanoTime();
                    temp = new BigInteger(Libraries.encryptmcc(
                                    input.getText().toString(),Integer.parseInt(key.getText().toString())
                            ));
                    mid = System.nanoTime();
                    end = mid;
                    if (RSA.isChecked()){
                        temp = Libraries.encryptrsa(
                                temp.toByteArray(),
                                new BigInteger(pub.getText().toString()),
                                new BigInteger(n.getText().toString())
                        );
                        end = System.nanoTime();

                    }

                    timelog.setText("Caesar Cipher encryption running time = "+(mid-start)+" ns\n"+
                            "RSA encryption running time = "+(end-mid)+" ns");
                    input.setText(temp.toString());
                }
                else {
                    start = System.nanoTime();
                    mid = start;
                    if(RSA.isChecked()){
                        BigInteger cipher = Libraries.encryptrsa(
                                input.getText().toString().getBytes(),
                                new BigInteger(pub.getText().toString()),
                                new BigInteger(n.getText().toString())
                        );
                        end = System.nanoTime();
                        EditText ciphert = findViewById(R.id.input);

                        timelog.setText("Caesar Cipher encryption running time = "+(mid-start)+" ns\n"+
                                "RSA encryption running time = "+(end-mid)+" ns");
                        ciphert.setText(cipher.toString());

                    }
                }

            }
        });

        //button Decrypt
        findViewById(R.id.buttonde).setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(android.view.View v) {
                EditText output = findViewById(R.id.edittext);
                TextView timelog = findViewById(R.id.timeView);
                EditText key = findViewById(R.id.key);
                EditText pri = findViewById(R.id.prkey);
                EditText n = findViewById(R.id.nkey);
                BigInteger BIctext = new BigInteger(output.getText().toString());
                BigInteger temp;
                long start,mid,end;

                if(RSA.isChecked()){

                    start = System.nanoTime();
                    temp = Libraries.decryptrsa(
                            BIctext,
                            new BigInteger(pri.getText().toString()),
                            new BigInteger(n.getText().toString())
                    );
                    mid = System.nanoTime();
                    end = mid;
                    if(MCC.isChecked()){
                        temp = new BigInteger(Libraries.decryptmcc(
                                temp.toByteArray(),Integer.parseInt(key.getText().toString())
                        ));
                        end = System.nanoTime();
                    }

                    timelog.setText("RSA decryption running time = "+(mid-start)+" ns\n"+
                            "Caesar Cipher decryption running time = "+(end-mid)+" ns");
                    output.setText(
                            new String(temp.toByteArray())
                    );
                }
                else {
                    start = System.nanoTime();
                    mid = start;
                    if(MCC.isChecked()){

                        temp = new BigInteger(Libraries.decryptmcc(
                                        BIctext.toByteArray(),Integer.parseInt(key.getText().toString())
                                ));
                        end = System.nanoTime();
                        timelog.setText("RSA decryption running time = "+(mid-start)+" ns\n"+
                                "Caesar Cipher decryption running time = "+(end-mid)+" ns");
                        output.setText(
                                new String(temp.toByteArray())
                        );
                    }

                }


            }
        });

        //button arrow
        findViewById(R.id.fab).setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(android.view.View v) {
                EditText input = findViewById(R.id.input);
                EditText inputname = findViewById(R.id.inputname);
                message.setValue(input.getText().toString());
                user.setValue(inputname.getText().toString());
                input.setText("");
            }
        });

        //button refresh
        findViewById(R.id.buttonre).setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(android.view.View v) {
                message.addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                        String value = dataSnapshot.getValue(String.class);
                        EditText output = findViewById(R.id.edittext);
                        output.setText(value);
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {
                    }
                });
                user.addValueEventListener(new ValueEventListener() {
                    @Override
                    public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                        String value = dataSnapshot.getValue(String.class);
                        TextView output = findViewById(R.id.textview2);
                        output.setText(value);
                    }

                    @Override
                    public void onCancelled(@NonNull DatabaseError error) {
                    }
                });
            }
        });
        displaychatmessage();


    }


    private void displaychatmessage(){
        message.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                String value = dataSnapshot.getValue(String.class);
                EditText output = findViewById(R.id.edittext);
                output.setText(value);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
            }
        });

        user.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                String value = dataSnapshot.getValue(String.class);
                TextView output = findViewById(R.id.textview2);
                output.setText(value);
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {
            }
        });

    }
}
