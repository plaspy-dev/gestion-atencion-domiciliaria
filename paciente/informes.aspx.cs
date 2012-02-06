using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class paciente_informes : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["i"] != null)
        {
            Session["directorioid"] = Request.QueryString["i"];
            Response.Redirect(Request.Url.AbsolutePath);
            return;
        }
        if (IsPostBack)
        {
            Session.Remove("directorioid");
        } 
        else
        {
            if (Session["directorioid"] == null)
            {
                DEStado.DataBind();
                DEStado.SelectedValue = "1";
            }
        }
        if (Request.QueryString["pid"] != null)
        {
            Response.Redirect("~/paciente/paciente.aspx?pid=" + Request.QueryString["pid"]);
            return;
        }

        if (!Usuario.GetUsuario().CanPrint())
            SResultados.SelectCommand = SResultados.SelectCommand.Insert(7, "TOP 1 ");

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
}
