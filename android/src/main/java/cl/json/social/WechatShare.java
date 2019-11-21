package cl.json.social;

import android.content.ActivityNotFoundException;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableMap;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import java.awt.image.BufferedImage;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import java.awt.image.DataBufferByte;
import java.io.IOException;
/**
 * Created by disenodosbbcl on 23-07-16.
 */
public class TwitterShare extends SingleShareIntent {

    private static final String PACKAGE = "com.twitter.android";
    private static final String DEFAULT_WEB_LINK = "https://twitter.com/intent/tweet?text={message}&url={url}";

    public TwitterShare(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    public void open(ReadableMap options) throws ActivityNotFoundException {
      WXWebpageObject webpage = new WXWebpageObject();
      webpage.webpageUrl = "https://itunes.apple.com/us/app/air-translator-translation-any-time-anywhere/id1119155198?mt=8";
      WXMediaMessage msg = new WXMediaMessage(webpage);
      msg.title = options.getString("title");
      msg.description = options.getString("message");
      byte[] imageBytes = null;
      try {
          URL url = new URL(options.getString("url"));
          BufferedImage img = ImageIO.read(url);
          imageBytes = ((DataBufferByte) bufferedImage.getData().getDataBuffer()).getData();
      } catch (IOException e) { }

      msg.thumbData = imageBytes;//Cover image byte array

      SendMessageToWX.Req req = new SendMessageToWX.Req();
      req.transaction = String.valueOf(System.currentTimeMillis());
      req.message = msg;
      req.scene = friendsCircle ? SendMessageToWX.Req.WXSceneTimeline : SendMessageToWX.Req.WXSceneSession;
      wxAPI.sendReq(req);
    }

    public void onResp(BaseResp resp){
        if (resp.getType() == ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX){
            Log.i("ansen", "Wechat Sharing Operation.....");
            // WeiXin weiXin = new WeiXin(2, resp.errCode, "");
            // EventBus.getDefault().post(weiXin);
        } else if (resp.getType() == ConstantsAPI.COMMAND_SENDAUTH){
            Log.i("ansen", "Wechat login operation.....");
            // SendAuth.Resp authResp = (SendAuth.Resp) resp;
            // WeiXin weiXin = new WeiXin(1, resp.errCode, authResp.code);
            // EventBus.getDefault().post(weiXin);
        }
        //finish();
    }

    @Override
    protected String getPackage() {
        return PACKAGE;
    }

    @Override
    protected String getDefaultWebLink() {
        return DEFAULT_WEB_LINK;
    }

    @Override
    protected String getPlayStoreLink() {
        return null;
    }
}
