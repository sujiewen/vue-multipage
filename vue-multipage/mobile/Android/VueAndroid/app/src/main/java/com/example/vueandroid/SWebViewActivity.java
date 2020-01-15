package com.example.vueandroid;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import android.util.Log;
import android.view.View;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.github.lzyzsd.jsbridge.BridgeHandler;
import com.github.lzyzsd.jsbridge.BridgeWebView;
import com.github.lzyzsd.jsbridge.CallBackFunction;
import com.github.lzyzsd.jsbridge.DefaultHandler;
import com.google.gson.Gson;

import androidx.appcompat.app.AppCompatActivity;

public class SWebViewActivity extends AppCompatActivity {

    private final String TAG = "MainActivity";

    private EditText et;

    BridgeWebView webView;

    private Button bt1;
    private Button bt2;

    int RESULT_CODE = 0;

    ValueCallback<Uri> mUploadMessage;
    ValueCallback<Uri[]> mUploadMessageArray;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sweb_view);


        et = (EditText) findViewById(R.id.et);
        bt1 = (Button) findViewById(R.id.bt);
        bt2 = (Button) findViewById(R.id.bt2);

        webView = (BridgeWebView) findViewById(R.id.webview);

        webView.setDefaultHandler(new DefaultHandler());
        webView.setWebChromeClient(new WebChromeClient() {
            @SuppressWarnings("unused")
            public void openFileChooser(ValueCallback<Uri> uploadMsg, String AcceptType, String capture) {
                this.openFileChooser(uploadMsg);
            }

            @SuppressWarnings("unused")
            public void openFileChooser(ValueCallback<Uri> uploadMsg, String AcceptType) {
                this.openFileChooser(uploadMsg);
            }

            public void openFileChooser(ValueCallback<Uri> uploadMsg) {
                mUploadMessage = uploadMsg;
                pickFile();
            }

            @Override
            public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
                mUploadMessageArray = filePathCallback;
                pickFile();
                return true;
            }
        });

        webView.loadUrl("file:///android_asset/demo.html");

        //      注册监听方法当js中调用callHandler方法时会调用此方法（handlerName必须和js中相同）
        webView.registerHandler("submitFromWeb", new BridgeHandler() {
            @Override
            public void handler(String data, CallBackFunction function) {
                Log.e("TAG", "js返回：" + data);
                //显示js传递给Android的消息
                Toast.makeText(SWebViewActivity.this, "js返回:" + data, Toast.LENGTH_LONG).show();
                //Android返回给JS的消息
                function.onCallBack("我是js调用Android返回数据：" + data);
            }
        });

        bt1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//              调用js中的方法（必须和js中的handlerName想同）
                webView.callHandler("functionInJs", "Android调用js66", new CallBackFunction() {
                    @Override
                    public void onCallBack(String data) {
                        Log.e("TAG", "onCallBack:" + data);
                        Toast.makeText(SWebViewActivity.this, data, Toast.LENGTH_LONG).show();
                    }
                });
            }
        });

        webView.setDefaultHandler(new DefaultHandler(){
            @Override
            public void handler(String data, CallBackFunction function) {
                Toast.makeText(SWebViewActivity.this, data, Toast.LENGTH_SHORT).show();
                function.onCallBack("Android收到了默认的消息");
            }
        });

        bt2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
//              发送信息给js,此处不需要配置handlerName
                webView.send(et.getText().toString().trim(), new CallBackFunction() {
                    @Override
                    public void onCallBack(String data) {
//                      接收js的回调数据
                        Toast.makeText(SWebViewActivity.this, data, Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == RESULT_CODE) {
            if (null == mUploadMessage && null == mUploadMessageArray){
                return;
            }
            if(null!= mUploadMessage && null == mUploadMessageArray){
                Uri result = intent == null || resultCode != RESULT_OK ? null : intent.getData();
                mUploadMessage.onReceiveValue(result);
                mUploadMessage = null;
            }

            if(null == mUploadMessage && null != mUploadMessageArray){
                Uri result = intent == null || resultCode != RESULT_OK ? null : intent.getData();
                if (result != null) {
                    mUploadMessageArray.onReceiveValue(new Uri[]{result});
                }
                mUploadMessageArray = null;
            }

        }
    }

    public void pickFile() {
        Intent chooserIntent = new Intent(Intent.ACTION_GET_CONTENT);
        chooserIntent.setType("image/*");
        startActivityForResult(chooserIntent, RESULT_CODE);
    }

}
