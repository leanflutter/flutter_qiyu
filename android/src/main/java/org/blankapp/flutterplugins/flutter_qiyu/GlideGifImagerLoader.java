package org.blankapp.flutterplugins.flutter_qiyu;

import android.content.Context;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.qiyukf.unicorn.api.UnicornGifImageLoader;

import java.io.Serializable;

public class GlideGifImagerLoader implements UnicornGifImageLoader, Serializable {

    Context context;

    public GlideGifImagerLoader(Context context) {
        this.context = context.getApplicationContext();
    }


    @Override
    public void loadGifImage(String url, ImageView imageView, String imgName) {
        if (url == null || imgName == null) {
            return;
        }
        Glide.with(context).load(url).into(imageView);
    }
}
