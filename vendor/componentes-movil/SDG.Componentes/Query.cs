using System;
using System.Collections.Generic;
using System.Globalization;
using MySql.Data.Types;

namespace SDG.Componentes;

[Serializable]
public class Query
{
	protected Dictionary<string, string> dCampos;

	protected Dictionary<string, bool> dQuoted;

	public string TableName { get; set; }

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
		TableName = tabla;
		dCampos = new Dictionary<string, string>();
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
		try
		{
			dCampos.Remove(campo);
			dQuoted.Remove(campo);
		}
		catch
		{
		}
	}

	public void Clean()
	{
		dCampos.Clear();
		dQuoted.Clear();
	}

	public static string GetValor(object value)
	{
		string text = null;
		if (value is string)
		{
			text = (string)value;
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
			text = GetMySQLDateFormat((DateTime)value, horas: true);
		}
		else if (value != null)
		{
			text = value.ToString();
		}
		if (string.IsNullOrEmpty(text))
		{
			return "NULL";
		}
		if (text.ToLower() == "sysdate()" || text.ToLower() == "getdate()")
		{
			return text;
		}
		return string.Format("'{0}'", text.Replace("\\", "\\\\").Replace("'", "\\'"));
	}

	public string GetUpdate(string condicion, params object[] args)
	{
		if (dCampos.Count == 0)
		{
			return "";
		}
		if (args.Length != 0)
		{
			condicion = string.Format(condicion, args);
		}
		string text = "UPDATE " + TableName + " SET ";
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

	public string GetInsert(bool replace = false)
	{
		if (dCampos.Count == 0)
		{
			return "";
		}
		string text = (replace ? "REPLACE INTO " : "INSERT INTO ") + TableName + " (";
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
		if (args.Length != 0)
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
		text = text + " FROM " + TableName + " ";
		text = text + join + " ";
		if (condicion.Length != 0)
		{
			text = text + " WHERE " + condicion;
		}
		return text;
	}

	public string GetDelete(string condicion, params object[] args)
	{
		if (args.Length != 0)
		{
			condicion = string.Format(condicion, args);
		}
		string text = "DELETE FROM " + TableName;
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
				return GetMySQLDateFormat(DateTime.Parse(text, CultureInfo.GetCultureInfo("es-CO")), horas);
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

	public static string GetFromMySQLDate(object fecha, bool horas = false, bool segundos = false)
	{
		try
		{
			DateTime dateTime = ((!(typeof(MySqlDateTime) == fecha.GetType())) ? ((DateTime)fecha) : ((MySqlDateTime)fecha).GetDateTime());
			if (horas)
			{
				return dateTime.ToString("dd/MM/yyyy HH:mm" + (segundos ? ":ss" : ""));
			}
			return dateTime.ToString("dd/MM/yyyy");
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
