using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class directorio_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["fiid"] != null)
        {
            Session["directorioid"] = Request.QueryString["fiid"];
            Response.Redirect(Request.Url.AbsolutePath);
            return;
        }
        if (!CUsuario.GetUsuario().CanPrint())
            SResultados.SelectCommand = SResultados.SelectCommand.Insert(7, "TOP 5 ");
        if (IsPostBack)
        {
            Session.Remove("directorioid");
            Conector.SetCookie("directorio_area", DArea.SelectedValue);
            Conector.SetCookie("directorio_estado", DEStado.SelectedValue);
            Conector.SetCookie("directorio_cargo", DCargo.SelectedValue);
            Conector.SetCookie("directorio_disponibilidad", DDisponibilidad.SelectedValue);
        } 
        else
        {
            if (Session["directorioid"] == null)
            {
                DEStado.DataBind();
                DEStado.SelectedValue = "1";
            }
            CConector conector = new CConector();
            conector.SelectInDropDown(DArea, CConector.GetCookie("directorio_area"));
            conector.SelectInDropDown(DEStado, CConector.GetCookie("directorio_estado"));
            conector.SelectInDropDown(DCargo, CConector.GetCookie("directorio_cargo"));
            conector.SelectInDropDown(DDisponibilidad, CConector.GetCookie("directorio_disponibilidad"));
        }
        CUsuario usuario = CUsuario.GetUsuario();
        GResultados.Columns[3].Visible = !usuario.CanUpdate();
        GResultados.Columns[4].Visible = usuario.CanUpdate();

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
    protected void DeDisponibilidad_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Cancel")
        {
            GResultados.SelectedIndex = -1;
            GResultados.DataBind();
        }
    }
    protected void DeDisponibilidad_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        GResultados.DataBind();
        GResultados.SelectedIndex = -1;
        DeDisponibilidad.DataBind();
    }
}
