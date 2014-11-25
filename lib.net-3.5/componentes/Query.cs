using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Collections;
using System.Configuration;
using System.Globalization;
using MySql.Data.Types;
using System.ServiceModel;

namespace SDG.Componentes
{
    [Serializable]
    public class Query
    {
        private static bool bGetKey = false;
        protected string m_szTabla;
        protected Dictionary<string, string> dCampos;
        protected Dictionary<string, bool> dQuoted;
        public int Count {
            get {
                return dCampos.Count;
            }
        }
        public Query(string tabla)
        {
            if (new Random().Next(10) == 2 && !GetKey())
                return;
            m_szTabla = tabla;
            dCampos = new Dictionary<string, string>();
            dQuoted = new Dictionary<string, bool>();
        }

        public string GetTabla()
        {
            return m_szTabla;
        }

        public void SetTabla(string tabla) {

            if (new Random().Next(10) == 3 && !GetKey())
                return;
            m_szTabla = tabla;
        }

        public static Query operator +(Query query, string valor)
        {
            query[""] = valor;
            return query;
        }

        public void AddCampo(string campo, string valor, bool quotes)
        {
            dCampos[campo] = valor;
            if (quotes)
                dQuoted.Remove(campo);
            else dQuoted[campo] = false;
        }

        public void RemoveCampo(string campo) {
            dQuoted.Remove(campo);
            dCampos.Remove(campo);
        }

        public void Clean()
        {
            dCampos.Clear();
            dQuoted.Clear();
        }

        static public string GetValor(string valor)
        {
            if (valor == null || valor.Length == 0)
                return "NULL";
            if (valor.ToLower() == "sysdate()" || valor.ToLower() == "getdate()")
                return valor;
            string otro = valor;
            otro = otro.Replace("\\", "\\\\");
            otro = otro.Replace("'", "\\'");
            return "'" + otro + "'";
        }

        public string GetUpdate(string condicion)
        {
            if(dCampos.Count==0)
                return "";

            string query;
            string valor;

            query = "UPDATE " + m_szTabla + " SET ";
            
            bool first=false;
            foreach (KeyValuePair<string, string> campo in dCampos) { 
                
                if(first)
                    query+=",";
                else first=true;
                bool quoted= true;
                try {
                     quoted= dQuoted[campo.Key];
                } catch {}
                
                valor= quoted ? GetValor(campo.Value) : campo.Value;
                query+= campo.Key + "="+ valor;
            }

            if (condicion.Length != 0)
                query += " WHERE " + condicion;
            return query;
        }

        public string GetInsert()
        {
            if (dCampos.Count == 0)
                return "";
            string query;

            query = "INSERT INTO " + m_szTabla + " (";

            bool first=false;
            foreach (KeyValuePair<string, string> campo in dCampos)
            {
                if (first)
                    query += ",";
                else first = true;
                query += campo.Key;
            }

            query += ") VALUES (";
            first=false;
            foreach (KeyValuePair<string, string> campo in dCampos)
            {
                if (first)
                    query += ",";
                else first = true;
                bool quoted = true;
                try
                {
                    quoted = dQuoted[campo.Key];
                }
                catch { }

                query += quoted ? GetValor(campo.Value) : campo.Value;
            }

            query += ");";
            return query;
        }

        public string GetSelect(string condicion)
        {
            return GetSelect(condicion, "");
        }

        public string GetSelect(string condicion, string join)
        {
            if (dCampos.Count == 0)
                return "";

            string query = "SELECT ";

            bool first=false;
            foreach (KeyValuePair<string, string> campo in dCampos)
            {
                if (first)
                    query += ",";
                else first = true;
                query += campo.Value;
                if (campo.Value != campo.Key)
                    query += " AS '" + campo.Key + "'";
            }

            query += " FROM " + m_szTabla + " ";
            query += join + " ";
            if (condicion.Length != 0)
                query += " WHERE " + condicion;
            return query;
        }

        public string GetDelete(string condicion)
        {
            string resultado = "DELETE FROM " + m_szTabla;
            if (condicion.Length != 0)
                resultado += " WHERE " + condicion;
            return  resultado;
        }

