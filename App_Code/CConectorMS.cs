using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.UI;

/// <summary>
/// Descripción breve de CConectorMS
/// </summary>
public class CConectorMS
{
	protected string m_szLastError;
    protected string m_szQuery;

    protected SqlConnection m_pSQLConector;
    protected SqlDataReader m_pSQLReader;

    public CConectorMS()
    {
        // cargamos los valores por defect
        m_szQuery = "";
        m_szLastError = "";
        m_pSQLConector = null;
        m_pSQLReader = null;
    }

    public SqlConnection GetConexion()
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

    public void ShowError(String error) {

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
            string conn = ConfigurationManager.ConnectionStrings["connBD"].ConnectionString;
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
            return true;
        }
        return true;
    }

    public SqlDataAdapter QueryAdaptador(string query)
    {
        return new SqlDataAdapter(query, ConfigurationManager.ConnectionStrings["connBD"].ConnectionString);
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
            SqlCommand command = m_pSQLConector.CreateCommand();
            command.CommandText = query;
            result = command.ExecuteNonQuery();
        }
        catch (SqlException ex)
        {
            result = -1;
            m_szLastError = ex.Message;
            ShowError(m_szLastError + "\nEn la consulta:\n"+ query);
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
        SqlDataReader data = Query(query);
        string retorno = "";
        if (data != null && data.Read())
        {
            retorno = data[0].ToString();
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
        if (m_pSQLReader != null)
        {
            m_pSQLReader.Close();
            m_pSQLReader = null;
        }
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

    static public CConectorMS GetConector()
    {

        if (HttpContext.Current.Session["ConectorMS"] == null)
        {
            CConectorMS conector = new CConectorMS();
            HttpContext.Current.Session["ConectorMS"] = conector;
        }
        return (CConectorMS)HttpContext.Current.Session["ConectorMS"];
    }
    public void FillComboBox(DropDownList lista, string query)
    {
        lista.Items.Add(new ListItem("(Ninguno)", "-1"));
        if (query == null || query.Length == 0)
            return;
        SqlDataReader reader = Query(query);
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
        return dia + "/" + mes + "/" + tiempo.Year;
    }
    public static string GetDateFormat(string fecha) {
        if(fecha.Length==0 || fecha.Length<10) 
            return "";
        return fecha.Substring(0, 10);
    }
}
