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

    public Alertas(string nombre, string numero, string url, string select)
    {
        Nombre = nombre;
        Numero = numero;
        SelectCommand = select;
        URL = url;
    }

    public static ArrayList GetAlertas() {
        
        ArrayList alertas = new ArrayList();
        CConectorMS conector = new CConectorMS();
        CConectorMS conectorc = new CConectorMS();
        SqlDataReader consultas = conectorc.Query("SELECT genTareas.tarTitulo AS nombre,genTareas.consulta,genTareas.url,genTareas.consultaCount FROM GenUsuarioTarea LEFT JOIN genTareas ON (genTareas.tarId=GenUsuarioTarea.tarId) WHERE usIdUsuario='" + Usuario.GetUsuario().GetLogin() + "' AND genTareas.consulta IS NOT NULL ORDER BY nombre");

        if (consultas != null)
        {
            while (consultas.Read())
            {
                string numero= conector.QueryString(consultas["consultaCount"].ToString());
                if(numero!="0") {
                    Alertas alerta = new Alertas(
                        consultas["nombre"].ToString(),
                        numero,
                        consultas["url"].ToString(),
                        consultas["consulta"].ToString()
                    );
                    alertas.Add(alerta);
                }
            }
        }

        return alertas;
    }
}
