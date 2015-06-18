using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class censo_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
        }
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@categoria", DCategoria.SelectedValue);

        SDiario.SelectCommand = SDiario.SelectCommand.Replace("@area", DArea.SelectedValue);
        SDiario.SelectCommand = SDiario.SelectCommand.Replace("@categoria", DCategoria.SelectedValue);

        SMensual.SelectCommand = SMensual.SelectCommand.Replace("@area", DArea.SelectedValue);
        SMensual.SelectCommand = SMensual.SelectCommand.Replace("@categoria", DCategoria.SelectedValue);


        RGrafica.DataSourceID = DTipo.SelectedValue=="0" ? "SDiario" : "SMensual";
        RGrafica.DataBind();

        GResultados.AllowPaging = false;
        GResultados.DataBind();
        LTotal.Text = GResultados.Rows.Count + " Resultados";
        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
        GResultados.AllowPaging = true;
        GResultados.DataBind();
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            /*e.Row.Cells[12].Text = Procedimientos.ReplaceVarios(
                                    Procedimientos.ReplaceProcedimientos(e.Row.Cells[12].Text))
                                    .Replace(",_", "<br/>");

            e.Row.Cells[9].Text = e.Row.Cells[9].Text.Replace(",_", "<br/>");*/

            // calculamos la edad
            int years = 0;
            try
            {
                DateTime birthDate = Convert.ToDateTime(HttpUtility.HtmlDecode(e.Row.Cells[3].Text));
                DateTime now = DateTime.Now;
                years = now.Year - birthDate.Year;
                if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                    --years;
            }
            catch  { }
            e.Row.Cells[3].Text = years==0 ? "" : years.ToString();
        }
    }
    protected void LLocalidad_Click(object sender, EventArgs e)
    {
        if (!CUsuario.GetUsuario().CanUpdate())
            return;
        LinkButton link = (LinkButton)sender;
        HPaciente.Value= link.CommandName;
        if (DLocalidad.Items.Count == 1)
            DLocalidad.DataBind();
        try {
            DLocalidad.SelectedValue = link.CommandArgument;
        } catch {
            DLocalidad.SelectedIndex = 0;
        }
        PLocalidad.Visible = true;
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        using(CConector conector = new CConector()) 
            conector.QueryMod("UPDATE paciente SET locId='" + DLocalidad.SelectedValue + "' WHERE pacId=" + HPaciente.Value);
        GResultados.DataBind();
        PLocalidad.Visible = false;
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        PLocalidad.Visible = false;
    }
}
