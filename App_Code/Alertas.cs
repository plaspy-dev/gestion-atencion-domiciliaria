using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data.SqlClient;
using SDG.Componentes;

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

            using (CConectorMS conectorc = new CConectorMS())
            {
                SqlDataReader consultas = conectorc.Query("SELECT genTareas.tarTitulo AS nombre,genTareas.consulta,genTareas.url,genTareas.consultaCount,genTareas.MySQL FROM GenUsuarioTarea LEFT JOIN genTareas ON (genTareas.tarId=GenUsuarioTarea.tarId) WHERE usIdUsuario='" + Usuario.GetUsuario().GetLogin() + "' AND genTareas.consulta IS NOT NULL ORDER BY nombre");

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
                            consulta = Procedimientos.SetCargos(consulta.Replace("{1}", "{0}"), "admPersonalHS.carId");
                            consultacount = Procedimientos.SetCargos(consultacount.Replace("{1}", "{0}"), "admPersonalHS.carId");
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
        using (CConector conectormysql = new CConector())
            using (CConectorMS conector = new CConectorMS())
            {
                List<Alertas> fullAlertas = GetFullAlertas();
                for (int i = 0; i < fullAlertas.Count; i++)
                {
                    Alertas alerta = (Alertas)fullAlertas[i];
                    alerta.Numero = alerta.MySQLDB ? conectormysql.QueryString(alerta.SelectCount) : conector.QueryString(alerta.SelectCount);
                    if (alerta.Numero != "0")
                        alertas.Add(alerta);
                }
            }
        return alertas;
    }
}
