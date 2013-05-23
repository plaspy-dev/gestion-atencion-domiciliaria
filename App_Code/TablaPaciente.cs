using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Collections;
using System.Data;

/// <summary>
/// Descripción breve de TablaPaciente
/// </summary>
public class TablaPaciente
{
    public TablaPaciente()
    {

    }

    static public void Add(DataTable m_pTabla, string szQuery, string entidad)
    {
        object[] todos = new object[m_pTabla.Columns.Count];
        CConector conector = new CConector();
        CConectorMS conectorms = new CConectorMS();

        MySqlDataReader readermysql = conector.Query(szQuery);
        if (readermysql != null)
        {
            while (readermysql.Read())
            {
                todos[0] = readermysql["pacId"].ToString();
                todos[1] = readermysql["Fecha"];
                todos[2] = readermysql["Barthel"];
                todos[3] = HttpUtility.HtmlDecode(readermysql["Analisis"].ToString());

                Paciente paciente = Paciente.GetPaciente(todos[0].ToString());

                if (entidad == "0" || paciente.entidadId == entidad)
                {
                    todos[4] = paciente.NombreCompleto;
                    todos[5] = paciente.documento;
                    todos[6] = paciente.Direccion;
                    todos[7] = paciente.Barrio;
                    todos[8] = paciente.Telefono;
                    todos[9] = paciente.cie10.Count > 0 ? paciente.cie10[0].ToString() : null;
                    todos[10] = paciente.cie10.Count > 1 ? paciente.cie10[1].ToString() : null;
                    todos[11] = paciente.cie10.Count > 2 ? paciente.cie10[2].ToString() : null;
                    todos[13] = paciente.sexoId == "1" ? "F" : "M";
                    if(paciente.Edad!=-1)
                        todos[12] = paciente.Edad;

                    m_pTabla.Rows.Add(todos);
                }
            }
        }
    }

    static public DataTable Rebuild(string desde, string hasta, string entidad)
    {

        DataTable m_pTabla = new DataTable();

        m_pTabla.Columns.Add("pacId");
        m_pTabla.Columns.Add("Fecha", typeof(DateTime));
        m_pTabla.Columns.Add("Barthel", typeof(int));
        m_pTabla.Columns.Add("Analisis");
        m_pTabla.Columns.Add("Paciente");
        m_pTabla.Columns.Add("Documento");
        m_pTabla.Columns.Add("Direccion");
        m_pTabla.Columns.Add("Barrio");
        m_pTabla.Columns.Add("Telefonos");
        m_pTabla.Columns.Add("Diagnostico1");
        m_pTabla.Columns.Add("Diagnostico2");
        m_pTabla.Columns.Add("Diagnostico3");
        m_pTabla.Columns.Add("Edad", typeof(int));
        m_pTabla.Columns.Add("Sexo");

        Query querymysql = new Query("ingreso_paciente");

        querymysql["Fecha"] = "ingreso_paciente.fecha";
        querymysql["Analisis"] = "ingreso_paciente.analisis";
        querymysql["Barthel"] = "SUM(varios.descripcion)";
        querymysql["pacId"] = "ingreso_paciente.paciente";

        Add(m_pTabla, querymysql.GetSelect("ingreso_paciente.fecha BETWEEN "
                            + Query.GetValor(CConector.GetMySQLDateFormat(desde))
                            + " AND "
                            + Query.GetValor(CConector.GetMySQLDateFormat(hasta))
                            + " AND indice_barthel.id=(SELECT id FROM indice_barthel WHERE paciente=ingreso_paciente.paciente ORDER BY fecha DESC LIMIT 1)"
                            + " GROUP BY ingreso_paciente.id"
                            , "LEFT JOIN indice_barthel ON (indice_barthel.paciente=ingreso_paciente.paciente)"
                            + " LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)"
                            + " LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)"
                            ), entidad);

        querymysql = new Query("evolucion_paciente");

        querymysql["Fecha"] = "evolucion_paciente.fecha";
        querymysql["Analisis"] = "evolucion_paciente.analisis";
        querymysql["Barthel"] = "SUM(varios.descripcion)";
        querymysql["pacId"] = "evolucion_paciente.paciente";

        Add(m_pTabla, querymysql.GetSelect("evolucion_paciente.fecha BETWEEN "
                            + Query.GetValor(CConector.GetMySQLDateFormat(desde))
                            + " AND "
                            + Query.GetValor(CConector.GetMySQLDateFormat(hasta))
                            + " AND indice_barthel.id=(SELECT id FROM indice_barthel WHERE paciente=evolucion_paciente.paciente ORDER BY fecha DESC LIMIT 1)"
                            + " GROUP BY evolucion_paciente.id"
                            , "LEFT JOIN indice_barthel ON (indice_barthel.paciente=evolucion_paciente.paciente)"
                            +" LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id)"
                            +" LEFT JOIN varios ON (varios.id=analisis_barthel.resultado)"
        ), entidad);

        HttpContext.Current.Session["paciente_atendido"] = m_pTabla;
        return m_pTabla;
    }
    public DataTable GetDataTable()
    {
        DataTable m_pTabla = (DataTable)HttpContext.Current.Session["paciente_atendido"];
        return m_pTabla;
    }
}
