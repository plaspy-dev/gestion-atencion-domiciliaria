using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.ComponentModel;

/// <summary>
/// Descripción breve de Procedimientos
/// </summary>
public class Procedimientos
{
    public enum TipoServicio { 
        [Description("(Ninguno)")]
        Ninguno=0,
        [Description("Terapia física")]
        TerapiaFisica=1,
        [Description("Terapia respiratoria")]
        TerapiaRespiratoria,
        [Description("Terapia ocupacional")]
        TerapiaOcupacional,
        [Description("Terapia de lenguaje")]
        TerapiaLenguaje
    }

    public static string GetNombreTipoServicio(TipoServicio valor)
    {
        try
        {
            return ((DescriptionAttribute)valor.GetType().GetField(valor.ToString()).GetCustomAttributes(typeof(DescriptionAttribute), true)[0]).Description;
        }
        catch { }
        return "";
    }

    public class Procedimiento { 
        public string sNombre;
        public Boolean bAutomatica;

        public Procedimiento(string nombre, bool automatica) {
            sNombre = nombre;
            bAutomatica = automatica;
        }
    }

    protected Dictionary<string, Procedimiento> pProcedimentos = new Dictionary<string, Procedimiento>();

    public Procedimientos()
    {
        HttpContext.Current.Session["Procedimientos"] = this;
    }

    static public Procedimientos GetProcedimientos() {
        Procedimientos info= (Procedimientos)HttpContext.Current.Session["Procedimientos"];
        if (info == null)
            info = new Procedimientos();
        return info;
    }

    static public void RemoveVarios(string id)
    {
        HttpRuntime.Cache.Remove("v" + id);
    }

    /*static public void RemoveIntensidad(string procedimientoid)
    {
        HttpRuntime.Cache.Remove("pv" + procedimientoid);
    }

    static public bool HasIntensidad(string procedimientoid) {
        
        if (string.IsNullOrEmpty(procedimientoid))
            return false;

        string cantidad = (string)HttpRuntime.Cache["pv" + procedimientoid];
        if (cantidad == null)
        {
            using (CConector conector = new CConector())
            {
                cantidad = conector.QueryString("SELECT COUNT(*) FROM varios WHERE tipo=21 AND estado IS NULL AND parametro1=" + Query.GetValor(procedimientoid));
                HttpRuntime.Cache.Insert("pv" + procedimientoid, cantidad);
            }
        }
        return cantidad!="0";
    }*/

    static public string GetVarios(string id) {

        if (string.IsNullOrEmpty(id))
            return "";

        string nombre= (string)HttpRuntime.Cache["v" + id];
        if (nombre == null) {
            using (CConector conector = new CConector())
            {
                nombre= conector.QueryString("SELECT nombre FROM varios WHERE id=" + Query.GetValor(id));
                HttpRuntime.Cache.Insert("v"+ id, nombre);
            }
        }
        return nombre;
    }

    static public Procedimiento AddProcedimiento(string id)
    {
        Procedimientos info = GetProcedimientos();
        Procedimiento resultado = null;
        try
        {
            resultado = info.pProcedimentos[id];
        }
        catch 
        {
            using (CConector conector = new CConector())
            {
                string nombre = "";
                bool automatico = false;
                MySqlDataReader reader = conector.Query("SELECT CONCAT(codigo, '-', nombre) AS nombre,automatica FROM medicamentos WHERE id=" + Query.GetValor(id));
                if (reader != null && reader.Read())
                {
                    nombre = reader["nombre"].ToString();
                    automatico = reader["automatica"].ToString() == "1";
                }
                resultado = new Procedimiento(nombre, automatico);
                info.pProcedimentos[id] = resultado;
            }
        }
        return resultado;
    }

