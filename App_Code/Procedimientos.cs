using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using SDG.Componentes;

/// <summary>
/// Descripción breve de Procedimientos
/// </summary>
public class Procedimientos
{
    protected Dictionary<string, string> proc = new Dictionary<string, string>();
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
}
