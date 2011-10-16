using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace componentes;

public class ConectorMS
{
	protected string m_szLastError;

	protected string m_szQuery;

	protected string m_szConexion;

	protected SqlConnection m_pSQLConector;

	protected SqlDataReader m_pSQLReader;

	public ConectorMS(string conexion)
	{
		m_szQuery = "";
		m_szLastError = "";
		m_pSQLConector = null;
		m_pSQLReader = null;
		m_szConexion = conexion;
	}

	~ConectorMS()
	{
		try
		{
			if (m_pSQLReader != null)
			{
				m_pSQLReader.Close();
			}
			if (m_pSQLConector != null)
			{
				m_pSQLConector.Close();
			}
		}
		catch (SqlException)
		{
		}
		catch (Exception)
		{
		}
	}

	public SqlConnection GetConexion()
	{
		return m_pSQLConector;
	}

	public static string GetCookie(string cookie)
	{
		return GetCookie(cookie, "");
	}

	public static string GetCookie(string cookie, string defecto)
	{
		string result = defecto;
		if (HttpContext.Current.Request.Cookies[cookie] != null)
		{
			result = HttpContext.Current.Request.Cookies[cookie].Value.Replace("%%", " ");
		}
		return result;
	}

	public static int GetCookie(string cookie, int defecto)
	{
		return Convert.ToInt32(GetCookie(cookie, defecto.ToString()));
	}

	public static void SetCookie(string cookie, string valor)
	{
		HttpContext.Current.Response.Cookies[cookie].Value = valor.Replace(" ", "%%");
		HttpContext.Current.Response.Cookies[cookie].Expires = DateTime.Now.AddYears(1);
	}

	public void ShowError(string error)
	{
		Page page = (Page)HttpContext.Current.Handler;
		if (page != null && page.Master != null)
		{
			Label label = (Label)page.Master.FindControl("LMensaje");
			if (label != null)
			{
				label.Text = error;
			}
		}
	}

	protected bool IsConect()
	{
		if (m_pSQLConector == null)
		{
			string szConexion = m_szConexion;
			try
			{
				m_pSQLConector = new SqlConnection(szConexion);
				m_pSQLConector.Open();
			}
			catch (SqlException ex)
			{
				m_szLastError = ex.Message;
				ShowError(m_szLastError);
				return false;
			}
		}
		return true;
	}

	public SqlDataAdapter QueryAdaptador(string query)
	{
		return new SqlDataAdapter(query, m_szConexion);
	}

	public int QueryMod(string query)
	{
		return QueryMod(query, identity: false);
	}

	public int QueryMod(string query, bool identity)
	{
		m_szQuery = query;
		if (query.IndexOf(" WHERE") == 0)
		{
			return 0;
		}
		int num = 0;
		if (!IsConect())
		{
			return -1;
		}
		if (m_pSQLReader != null)
		{
			m_pSQLReader.Close();
			m_pSQLReader = null;
		}
		try
		{
			SqlCommand sqlCommand = m_pSQLConector.CreateCommand();
			sqlCommand.CommandText = query;
			num = sqlCommand.ExecuteNonQuery();
		}
		catch (SqlException ex)
		{
			num = -1;
			m_szLastError = ex.Message;
			ShowError(m_szLastError + "\nEn la consulta:\n" + query);
		}
		if (identity && num != -1)
		{
			num = -1;
			if (Query("SELECT @@IDENTITY") != null && m_pSQLReader.Read())
			{
				num = Convert.ToInt32(m_pSQLReader[0].ToString());
			}
		}
		return num;
	}

	public string QueryString(string query)
	{
		SqlDataReader sqlDataReader = Query(query);
		string result = "";
		if (sqlDataReader != null && sqlDataReader.Read())
		{
			result = sqlDataReader[0].ToString();
		}
		return result;
	}

	public SqlDataReader Query(string query)
	{
		return Query(query, reset: false);
	}

	public SqlDataReader Query(string query, bool reset)
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
		if (m_pSQLReader != null)
		{
			m_pSQLReader.Close();
			m_pSQLReader = null;
		}
		try
		{
			SqlCommand sqlCommand = m_pSQLConector.CreateCommand();
			sqlCommand.CommandText = query;
			sqlCommand.CommandTimeout = 0;
			m_pSQLReader = sqlCommand.ExecuteReader();
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
		{
			return 0;
		}
		return m_pSQLReader.FieldCount;
	}

	public string GetLastError()
	{
		if (m_szLastError.Length == 0)
		{
			return "";
		}
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
		{
			return "";
		}
		DateTime dateTime = (DateTime)fecha;
		string text = ((dateTime.Month < 10) ? ("0" + dateTime.Month) : dateTime.Month.ToString());
		string text2 = ((dateTime.Day < 10) ? ("0" + dateTime.Day) : dateTime.Day.ToString());
		return text2 + "/" + text + "/" + dateTime.Year;
	}

	public static string GetDateFormat(string fecha)
	{
		if (fecha.Length == 0 || fecha.Length < 10)
		{
			return "";
		}
		return fecha.Substring(0, 10);
	}

	public bool SelectInDropDown(DropDownList lista, object valor, string query)
	{
		bool result = true;
		lista.DataBind();
		lista.SelectedIndex = -1;
		ListItem listItem = lista.Items.FindByValue(valor.ToString());
		if (listItem == null)
		{
			ConectorMS conectorMS = new ConectorMS(m_szConexion);
			listItem = new ListItem(conectorMS.QueryString(query), valor.ToString());
			lista.Items.Add(listItem);
			result = false;
		}
		listItem.Selected = true;
		return result;
	}
}
