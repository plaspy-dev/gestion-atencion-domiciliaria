using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class terapeutico_evoluciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            CUsuario usuario= (CUsuario)CUsuario.GetInstance();
            TInicio.Text = DateTime.Now.AddDays(-1).ToShortDateString();
            TFin.Text = DateTime.Now.ToShortDateString();
            if(!usuario.CanInsert()) {
                UCFuncionario.IdFuncionario= usuario["personal"];
                UCFuncionario.ReadOnly = true;
            }

            BBuscar_Click(sender, e);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (sender==BBuscar && !IsValid)
            return;

        GridUtils.GetRowsCount(GResultados, LTotal);
    }
}