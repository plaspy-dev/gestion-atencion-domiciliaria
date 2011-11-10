using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Descripción breve de ProgramacionTipo
/// </summary>
public class ProgramacionTipo
{
    public enum TipoServicios
    {

        phd = 1,
        apoyo = 2,
        medico = 3,
    };

    static public TipoServicios TipoServicio
    {
        get
        {
            if (HttpContext.Current.Session["phd_programacion_tipo"] == null)
                return TipoServicios.phd;
            return (TipoServicios)HttpContext.Current.Session["phd_programacion_tipo"];
        }
        set
        {
            HttpContext.Current.Session["phd_programacion_tipo"] = value;
        }
    }

    static public String GetNombreTabla()
    {

        string tabla = "phdProgramacion";
        if (TipoServicio == TipoServicios.medico)
        {
            tabla = "phdProgramacionMD";
        } else if(TipoServicio==TipoServicios.apoyo) {

            tabla = "atxProgramacion";
        }
        return tabla;
    }
}
