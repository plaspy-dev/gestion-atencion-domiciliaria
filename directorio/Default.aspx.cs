using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class directorio_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Procedimientos.SetCargos(SResultados, "per.carId");
        Procedimientos.SetCargos(SCargo, "carId");
        
        if (!Usuario.GetUsuario().CanPrint())
            SResultados.SelectCommand += " LIMIT 5";
        if (IsPostBack)
        {
            Conector.SetCookie("directorio_area", DArea.SelectedValue);
            Conector.SetCookie("directorio_estado", DEStado.SelectedValue);
            Conector.SetCookie("directorio_cargo", DCargo.SelectedValue);
            Conector.SetCookie("directorio_disponibilidad", DDisponibilidad.SelectedValue);
        } 
        else
        {
            if (Request.QueryString["fiid"] != null)
            {
                TNombreID.Text = Request.QueryString["fiid"];
                TNombres.Text = Funcionario.GetFuncionario(Request.QueryString["fiid"]).DocumentoYNombres;
            }
            Utilidades.SelectInDropDown(DArea, CConector.GetCookie("directorio_area"));
            Utilidades.SelectInDropDown(DEStado, (CConector.GetCookie("directorio_estado") == "" || CConector.GetCookie("directorio_estado") == "0") ? "1" : CConector.GetCookie("directorio_estado"));
            Utilidades.SelectInDropDown(DCargo, CConector.GetCookie("directorio_cargo"));
            Utilidades.SelectInDropDown(DDisponibilidad, CConector.GetCookie("directorio_disponibilidad"));
        }
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        GResultados.GetGridColumn("Disponibilidad").Visible = !usuario.CanUpdate();
        GResultados.GetGridColumn("Disponibilidad ").Visible = usuario.CanUpdate();

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
