using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class gerencia_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master).Excel(GResultados);
        if (!IsPostBack)
        {
            ViewState["servicios"] = "";
            ViewState["costos"] = "";
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            DGrupo.SelectedValue= Conector.GetCookie("gerencia_programacion_grupo", "0");
            ((MasterPageI)Master).Imprimir(GResultados);
        }
        switch (DGrupo.SelectedValue) { 
            case "0":
                ViewState["titulo"] = "Servicios";
                ViewState["grupo"] = "servicio";
                break;
            case "1":
                ViewState["titulo"] = "Aseguradores";
                ViewState["grupo"] = "servicio";
                break;
            case "2":
                ViewState["titulo"] = "Aseguradores";
                ViewState["grupo"] = "paciente";
                break;
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        Conector.SetCookie("gerencia_programacion_grupo", DGrupo.SelectedValue);
        ViewState["servicios"] = "";
        ViewState["costos"] = "";
    }

    protected void RServicios_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex != -1)
        {
            Label titulo= (Label)e.Item.FindControl("LT");
            Label cantidad = (Label)e.Item.FindControl("LC");
            Label costo = (Label)e.Item.FindControl("LCo");

            if (titulo.Text.Length == 0)
            {
                HiddenField field = e.Item.Parent==RServicios ? (HiddenField)e.Item.FindControl("HId") : (HiddenField)e.Item.FindControl("HId2");

                titulo.Text = Procedimientos.GetProcedimiento(field.Value);
            }

            if (e.Item.Parent == RServicios)
            {

                if (ViewState["servicios"].ToString().Length == 0)
                    ViewState["servicios"] = "['" + ViewState["titulo"].ToString() + "', 'Cantidad']";
                ViewState["servicios"] = ViewState["servicios"].ToString() + ",['" + titulo.Text + "'," + cantidad.Text + "]";

                if (costo.Text.Length > 0)
                {
                    if (ViewState["costos"].ToString().Length == 0)
                        ViewState["costos"] = "['Costos', 'Cantidad']";
                    ViewState["costos"] = ViewState["costos"].ToString() + ",['" + titulo.Text + "'," + costo.Text.Replace("$", "").Replace(".", "").Replace(",", ".") + "]";
                }
                cantidad.Text += " " + ViewState["grupo"].ToString();
            }
            else {
                cantidad.Text += " " + "servicio";
            }

            if (cantidad.Text!= "1")
                cantidad.Text += "s";
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
            repeater.DataSourceID = "SEntidades";
            repeater.DataBind();
            ScriptManager.RegisterStartupScript(parent, typeof(string), "acordeon", "$('#" + parent.Parent.ClientID + "').find('.tmpacordeon').accordion({autoHeight: false,navigation: true,collapsible: true,active: false,animated: false,change: function(event, ui) {ui.newContent.children('div:eq(0)').children(':submit').click();}}).removeClass('tmpacordeon');"
            , true);
        }
        else
        {
            GridView gr = (GridView)parent.FindControl("GR");
            gr.DataSourceID = "SR";
            gr.DataBind();
            gr.Visible = true;
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            bool primero = false;
            try
            {
                string valor = HttpUtility.HtmlDecode(e.Row.Cells[2].Text).Trim();
                string []valores= valor.Split('$');
                if(valores.Length>1) {

                    Convert.ToInt32(valores[0]);
                    e.Row.Cells[2].Text = Procedimientos.GetProcedimiento(valores[0]);
                    if(valores[1].Length>0) 
                        e.Row.Cells[2].Text += " [" + Procedimientos.GetVarios(valores[1]) + "]";
                    primero = true;
                }
            }
            catch { }
            
            if(!primero) {

                try
                {
                    string valor = HttpUtility.HtmlDecode(e.Row.Cells[5].Text).Trim();
                    Convert.ToInt32(valor);
                    e.Row.Cells[5].Text = Procedimientos.GetProcedimiento(valor);
                    primero = true;
                }
                catch { }
                if(primero) {
                    try
                    {
                        string valor = HttpUtility.HtmlDecode(e.Row.Cells[6].Text).Trim();
                        Convert.ToInt32(valor);
                        e.Row.Cells[6].Text = Procedimientos.GetVarios(valor);
                    }
                    catch { }
                }
            }
        }
    }
}
