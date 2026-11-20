using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Globalization;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace SDG.Web.UI.WebControls
{
    [Serializable]
    class SessionState
    {
        [Serializable]
        class Querys
        {
            public int pos;
            public string query;
            public Querys(int pos, string query)
            {
                this.pos = pos;
                this.query = query;
            }
        }

        public ArrayList aCambios= new ArrayList();
        public string szQuery="";
        public DataTable dataTable;

        public SessionState(string owner, string query)
        {
            szQuery = query;
            dataTable = new DataTable();

            Utilidades.GetViewState()["SessionState_" + owner]= this;
            // HttpContext.Current.Session["SessionState_" + owner] = this;
        }

        static public string GetValor(object valor)
        {
            if (valor == null)
                return "NULL";
            if (valor is float)
                return GetValor(((decimal)valor).ToString(CultureInfo.InvariantCulture));
            if(valor is double) 
                return GetValor(((double)valor).ToString(CultureInfo.InvariantCulture));
            if(valor is decimal)
                return GetValor(((decimal)valor).ToString(CultureInfo.InvariantCulture));
            if(valor is DateTime)
                return GetValor(Query.GetMySQLDateFormat((DateTime)valor, true));
            return GetValor(valor.ToString());
        }
        static public string GetValor(string valor)
        {

            /*string fecha = Query.GetMySQLDateFormat(valor, true);
            if (fecha.Length > 0)
                valor = fecha;*/

            if (valor == null || valor.Length == 0)
                return "NULL";
            if (valor == "SYSDATE()")
                return valor;
            if (valor == "True")
                return "true";
            if (valor == "False")
                return "false";
            
            string otro = valor;
            otro = otro.Replace("\\", "\\\\");
            otro = otro.Replace("'", "\\'");
            return "'" + otro + "'";
        }

        public String[] GetQuerys() {

            String[] resultado = new String[aCambios.Count];
            for (int i = 0; i < aCambios.Count; i++ ) {
                resultado[i] = ((Querys)aCambios[i]).query;
            }
            return resultado;
        }

        public bool Aplicar(string conexion)
        {
            if (aCambios.Count == 0)
                return true;
            MySqlConnection pSQLConector;
            try
            {
                pSQLConector = new MySqlConnection(conexion);
                pSQLConector.Open();
            }
            catch (MySqlException ex)
            {
                throw new InvalidOperationException(conexion + ": Error en la consulta", ex);
            }

            for (int i = 0; i < aCambios.Count; i++)
            {
                Querys query = (Querys)aCambios[i];
                try
                {
                    MySqlCommand command = pSQLConector.CreateCommand();
                    command.CommandText = query.query;
                    int result = command.ExecuteNonQuery();
                    if (result == -1)
                        return false;
                }
                catch (MySqlException ex)
                {
                    throw new InvalidOperationException(query.query + ": Error en la consulta", ex);
                }
            }
            return true;
        }

        public bool CleanQuerys(int pos)
        {
            if (pos == -1)
                return false;
            bool retorno = false;
            DataRow row = dataTable.Rows[pos];
            if (row["sqlexists"].ToString().Length==0)
            {
                for (int i = 0; i < aCambios.Count; i++)
                {
                    Querys query = (Querys)aCambios[i];
                    if (query.pos == pos)
                    {
                        aCambios.RemoveAt(i);
                        i--;
                    } else if (query.pos > pos) {
                        query.pos--;
                    }
                }
                retorno = true;
            }
            return retorno;
        }

        public void DeleteRow(int pos)
        {
            DataRow row = dataTable.Rows[pos];
            row.Delete();
        }

        public void AddQuery(string query, int pos)
        {
            aCambios.Add(new Querys(pos, query));
        }

        public static void Clean(string owner)
        {
            Utilidades.GetViewState()["SessionState_" + owner] = null;
            // HttpContext.Current.Session.Remove("SessionState_" + owner);
        }

        public static SessionState Get(string owner)
        {
            SessionState session = (SessionState)Utilidades.GetViewState()["SessionState_" + owner];
            // SessionState session = (SessionState)System.Web.HttpContext.Current.Session["SessionState_" + owner];
            return session;
        }

        public static SessionState Get(string owner, string query)
        {
            SessionState session = (SessionState)Utilidades.GetViewState()["SessionState_" + owner];
            // SessionState session = (SessionState)HttpContext.Current.Session["SessionState_" + owner];
            if (session == null || session.szQuery!=query)
            {
                return null;
            }
            return session;
        }
    }
}
