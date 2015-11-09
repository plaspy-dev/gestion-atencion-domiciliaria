using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class archivo_digitalizacionc : System.Web.UI.UserControl
{
    public string Tipo { get; set; }
    public string Tipo2 { get; set; }

    public static int GetTipo(string Tipo) {
        if (Tipo == "facturacion")
            return 0;
        Dictionary<string, int> tipos = (Dictionary<string, int>)HttpRuntime.Cache["tipodigitalizacion"];
        int tipo = -1;
        if (tipos == null)
            tipos = new Dictionary<string, int>();
        try
        {
            tipo = tipos[Tipo];
        }
        catch { }
        if (tipo == -1)
        {
            using (CConector conector = new CConector())
            {
                try
                {
                    tipo = Convert.ToInt32(conector.QueryString("SELECT id FROM varios WHERE tipo=138 AND nombre={0}", Query.GetValor(Tipo)));
                }
                catch { }
            }
            tipos[Tipo] = tipo;
            HttpRuntime.Cache["tipodigitalizacion"] = tipos;
        }
        return tipo;
    }

    public string IdPaciente {
        set {
            SArchivo.SelectParameters["paciente"].DefaultValue = value;
            SArchivo.SelectParameters["tipo"].DefaultValue = GetTipo(Tipo).ToString();
            SArchivo.SelectParameters["tipo2"].DefaultValue = GetTipo(Tipo2).ToString();
            if(GetTipo(Tipo2)==-1)
                GArchivo.GetGridColumn("Tipo").Visible = false;

            int total = GridUtils.GetRowsCount(GArchivo);
            UA.Visible = total != 0;
            if (total != 0)
            {
                LArchivo.Text = string.Format("{0} Archivo{1}", total, total == 1 ? "" : "s");
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if(UA.Visible)
            ScriptManager.RegisterClientScriptBlock(UA, typeof(string), "aarchivo", "$(function() { $('#" + UA.ClientID + "').accordion({ autoHeight: false,collapsible: true, active: false}); });", true);
    }
}
