using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using SDG.Componentes;

public partial class auditoria_indicadores : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            THasta.Text= DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            BBuscar_Click(sender, e);
        }
        if (ViewState["consulta"] != null)
        {
            SDetalle.SelectCommand = ViewState["consulta"].ToString();
            SDetalle.ProviderName = ViewState["ProviderName"].ToString();
            SDetalle.ConnectionString = ViewState["ConnectionString"].ToString();
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        PDetalle.Visible = false;
        DResultados.DataBind();
        if (DResultados.Rows.Count == 0)
            return;

        LChart.Text= "['PHD', " + DResultados.Rows[3].Cells[1].Text + ", " + DResultados.Rows[4].Cells[1].Text + ", " + DResultados.Rows[5].Cells[1].Text + "],";
        LChart.Text+= "['Apoyo terapéutico', " + DResultados.Rows[6].Cells[1].Text + ", " + DResultados.Rows[7].Cells[1].Text + ", " + DResultados.Rows[8].Cells[1].Text + "]";

        DEventos.DataBind();

        // LResultado.Text += "['" + ((LinkButton)DResultados.Rows[i].Cells[0].Controls[1]).Text + "', " + ((DataBoundLiteralControl)DResultados.Rows[i].Cells[1].Controls[0]).Text + "]";

        LChart2.Text = "['Eventos'";
        for (int i = 0; i < DEventos.Rows.Count; i++)
            LChart2.Text += "," + ((DataBoundLiteralControl)DEventos.Rows[i].Cells[1].Controls[0]).Text;
        LChart2.Text += "]";
    }

    protected void LEventos_Click(object sender, EventArgs e)
    {
        ViewState["consulta"] = null;
        string[] consultas = SEventos.SelectCommand.Split('\r');
        string consulta = "";

        for (int i = 0; i < consultas.Length; i++)
        {
            if (consultas[i].IndexOf(((LinkButton)sender).CommandName) != -1)
            {
                consulta = consultas[i];
                break;
            }
        }
        if (consulta.Length == 0)
            return;

        consulta = consulta.Replace("COUNT(*)", "DISTINCT evento_adverso.id,fecha,paciente AS pacienteid,descripcion,paciente");
        consulta = consulta.Replace("COUNT(DISTINCT evento_adverso.id)", "DISTINCT evento_adverso.id,fecha,paciente AS pacienteid,descripcion,paciente");
        consulta = consulta.Replace("@desde", Query.GetValor(TDesde.Text));
        consulta = consulta.Replace("@hasta", Query.GetValor(THasta.Text));

        int pos = consulta.IndexOf("(");
        if (pos != -1)
        {
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
        ViewState["ConnectionString"] = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;
        ViewState["ProviderName"] = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ProviderName;

        SDetalle.ProviderName = ViewState["ProviderName"].ToString();
        SDetalle.ConnectionString = ViewState["ConnectionString"].ToString();

        PDetalle.Visible = true;
        GDetalle.DataBind();
    }
    protected void GDetalle_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex == -1)
            return;
        CConectorMS conector = new CConectorMS();
        ((LinkButton)e.Row.FindControl("LPaciente")).Text = conector.QueryString("SELECT pacnombres FROM phdPaciente WHERE pacId=" + ((LinkButton)e.Row.FindControl("LPaciente")).Text);
    }
}
