using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using SDG.Componentes;

public partial class rh_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(Request.QueryString["id"]!=null) {

            // agregar el id del usuario
            Response.Redirect("~/rh/funcionario.aspx?id=" + Request.QueryString["id"]);
            return;
        }
        if(!Usuario.GetUsuario().CanPrint())
            SResultados.SelectCommand = SResultados.SelectCommand.Replace("SELECT ", "SELECT TOP 10 ");

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
        ((MasterPageI)Master).Nuevo("~/rh/funcionario.aspx");
    }
}
