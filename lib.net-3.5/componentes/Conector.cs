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

namespace SDG.Componentes
{
    public class Conector : IDisposable
    {
        private static bool bGetKey = false;
        protected string m_szLastError;
        protected string m_szQuery;
        protected string m_szConexion;
        protected bool m_bTransaccion = false;

        protected MySqlConnection m_pSQLConector;
        protected MySqlDataReader m_pSQLReader;

        public Conector(string conexionstring)
        {
            // cargamos los valores por defect
            m_szQuery = "";
            m_szLastError = "";
            m_pSQLConector = null;
            m_pSQLReader = null;
            m_szConexion = conexionstring;
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

        public string GetConexionString() {
            
            return m_szConexion;
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
            err+= "\r\n" + m_szLastError
                + "\r\n" + m_szQuery;
            Logs.WriteLog(err);
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
            if (m_pSQLConector == null && GetKey())  // verificamos que la conexion exista
            {
                // solo por guardar compatibilidad con la version anterior 'coneccion'
                string conn = m_szConexion;
                try
                {
                    m_pSQLConector = new MySqlConnection(conn);
                    m_pSQLConector.Open();
                }
                catch (MySqlException ex)
                {
                    m_szLastError = ex.Message;
                    ShowError(m_szLastError);
                    return false;
                } catch {}
            }
            return true;
        }

        public MySqlDataAdapter QueryAdaptador(string query)
        {
            return new MySqlDataAdapter(query, m_szConexion);
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
                m_szLastError = ex.Message;
                ShowError(m_szLastError + "\nEn la consulta:\n" + query);
            } catch (Exception ex) {
                result = -1;
                m_szLastError = ex.Message;
                ShowError(m_szLastError + "\nEn la consulta:\n" + query);
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

        public string QueryString(string query)
        {
            MySqlDataReader data = Query(query);
            string retorno = "";
            if (data != null && data.Read())
            {
                if (data[0].GetType() == typeof(System.Byte[]))
                {
                    retorno = System.Text.Encoding.UTF8.GetString((byte [])data[0]);
                } else 
                    retorno = data[0].ToString();
            }
            try
            {
                data.Close();
            }
            catch
            {
            }
            return retorno;
        }

        public MySqlDataReader Query(string query)
        {
            return Query(query, false);
        }

        public MySqlDataReader Query(string query, bool reset)
        {
            if (!IsConect())
            {
                return null;
            }
            if (query == null || query.Length == 0)
            {
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
                MySqlCommand command = m_pSQLConector.CreateCommand();
                command.CommandText = query;
                command.CommandTimeout = 0;
                m_pSQLReader = command.ExecuteReader();
            }
            catch (MySqlException ex)
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
            return GetModificacion(idUsuario, idDocumento, id2,tabla, HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~"));
        }

        public static string GetModificacion(string idUsuario, string idDocumento, string id2)
        {
            return GetModificacion(idUsuario, idDocumento, id2, "modificaciones");
        }

        public int InsertModificacion(string idDocumento, string id2)
        {
            Usuario usuario = Usuario.GetUsuario();
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, id2));
        }

        public int InsertModificacion(string idDocumento)
        {
            Usuario usuario = Usuario.GetUsuario();
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, null));
        }
        
        public int InsertModificacion(string idDocumento, string id2, string url)
        {
            Usuario usuario = Usuario.GetUsuario();
            return QueryMod(GetModificacion(usuario.GetID(), idDocumento, id2, "modificaciones", url));
        }

        public int InsertModificacionWeb(string idDocumento)
        {
            Usuario usuario = Usuario.GetUsuario();
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
                    using (Conector conector = new Conector(m_szConexion))
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

        static private bool GetKey()
        {
            if (bGetKey)
                return true;
            try {
                string[] keys = null;
                string dominio;
                
                if (HttpContext.Current == null) // es una pagina web
                {
                    if (OperationContext.Current == null)
                        dominio = System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else dominio = OperationContext.Current.IncomingMessageHeaders.To.Host;
                    if (dominio == "localhost")
                        return true;
                }
                else
                {
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
            } catch {}
            return false;
        }
    }
}