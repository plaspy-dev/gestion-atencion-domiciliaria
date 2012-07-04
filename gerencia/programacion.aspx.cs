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
        if (!IsPostBack)
        {
            TInicio.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
        }
    }
    protected void RServicios_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemIndex != -1) {
            if(((Label)e.Item.FindControl("TTitulo")).Text.Length==0)
                ((Label)e.Item.FindControl("TTitulo")).Text = Procedimientos.GetProcedimiento(((HiddenField)e.Item.FindControl("HId")).Value);
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
}
