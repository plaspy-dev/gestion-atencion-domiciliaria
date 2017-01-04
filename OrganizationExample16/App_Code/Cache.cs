using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;

namespace SDG.OrganizationExample16
{
    public class Cache
    {
        // private static MemcachedClient cliente = MemcachedClient.Exists("cache") ? MemcachedClient.GetInstance("cache") : null;
        public static object Get(string clave)
        {
            /*if (cliente != null)
                return cliente.Get(clave);
            else*/
                return HttpRuntime.Cache[clave];
        }

        public static void Set(string clave, object valor)
        {
            /*if (cliente != null)
                cliente.Set(clave, valor);
            else*/
            HttpRuntime.Cache.Insert(clave, valor, null, DateTime.Now.AddHours(1), System.Web.Caching.Cache.NoSlidingExpiration);
        }

        public static void Remove(string clave)
        {
            /*if (cliente != null)
                cliente.Delete(clave);
            else*/ HttpRuntime.Cache.Remove(clave);
        }

        public static void FlushAll(string start_key)
        {

            /*if (cliente != null)
                cliente.FlushAll();
            else
            {*/
                foreach (DictionaryEntry i in HttpRuntime.Cache)
                { // las consultas con parametros
                    if (i.Key.ToString().StartsWith(start_key))
                    {
                        Cache.Remove(i.Key.ToString());
                    }
                }
            // }
        }
    }
}