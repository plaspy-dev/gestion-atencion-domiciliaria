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
    public String Nombre { get; set; }
    public String Numero { get; set; }
    public String URL { get; set; }
    public String SelectCommand { get; set; }
    public String SelectCount { get; set; }

    public Alertas(string nombre, string numero, string url, string select, string selectcount)
    {
        Nombre = nombre;
        Numero = numero;
        SelectCommand = select;
        URL = url;
        SelectCount = selectcount;
    }

    public static ArrayList GetFullAlertas() {

        ArrayList alertas = (ArrayList)HttpContext.Current.Session["Alertas"];
        if(alertas==null) {
            alertas = new ArrayList();
            HttpContext.Current.Session["Alertas"] = alertas;

            CConectorMS conectorc = new CConectorMS();
            SqlDataReader consultas = conectorc.Query("SELECT genTareas.tarTitulo AS nombre,genTareas.consulta,genTareas.url,genTareas.consultaCount FROM GenUsuarioTarea LEFT JOIN genTareas ON (genTareas.tarId=GenUsuarioTarea.tarId) WHERE usIdUsuario='" + Usuario.GetUsuario().GetLogin() + "' AND genTareas.consulta IS NOT NULL ORDER BY nombre");

            if (consultas != null)
            {
                while (consultas.Read())
                {
                    alertas.Add(new Alertas(
                            consultas["nombre"].ToString(),
                            "0",
                            consultas["url"].ToString(),
                            consultas["consulta"].ToString(),
                            consultas["consultaCount"].ToString()
                    ));
                }
            }

        }
        return alertas;
    }

    public static ArrayList GetAlertas() {
        
        ArrayList alertas = new ArrayList();
        CConectorMS conector = new CConectorMS();

        ArrayList fullAlertas= GetFullAlertas();
        for (int i = 0; i < fullAlertas.Count; i++ ) {

            Alertas alerta = (Alertas)fullAlertas[i];
            alerta.Numero = conector.QueryString(alerta.SelectCount);
            if(alerta.Numero!="0")
                alertas.Add(alerta);
        }
        return alertas;
    }
}
