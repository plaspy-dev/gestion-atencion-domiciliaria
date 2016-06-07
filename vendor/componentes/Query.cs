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
using System.Threading;

namespace SDG.Componentes
{
    [Serializable]
    public class Query
    {
        public Dictionary<string, string> Fields { get; set; }
        protected Dictionary<string, bool> dQuoted;
        public static List<string> Functions = new List<string>() { "sysdate()", "getdate()", "now()" };
        public static List<string> ReservedWords = new List<string> { "generated" };

        public string TableName { get; set; }
        public int Count {
            get {
                return Fields.Count;
            }
        }

        public Query(string tabla)
        {
            TableName = tabla;
            Fields = new Dictionary<string, string>();
            dQuoted = new Dictionary<string, bool>();
        }
        
        public static Query operator +(Query query, string valor)
        {
            query[""] = valor;
            return query;
        }

        public static Query operator -(Query query, string valor)
        {
            query.RemoveCampo(valor);
            return query;
        }

        public void AddCampo(string campo, string valor, bool quotes)
        {
            Fields[campo] = valor;
            if (quotes)
                dQuoted.Remove(campo);
            else dQuoted[campo] = false;
        }

        public void RemoveCampo(string campo) {
            try
            {
                Fields.Remove(campo);
                dQuoted.Remove(campo);
            } catch { }
        }

        public void Clean()
        {
            Fields.Clear();
            dQuoted.Clear();
        }

        static public string GetValor(object value)
        {
            string valor=null;
            if (value is string) { valor = (string)value; }
            else if (value is float) {
                valor = ((float)value).ToString(CultureInfo.InvariantCulture);
            } else if (value is double) {
                valor = ((double)value).ToString(CultureInfo.InvariantCulture);
            } else if (value is decimal) {
                valor = ((decimal)value).ToString(CultureInfo.InvariantCulture);
            } else if (value is DateTime) {
                valor = Query.GetMySQLDateFormat((DateTime)value, true);
            } else if(value!= null) {
                valor= value.ToString();
            }

            if (string.IsNullOrEmpty(valor))
                return "NULL";
            if (Functions.Contains(valor.ToLower()))
                return valor;
            return string.Format("'{0}'", valor
                .Replace("\\", "\\\\")
                .Replace("'", "\\'"));
        }

        public static string GetColumnName(string columName) {

            if (ReservedWords.Contains(columName.ToLower()))
                return string.Format("`{0}`", columName);
            return columName;
        }

        public string GetUpdate(string condicion, params object[] args)
        {
            if(Fields.Count==0)
                return "";

            if (args.Length > 0)
                condicion = string.Format(condicion, args);

            string query;
            string valor;

            query = "UPDATE " + TableName + " SET ";
            
            bool first=false;
            foreach (KeyValuePair<string, string> campo in Fields) { 
                
                if(first)
                    query+=",";
                else first=true;
                bool quoted= true;
                try {
                     quoted= dQuoted[campo.Key];
                } catch {}
                
                valor= quoted ? GetValor(campo.Value) : campo.Value;
                query+= GetColumnName(campo.Key) + "="+ valor;
            }

            if (condicion.Length != 0)
                query += " WHERE " + condicion;
            return query;
        }

        public string GetInsertUpdate() {

            string query = GetInsert();
            query += " ON DUPLICATE KEY UPDATE ";

            string valor;
            bool first = false;

            foreach (KeyValuePair<string, string> campo in Fields)
            {
                if (first)
                    query += ",";
                else first = true;
                bool quoted = true;
                try
                {
                    quoted = dQuoted[campo.Key];
                } catch { }

                valor = quoted ? GetValor(campo.Value) : campo.Value;
                query += GetColumnName(campo.Key) + "=" + valor;
            }
            return query;
        }

        public string GetInsert(bool replace=false)
        {
            if (Fields.Count == 0)
                return "";
            string query;

            query = (replace ? "REPLACE INTO " : "INSERT INTO ") + TableName + " (";

            bool first=false;
            foreach (KeyValuePair<string, string> campo in Fields)
            {
                if (first)
                    query += ",";
                else first = true;
                query += GetColumnName(campo.Key);
            }

            query += ") VALUES (";
            first=false;
            foreach (KeyValuePair<string, string> campo in Fields)
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

            query += ")";
            return query;
        }

