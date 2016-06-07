using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.UI;
using System.Configuration;

namespace SDG.Componentes
{
    public class ConectorMS : IDisposable
    {
        protected string m_szLastError;
        protected string m_szQuery;
        protected string m_szConexion;
        public bool m_bTransaccion=false;

        protected SqlConnection m_pSQLConector;
        protected SqlDataReader m_pSQLReader;

        public ConectorMS(string conexion)
        {
            // cargamos los valores por defect
            m_szQuery = "";
            m_szLastError = "";
            m_pSQLConector = null;
            m_pSQLReader = null;
            m_szConexion = conexion;
        }

        ~ConectorMS() {
            CloseAll();
        }

        void IDisposable.Dispose()
        {
            CloseAll();
        }

        public void Dispose()
        {
            CloseAll();
        }

        private void CloseAll() {
            if (m_bTransaccion)
                RoolBack();
            try
            {
                if (m_pSQLReader != null)
                    m_pSQLReader.Close();
                m_pSQLReader = null;
            } catch {
            }
            try
            {
                if (m_pSQLConector != null)
                    m_pSQLConector.Close();
                m_pSQLConector = null;
            }
            catch
            {
            }
        }

        public string GetConexionString()
        {
            return m_szConexion;
        }

        public SqlConnection GetConexion()
        {
            return m_pSQLConector;
        }

        public void ShowError(String error) {
#if DEBUG
#else
            string err = DateTime.Now.ToString() + " Error[ConectorMS] : ";
            if (HttpContext.Current == null)
                if (OperationContext.Current == null)
                    err += System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                else err += OperationContext.Current.IncomingMessageHeaders.To.ToString();
            else err += HttpContext.Current.Request.Url.ToString();
            err += "\r\n" + m_szLastError
                + "\r\n" + m_szQuery;

            Logs.WriteLog(err);
#endif
            try {
                Page pagina = (Page)HttpContext.Current.Handler;
                if (pagina != null && pagina.Master != null)
                {
                    Label label = (Label)pagina.Master.FindControl("LMensaje");
                    if (label != null)
                    {
                        label.Text = error;
                    }
                }
            } catch { }
        }

        protected bool IsConect()
        {
            if (m_pSQLConector == null)  // verificamos que la conexion exista
            {
                // solo por guardar compatibilidad con la version anterior 'coneccion'
                string conn = m_szConexion;
                try
                {
                    m_pSQLConector = new SqlConnection(conn);
                    m_pSQLConector.Open();
                }
                catch (SqlException ex)
                {
                    m_szLastError = ex.Message;
                    ShowError(m_szLastError);
                    return false;
                }
                catch { }
            }
            return true;
        }

        public SqlDataAdapter QueryAdaptador(string query)
        {
            return new SqlDataAdapter(query, m_szConexion);
        }

        public int QueryMod(string query)
        {
            return QueryMod(query, false);
        }

        public int QueryMod(string query, bool identity)
        {
            m_szQuery = query;
            if (query.IndexOf(" WHERE") == 0)
                return 0;
            int result = 0;
            if (!IsConect())
                return -1;
            try {
                if (m_pSQLReader != null)
                {
                    m_pSQLReader.Close();
                    m_pSQLReader = null;
                }
            }
            catch
            {
            }
            try
            {
                SqlCommand command = m_pSQLConector.CreateCommand();
                command.CommandText = query;
                result = command.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                result = -1;
                m_szLastError = ex.Message;
                ShowError(m_szLastError + "\nEn la consulta:\n"+ query);
            } catch (Exception ex)
            {
                result = -1;
                m_szLastError = ex.Message;
                ShowError(m_szLastError + "\nEn la consulta:\n" + query);
            }
            if (identity && result != -1)
            {
                result = -1;
                if (Query("SELECT @@IDENTITY") != null)
                {
                    if (m_pSQLReader.Read())
                    {
                        result = Convert.ToInt32(m_pSQLReader[0].ToString());
                    }
                }
            }
            return result;
        }

