using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class gerencia_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master).Excel(GResultados);
        if (!IsPostBack)
        {
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        LServicios.Text = "";
        LCostos.Text = "";
    }

    protected void RServicios_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex != -1)
        {
            Label titulo= (Label)e.Item.FindControl("TTitulo");
            Label cantidad = (Label)e.Item.FindControl("LC");
            Label costo = (Label)e.Item.FindControl("LCo");

            if (titulo.Text.Length == 0)
                titulo.Text = Procedimientos.GetProcedimiento(((HiddenField)e.Item.FindControl("HId")).Value);
            if (LServicios.Text.Length == 0)
                LServicios.Text = "['Servicio', 'Cantidad']";
            LServicios.Text += ",['" + titulo.Text + "'," + cantidad.Text + "]";

            if (LCostos.Text.Length > 0)
            {
                if (LCostos.Text.Length == 0)
                    LCostos.Text = "['Costos', 'Cantidad']";
                LCostos.Text += ",['" + titulo.Text + "'," + costo.Text.Replace("$", "").Replace(".", "").Replace(",", ".") + "]";
            }

            if (cantidad.Text == "1")
                cantidad.Text += " servicio";
            else cantidad.Text += " servicios";
            if (costo.Text.Length > 0)
                costo.Text = ", " + costo.Text;
        }
    }

    protected Control GetControl(Control parent, string id) {

        for (int i = 0; i < parent.Controls.Count; i++) {
            if (parent.Controls[i].ID!=null && parent.Controls[i].ID.IndexOf(id) != -1)
                return parent.Controls[i];
        }
        return null;
    }

    protected void OnClickBA(object sender, EventArgs e)
    {
        Button boton= (Button)sender;
        Control parent = boton.Parent;

        boton.Visible = false;

        Image img = (Image)GetControl(parent, "IL");
        if (img != null)
            img.Visible = false;

        Repeater repeater = (Repeater) GetControl(parent, "RH");
        if (repeater != null)
        {
            repeater.Visible = true;
            ScriptManager.RegisterStartupScript(parent, typeof(string), "acordeon", "$('#" + parent.Parent.ClientID + "').find('.tmpacordeon').accordion({autoHeight: false,navigation: true,collapsible: true,active: -1,animated: false,change: function(event, ui) {ui.newContent.children('div:eq(0)').children(':submit').click();}}).removeClass('tmpacordeon');"
            , true);
        }
        else
        {
            parent.FindControl("GR").Visible = true;
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[2].Text = Procedimientos.GetProcedimiento(HttpUtility.HtmlDecode(e.Row.Cells[2].Text).Trim());
        }
    }
}
