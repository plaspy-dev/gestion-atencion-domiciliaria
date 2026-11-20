using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.IO;
using System.Web.Security;

namespace SDG.Componentes
{
    public class Crypt
    {
        // D2D8884BFDA2E259859F1AAEF3A677C8
        private static byte[] IV_CBC = { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63 };
        private static Byte[] IV = { 16, 17, 18, 19, 20, 21, 22, 23 };
        Crypt() {

        }

        public static String DesencriptarDES(String palabra)
        {
            String key = "";
            key = "DEMO" + DateTime.Now.Day.ToString().PadLeft(2, '0') + "K7";
            return DesencriptarDES(palabra, key);
        }

        public static String DesencriptarDES(String palabra, String key) {

            if (string.IsNullOrEmpty(palabra) || string.IsNullOrEmpty(key))
                return "";

            return Encoding.UTF8.GetString(DesencriptarDES(Convert.FromBase64String(palabra), key));
        }

        public static byte[] DesencriptarDES(byte[] content, String key)
        {
            if (content==null || content.Length==0 || string.IsNullOrEmpty(key))
                return null;

            try
            {
                Byte[] bKey = Encoding.UTF8.GetBytes(key);

                using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
                using (MemoryStream ms = new MemoryStream())
                using (CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(bKey, IV), CryptoStreamMode.Write))
                {
                    cs.Write(content, 0, content.Length);
                    cs.FlushFinalBlock();

                    return ms.ToArray();
                }
            } catch { }
            return null;
        }

        public static String EncriptarDES(String palabra)
        {
            String key = "";
            key = "DEMO" + DateTime.Now.Day.ToString().PadLeft(2, '0') + "K7";
            return EncriptarDES(palabra, key);
        }

        // la clave tiene que ser de 8 caracteres
        public static String EncriptarDES(String palabra, String key) {

            if (string.IsNullOrEmpty(palabra) || string.IsNullOrEmpty(key))
                return "";

            return Convert.ToBase64String(EncriptarDES(Encoding.UTF8.GetBytes(palabra), key));
        }

