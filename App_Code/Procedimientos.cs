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
        public Dictionary<string, Entidad_Costo> pCostos = new Dictionary<string, Entidad_Costo>();
        public Procedimiento(string nombre) {
            sNombre = nombre;
        }
    }

    protected Dictionary<string, Procedimiento> pProcedimentos = new Dictionary<string, Procedimiento>();
    protected Dictionary<string, string> varios = new Dictionary<string, string>();

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
    static public string GetVarios(string id) {
        Procedimientos info = GetProcedimientos();
        string nombre = null;
        try
        {
            nombre = info.varios[id];
        }
        catch (Exception ex)
        {
            nombre = new CConector().QueryString("SELECT nombre FROM varios WHERE id=" + Query.GetValor(id));
            info.varios[id] = nombre;
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
        catch (Exception ex)
        {
            CConector conector = new CConector();
            resultado = new Procedimiento(conector.QueryString("SELECT CONCAT(codigo, '-', nombre) FROM medicamentos WHERE id=" + Query.GetValor(id)));
            info.pProcedimentos[id] = resultado;
            MySqlDataReader reader = conector.Query("SELECT entidad,costo,maxima FROM medicamento_valor WHERE medicamento=" + Query.GetValor(id));
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

    static public double GetCosto(string procedimento, string entidad)
    {
        Procedimiento info = AddProcedimiento(procedimento);
        double costo = 0;
        try
        {
            costo = info.pCostos[entidad].dCosto;
        }
        catch (Exception ex)
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
        catch (Exception ex)
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

    static public string SetCargos(SqlDataSource datasource, string variable)
    {
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        string condicion = "";
        if (!usuario.CanAdmin())
        {
            if (!string.IsNullOrEmpty(usuario["cargos"]))
            {
                condicion = "AND " + variable + " IN (" + usuario["cargos"] + ")";
            }
            else condicion = "AND " + variable + "=-1";
        }
        datasource.SelectCommand = string.Format(datasource.SelectCommand, condicion);
        return datasource.SelectCommand;
    }

    static public string SetProcedimientos(SqlDataSource datasource, string variable)
    {
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        string condicion = "";
        if (!usuario.CanAdmin())
        {
            if (!string.IsNullOrEmpty(usuario["procedimientos"]))
            {
                condicion = "AND " + variable + " IN (" + usuario["procedimientos"] + ")";
            }
            else condicion = "AND " + variable + "=-1";
        }
        datasource.SelectCommand = string.Format(datasource.SelectCommand, condicion);
        return datasource.SelectCommand;
    }
}
