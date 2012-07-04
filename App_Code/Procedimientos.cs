using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SDG.Componentes;

/// <summary>
/// Descripción breve de Procedimientos
/// </summary>
public class Procedimientos
{
    protected Dictionary<string, string> proc = new Dictionary<string, string>();
    protected Dictionary<string, string> varios = new Dictionary<string, string>();
    protected Dictionary<string, string> costos = new Dictionary<string, string>();
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
    static public string GetProcedimiento(string id) {
        Procedimientos info=GetProcedimientos();
        string nombre = null;
        try {
            nombre = info.proc[id];
        } catch( Exception ex) {
            nombre = new CConector().QueryString("SELECT CONCAT(codigo, '-', nombre) FROM medicamentos WHERE id=" + Query.GetValor(id));
            info.proc[id] = nombre;
        }
        return nombre;
    }
    static public string GetCosto(string procedimento, string entidad)
    {
        Procedimientos info = GetProcedimientos();
        string id = procedimento + "," + entidad;
        string nombre = null;
        try
        {
            nombre = info.proc[id];
        }
        catch (Exception ex)
        {
            nombre = new CConector().QueryString("SELECT costo FROM medicamento_valor WHERE medicamento=" + Query.GetValor(procedimento) + " AND entidad=" + Query.GetValor(entidad));
            info.proc[id] = nombre;
        }
        return nombre;
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
        CUsuario usuario = CUsuario.GetUsuario();
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
        CUsuario usuario = CUsuario.GetUsuario();
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
