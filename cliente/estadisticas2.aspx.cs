using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class cliente_estadisticas2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            BBuscar_Click(sender, e);
        }
        if (ViewState["consulta"]!=null)
            SDetalle.SelectCommand = ViewState["consulta"].ToString();
    }

    protected void LEstadisticas_Click(object sender, EventArgs e) {

        ViewState["consulta"] = null;
        string[] consultas = SResultados.SelectCommand.Split('\r');
        string consulta = "";

        for (int i = 0; i < consultas.Length; i++)
        {
            if(consultas[i].IndexOf(((LinkButton)sender).CommandName)!=-1) {

                consulta = consultas[i];
                break;
            }
        }
        if (consulta.Length==0)
            return;

        consulta = consulta.Replace("COUNT(*)", "queja_reclamo.qrId,qrFecha,qrDetalle,qrObsHS,pacNombres");
        consulta = consulta.Replace("WHERE", "LEFT JOIN paciente ON (paciente.pacId=queja_reclamo.pacId) WHERE");
        /*consulta= consulta.Replace("@desde", Query.GetValor(TDesde.Text));
        consulta = consulta.Replace("@hasta", Query.GetValor(THasta.Text));*/

        int pos = consulta.IndexOf("(");
        if(pos!=-1) {
            consulta = consulta.Substring(pos + 1);
        }
        pos = consulta.IndexOf(") AS ");
        if (pos != -1)
        {
            consulta = consulta.Substring(0, pos);
        }

        ViewState["consulta"] = consulta;

        LDetalle.Text = ((LinkButton)sender).Text;
        SDetalle.SelectCommand = ViewState["consulta"].ToString();
        PDetalle.Visible = true;
        GDetalle.DataBind();
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        PDetalle.Visible = false;
        DResultados.DataBind();
        DSolucion.DataBind();
        if (DResultados.Rows.Count == 0)
        {
            LResultado2.Text = LResultado.Text = "";
            LTotal.Text = "0 Quejas";
            return;
        }

        LTotal.Text= DResultados.Rows[0].Cells[1].Text + " Quejas";

        LResultado.Text = "";
        for (int i = 2; i < DResultados.Rows.Count+1; i++)
        {
            if (LResultado.Text.Length > 0)
                LResultado.Text += ",";

            LResultado.Text += "['" 
                + ((LinkButton)DResultados.FindControl("L" + i)).Text 
                + "', " 
                + ((Label)DResultados.FindControl("S" + i)).Text + "]";
        }

        LResultado2.Text = "";
        for (int i = 1; i < DSolucion.Rows.Count+1; i++)
        {
            if (LResultado2.Text.Length > 0)
                LResultado2.Text += ",";
            LResultado2.Text += "['" 
                + ((LinkButton)DSolucion.FindControl("L" + i)).Text 
                + "', " 
                + ((Label)DSolucion.FindControl("S" +i)).Text + "]";
        }
    }
}
