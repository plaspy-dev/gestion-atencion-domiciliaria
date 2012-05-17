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

        Query msquery = new Query("phdPaciente");

        msquery += "entId";
        msquery += "pacNombres";
        msquery += "pacDocumento";
        msquery += "pacFechaNac";
        msquery += "pacDireccion";
        msquery += "pacBarrio";
        msquery += "pacTelefono";
        msquery += "cieCodDx";
        msquery += "cieCodDx_1";
        msquery += "cieCodDx_2";
        msquery += "sexoDesc";

        MySqlDataReader readermysql = conector.Query(szQuery);
        if (readermysql != null)
        {
            while (readermysql.Read())
            {
                todos[0] = readermysql["pacId"].ToString();
                todos[1] = readermysql["Fecha"];
                todos[2] = readermysql["Barthel"];
                todos[3] = HttpUtility.HtmlDecode(readermysql["Analisis"].ToString());

                SqlDataReader readerms = conectorms.Query(msquery.GetSelect("pacId=" + todos[0].ToString(), "LEFT JOIN admSexo ON (admSexo.sexoId=phdPaciente.sexoId)"));
                if (readerms != null && readerms.Read())
                {
                    if (entidad == "0" || readerms["entID"].ToString() == entidad)
                    {
                        todos[4] = readerms["pacNombres"].ToString();
                        todos[5] = readerms["pacDocumento"].ToString();
                        todos[6] = readerms["pacDireccion"].ToString();
                        todos[7] = readerms["pacBarrio"].ToString();
                        todos[8] = readerms["pacTelefono"].ToString();
                        todos[9] = readerms["cieCodDx"].ToString();
                        todos[10] = readerms["cieCodDx_1"].ToString();
                        todos[11] = readerms["cieCodDx_2"].ToString();
                        todos[13] = readerms["sexoDesc"].ToString();

                        DateTime fechaNacimiento = (DateTime)readerms["pacFechaNac"];

                        if (fechaNacimiento != null)
                        {
                            int edad = DateTime.Now.Year - fechaNacimiento.Year;

                            //Obtengo la fecha de cumpleaños de este año.
                            DateTime nacimientoAhora = fechaNacimiento.AddYears(edad);
                            //Le resto un año si la fecha actual es anterior 
                            //al día de nacimiento.
                            if (DateTime.Now.CompareTo(nacimientoAhora) > 0)
                            {
                                edad--;
                            }
                            todos[12] = edad;
                        }
                        m_pTabla.Rows.Add(todos);
                    }
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
        querymysql["Barthel"] = "(SELECT SUM(varios.descripcion) FROM indice_barthel LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id) LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE indice_barthel.paciente=ingreso_paciente.paciente GROUP BY indice_barthel.id ORDER BY indice_barthel.fecha DESC LIMIT 1)";
        querymysql["pacId"] = "ingreso_paciente.paciente";

        Add(m_pTabla, querymysql.GetSelect("ingreso_paciente.fecha BETWEEN "
                            + Query.GetValor(CConector.GetMySQLDateFormat(desde))
                            + " AND "
                            + Query.GetValor(CConector.GetMySQLDateFormat(hasta))), entidad);

        querymysql = new Query("evolucion_paciente");

        querymysql["Fecha"] = "evolucion_paciente.fecha";
        querymysql["Analisis"] = "evolucion_paciente.analisis";
        querymysql["Barthel"] = "(SELECT SUM(varios.descripcion) FROM indice_barthel LEFT JOIN analisis_barthel ON (analisis_barthel.indice_barthel=indice_barthel.id) LEFT JOIN varios ON (varios.id=analisis_barthel.resultado) WHERE indice_barthel.paciente=evolucion_paciente.paciente GROUP BY indice_barthel.id ORDER BY indice_barthel.fecha DESC LIMIT 1)";
        querymysql["pacId"] = "evolucion_paciente.paciente";

        Add(m_pTabla, querymysql.GetSelect("evolucion_paciente.fecha BETWEEN "
                            + Query.GetValor(CConector.GetMySQLDateFormat(desde))
                            + " AND "
                            + Query.GetValor(CConector.GetMySQLDateFormat(hasta))), entidad);

        HttpContext.Current.Session["paciente_atendido"] = m_pTabla;
        return m_pTabla;
    }
    public DataTable GetDataTable()
    {
        DataTable m_pTabla = (DataTable)HttpContext.Current.Session["paciente_atendido"];
        return m_pTabla;
    }
}
