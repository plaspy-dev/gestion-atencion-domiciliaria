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
            Session["directorioid"] = Request.QueryString["fid"];
            Response.Redirect(Request.Url.AbsolutePath);
            return;
        }
        if (!Usuario.GetUsuario().CanPrint())
            SResultados.SelectCommand = SResultados.SelectCommand.Insert(7, "TOP 5 ");
        if (IsPostBack)
        {
            Session.Remove("directorioid");
            CConectorMS conector = new CConectorMS();
            conector.StartTransaction();
            conector.QueryMod("TRUNCATE TABLE programacion_directorio;");
            conector.QueryMod("INSERT INTO programacion_directorio "
                + " SELECT prgFechaProg, perId, pacId, actId FROM phdProgramacion WHERE prgFechaProg>=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))"
                + " UNION SELECT prgFechaProg, perId, pacId, actId FROM atxProgramacion WHERE prgFechaProg>=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))"
                + " UNION SELECT prgFechaProg, perId, pacId, actId FROM phdProgramacionMD WHERE prgFechaProg>=DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))");
            conector.Commit();
        } 
        else
        {
            if (Session["directorioid"] == null)
            {
                DEStado.DataBind();
                DEStado.SelectedValue = "1";
            }
        }
        Usuario usuario= Usuario.GetUsuario();
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
