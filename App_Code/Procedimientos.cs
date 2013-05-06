using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SDG.Componentes;
using MySql.Data.MySqlClient;

/// <summary>
/// Descripción breve de Procedimientos
/// </summary>
public class Procedimientos
{
    public class Entidad_Costo {

        public double dCosto;
        public int nServicios;

        public Entidad_Costo(double costo, int servicios) {

            dCosto = costo;
            nServicios = servicios;
        }
    }

    public class Procedimiento { 
        public string sNombre;
        public Boolean bAutomatica;
        public Dictionary<string, Entidad_Costo> pCostos = new Dictionary<string, Entidad_Costo>();
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

    static public void RemoveIntensidad(string procedimientoid)
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
    }

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
            CConector conector = new CConector();
            string nombre = "";
            bool automatico = false;
            MySqlDataReader reader = conector.Query("SELECT CONCAT(codigo, '-', nombre) AS nombre,automatica FROM medicamentos WHERE id=" + Query.GetValor(id));
            if (reader != null && reader.Read())
            {
                nombre= reader["nombre"].ToString();
                automatico = reader["automatica"].ToString() == "1";
            }
            resultado = new Procedimiento(nombre, automatico);
            info.pProcedimentos[id] = resultado;
            reader = conector.Query("SELECT entidad,costo,maxima FROM medicamento_valor WHERE medicamento=" + Query.GetValor(id));
            if (reader != null)
            {
                while (reader.Read())
                {
                    double costo= reader["costo"].ToString()=="" ? 0 : (double)reader["costo"];
                    int maxima = reader["maxima"].ToString()=="" ? 0 : (int)reader["maxima"];
                    info.pProcedimentos[id].pCostos[reader["entidad"].ToString()] = new Entidad_Costo(costo, maxima);
                }
            }
        }

        return resultado;
    }

    static public string GetProcedimiento(string id) {

        return AddProcedimiento(id).sNombre;
    }
    static public bool GetAutomatico(string id) {
        
        return AddProcedimiento(id).bAutomatica;
    }

    static public double GetCosto(string procedimento, string entidad)
    {
        Procedimiento info = AddProcedimiento(procedimento);
        double costo = 0;
        try
        {
            costo = info.pCostos[entidad].dCosto;
        }
        catch 
        {
        }
        return costo;
    }

    static public int GetMaxServicios(string procedimento, string entidad)
    {
        Procedimiento info = AddProcedimiento(procedimento);
        int servicios = 0;
        try
        {
            servicios = info.pCostos[entidad].nServicios;
        }
        catch 
        {
        }
        return servicios;
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

    static public string SetProcedimientos(string query, string variable) {

        CUsuario usuario = (CUsuario)Usuario.GetUsuario();
        string condicion = "";
        if (!usuario.CanAdmin())
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

    static public string SetProcedimientos(SqlDataSource datasource, string variable)
    {
        datasource.SelectCommand = SetProcedimientos(datasource.SelectCommand, variable);
        return datasource.SelectCommand;
    }

    static public string GetCodigoCIE(string text)
    {
        string descripcion= (string)HttpRuntime.Cache["cie10" + text];
        if (descripcion == null) {
            using(CConectorMS conector= new CConectorMS()) 
                descripcion = conector.QueryString("SELECT [cieCodDx]+' - '+ [cirDescripcion] FROM phdCIE10 WHERE cieCodDx='" + text + "'");
            HttpRuntime.Cache.Insert("cie10" + text, descripcion);
        }
        return text + " - " + descripcion;
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
        CConector conectormysql = new CConector();

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
        return lista;
    }
}
