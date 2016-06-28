using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class rh_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CUsuario usuario = (CUsuario)CUsuario.GetInstance();

        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
        Procedimientos.SetProcedimientos(SResultados, "programacion.actId", !usuario.CanInsert());

        if (!IsPostBack)
        {
            TInicio.Text = TFin.Text = DateTime.Now.ToShortDateString();
            BBuscar_Click(sender, e);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
}