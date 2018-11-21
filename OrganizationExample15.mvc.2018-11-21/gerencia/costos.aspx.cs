using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Web.UI.WebControls;
using System.Globalization;

public partial class gerencia_costos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            TFin.Text= DateTime.Now.ToShortDateString();
            LTipo.DataBind();
            foreach (ListItem item in LTipo.Items) 
                item.Selected = true;
#if DEBUG
            BBuscar_Click(sender, e);
#endif
        }
        string tipo = "0";
        foreach (ListItem item in LTipo.Items)
        {
            if (item.Selected)
            {
                tipo += "," + item.Value;
            }
        }
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@formulacion", tipo);
    }

    protected void BBuscar_Click(object sender, EventArgs e) {

        GResultados.Visible= true;
        GResultados.DataBind();
        ((MasterPageI)Master).Imprimir(GResultados);
        ((MasterPageI)Master).Excel(GResultados);
    }

    public decimal Totalizar(params object[] valores) {

        decimal total = 0;
        foreach (object valor in valores) {
            try { total += Convert.ToDecimal(valor); } catch { }
        }
        return total;
    }
}
