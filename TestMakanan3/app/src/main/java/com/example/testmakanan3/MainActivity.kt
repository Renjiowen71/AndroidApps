package com.example.testmakanan3

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_main.*
import org.json.JSONArray
import java.io.InputStream
import android.content.Intent

import android.widget.Button

import androidx.viewpager2.widget.ViewPager2


class MainActivity : AppCompatActivity() {

    lateinit var adapters: Adapters3
    //lateinit var adapters2:Adapters2
    var name = arrayListOf<String>()
    var pict = arrayListOf<String>()

    var id = arrayListOf<String>()
    private lateinit var mPager: ViewPager2

    override fun onCreate(savedInstanceState: Bundle?) {



        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        mPager = findViewById(R.id.viewpager)
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

        adapters = Adapters3(this)
        adapters.setContentList(pict,name)

        viewpager.adapter = adapters
        val button = findViewById(R.id.button) as Button
        button.setOnClickListener {
            val intent = Intent(this, Details::class.java).apply {
                putExtra("key", (mPager.currentItem).toString())
                }
            startActivity(intent)
        }
        val button2 = findViewById(R.id.button2) as Button
        button2.setOnClickListener {
            val intent = Intent(this, Details::class.java).apply {
                putExtra("key", (mPager.currentItem+1).toString())
            }
            startActivity(intent)
        }




    }


}


