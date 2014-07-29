using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class archivo_digitalizacionc : System.Web.UI.UserControl
{
    public string IdPaciente {
        set {
            SArchivo.SelectParameters["paciente"].DefaultValue = value;
            int total = Utilidades.GetRowsCount(GArchivo);
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
