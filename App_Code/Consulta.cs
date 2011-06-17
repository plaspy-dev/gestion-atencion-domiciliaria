using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Globalization;


public class Consulta
{
    protected string m_szQuery;
    protected string m_szColor;
    protected string m_szInfo;
    protected int m_nNumero;

	public Consulta(string query, string color, string info, int numero)
	{
        m_szQuery = query;
        m_szColor = color;
        m_szInfo = info;
        m_nNumero = numero;
	}
    public string GetColor() {
        return m_szColor;
    }
    public string GetQuery() {
        return m_szQuery;
    }
    public string GetInfo() {
        return m_szInfo;
    }
    public int GetNumero() {
        return m_nNumero;
    }
    public string GetJavascript(MySqlDataReader reader) {

        string inicial = "";
        return GetJavascript(reader, ref inicial);
    }

    public string GetJavascript(MySqlDataReader reader, ref string inicial)
    {
        if (reader == null)
            return "";
        string resultado = "";
        while (reader.Read())
        {
            double vel = Convert.ToDouble(reader["vel"]);
            vel *= 3.6;
            resultado+= "add(" + ((double)reader["lat"]).ToString(CultureInfo.InvariantCulture) 
            + ", "
            + ((double)reader["lon"]).ToString(CultureInfo.InvariantCulture) + ", " + (m_nNumero + 1)
            + ",'" + m_szColor + "','" + m_szInfo + "<br/>Vel: "+ vel.ToString() + "Km/h','" + reader["fecha"].ToString() + "');\n";

            inicial = "function i() {myLatlng = new google.maps.LatLng(" + ((double)reader["lat"]).ToString(CultureInfo.InvariantCulture)
                + ", " +
                ((double)reader["lon"]).ToString(CultureInfo.InvariantCulture) + ");}"
                ;
        }
        return resultado;
    }
}
