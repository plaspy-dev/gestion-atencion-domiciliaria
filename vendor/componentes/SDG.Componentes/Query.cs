using System;
using System.Collections.Generic;
using System.Globalization;
using MySql.Data.Types;

namespace SDG.Componentes;

[Serializable]
public class Query
{
	protected string m_szTabla;

	protected Dictionary<string, string> dCampos;

	protected Dictionary<string, bool> dQuoted;

	public int Count => dCampos.Count;

	public object this[string campo]
	{
		get
		{
			try
			{
				return dCampos[campo];
			}
			catch
			{
			}
			return "";
		}
		set
		{
			string text = ((value == null) ? "" : value.ToString());
			if (string.IsNullOrEmpty(campo))
			{
				campo = text;
			}
			else if (value is float num)
			{
				text = num.ToString(CultureInfo.InvariantCulture);
			}
			else if (value is double num2)
			{
				text = num2.ToString(CultureInfo.InvariantCulture);
			}
			else if (value is decimal num3)
			{
				text = num3.ToString(CultureInfo.InvariantCulture);
			}
			else if (value is DateTime)
			{
				text = GetMySQLDateFormat((DateTime)value);
			}
			dCampos[campo] = text;
		}
	}

	public Query(string tabla)
	{
		m_szTabla = tabla;
		dCampos = new Dictionary<string, string>();
		dQuoted = new Dictionary<string, bool>();
	}

	public string GetTabla()
	{
		return m_szTabla;
	}

	public void SetTabla(string tabla)
	{
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
		{
			dQuoted.Remove(campo);
		}
		else
		{
			dQuoted[campo] = false;
		}
	}

	public void RemoveCampo(string campo)
	{
		dQuoted.Remove(campo);
		dCampos.Remove(campo);
	}

	public void Clean()
	{
		dCampos.Clear();
		dQuoted.Clear();
	}

	public static string GetValor(string valor)
	{
		if (valor == null || valor.Length == 0)
		{
			return "NULL";
		}
		if (valor.ToLower() == "sysdate()" || valor.ToLower() == "getdate()")
		{
			return valor;
		}
		string text = valor;
		text = text.Replace("\\", "\\\\");
		text = text.Replace("'", "\\'");
		return "'" + text + "'";
	}

	public string GetUpdate(string condicion, params object[] args)
	{
		if (dCampos.Count == 0)
		{
			return "";
		}
		if (args.Length > 0)
		{
			condicion = string.Format(condicion, args);
		}
		string text = "UPDATE " + m_szTabla + " SET ";
		bool flag = false;
		foreach (KeyValuePair<string, string> dCampo in dCampos)
		{
			if (flag)
			{
				text += ",";
			}
			else
			{
				flag = true;
			}
			bool flag2 = true;
			try
			{
				flag2 = dQuoted[dCampo.Key];
			}
			catch
			{
			}
			string text2 = (flag2 ? GetValor(dCampo.Value) : dCampo.Value);
			text = text + dCampo.Key + "=" + text2;
		}
		if (condicion.Length != 0)
		{
			text = text + " WHERE " + condicion;
		}
		return text;
	}

	public string GetInsert(bool replace)
	{
		string statement = GetInsert();
		if (!replace || statement.Length == 0)
			return statement;
		const string prefix = "INSERT INTO ";
		return "REPLACE INTO " + statement.Substring(prefix.Length);
	}

	public string TableName
	{
		get { return m_szTabla; }
		set { m_szTabla = value; }
	}

	public static Query operator -(Query query, string valor)

        {

            query.RemoveCampo(valor);

            return query;

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



            return GetValor(valor);
        }

