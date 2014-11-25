using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class programacion_consulta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);

        Procedimientos.SetProcedimientos(SResultados, "programacion.actId");
        if (!IsPostBack)
        {
            TInicio.Text = TFin.Text = DateTime.Now.ToShortDateString();
        }
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
            // ya no se busca mas los procedimientos
            /*string []valores= e.Row.Cells[Utilidades.GetGridColumnIndex(GResultados, "Actividad")].Text.Split('_');
            e.Row.Cells[Utilidades.GetGridColumnIndex(GResultados, "Actividad")].Text = Procedimientos.GetProcedimiento(valores[0]);
            if(valores.Length>1 && valores[1].Length>0)
                e.Row.Cells[Utilidades.GetGridColumnIndex(GResultados, "Actividad")].Text += " [" + Procedimientos.GetVarios(valores[1]) + "]";*/
            LinkButton boton = (LinkButton)e.Row.FindControl("LNovedad");
            boton.Text = boton.Text.Replace(",_", "<br/>");
        }
    }
    protected void GResultados_SelectedIndexChanged(object sender, EventArgs e)
    {
        UCNovedad.IdProgramacion = GResultados.DataKeys[GResultados.SelectedIndex].Value.ToString();
        UCNovedad.IdServicio = HttpUtility.HtmlDecode(GResultados.Rows[GResultados.SelectedIndex].Cells[5].Text).Trim();
        UCNovedad.Visible = true;
        UCNovedad.Editable = false;
    }
    protected void UCNovedad_AceptarClicked(object sender, EventArgs e)
    {
        GResultados.SelectedIndex = -1;
    }
    protected void UCNovedad_CancelarClicked(object sender, EventArgs e)
    {
        GResultados.SelectedIndex = -1;
    }
}