        public string QueryString(string query)
        {
            SqlDataReader data = Query(query);
            string retorno = "";
            if (data != null && data.Read())
            {
                if (data[0].GetType() == typeof(System.Byte[]))
                {
                    retorno = System.Text.Encoding.UTF8.GetString((byte[])data[0]);
                }
                else
                    retorno = data[0].ToString();
            }
            try {
                data.Close();
            }
            catch
            {
            }
            return retorno;
        }

        public SqlDataReader Query(string query)
        {
            return Query(query, false);
        }

        public SqlDataReader Query(string query, bool reset)
        {
            if (!IsConect())
            {
                return null;
            }
            if (query == null || query.Length == 0) {
                m_szLastError = "";
                return null;
            }
            m_szQuery = query;
            try
            {
                if (m_pSQLReader != null)
                {
                    m_pSQLReader.Close();
                    m_pSQLReader = null;
                }
            } catch {}
            try
            {
                SqlCommand command = m_pSQLConector.CreateCommand();
                command.CommandText = query;
	        command.CommandTimeout=0;
                m_pSQLReader = command.ExecuteReader();
            }
            catch (SqlException ex)
            {
                m_pSQLReader = null;
                m_szLastError = ex.Message;
                ShowError(m_szLastError + "\nEn la consulta:\n" + query);
            }
            catch { }
            return m_pSQLReader;
        }

        public int GetColCount()
        {
            if (m_pSQLReader == null)
                return 0;
            return m_pSQLReader.FieldCount;
        }

        public string GetLastError()
        {
            if (m_szLastError.Length == 0)
                return "";
            return m_szLastError + "<br>" + m_szQuery;
        }

        public static string GetCondicion(string campo, string dato)
        {
            return GetCondicion(campo, dato, "=");
        }

        public static string GetCondicion(string campo, string dato, string comparador)
        {
            return " WHERE " + campo + " " + comparador + " '" + dato + "'";
        }
        public static string GetDate(object fecha)
        {
            if (fecha == null || fecha.ToString().Length == 0)
                return "";
            DateTime tiempo = (DateTime)fecha;
            string mes= tiempo.Month<10 ? ("0" + tiempo.Month) : tiempo.Month.ToString();
            string dia = tiempo.Day < 10 ? ("0" + tiempo.Day) : tiempo.Day.ToString();
            return dia + "/" + mes + "/" + tiempo.Year;
        }
        public static string GetDateFormat(string fecha) {
            if(fecha.Length==0 || fecha.Length<10) 
                return "";
            return fecha.Substring(0, 10);
        }
        
        public bool SelectInDropDown(DropDownList lista, object valor) {

            return new ConectorMS("").SelectInDropDown(lista, valor, "");
        }

        public bool SelectInDropDown(DropDownList lista, object valor, string query) {

            bool retorno=true;
            if (lista.Items.Count < 2)
                lista.DataBind();
            lista.SelectedIndex = -1;
            ListItem item = lista.Items.FindByValue(valor.ToString());
            if (item == null)
            {
                ConectorMS conector = new ConectorMS(m_szConexion);
                string texto = "";
                if(query.Length>0) {
                    if (query.IndexOf("{") != -1 && query.IndexOf("}") != -1)
                        query = String.Format(query, valor);
                    texto= conector.QueryString(query);
                }
                item = new ListItem(texto, valor.ToString());
                lista.Items.Add(item);
                retorno = false;
            }
            item.Selected = true;
            return retorno;
        }

        public bool StartTransaction() {
            m_bTransaccion = true;
            return QueryMod("BEGIN TRANSACTION;")!=-1;
        }

        public bool RoolBack() {
            m_bTransaccion = false;
            bool retorno= QueryMod("ROLLBACK") != -1;
            CloseAll();
            return retorno;
        }

        public bool Commit() {
            m_bTransaccion = false;
            bool retorno = QueryMod("COMMIT;") != -1;
            CloseAll();
            return retorno;
        }
    }
}
