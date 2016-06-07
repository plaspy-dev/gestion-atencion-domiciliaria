using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.ServiceModel;
using System.Globalization;
using System.Configuration;
using MySql.Data.MySqlClient;
using MySql.Data.Types;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;

namespace SDG.Componentes
{
    public class Conector : IDisposable
    {
        public static event EventHandler MySQLError;
        protected string _LastError;
        public string LastError
        {
            get
            {
                if (string.IsNullOrEmpty(_LastError))
                    return "";
                return _LastError + "<br>" + CurrentQuery;
            }
        }
        public string CurrentQuery { get; protected set; }
        public string ConnectionString { get; protected set; }
        
        protected bool m_bTransaccion = false;
        protected MySqlConnection m_pSQLConector;
        protected MySqlDataReader m_pSQLReader;

        public Conector(string conexionstring)
        {
            // cargamos los valores por defect
            CurrentQuery = "";
            _LastError = "";
            m_pSQLConector = null;
            m_pSQLReader = null;
            ConnectionString = conexionstring;
        }

        ~Conector() {
            CloseAll();
        }

        void IDisposable.Dispose()
        {
            CloseAll();
        }

        public void Dispose() {
            CloseAll();
        }

        public void CloseAll() {
            if (m_bTransaccion)
                RoolBack();
            try
            {
                if (m_pSQLReader != null)
                    m_pSQLReader.Close();
                m_pSQLReader = null;
            }
            catch
            {
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

        public MySqlConnection GetConexion()
        {
            return m_pSQLConector;
        }

        static public string GetCookie(string cookie)
        {
            return GetCookie(cookie, "");
        }

        static public string GetCookie(string cookie, string defecto)
        {
            string valor = defecto;
            if (HttpContext.Current.Request.Cookies[cookie] != null)
                valor = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies[cookie].Value);
            return valor;
        }

        static public int GetCookie(string cookie, int defecto)
        {
            return Convert.ToInt32(GetCookie(cookie, defecto.ToString()));
        }

        static public void SetCookie(string cookie, string valor)
        {
            SetCookie(cookie, valor, DateTime.Now.AddYears(1));
        }

        static public void SetCookie(string cookie, string valor, DateTime expires)
        {
            HttpContext.Current.Response.Cookies[cookie].Value = HttpUtility.UrlEncode(valor);
            HttpContext.Current.Response.Cookies[cookie].Expires = expires;
        }

        public void ShowError(String error)
        {
            string err = DateTime.Now.ToString() + " Error[Conector] : ";
            try
            {
                if (HttpContext.Current == null)
                {
                    if (OperationContext.Current == null)
                        err += System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else err += OperationContext.Current.IncomingMessageHeaders.To.ToString();
                } else err += HttpContext.Current.Request.Url.ToString();
            } catch { }
            err += "\r\n" + _LastError
                + "\r\n" + CurrentQuery
                + "\r\n" + (new StackTrace()).ToString();
            Logs.WriteClassLog(err);
            if (MySQLError != null) {
                MySQLError(this, null);
            }
            try
            {
                Page pagina = (Page)HttpContext.Current.Handler;
                if (pagina != null && pagina.Master != null)
                {

                    Label label = (Label)pagina.Master.FindControl("LMensaje");
                    if (label != null)
                    {
                        label.Text = error;
                    }
                }
            }
            catch  { }
        }

        protected bool IsConect()
        {
            if (m_pSQLConector == null)  // verificamos que la conexion exista
            {
                // solo por guardar compatibilidad con la version anterior 'coneccion'
                string conn = ConnectionString;
                try
                {
                    m_pSQLConector = new MySqlConnection(conn);
                    m_pSQLConector.Open();
                }
                catch (MySqlException ex)
                {
                    _LastError = ex.Message;
                    ShowError(LastError);
                    return false;
                } catch {}
            }
            return true;
        }

        public MySqlDataAdapter QueryAdaptador(string query)
        {
            return new MySqlDataAdapter(query, ConnectionString);
        }

        public int QueryMod(string query, bool identity=false, params object[] args)
        {
            if (args.Length > 0)
                query = string.Format(query, args);
            CurrentQuery = query;
            if (query.IndexOf(" WHERE") == 0)
                return 0;
            int result = 0;
            if (!IsConect())
                return -1;
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
                MySqlCommand command = m_pSQLConector.CreateCommand();
                command.CommandText = query;
                result = command.ExecuteNonQuery();
            }
            catch (MySqlException ex)
            {
                result = -1;
                _LastError = ex.Message;
                ShowError(_LastError + "\nEn la consulta:\n" + query);
            } catch (Exception ex) {
                result = -1;
                _LastError = ex.Message;
                ShowError(_LastError + "\nEn la consulta:\n" + query);
            }
            if (identity && result != -1)
            {
                result = -1;
                if (Query("SELECT LAST_INSERT_ID()") != null)
                {
                    if (m_pSQLReader.Read())
                    {
                        result = Convert.ToInt32(m_pSQLReader[0].ToString());
                    }
                }
            }
            return result;
        }

