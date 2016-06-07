using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO.Compression;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text.RegularExpressions;

namespace SDG.Componentes
{
    public class Serializar
    {

        public static byte[] GZip(byte[] bytes)
        {

            using (var msi = new MemoryStream(bytes))
            using (var mso = new MemoryStream())
            {
                using (var gs = new GZipStream(mso, CompressionMode.Compress))
                {
                    msi.CopyTo(gs);
                    // CopyTo(msi, gs);
                }

                return mso.ToArray();
            }
        }

        public static byte[] UnGZip(byte[] bytes)
        {
            using (var msi = new MemoryStream(bytes))
            using (var mso = new MemoryStream())
            {
                using (var gs = new GZipStream(msi, CompressionMode.Decompress))
                {
                    gs.CopyTo(mso);
                    // CopyTo(gs, mso);
                }

                return mso.ToArray();
            }
        }

        public static byte[] Compress(byte[] bytes)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                using (DeflateStream gzs = new DeflateStream(ms, CompressionMode.Compress, false))
                {
                    gzs.Write(bytes, 0, bytes.Length);
                }
                ms.Close();
                return ms.ToArray();
            }
        }

        public static byte[] Decompress(byte[] bytes)
        {
            using (MemoryStream ms = new MemoryStream(bytes, false))
            {
                using (DeflateStream gzs = new DeflateStream(ms, CompressionMode.Decompress, false))
                {
                    using (MemoryStream dest = new MemoryStream())
                    {
                        byte[] tmp = new byte[bytes.Length];
                        int read;
                        while ((read = gzs.Read(tmp, 0, tmp.Length)) != 0)
                        {
                            dest.Write(tmp, 0, read);
                        }
                        dest.Close();
                        return dest.ToArray();
                    }
                }
            }
        }

        public static T DesSerialize<T>(byte[] stream) {

            if (stream == null || stream.Length==0)
                return default(T);

            BinaryFormatter binaryFormatter = new BinaryFormatter();
            using (MemoryStream memoryStream = new MemoryStream(stream))
            {
                T result = (T)binaryFormatter.Deserialize(memoryStream);
                return result;
            }
        }

        public static byte[] Serialize(object objeto) {

            using (MemoryStream builder = new MemoryStream())
            {
                BinaryFormatter bFormatter = new BinaryFormatter();
                bFormatter.Serialize(builder, objeto);
                builder.Flush();
                builder.Position = 0;

                return builder.ToArray();
            }
        }

        public static string SerializeBinary(object objeto) {
            return SerializeBinary(objeto, true);
        }

        public static string SerializeBinary(object objeto, bool compress)
        {
            byte[] buffer = Serialize(objeto);
            return Convert.ToBase64String(compress ? Compress(buffer) : buffer);
        }

        public static T DesSerializeBinary<T>(string variable)
        {
            return DesSerializeBinary<T>(variable, true);
        }

        public static T DesSerializeBinary<T>(string variable, bool compressed)
        {
            if (!string.IsNullOrEmpty(variable))
            {
                using (MemoryStream builder = new MemoryStream(compressed ? Decompress(Convert.FromBase64String(variable)) : Convert.FromBase64String(variable)))
                {
                    BinaryFormatter deserializer = new BinaryFormatter();
                    object info = deserializer.Deserialize(builder);
                    builder.Close();
                    return (T)info;
                }
            }
            return (T)Activator.CreateInstance(typeof(T));
        }

        public static string SerializeXML(object objeto, bool compress=true, bool base64=true, bool removeEmptySpaces=true)
        {
            if (objeto == null)
                return null;
            StringBuilder builder = new StringBuilder();
            XmlSerializer s = new XmlSerializer(objeto.GetType());
            using (StringWriter writer = new StringWriter(builder))
            {
                s.Serialize(writer, objeto);
            }
            string myXml = builder.ToString();
            // limipiamos las cadenas con xsi:nil que estan vacias
            Regex regex = new Regex("<[\\w]+? xsi:nil=\"true\" \\/>");
            myXml = regex.Replace(myXml, "");
            if (removeEmptySpaces)
            {
                regex = new Regex(@">\s*<");
                myXml = regex.Replace(myXml, "><");
            }

            if(base64)
                return Convert.ToBase64String(compress ? Compress(UTF8Encoding.UTF8.GetBytes(myXml)) : UTF8Encoding.UTF8.GetBytes(myXml));
            return myXml;
        }

        public static T DesSerializeXML<T>(string variable, bool compressed=true, bool base64=true)
        {
            if (!string.IsNullOrEmpty(variable))
            {
                try
                {
                    if(base64)
                        variable =  UTF8Encoding.UTF8.GetString(compressed ? Decompress(Convert.FromBase64String(variable)) : Convert.FromBase64String(variable));
                    StringReader builder = new StringReader(variable);
                    XmlSerializer s = new XmlSerializer(typeof(T));
                    return (T)s.Deserialize(builder);
                }
                catch { }
            }
            return (T)Activator.CreateInstance(typeof(T));
        }

        public static T DeepClone<T>(T obj)
        {
            if (obj == null)
                return default(T);
            using (var ms = new MemoryStream())
            {
                var formatter = new BinaryFormatter();
                formatter.Serialize(ms, obj);
                ms.Position = 0;

                return (T)formatter.Deserialize(ms);
            }
        }
    }
}
