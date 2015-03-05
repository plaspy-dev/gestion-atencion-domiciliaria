using System;
using System.IO;
using System.Reflection;
using System.ServiceModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace SDG.Componentes;

public class Conector : IDisposable
{
	protected string _LastError;

	protected bool m_bTransaccion;

	protected MySqlConnection m_pSQLConector;

	protected MySqlDataReader m_pSQLReader;

	public string LastError
	{
		get
		{
			if (string.IsNullOrEmpty(_LastError))
			{
				return "";
			}
			return _LastError + "<br>" + CurrentQuery;
		}
	}

	public string CurrentQuery { get; protected set; }

	public string ConnectionString { get; protected set; }

	public Conector(string conexionstring)
	{
		CurrentQuery = "";
		_LastError = "";
		m_pSQLConector = null;
		m_pSQLReader = null;
		ConnectionString = conexionstring;
	}

	~Conector()
	{
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

	public void CloseAll()
	{
		if (m_bTransaccion)
		{
			RoolBack();
		}
		try
		{
			if (m_pSQLReader != null)
			{
				m_pSQLReader.Close();
			}
			m_pSQLReader = null;
		}
		catch
		{
		}
		try
		{
			if (m_pSQLConector != null)
			{
				m_pSQLConector.Close();
			}
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

	public static string GetCookie(string cookie)
	{
		return GetCookie(cookie, "");
	}

	public static string GetCookie(string cookie, string defecto)
	{
		string result = defecto;
		if (HttpContext.Current.Request.Cookies[cookie] != null)
		{
			result = HttpUtility.UrlDecode(HttpContext.Current.Request.Cookies[cookie].Value);
		}
		return result;
	}

	public static int GetCookie(string cookie, int defecto)
	{
		return Convert.ToInt32(GetCookie(cookie, defecto.ToString()));
	}

	public static void SetCookie(string cookie, string valor)
	{
		SetCookie(cookie, valor, DateTime.Now.AddYears(1));
	}

	public static void SetCookie(string cookie, string valor, DateTime expires)
	{
		HttpContext.Current.Response.Cookies[cookie].Value = HttpUtility.UrlEncode(valor);
		HttpContext.Current.Response.Cookies[cookie].Expires = expires;
	}

	public void ShowError(string error)
	{
		string text = DateTime.Now.ToString() + " Error[Conector] : ";
		try
		{
			text = ((HttpContext.Current != null) ? (text + HttpContext.Current.Request.Url.ToString()) : ((OperationContext.Current != null) ? (text + OperationContext.Current.IncomingMessageHeaders.To.ToString()) : (text + Path.GetFileName(Assembly.GetEntryAssembly().Location))));
		}
		catch
		{
		}
		string text2 = text;
		text = text2 + "\r\n" + _LastError + "\r\n" + CurrentQuery;
		Logs.WriteClassLog(text);
		try
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
		catch
		{
		}
	}

	protected bool IsConect()
	{
		if (m_pSQLConector == null)
		{
			string connectionString = ConnectionString;
			try
			{
				m_pSQLConector = new MySqlConnection(connectionString);
				m_pSQLConector.Open();
			}
			catch (MySqlException ex)
			{
				_LastError = ex.Message;
				ShowError(LastError);
				return false;
			}
			catch
			{
			}
		}
		return true;
	}

	public MySqlDataAdapter QueryAdaptador(string query)
	{
		return new MySqlDataAdapter(query, ConnectionString);
	}

	public int QueryMod(string query, params object[] args)
	{
		return QueryMod(query, identity: false, args);
	}

	public int QueryMod(string query, bool identity, params object[] args)
	{
		if (args.Length > 0)
		{
			query = string.Format(query, args);
		}
		CurrentQuery = query;
		if (query.IndexOf(" WHERE") == 0)
		{
			return 0;
		}
		int num = 0;
		if (!IsConect())
		{
			return -1;
		}
		try
		{
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
			MySqlCommand mySqlCommand = m_pSQLConector.CreateCommand();
			mySqlCommand.CommandText = query;
			num = mySqlCommand.ExecuteNonQuery();
		}
		catch (MySqlException ex)
		{
			num = -1;
			_LastError = ex.Message;
			ShowError(_LastError + "\nEn la consulta:\n" + query);
		}
		catch (Exception ex2)
		{
			num = -1;
			_LastError = ex2.Message;
			ShowError(_LastError + "\nEn la consulta:\n" + query);
		}
		if (identity && num != -1)
		{
			num = -1;
			if (Query("SELECT LAST_INSERT_ID()") != null && m_pSQLReader.Read())
			{
				num = Convert.ToInt32(m_pSQLReader[0].ToString());
			}
		}
		return num;
	}

	public string QueryString(string query, params object[] args)
	{
		if (args.Length > 0)
		{
			query = string.Format(query, args);
		}
		MySqlDataReader mySqlDataReader = Query(query);
		string result = "";
		if (mySqlDataReader != null && mySqlDataReader.Read())
		{
			result = ((!(mySqlDataReader[0].GetType() == typeof(byte[]))) ? mySqlDataReader[0].ToString() : Encoding.UTF8.GetString((byte[])mySqlDataReader[0]));
		}
		try
		{
			mySqlDataReader.Close();
		}
		catch
		{
		}
		return result;
	}

	public MySqlDataReader Query(string query, params object[] args)
	{
		if (args.Length > 0)
		{
			query = string.Format(query, args);
		}
		if (!IsConect())
		{
			return null;
		}
		if (query == null || query.Length == 0)
		{
			_LastError = "";
			return null;
		}
		CurrentQuery = query;
		try
		{
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
			MySqlCommand mySqlCommand = m_pSQLConector.CreateCommand();
			mySqlCommand.CommandText = query;
			mySqlCommand.CommandTimeout = 0;
			m_pSQLReader = mySqlCommand.ExecuteReader();
		}
		catch (MySqlException ex)
		{
			m_pSQLReader = null;
			_LastError = ex.Message;
			ShowError(_LastError + "\nEn la consulta:\n" + query);
		}
		catch
		{
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

	[Obsolete("use new variable LastError")]
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

	public static bool SelectInComboText(DropDownList lista, string texto)
	{
		bool result = true;
		if (lista.Items.Count < 2)
		{
			lista.DataBind();
		}
		lista.SelectedIndex = -1;
		ListItem listItem = lista.Items.FindByText(texto);
		if (listItem == null)
		{
			result = false;
		}
		else
		{
			listItem.Selected = true;
		}
		return result;
	}

	public static string GetHora(object fecha)
	{
		if (fecha == null || fecha.ToString().Length == 0)
		{
			return "";
		}
		DateTime dateTime = (DateTime)fecha;
		string text = ((dateTime.Hour < 10) ? ("0" + dateTime.Hour) : dateTime.Hour.ToString());
		string text2 = ((dateTime.Minute < 10) ? ("0" + dateTime.Minute) : dateTime.Minute.ToString());
		return text + ":" + text2;
	}

	public static string GetDateFormat(string fecha)
	{
		if (fecha.Length == 0 || fecha.Length < 10)
		{
			return "";
		}
		return fecha.Substring(0, 10);
	}

	public static string GetModificacion(string idUsuario, string idDocumento, string id2, string tabla, string url)
	{
		Query query = new Query(tabla);
		query["id"] = idDocumento;
		query["fecha"] = "SYSDATE()";
		query["url"] = url;
		query["usuario"] = idUsuario;
		if (!string.IsNullOrEmpty(id2))
		{
			query["id2"] = id2;
		}
		return query.GetInsert();
	}

	public static string GetModificacion(string idUsuario, string idDocumento, string id2, string tabla)
	{
		return GetModificacion(idUsuario, idDocumento, id2, tabla, Usuario.GetCurrentURL());
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
		return QueryMod(GetModificacion(usuario.GetID(), idDocumento, null, "modificacionesweb"));
	}

	public bool SelectInDropDown(DropDownList lista, object valor, string query)
	{
		bool result = true;
		try
		{
			if (lista.Items.Count < 2)
			{
				lista.DataBind();
			}
			lista.SelectedIndex = -1;
			ListItem listItem = lista.Items.FindByValue(valor.ToString());
			if (listItem == null)
			{
				result = false;
				using Conector conector = new Conector(ConnectionString);
				string text = "";
				if (query.Length > 0)
				{
					if (query.IndexOf("{") != -1 && query.IndexOf("}") != -1)
					{
						query = string.Format(query, valor);
					}
					text = conector.QueryString(query);
				}
				listItem = new ListItem(text, valor.ToString());
				lista.Items.Add(listItem);
			}
			listItem.Selected = true;
		}
		catch
		{
		}
		return result;
	}

	public bool StartTransaction()
	{
		m_bTransaccion = true;
		return QueryMod("START TRANSACTION;") != -1;
	}

	public bool RoolBack()
	{
		m_bTransaccion = false;
		bool result = QueryMod("ROLLBACK;") != -1;
		CloseAll();
		return result;
	}

	public bool Commit()
	{
		m_bTransaccion = false;
		bool result = QueryMod("COMMIT;") != -1;
		CloseAll();
		return result;
	}
}