        public string QueryString(string query, params object[] args)
        {
            if (args.Length > 0)
                query = string.Format(query, args);

            string retorno = null;
            MySqlDataReader data = Query(query);
            if (data != null)
            {
                retorno = "";
                if(data.Read()) {
                    if (data[0].GetType() == typeof(System.Byte[]))
                    {
                        retorno = System.Text.Encoding.UTF8.GetString((byte[])data[0]);
                    } else retorno = data[0].ToString();
                }
            }
            try { data.Close(); } catch { }
            return retorno;
        }

        public MySqlDataReader Query(string query, params object[] args)
        {
            if(args.Length>0)
                query= string.Format(query, args);
            CurrentQuery = query;
            if (!IsConect())
            {
                return null;
            }
            if (query == null || query.Length == 0)
            {
                _LastError = "";
                return null;
            }
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
                MySqlCommand command = m_pSQLConector.CreateCommand();
                command.CommandText = query;
                command.CommandTimeout = 0;
                m_pSQLReader = command.ExecuteReader();
            }
            catch (MySqlException ex)
            {
                m_pSQLReader = null;
                _LastError = ex.Message;
                ShowError(_LastError + "\nEn la consulta:\n" + query);
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

        [System.Obsolete("use new variable LastError")]
        public string GetLastError()
        {
            return LastError;
        }

        public static string GetCondicion(string campo, string dato)
        {
            return GetCondicion(campo, dato, "=");
        }

        public static string GetCondicion(string campo, string dato, string comparador)
        {
            return " WHERE " + campo + " " + comparador + " '" + dato + "'";
        }
        
        static public bool SelectInComboText(DropDownList lista, string texto)
        {
            bool retorno = true;
            if (lista.Items.Count < 2)
                lista.DataBind();
            lista.SelectedIndex = -1;
            ListItem item = lista.Items.FindByText(texto);
            if (item == null)
            {
                retorno = false;
            } else item.Selected = true;
            return retorno;
        }

        
        public static string GetHora(object fecha)
        {
            if (fecha == null || fecha.ToString().Length == 0)
                return "";
            DateTime tiempo = (DateTime)fecha;
            string hora = tiempo.Hour < 10 ? ("0" + tiempo.Hour) : tiempo.Hour.ToString();
            string minutos = tiempo.Minute < 10 ? ("0" + tiempo.Minute) : tiempo.Minute.ToString();
            return hora + ":" + minutos;
        }

        public static string GetDateFormat(string fecha)
        {
            if (fecha.Length == 0 || fecha.Length < 10)
                return "";
            return fecha.Substring(0, 10);
        }


        public static string GetModificacion(string idUsuario, string idDocumento, string id2, string tabla, string url)
        {
            Query query = new Query(tabla);

            query["id"] = idDocumento;
            query["fecha"] = "SYSDATE()";
            query["url"] = url;
            query["usuario"] = idUsuario;
            if(!string.IsNullOrEmpty(id2)) 
                query["id2"] = id2;
            return query.GetInsert();
        }

        public static string GetModificacion(string idUsuario, string idDocumento, string id2, string tabla)
        {
            return GetModificacion(idUsuario, idDocumento, id2,tabla, Usuario.GetCurrentURL());
        }

        public static string GetModificacion(string idUsuario, string idDocumento, string id2)
        {
            return GetModificacion(idUsuario, idDocumento, id2, "modificaciones");
        }

        public int InsertModificacion(string idDocumento, string id2)
        {
            Usuario usuario = Usuario.GetInstance(false);
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, id2));
        }

        public int InsertModificacion(string idDocumento)
        {
            Usuario usuario = Usuario.GetInstance(false);
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, null));
        }
        
        public int InsertModificacion(string idDocumento, string id2, string url)
        {
            Usuario usuario = Usuario.GetInstance(false);
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, id2, "modificaciones", url));
        }

        public int InsertModificacionWeb(string idDocumento)
        {
            Usuario usuario = Usuario.GetInstance(false);
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, null,  "modificacionesweb"));
        }

        public bool SelectInDropDown(DropDownList lista, object valor, string query)
        {
            bool retorno = true;
            try
            {
                if (lista.Items.Count < 2)
                    lista.DataBind();
                lista.SelectedIndex = -1;
                ListItem item = lista.Items.FindByValue(valor.ToString());
                if (item == null)
                {
                    retorno = false;
                    using (Conector conector = new Conector(ConnectionString))
                    {
                        string texto = "";
                        if (query.Length > 0)
                        {
                            if (query.IndexOf("{") != -1 && query.IndexOf("}") != -1)
                                query = String.Format(query, valor);
                            texto = conector.QueryString(query);
                        }
                        item = new ListItem(texto, valor.ToString());
                        lista.Items.Add(item);
                    }
                }
                item.Selected = true;
            } catch { }
            return retorno;
        }
        public bool StartTransaction()
        {
            m_bTransaccion = true;
            return QueryMod("START TRANSACTION;") != -1;
        }

        public bool RoolBack()
        {
            m_bTransaccion = false;
            bool retorno= QueryMod("ROLLBACK;") != -1;
            CloseAll();
            return retorno;
        }

        public bool Commit()
        {
            m_bTransaccion = false;
            bool retorno= QueryMod("COMMIT;") != -1;
            CloseAll();
            return retorno;
        }
    }
}