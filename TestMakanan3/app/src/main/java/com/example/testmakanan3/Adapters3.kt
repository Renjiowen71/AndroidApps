package com.example.testmakanan3

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.makeramen.roundedimageview.RoundedImageView
import com.squareup.picasso.Picasso
import android.content.Intent
import android.provider.AlarmClock.EXTRA_MESSAGE
import androidx.core.content.ContextCompat.startActivity


class Adapters3 (val context:Context):RecyclerView.Adapter<Adapters3.MyViewHolder>(){

    lateinit var list:List<String>
    lateinit var namess:List<String>
    var page =0
    fun setContentList(list:List<String>,list2:List<String>){
        this.list=list
        this.namess = list2
        notifyDataSetChanged()
    }

    inner class MyViewHolder(view: View):RecyclerView.ViewHolder(view){
        var image = itemView.findViewById<RoundedImageView>(R.id.list_item_image2)
        var image2 = itemView.findViewById<RoundedImageView>(R.id.list_item_image)
        var nama1 = itemView.findViewById<TextView>(R.id.Nama2)
        var nama2 = itemView.findViewById<TextView>(R.id.Nama1)
    }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view= LayoutInflater.from(context).inflate(R.layout.list_test,parent,false)
        return MyViewHolder(view)
    }


    override fun getItemCount(): Int {
        return list.size-1;
    }

    override fun onBindViewHolder(holder: Adapters3.MyViewHolder, position: Int) {
        //holder.image.setImageResource(list[position])

        holder.nama1.setText(namess[position])
        holder.nama2.setText(namess[position+1])
        Picasso.get().load(list[position]).into(
            holder.image)
        Picasso.get().load(list[position+1]).into(
            holder.image2)
        //holder.itemView.setOnClickListener(){
        //}

    }

}