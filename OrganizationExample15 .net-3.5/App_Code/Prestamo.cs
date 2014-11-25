using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;

[Serializable]
public class Prestamo
{
    public int IdTabla { get; set; }
    public string IdPrestamo { get; set; }
    public DateTime Fecha { get; set; }
    public DateTime? Estimado { get; set; }
    public DateTime? Devolucion { get; set; }
    public string IdFuncionario { get; set; }
    public string Familiar { get; set; }
    public string IdPaciente { get; set; }
    public bool Pagare { get; set; }
    public string Observaciones { get; set; }
    public bool Visible { get; set; }
    public string NombrePaciente { get { return Paciente.GetPaciente(IdPaciente).DocumentoYNombres; } }
    public string NombreFuncionario { get { return Funcionario.GetFuncionario(IdFuncionario).DocumentoYNombres; } }

    public Prestamo(int idTabla)
    {
        IdTabla = idTabla;
        Estimado = null;
        Visible = true;
    }

    public static bool UpdateEstado(Conector conector, string idEquipo) {
        
        string prestado = conector.QueryString(string.Format("SELECT 1 FROM equipo_prestamo WHERE equipo={0} AND devolucion IS NULL LIMIT 1", idEquipo));

        Query query = new Query("equipo");

        query["estado"] = string.IsNullOrEmpty(prestado) ? "1" : "2";

        if (conector.QueryMod(query.GetUpdate("id=" + idEquipo)) == -1)
            return false;

        return true;
    }
}