        public static byte[] EncriptarDES(byte[] content, String key)
        {

            if (content==null || content.Length==0 || string.IsNullOrEmpty(key))
                return null;

            Byte[] bKey = Encoding.UTF8.GetBytes(key);

            using (DESCryptoServiceProvider des = new DESCryptoServiceProvider())
            using (MemoryStream ms = new MemoryStream())
            using (CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(bKey, IV), CryptoStreamMode.Write))
            {
                cs.Write(content, 0, content.Length);
                cs.FlushFinalBlock();

                return ms.ToArray();
            }
        }

        public static string EncriptarAESCBC(String palabra, String key)
        {
            if (string.IsNullOrEmpty(palabra) || string.IsNullOrEmpty(key))
                return "";

            return Convert.ToBase64String(EncriptarAESCBC(Encoding.UTF8.GetBytes(palabra), key));
        }

        public static byte[] EncriptarAESCBC(byte[] content, string key)
        {
            if (content == null || content.Length == 0 || string.IsNullOrEmpty(key))
                return null;

            byte[] bKey = Encoding.UTF8.GetBytes(key);

            using (RijndaelManaged rijndaelCipher = new RijndaelManaged())
            {
                rijndaelCipher.Mode = CipherMode.CBC;
                rijndaelCipher.Padding = PaddingMode.PKCS7;

                rijndaelCipher.KeySize = 128;
                rijndaelCipher.BlockSize = 128;

                rijndaelCipher.Key = bKey;
                rijndaelCipher.IV = IV_CBC;

                using (ICryptoTransform transform = rijndaelCipher.CreateEncryptor())
                {
                    return transform.TransformFinalBlock(content, 0, content.Length);
                }
            }
        }

        // la clave tiene que ser de 16 caracteres
        public static String Encriptar3DES(String palabra, String key)
        {
            if (string.IsNullOrEmpty(palabra) || string.IsNullOrEmpty(key))
                return "";

            return Convert.ToBase64String(Encriptar3DES(Encoding.UTF8.GetBytes(palabra), key));
        }

        // la clave tiene que ser de 16 caracteres
        public static byte[] Encriptar3DES(byte[] content, string key)
        {
            if (content==null || content.Length==0 || string.IsNullOrEmpty(key))
                return null;

            Byte[] bKey = Encoding.UTF8.GetBytes(key);

            using(TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider())
            using (MemoryStream ms = new MemoryStream())
            using(CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(bKey, IV), CryptoStreamMode.Write))
            {
                des.Mode = CipherMode.CBC;
                cs.Write(content, 0, content.Length);
                cs.FlushFinalBlock();

                return ms.ToArray();
            }
        }

        public static String DesencriptarAESCBC(String palabra, String key)
        {
            if (string.IsNullOrEmpty(palabra) || string.IsNullOrEmpty(key))
                return "";

            return Encoding.UTF8.GetString(DesencriptarAESCBC(Convert.FromBase64String(palabra), key));
        }

        public static byte[] DesencriptarAESCBC(byte[] content, string key)
        {
            if (content == null || content.Length == 0 || string.IsNullOrEmpty(key))
                return null;

            byte[] bKey = Encoding.UTF8.GetBytes(key);

            using (RijndaelManaged rijndaelCipher = new RijndaelManaged())
            {
                rijndaelCipher.Mode = CipherMode.CBC;
                rijndaelCipher.Padding = PaddingMode.PKCS7;

                rijndaelCipher.KeySize = 128;
                rijndaelCipher.BlockSize = 128;

                rijndaelCipher.Key = bKey;
                rijndaelCipher.IV = IV_CBC;

                using (ICryptoTransform transform = rijndaelCipher.CreateDecryptor())
                {
                    return transform.TransformFinalBlock(content, 0, content.Length);
                }
            }
        }

        public static String Desencriptar3DES(String palabra, String key)
        {
            if (string.IsNullOrEmpty(palabra) || string.IsNullOrEmpty(key))
                return "";

            return Encoding.UTF8.GetString(Desencriptar3DES(Convert.FromBase64String(palabra), key));
        }

        public static byte[] Desencriptar3DES(byte[] content, String key)
        {
            if (content==null || content.Length==0 || string.IsNullOrEmpty(key))
                return null;

            try
            {
                Byte[] bKey = System.Text.Encoding.UTF8.GetBytes(key);

                using (TripleDESCryptoServiceProvider des = new TripleDESCryptoServiceProvider())
                using (MemoryStream ms = new MemoryStream())
                using(CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(bKey, IV), CryptoStreamMode.Write))
                {
                    des.Mode = CipherMode.CBC;
                    cs.Write(content, 0, content.Length);
                    cs.FlushFinalBlock();

                    return ms.ToArray();
                }
            } catch { }
            return null;
        }

        static public string Protect(string unprotectedText, string Purpose= "Authentication Token")
        {
            if (string.IsNullOrEmpty(unprotectedText))
                return unprotectedText;
            var unprotectedBytes = Encoding.UTF8.GetBytes(unprotectedText);
            var protectedBytes = MachineKey.Protect(unprotectedBytes, Purpose);
            var protectedText = Convert.ToBase64String(protectedBytes);
            return protectedText;
        }

        static public string Unprotect(string protectedText, string Purpose = "Authentication Token")
        {
            if (string.IsNullOrEmpty(protectedText))
                return protectedText;
            var protectedBytes = Convert.FromBase64String(protectedText);
            var unprotectedBytes = MachineKey.Unprotect(protectedBytes, Purpose);
            var unprotectedText = Encoding.UTF8.GetString(unprotectedBytes);
            return unprotectedText;
        }

        public static string GetMD5(string str)
        {
            using (MD5 md5 = MD5CryptoServiceProvider.Create())
            {
                ASCIIEncoding encoding = new ASCIIEncoding();
                StringBuilder sb = new StringBuilder();
                byte[] stream = md5.ComputeHash(encoding.GetBytes(str));
                for (int i = 0; i < stream.Length; i++)
                    sb.AppendFormat("{0:x2}", stream[i]);
                return sb.ToString();
            }
        }

        public static string GetMD5File(string filename) {

            using (var md5 = MD5.Create())
            {
                using (var stream = File.OpenRead(filename))
                {
                    StringBuilder sb = new StringBuilder();
                    byte[] bstream = md5.ComputeHash(stream);
                    for (int i = 0; i < bstream.Length; i++)
                        sb.AppendFormat("{0:x2}", bstream[i]);
                    return sb.ToString();
                }
            }
        }
    }
}
