using System;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;

public class CConector
{
    protected string m_szLastError;
    protected string m_szQuery;

    protected MySqlConnection m_pSQLConector;
    protected MySqlDataReader m_pSQLReader;

    public CConector()
    {
        // cargamos los valores por defect
        m_szQuery = "";
        m_szLastError = "";
        m_pSQLConector = null;
        m_pSQLReader = null;
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
            valor = HttpContext.Current.Request.Cookies[cookie].Value.Replace("%%", " ");
        return valor;
    }

    static public int GetCookie(string cookie, int defecto)
    {
        return Convert.ToInt32(GetCookie(cookie, defecto.ToString()));
    }

    static public void SetCookie(string cookie, string valor)
    {
        HttpContext.Current.Response.Cookies[cookie].Value = valor.Replace(" ", "%%");
        HttpContext.Current.Response.Cookies[cookie].Expires = DateTime.Now.AddYears(1);
    }
    
    public void ShowError(String error)
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

    protected bool IsConect()
    {
        if (m_pSQLConector == null)  // verificamos que la conexion exista
        {
            // solo por guardar compatibilidad con la version anterior 'coneccion'
            string conn = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;
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
            }
            return true;
        }
        return true;
    }

    public MySqlDataAdapter QueryAdaptador(string query)
    {
        return new MySqlDataAdapter(query, ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString);
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
        if (m_pSQLReader != null)
        {
            m_pSQLReader.Close();
            m_pSQLReader = null;
        }
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
            retorno = data[0].ToString();
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
        if (query == null || query.Length == 0) {
            m_szLastError = "";
            return null;
        }
        m_szQuery = query;
        if (m_pSQLReader != null)
        {
            m_pSQLReader.Close();
            m_pSQLReader = null;
        }
        try
        {
            MySqlCommand command = m_pSQLConector.CreateCommand();
            command.CommandText = query;
	    command.CommandTimeout=0;
            m_pSQLReader = command.ExecuteReader();
        }
        catch (MySqlException ex)
        {
            m_pSQLReader = null;
            m_szLastError = ex.Message;
            ShowError(m_szLastError + "\nEn la consulta:\n" + query);
        }
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

    static public CConector GetConector()
    {
        if (HttpContext.Current.Session["Conector"] == null)
        {
            CConector conector = new CConector();
            HttpContext.Current.Session["Conector"] = conector;
        }
        return (CConector)HttpContext.Current.Session["Conector"];
    }
    public void FillComboBox(DropDownList lista, string query)
    {
        lista.Items.Add(new ListItem("(Ninguno)", "-1"));
        if (query == null || query.Length == 0)
            return;
        MySqlDataReader reader = Query(query);
        if (reader != null)
        {
            while (reader.Read())
            {
                lista.Items.Add(new ListItem(reader[1].ToString(), reader[0].ToString()));
            }
        }
    }
    static public void SelectInCombo(DropDownList lista, string value)
    {
        ListItem item = lista.Items.FindByValue(value);
        lista.SelectedIndex = item == null ? 0 : lista.Items.IndexOf(item);
    }
    static public void SelectInComboText(DropDownList lista, string value)
    {
        ListItem item = lista.Items.FindByText(value);
        lista.SelectedIndex = item == null ? 0 : lista.Items.IndexOf(item);
    }
    public static string GetDate(object fecha)
    {
        if (fecha == null || fecha.ToString().Length == 0)
            return "";
        DateTime tiempo = (DateTime)fecha;
        string mes= tiempo.Month<10 ? ("0" + tiempo.Month) : tiempo.Month.ToString();
        string dia = tiempo.Day < 10 ? ("0" + tiempo.Day) : tiempo.Day.ToString();
        return tiempo.Year + "-" + mes + "-" + dia;
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

    public static string GetDateFormat(string fecha) {
        if(fecha.Length==0 || fecha.Length<10) 
            return "";
        return fecha.Substring(0, 10);
    }

    public static string GetModificacion(string idUsuario, string idDocumento)
    {
        CQuery query = new CQuery("modificaciones");
        
        query["id"] = idDocumento;
        query["fecha"]= "SYSDATE()";
        string url = HttpContext.Current.Request.Url.AbsolutePath.Replace(HttpContext.Current.Request.ApplicationPath, "~");
        query["url"] = url;
        query["usuario"] = idUsuario;
        return query.GetInsert();
    }
    
    public int InsertModificacion(string idDocumento)
    {
        CUsuario usuario = CUsuario.GetUsuario();
        return QueryMod(GetModificacion(usuario.GetID(), idDocumento));
    }
}