    static public string GetNombreMedicamento(string id) {

        string nombre = "";
        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query("SELECT id,nombre,principio,concentracion,forma,codigo FROM medicamentos WHERE id=" + Query.GetValor(id));
            if (reader != null && reader.Read())
            {
                // PARACETAMOL [ACETAMINOFÉN], 100 mg/mL (10%) - SOLUCIÓN ORAL
                nombre = reader["codigo"].ToString() + " - ";
                nombre += reader["nombre"].ToString();
                if (reader["principio"].ToString().Length != 0)
                    nombre += " [" + reader["principio"].ToString() + "]";
                if (reader["concentracion"].ToString().Length != 0)
                    nombre += ", " + reader["concentracion"].ToString();
                if (reader["forma"].ToString().Length != 0)
                    nombre += "-" + reader["forma"].ToString();
            }
            // lo agregamos al cache.
        }
        return nombre;
    }

    static public string GetProcedimiento(string id) {

        return AddProcedimiento(id).sNombre;
    }
    static public bool GetAutomatico(string id) {
        
        return AddProcedimiento(id).bAutomatica;
    }

    static public void RemoveCostoProcedimiento(string entidad, string procedimiento)
    {
        HttpRuntime.Cache.Remove("cp" + entidad + ";" + procedimiento);
    }

    static public void RemoveMaximoProcedimiento(string entidad, string procedimiento)
    {
        HttpRuntime.Cache.Remove("sp" + entidad + ";" + procedimiento);
    }

    /*static public void RemoveCostoIntensidad(string entidad, string intensidad) {

        HttpRuntime.Cache.Remove("ci" + entidad + ";" + intensidad);
    }

    static public Decimal GetCosto(string entidad, string procedimento, string intensidad) {
        
        if (string.IsNullOrEmpty(intensidad))
            return Convert.ToDecimal(GetCosto(procedimento, entidad));
        if (string.IsNullOrEmpty(entidad) || string.IsNullOrEmpty(procedimento))
            return 0;

        string clave= "CONFIGURAR_EN_ENTORNO" + entidad + ";" + intensidad;

        string szCosto = (string)HttpRuntime.Cache[clave];
        if (szCosto == null)
        {
            using (CConector conector = new CConector())
            {
                szCosto = conector.QueryString(string.Format("SELECT costo FROM intensidad_valor WHERE entidad={0} AND intensidad={1}", entidad, intensidad));
                HttpRuntime.Cache.Insert(clave, szCosto);
            }
        }
        if (string.IsNullOrEmpty(szCosto)) // si no esta definido el valor usamos el del procedimiento.
            return Convert.ToDecimal(GetCosto(procedimento, entidad));
        try
        {
            return Convert.ToDecimal(szCosto);
        }
        catch { }
        return 0;
    }*/

    static public double GetCosto(string procedimento, string entidad)
    {
        if (string.IsNullOrEmpty(entidad) || string.IsNullOrEmpty(procedimento))
            return 0;

        string clave = "CONFIGURAR_EN_ENTORNO" + entidad + ";" + procedimento;

        string szCosto = (string)HttpRuntime.Cache[clave];
        if (szCosto == null)
        {
            using (CConector conector = new CConector())
            {
                szCosto = conector.QueryString(string.Format("SELECT costo FROM medicamento_valor WHERE entidad={0} AND medicamento={1}", entidad, procedimento));
                HttpRuntime.Cache.Insert(clave, szCosto);
            }
        }
        try
        {
            return Convert.ToDouble(szCosto);
        }
        catch { }
        return 0;
    }

    static public int GetMaxServicios(string procedimento, string entidad)
    {
        if (string.IsNullOrEmpty(entidad) || string.IsNullOrEmpty(procedimento))
            return 0;

        string clave = "CONFIGURAR_EN_ENTORNO" + entidad + ";" + procedimento;

        string szCosto = (string)HttpRuntime.Cache[clave];
        if (szCosto == null)
        {
            using (CConector conector = new CConector())
            {
                szCosto = conector.QueryString(string.Format("SELECT maxima FROM medicamento_valor WHERE entidad={0} AND medicamento={1}", entidad, procedimento));
                HttpRuntime.Cache.Insert(clave, szCosto);
            }
        }
        try
        {
            return Convert.ToInt32(szCosto);
        }
        catch { }
        return 0;
    }

    static public string ReplaceProcedimientos(string textoIn) {
        
        int pos = textoIn.IndexOf("%%");
        while (pos != -1)
        {
            string texto = "";
            for (int i = pos + 2; i < textoIn.Length; i++)
            {
                if (textoIn[i] == ' ')
                    break;
                texto += textoIn[i];
            }
            textoIn = textoIn.Replace("%%" + texto, Procedimientos.GetProcedimiento(texto));
            pos = textoIn.IndexOf("%%");
        }
        return textoIn;
    }

    static public string ReplaceVarios(string textoIn)
    {
        int pos = textoIn.IndexOf("[$$");
        while (pos != -1)
        {
            string texto = "";
            for (int i = pos + 3; i < textoIn.Length; i++)
            {
                if (textoIn[i] == ']')
                    break;
                texto += textoIn[i];
            }
            textoIn = textoIn.Replace("[$$" + texto, "[" + Procedimientos.GetVarios(texto));
            pos = textoIn.IndexOf("[$$");
        }
        return textoIn;
    }

    static public string SetCargos(string query, string variable)
    {
        CUsuario usuario = (CUsuario)Usuario.GetUsuario();
        string condicion = "";
        if (!usuario.CanAdmin())
        {
            if (!string.IsNullOrEmpty(usuario["cargos"]))
            {
                condicion = "AND " + variable + " IN (" + usuario["cargos"] + ")";
            }
            else condicion = "AND " + variable + "=-1";
        }
        query= string.Format(query, condicion);
        return query;
    }

    static public string SetCargos(SqlDataSource datasource, string variable)
    {
        datasource.SelectCommand = SetCargos(datasource.SelectCommand, variable);
        return datasource.SelectCommand;
    }

    static public string SetProcedimientos(string query, string variable, bool skipAdmin = false) {
        CUsuario usuario = (CUsuario)Usuario.GetUsuario();
        string condicion = "";
        if (!(usuario.CanAdmin() || skipAdmin))
        {
            if (!string.IsNullOrEmpty(usuario["procedimientos"]))
            {
                condicion = "AND " + variable + " IN (" + usuario["procedimientos"] + ")";
            }
            else condicion = "AND " + variable + "=-1";
        }
        query = string.Format(query, condicion);
        return query;
    }

    static public string SetProcedimientos(SqlDataSource datasource, string variable, bool skipAdmin=false)
    {
        datasource.SelectCommand = SetProcedimientos(datasource.SelectCommand, variable, skipAdmin);
        return datasource.SelectCommand;
    }

    static public string GetCodigoCIE(string text)
    {
        string descripcion= (string)HttpRuntime.Cache["cie10" + text];
        if (descripcion == null) {
            using(CConector conector= new CConector())
                descripcion = conector.QueryString("SELECT CONCAT(cieCodDx,' - ', cirDescripcion) FROM cie10 WHERE cieCodDx='" + text + "'");
            HttpRuntime.Cache.Insert("cie10" + text, descripcion);
        }
        return descripcion;
    }

    static public ArrayList AddCIE10(ArrayList listaactual, string nuevo_codigo) {

        if (!string.IsNullOrEmpty(nuevo_codigo))
        {
            bool found = false;
            for (int i = 0; i < listaactual.Count; i++)
            {

                if (listaactual[i].ToString() == nuevo_codigo)
                {
                    found = true;
                    break;
                }
            }
            if (!found)
                listaactual.Add(nuevo_codigo);
        }
        return listaactual;
    }

    static public ArrayList GetCodigosCIE10(string paciente) {

        ArrayList lista = new ArrayList();
        using (CConector conectormysql = new CConector())
        {

            MySqlDataReader readermysql = conectormysql.Query("SELECT evolucion_paciente.id,codigo FROM evolucion_paciente"
            + " LEFT JOIN codigos_evolucion ON (codigos_evolucion.evolucion_paciente=evolucion_paciente.id) "
            + " WHERE evolucion_paciente.id=(SELECT id FROM evolucion_paciente WHERE evolucion_paciente.paciente="
            + paciente
            + "  ORDER BY fecha DESC LIMIT 1);");

            if (readermysql != null)
            {
                while (readermysql.Read())
                {
                    AddCIE10(lista, readermysql["codigo"].ToString());
                }
            }

            if (lista.Count == 0)
            {
                readermysql = conectormysql.Query("SELECT codigo FROM ingreso_paciente LEFT JOIN codigos_ingreso ON (codigos_ingreso.ingreso_paciente=ingreso_paciente.id) WHERE paciente=" + paciente);
                if (readermysql != null)
                {
                    while (readermysql.Read())
                    {
                        AddCIE10(lista, readermysql["codigo"].ToString());
                    }
                }
            }
        }
        return lista;
    }

    static public string GetPlanDeManejo(CConector conector, string idpaciente, string fecha) { 

        string resultado="";
        
        Query query= new Query("formulacion");
        
        query+="medicamentos.nombre";
        query += "medicamentos.concentracion";
        query += "medicamento_formulacion.via";
        query += "medicamento_formulacion.tiempo";
        query+="medicamento_formulacion.formulada";
        query+="medicamento_formulacion.posologia";
        
        MySqlDataReader reader= conector.Query(query.GetSelect("formulacion.paciente=" +Query.GetValor(idpaciente) 
                            + " AND formulacion.fecha=" + Query.GetValor(Query.GetMySQLDateFormat(fecha))
                            + " AND medicamento_formulacion.id IS NOT NULL"
                            , "LEFT JOIN medicamento_formulacion ON (formulacion.id=medicamento_formulacion.formulacion)"
                            + " LEFT JOIN medicamentos ON (medicamentos.id=medicamento_formulacion.medicamento)"
                            ));
        if(reader!=null) {
            while(reader.Read()) {
                resultado += reader["nombre"].ToString();
                resultado += ", ";
                resultado += reader["concentracion"].ToString();
                resultado += ". ";
                resultado += reader["posologia"].ToString();
                if (reader["via"].ToString().Length!=0)
                {
                    resultado += " [Vía: ";
                    resultado += reader["via"].ToString();
                    resultado += " , Tiempo: ";
                    resultado += reader["tiempo"].ToString();
                    resultado += " ]";
                }
                resultado += " (";
                resultado += reader["formulada"].ToString();
                resultado += ")\n";
            }
        }

        // buscamos los formatos CTC
        query = new Query("formato_ctc");

        query += "formato_ctc_items.nombre";
        query += "formato_ctc_items.cantidad";
        query += "formato_ctc_items.tiempo";
        query += "formato_ctc_items.efecto";
        query += "formato_ctc_items.respuesta";
        query += "formato_ctc_items.efecto_secundario";

        reader = conector.Query(query.GetSelect("formato_ctc.paciente=" + Query.GetValor(idpaciente)
            + " AND formato_ctc.fecha=" + Query.GetValor(Query.GetMySQLDateFormat(fecha))
            + " AND formato_ctc_items.id IS NOT NULL"
            , "LEFT JOIN formato_ctc_items ON (formato_ctc.id=formato_ctc_items.formato_ctc)"));
        if (reader != null)
        {
            while (reader.Read())
            {
                resultado += reader["nombre"].ToString();
                resultado += " ";
                resultado += reader["cantidad"].ToString();
                resultado += " (";
                resultado += reader["tiempo"].ToString();
                resultado += ")";
                resultado += ", efecto: ";
                resultado += reader["efecto"].ToString();
                resultado += ", respuesta: ";
                resultado += reader["respuesta"].ToString();
                resultado += ", Efecto secundario: ";
                resultado += reader["efecto_secundario"].ToString();
                resultado += ".";
                resultado += "\n";
            }
        }

        return resultado.Trim();
    }
}
