package com.example.testmakanan3

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.squareup.picasso.Picasso
import org.json.JSONArray
import java.io.InputStream

class Details : AppCompatActivity() {
    var name = arrayListOf<String>()
    var pict = arrayListOf<String>()

    var id = arrayListOf<String>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_details)
        var page = intent.getStringExtra("key")
        var pageint = page.toInt()
        var nama = findViewById<TextView>(R.id.Nama)
        var desc = findViewById<TextView>(R.id.Desc)
        var viewimage = findViewById<ImageView>(R.id.imageView)
        //Seharusnya menggunakan id untuk url, tetapi url yang diberikan tidak berjalan

        var json : String
        val inputStream: InputStream = assets.open("List.json")
        json = inputStream.bufferedReader().use { it.readText() }

        var jsonarr = JSONArray(json)

        for(i in 0 until jsonarr.length()-2){
            var jsonobj = jsonarr.getJSONObject(i)
            name.add(jsonobj.getString("strMeal"))
            pict.add(jsonobj.getString("strMealThumb"))
            id.add(jsonobj.getString("idMeal"))
        }

        nama.setText(name[pageint])
        Picasso.get().load(pict[pageint]).into(
            viewimage)
        desc.setText(id[pageint])

        val button3 = findViewById(R.id.button3) as Button
        button3.setOnClickListener {
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
        }

    }
}
