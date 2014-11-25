using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.ComponentModel;

/// <summary>
/// Descripción breve de Calificacion
/// </summary>
public class Calificacion
{
    public enum Escalas {
        [Description("Índice de Barthel")]
        Barthel=8,
        [Description("Escala Braden")]
        Braden = 41,
        [Description("Escala de la Cruz Roja")]
        CruzRoja= 77,
        [Description("Escala Norton")]
        Norton= 79
    }
    public static Calificacion[] IndiceBarthel = { new Calificacion(45, "Severa"), new Calificacion(60, "Grave"), new Calificacion(80, "Moderada"), new Calificacion(101, "Ligera") };
    public static Calificacion[] EscalaBraden = { new Calificacion(13, "Alto riesgo"), new Calificacion(15, "Riesgo moderado"), new Calificacion(17, "Bajo riesgo"), new Calificacion(50, "Sin riesgo") };
    public static Calificacion[] EscalaNorton = { new Calificacion(10,"Riesgo muy alto"),new Calificacion(13,"Riesgo alto"),new Calificacion(15,"Riesgo medio"),new Calificacion(50,"Riesgo mínimo")};

    public int maximo { get; set; }
    public string mensaje { get; set; }
    public Calificacion(int max, string mess)
    {
        maximo = max;
        mensaje = mess;
    }

    public static string GetNombreEscala(Escalas valor)
    {
        try
        {
            return ((DescriptionAttribute)valor.GetType().GetField(valor.ToString()).GetCustomAttributes(typeof(DescriptionAttribute), true)[0]).Description;
        } catch { }
        return "";
    }
    static public string GetMensajeDescripcion(String tipo) {
        switch (Convert.ToInt32(tipo))
        {
            case (int)Escalas.Barthel:
                return "La incapacidad se valora como ";
            case (int)Escalas.Braden:
                return "Riesgo de padecer úlceras por presión ";
            case (int)Escalas.Norton:
                return "Riesgo de padecer úlceras por presión ";
        }
        return "";
    }
    static public String GetDescripcion(int calificacion, String tipo)
    {
        Calificacion[] escala = null;
        switch (Convert.ToInt32(tipo)) { 
            case (int)Escalas.Barthel:
                escala = IndiceBarthel;
                break;
            case (int)Escalas.Braden:
                escala = EscalaBraden;
                break;
            case (int)Escalas.Norton:
                escala = EscalaNorton;
                break;
            default:
                return "";
        }
        for (int i = 0; i < escala.Length; i++)
        {
            if (calificacion < escala[i].maximo)
                return escala[i].mensaje;
        }
        return "";
    }

    public static String GetArrayMessages(String tipo)
    {
        Calificacion[] escala = null;
        switch (Convert.ToInt32(tipo))
        {
            case (int)Escalas.Barthel:
                escala = IndiceBarthel;
                break;
            case (int)Escalas.Braden:
                escala = EscalaBraden;
                break;
            case (int)Escalas.Norton:
                escala = EscalaNorton;
                break;
        }
        string script = "escala=[";
        if (escala!=null)
        {
            for (int i = 0; i < escala.Length; i++)
            {
                if (i > 0)
                    script += ",";
                script += string.Format("[{0},'{1}']", escala[i].maximo, escala[i].mensaje);
            }
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
                        + " LIMIT 1;", idPaciente, Query.GetValor(Query.GetMySQLDateFormat(fecha)), (int)tipo)
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
                string descripcion= GetDescripcion(calificacion, ((int)tipo).ToString());
                if (string.IsNullOrEmpty(descripcion))
                    resultado = calificacion.ToString();
                else resultado= string.Format("{0} ({1})", calificacion, descripcion);
            } catch { }
        }
        return resultado;
    }
}