	public string GetInsert()
	{
		if (dCampos.Count == 0)
		{
			return "";
		}
		string text = "INSERT INTO " + m_szTabla + " (";
		bool flag = false;
		foreach (KeyValuePair<string, string> dCampo in dCampos)
		{
			if (flag)
			{
				text += ",";
			}
			else
			{
				flag = true;
			}
			text += dCampo.Key;
		}
		text += ") VALUES (";
		flag = false;
		foreach (KeyValuePair<string, string> dCampo2 in dCampos)
		{
			if (flag)
			{
				text += ",";
			}
			else
			{
				flag = true;
			}
			bool flag2 = true;
			try
			{
				flag2 = dQuoted[dCampo2.Key];
			}
			catch
			{
			}
			text += (flag2 ? GetValor(dCampo2.Value) : dCampo2.Value);
		}
		return text + ");";
	}

	public string GetSelect(string condicion, string join = null, params object[] args)
	{
		if (dCampos.Count == 0)
		{
			return "";
		}
		if (args.Length > 0)
		{
			condicion = string.Format(condicion, args);
		}
		string text = "SELECT ";
		bool flag = false;
		foreach (KeyValuePair<string, string> dCampo in dCampos)
		{
			if (flag)
			{
				text += ",";
			}
			else
			{
				flag = true;
			}
			text += dCampo.Value;
			if (dCampo.Value != dCampo.Key)
			{
				text = text + " AS '" + dCampo.Key + "'";
			}
		}
		text = text + " FROM " + m_szTabla + " ";
		text = text + join + " ";
		if (condicion.Length != 0)
		{
			text = text + " WHERE " + condicion;
		}
		return text;
	}

	public string GetDelete(string condicion, params object[] args)
	{
		if (args.Length > 0)
		{
			condicion = string.Format(condicion, args);
		}
		string text = "DELETE FROM " + m_szTabla;
		if (condicion.Length != 0)
		{
			text = text + " WHERE " + condicion;
		}
		return text;
	}

	public static string GetMySQLDateFormat(DateTime fecha, bool horas = false)
	{
		string text = fecha.ToString("yyyy-MM-dd");
		if (horas)
		{
			text += fecha.ToString(" HH:mm:ss");
		}
		return text;
	}

	public static string GetMySQLDateFormat(string text, bool horas = false)
	{
		try
		{
			if (!string.IsNullOrEmpty(text))
			{
				return GetMySQLDateFormat(Convert.ToDateTime(text), horas);
			}
		}
		catch
		{
			Logs.WriteClassLog(text);
		}
		return "";
	}

	public static DateTime GetFromMySQLDate(string fecha)
	{
		try
		{
			if (!string.IsNullOrEmpty(fecha))
			{
				return DateTime.ParseExact(fecha, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
			}
		}
		catch
		{
			Logs.WriteClassLog(fecha);
		}
		return DateTime.MinValue;
	}

	public static string GetFromMySQLDate(object fecha, bool horas = false)
	{
		try
		{
			DateTime dateTime = ((!(typeof(MySqlDateTime) == fecha.GetType())) ? ((DateTime)fecha) : ((MySqlDateTime)fecha).GetDateTime());
			if (horas)
			{
				return dateTime.ToShortDateString() + " " + dateTime.Hour.ToString("00") + ":" + dateTime.Minute.ToString("00");
			}
			return dateTime.ToShortDateString();
		}
		catch
		{
		}
		return "";
	}

	public static string TryGetCurrency(string valor)
	{
		try
		{
			if (!string.IsNullOrEmpty(valor))
			{
				return decimal.Parse(valor, NumberStyles.Currency).ToString(CultureInfo.InvariantCulture);
			}
		}
		catch
		{
		}
		return "";
	}

	public static string TryGetDouble(string valor)
	{
		try
		{
			if (!string.IsNullOrEmpty(valor))
			{
				return Convert.ToDouble(valor).ToString(CultureInfo.InvariantCulture);
			}
		}
		catch
		{
		}
		return "";
	}

	public static string TryGetInt(string valor)
	{
		try
		{
			if (!string.IsNullOrEmpty(valor))
			{
				return Convert.ToInt32(valor).ToString();
			}
		}
		catch
		{
		}
		return "";
	}
}
