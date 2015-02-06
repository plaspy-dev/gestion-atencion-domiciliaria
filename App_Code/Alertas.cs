using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data.SqlClient;
using SDG.Componentes;
using MySql.Data.MySqlClient;

/// <summary>
/// Descripción breve de Alertas
/// </summary>
public class Alertas
{
    public String Id { get; set; }
    public String Nombre { get; set; }
    public String Numero { get; set; }
    public String URL { get; set; }
    public String SelectCommand { get; set; }
    public String SelectCount { get; set; }
    public bool MySQLDB { get; set; }

    public Alertas(string id, string nombre, string numero, string url, string select, string selectcount, bool mysql)
    {
        Id = id;
        Nombre = nombre;
        Numero = numero;
        SelectCommand = select;
        URL = url;
        SelectCount = selectcount;
        MySQLDB = mysql;
    }

    public static List<Alertas> GetFullAlertas()
    {
        List<Alertas> alertas = (List<Alertas>)HttpContext.Current.Session["Alertas"];
        if(alertas==null) {

            alertas = new List<Alertas>();
            HttpContext.Current.Session["Alertas"] = alertas;

            using (CConector conectorc = new CConector())
            {
                MySqlDataReader consultas = conectorc.Query("SELECT alerta.tarTitulo AS nombre,alerta.consulta,alerta.url,alerta.consultaCount,alerta.MySQL FROM usuario_alerta LEFT JOIN alerta ON (alerta.tarId=usuario_alerta.tarId) WHERE usIdUsuario='" + Usuario.GetUsuario().GetLogin() + "' AND alerta.consulta IS NOT NULL ORDER BY nombre");

                if (consultas != null)
                {
                    while (consultas.Read())
                    {
                        string consulta = consultas["consulta"].ToString();
                        string consultacount = consultas["consultaCount"].ToString();

                        if (consulta.IndexOf("{0}") != -1)
                        {
                            consulta = Procedimientos.SetProcedimientos(consulta, "programacion.actId");
                            consultacount = Procedimientos.SetProcedimientos(consultacount, "programacion.actId");
                        }
                        if (consulta.IndexOf("{1}") != -1)
                        {
                            consulta = Procedimientos.SetCargos(consulta.Replace("{1}", "{0}"), "recurso_humano.carId");
                            consultacount = Procedimientos.SetCargos(consultacount.Replace("{1}", "{0}"), "recurso_humano.carId");
                        }

                        alertas.Add(new Alertas(alertas.Count.ToString(), 
                                consultas["nombre"].ToString(),
                                "0",
                                consultas["url"].ToString(),
                                consulta,
                                consultacount,
                                consultas["MySQL"].ToString()=="1"
                        ));
                    }
                }
            }

        }
        return alertas;
    }

    public static List<Alertas> GetAlertas() {

        List<Alertas> alertas = new List<Alertas>();
        using (CConector conector = new CConector())
            {
                List<Alertas> fullAlertas = GetFullAlertas();
                for (int i = 0; i < fullAlertas.Count; i++)
                {
                    Alertas alerta = (Alertas)fullAlertas[i];
                    alerta.Numero = conector.QueryString(alerta.SelectCount);
                    if (alerta.Numero != "0")
                        alertas.Add(alerta);
                }
            }
        return alertas;
    }
}
