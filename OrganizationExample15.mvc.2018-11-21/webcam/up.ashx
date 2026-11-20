<%@ WebHandler Language="C#" Class="up" %>

using System;
using System.Web;
using System.Web.SessionState;

public class up : IHttpHandler, IRequiresSessionState {

    public static int GetHexVal(char hex)
    {
        int val = (int)hex;
        //For uppercase A-F letters:
        return val - (val < 58 ? 48 : 55);
        //For lowercase a-f letters:
        //return val - (val < 58 ? 48 : 87);
        //Or the two combined, but a bit slower:
        //return val - (val < 58 ? 48 : (val < 97 ? 55 : 87));
    }
    
    public static byte[] StringToByteArrayFastest(string hex)
    {
        if (hex.Length % 2 == 1)
            return null;

        byte[] arr = new byte[hex.Length >> 1];

        for (int i = 0; i < hex.Length >> 1; ++i)
        {
            arr[i] = (byte)((GetHexVal(hex[i << 1]) << 4) + (GetHexVal(hex[(i << 1) + 1])));
        }

        return arr;
    }

    public void ProcessRequest (HttpContext context) {

        if(!string.IsNullOrEmpty(context.Request.QueryString["par"])) {
            context.Response.Clear();
            context.Response.AddHeader("Content-Disposition", "inline;filename=foto.jpg");
            context.Response.ContentType = "image/jpeg";
            context.Response.BinaryWrite((byte [])context.Session["webcam_foto"]);
        } else {
            System.Text.UTF8Encoding encoding = new System.Text.UTF8Encoding();
            string cadena = encoding.GetString(context.Request.BinaryRead(context.Request.TotalBytes));
            context.Session["webcam_foto"] = StringToByteArrayFastest(cadena);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}