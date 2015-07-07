using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class terapeutico_programadovsevoluciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            TInicio.Text = DateTime.Now.AddDays(-7).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            if (!usuario.CanInsert())
            {
                UCFuncionario.IdFuncionario = usuario["personal"];
                UCFuncionario.ReadOnly = true;
            }
            ((MasterPageI)Master).RestoreState();
            BBuscar_Click(sender, e);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (sender == BBuscar && !IsValid)
            return;
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0) {
            ((MasterPageI)Master).Imprimir(GResultados);
            ((MasterPageI)Master).Excel(GResultados);
        } else {
            ((MasterPageI)Master).Imprimir((GridView)null);
            ((MasterPageI)Master).Excel(null);
        }
    }
}