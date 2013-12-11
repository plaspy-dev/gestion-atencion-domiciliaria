using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;

/// <summary>
/// Descripción breve de Calificacion
/// </summary>
public class Calificacion
{
    public enum Escalas {
        Barthel=8,
        Braden = 41
    }
    public static Calificacion[] IndiceBarthel = { new Calificacion(45, "Severa"), new Calificacion(60, "Grave"), new Calificacion(80, "Moderada"), new Calificacion(101, "Ligera") };
    public static Calificacion[] EscalaBraden = { new Calificacion(13, "Alto riesgo"), new Calificacion(15, "Riesgo moderado"), new Calificacion(17, "Bajo riesgo"), new Calificacion(50, "Sin riesgo") };

    public int maximo { get; set; }
    public string mensaje { get; set; }
    public Calificacion(int max, string mess)
    {
        maximo = max;
        mensaje = mess;
    }

    static public String GetDescripcion(int calificacion, String tipo)
    {
        Calificacion[] escala = tipo == "8" ? IndiceBarthel : EscalaBraden;
        for (int i = 0; i < escala.Length; i++)
        {
            if (calificacion < escala[i].maximo)
                return escala[i].mensaje;
        }
        return "";
    }

    public static String GetArrayMessages(String tipo)
    {
        string script = "escala=[";
        Calificacion[] escala = tipo == "8" ? IndiceBarthel : EscalaBraden;
        for (int i = 0; i < escala.Length; i++)
        {
            if (i > 0)
                script += ",";
            script += string.Format("[{0},'{1}']", escala[i].maximo, escala[i].mensaje);
        }
        return script + "]";
    }

    public static string GetCalificacion(string idPaciente, string fecha, Calificacion.Escalas tipo)
    {
        using (CConector conector= new CConector())
        {
            string resultado =
                conector.QueryString(
                        string.Format("SELECT SUM(varios.descripcion) FROM indice_barthel "
                        + " LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)"
                        + " LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)"
                        + " WHERE "
                        + " indice_barthel.paciente={0} "
                        + " AND DATE(indice_barthel.fecha)={1}"
                        + " AND indice_barthel.tipo={2}"
                        + " GROUP BY indice_barthel.id"
                        + " LIMIT 1;", idPaciente, Query.GetValor(Conector.GetMySQLDateFormat(fecha)), (int)tipo)
                        );
            return resultado;
        }
    }

    public static string GetCalificacionYDescripcion(string idPaciente, string fecha, Calificacion.Escalas tipo)
    {
        string resultado = GetCalificacion(idPaciente, fecha, tipo);
        if (!string.IsNullOrEmpty(resultado)) {
            try
            {
                int calificacion = Convert.ToInt32(resultado);
                resultado= string.Format("{0} ({1})", calificacion, GetDescripcion(calificacion, ((int)tipo).ToString()));
            } catch { }
        }
        return resultado;
    }
}