        public string GetSelect(string condicion, string join=null, params object[] args)
        {
            if (Fields.Count == 0)
                return "";

            if (args.Length > 0)
                condicion = string.Format(condicion, args);

            string query = "SELECT ";

            bool first=false;
            foreach (KeyValuePair<string, string> campo in Fields)
            {
                if (first)
                    query += ",";
                else first = true;
                query += GetColumnName(campo.Value);
                if (campo.Value != campo.Key)
                    query += " AS '" + campo.Key + "'";
            }

            query += " FROM " + TableName + " ";
            query += join + " ";
            if (condicion.Length != 0)
                query += " WHERE " + condicion;
            return query;
        }

        public string GetDelete(string condicion, params object[] args)
        {
            if (args.Length > 0)
                condicion = string.Format(condicion, args);

            string resultado = "DELETE FROM " + TableName;
            if (condicion.Length != 0)
                resultado += " WHERE " + condicion;
            return  resultado;
        }

        public object this[string campo]
        {
            get
            {
                try
                {
                    return Fields[campo];
                } catch { }
                return "";
            }
            set
            {
                string valor = value == null ? "" : value.ToString();
                if (string.IsNullOrEmpty(campo))
                    campo = valor;
                else {
                    if (value is float) {
                        valor= ((float)value).ToString(CultureInfo.InvariantCulture);
                    } else if(value is double) {
                        valor = ((double)value).ToString(CultureInfo.InvariantCulture);
                    } else if (value is decimal) {
                        valor = ((decimal)value).ToString(CultureInfo.InvariantCulture);
                    } else if (value is DateTime) {
                        valor = Query.GetMySQLDateFormat((DateTime)value, true);
                    }
                }
                Fields[campo] = valor;
            }
        }

        // funciones de fecha y hora.
        public static string GetMySQLDateFormat(DateTime fecha, bool horas=false)
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

        public static string GetMySQLDateFormat(string text, bool horas=false)
        {
            try
            {
                if (!string.IsNullOrEmpty(text))
                    return GetMySQLDateFormat(DateTime.Parse(text, CultureInfo.GetCultureInfo("es-CO")), horas);
            }
            catch
            {
                Logs.WriteClassLog(text);
            }
            return "";
        }

        public static DateTime GetFromMySQLDate(string fecha)
        {
            try {
                if (!string.IsNullOrEmpty(fecha) && fecha.Length > 18)
                    return DateTime.Parse(fecha, null, DateTimeStyles.RoundtripKind);
            } catch { }
            try {
                if (!string.IsNullOrEmpty(fecha) && fecha.Length > 18)
                    return DateTime.ParseExact(fecha.Substring(0, 19), "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            } catch { }
            try
            {
                if (!string.IsNullOrEmpty(fecha) && fecha.Length > 15)
                    return DateTime.ParseExact(fecha.Substring(0, 16), "yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture);
            } catch { }
            try {
                if (!string.IsNullOrEmpty(fecha) && fecha.Length==10)
                    return DateTime.ParseExact(fecha, "yyyy-MM-dd", CultureInfo.InvariantCulture);
            } catch {}
            Logs.WriteClassLog(fecha);
            return DateTime.MinValue;
        }

        public static string GetFromMySQLDate(object fecha, bool horas=false, bool segundos=false)
        {
            try
            {
                DateTime dFecha;
                if (typeof(MySqlDateTime) == fecha.GetType())
                    dFecha = ((MySqlDateTime)fecha).GetDateTime();
                /*else if (fecha is string)
                    dFecha = DateTime.Parse((string)fecha, CultureInfo.GetCultureInfo("es-CO"));*/
                else dFecha = (DateTime)fecha;

                string dateFormat = "MM/dd/yyyy";
                if (Thread.CurrentThread.CurrentCulture.Name.ToLower().StartsWith("es"))
                    dateFormat = "dd/MM/yyyy";

                if (horas)
                    return dFecha.ToString(dateFormat + " HH:mm" + (segundos ? ":ss" : ""));
                return dFecha.ToString(dateFormat);
            } catch {
            }
            return "";
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
    }
}
