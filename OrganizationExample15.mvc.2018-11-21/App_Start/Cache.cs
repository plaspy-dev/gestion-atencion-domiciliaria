using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Caching;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15
{
    public class Cache
    {
        public static JsonSerializerSettings JSonRedisSettings = new JsonSerializerSettings()
        {
            TypeNameHandling = TypeNameHandling.All,
            // ContractResolver = new RedisContractResolver(),
            NullValueHandling = NullValueHandling.Ignore
        };

        public static T DeserializeJSON<T>(string value)
        {
            try
            {
                if (!string.IsNullOrEmpty(value))
                    return JsonConvert.DeserializeObject<T>(value, Cache.JSonRedisSettings);
            }
            catch { }
            return default(T);
        }

        public static T DeserializeJSON<T>(byte[] value)
        {
            try
            {
                if (value != null && value.Length > 0)
                {
                    /*if (value.Length > 2 && value[0] == 0x1f && value[1] == 0x8b) // esta comprimido en gzip
                        value = Serializar.UnGZip(value);*/
                    return JsonConvert.DeserializeObject<T>(UTF8Encoding.UTF8.GetString(value), Cache.JSonRedisSettings);
                }
            }
            catch { }
            return default(T);
        }

        public static byte[] SerializeJSONGZip(object value)
        {
            byte[] content = ASCIIEncoding.UTF8.GetBytes(JsonConvert.SerializeObject(value, Cache.JSonRedisSettings));
            /*if (content.Length > 300) // Min size to GZIP relations vs profit
                content = Serializar.GZip(content);*/
            return content;
        }

        public static string SerializeJSON(object value)
        {
            return JsonConvert.SerializeObject(value, Cache.JSonRedisSettings);
        }

        public static T Get<T>(string clave)
        {
            try
            {
                clave = clave.Replace(".", "_");
                return (T)Serializar.DeepClone(HttpRuntime.Cache[clave]);
            }
            catch (Exception ex) { }
            return default(T);
        }

        public static bool Set(string clave, object valor, TimeSpan? expiration = null)
        {
            try
            {
                clave = clave.Replace(".", "_");
                if (expiration == null)
                    expiration = TimeSpan.FromDays(1);
                HttpRuntime.Cache.Insert(clave, valor, null, DateTime.Now.Add(expiration.Value), System.Web.Caching.Cache.NoSlidingExpiration);
                return true;
            }
            catch (Exception ex) {  }
            return false;
        }

        public static bool Remove(string clave)
        {
            try
            {
                clave = clave.Replace(".", "_");
                HttpRuntime.Cache.Remove(clave);
                return true;
            }
            catch (Exception ex) {  }
            return false;
        }

        public static void FlushAll()
        {
            foreach (System.Collections.DictionaryEntry entry in HttpContext.Current.Cache)
            {
                HttpContext.Current.Cache.Remove((string)entry.Key);
            }
        }

        public static string GetEnumDescription<T>(T valor)
        {
            try
            {
                return ((DescriptionAttribute)valor.GetType().GetField(valor.ToString()).GetCustomAttributes(typeof(DescriptionAttribute), true)[0]).Description;
            }
            catch { }
            return "";
        }

        public static void RemoveList(string keyname)
        {
            List<string> cachelist = Cache.Get<List<string>>(keyname) ?? new List<string>();
            Cache.Remove(keyname);
            foreach (string key in cachelist)
            {
                Cache.Remove(key);
            }
        }
        public static void AddList(string keyname, string value)
        {

            List<string> cachelist = Cache.Get<List<string>>(keyname) ?? new List<string>();
            if (!cachelist.Contains(value))
            {
                cachelist.Add(value);
                Cache.Set(keyname, cachelist);
            }
        }
    }
}