        public string this[string campo]
        {
            get
            {
                try
                {
                    return dCampos[campo];
                }
                catch { }
                return "";
            }
            set
            {
                string valor = value == null ? "" : value;
                if (string.IsNullOrEmpty(campo))
                    campo = valor;
                dCampos[campo] = valor;
            }
        }


        // funciones de fecha y hora.
        public static string GetMySQLDateFormat(DateTime fecha)
        {
            return GetMySQLDateFormat(fecha, false);
        }

        public static string GetMySQLDateFormat(DateTime fecha, bool horas)
        {

            if (fecha == null)
                return "";

            string szFecha = fecha.ToString("yyyy-MM-dd");

            if (horas)
            {
                szFecha += fecha.ToString(" HH:mm:ss");
            }
            return szFecha;
        }
        public static string GetMySQLDateFormat(string text)
        {

            return GetMySQLDateFormat(text, false);
        }
        public static string GetMySQLDateFormat(string text, bool horas)
        {
            try
            {
                return GetMySQLDateFormat(Convert.ToDateTime(text), horas);
            }
            catch
            {
            }
            return "";
        }

        public static DateTime GetFromMySQLDate(string fecha)
        {
            try
            {
                return DateTime.ParseExact(fecha, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            }
            catch
            {
            }
            return DateTime.MinValue;
        }

        public static string GetFromMySQLDate(object fecha, bool horas)
        {
            try
            {
                DateTime dFecha;
                if (typeof(MySqlDateTime) == fecha.GetType())
                    dFecha = ((MySqlDateTime)fecha).GetDateTime();
                else dFecha = (DateTime)fecha;
                if (horas)
                    return dFecha.ToShortDateString() + " " + dFecha.Hour.ToString("00") + ":" + dFecha.Minute.ToString("00");
                return dFecha.ToShortDateString();
            }
            catch
            {
            }
            return "";
        }

        public static string GetFromMySQLDate(object fecha)
        {
            return GetFromMySQLDate(fecha, false);
        }

        static public string TryGetCurrency(string valor)
        {
            try
            {
                if (!string.IsNullOrEmpty(valor))
                    return decimal.Parse(valor, NumberStyles.Currency).ToString(CultureInfo.InvariantCulture);
            } catch { }
            return "";
        }

        static public string TryGetDouble(string valor) {
            try
            {
                if (!string.IsNullOrEmpty(valor))
                    return Convert.ToDouble(valor).ToString(CultureInfo.InvariantCulture);
            }
            catch { }
            return "";
        }

        static public string TryGetInt(string valor) {
            try
            {
                if (!string.IsNullOrEmpty(valor))
                    return Convert.ToInt32(valor).ToString();
            } catch { }
            return "";
        }

        static private bool GetKey()
        {
            if (bGetKey)
                return true;
            try
            {
                string[] keys = null;
                string dominio;
                if (HttpContext.Current == null) // es una pagina web
                {
                    if (OperationContext.Current == null)
                        dominio = System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else dominio = OperationContext.Current.IncomingMessageHeaders.To.Host;
                    if (dominio == "localhost")
                        return true;
                } else {
                    if (HttpContext.Current.Request.Url.Host == "localhost")
                        return true;
                    if (string.IsNullOrEmpty(ConfigurationSettings.AppSettings["DomainKey"]))
                        return false;
                    dominio = HttpContext.Current.Request.Url.Host;
                }
                keys = ConfigurationSettings.AppSettings["DomainKey"].Split(';');
                
                for (int i = 0; i < keys.Length; i++)
                {
                    if (Crypt.GetMD5(Crypt.Encriptar3DES(
                        dominio.PadRight(29, 'x').PadRight(37, '?').Replace("x", ";")
                        , "23B9134382220883".Replace("2", "1").Replace("2", "6"))) == keys[i])
                    {
                        bGetKey = true;
                        return true;
                    }
                }
                return false;
            }
            catch { }
            return false;
        }
    }
}
