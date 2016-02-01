using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class programacion_consulta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CUsuario usuario = (CUsuario)CUsuario.GetInstance();
        if (!usuario.CanInsert())
        {
            UCFuncionario.IdFuncionario= usuario["personal"];
            UCFuncionario.ReadOnly= true;
        }
        Procedimientos.SetProcedimientos(SResultados, "programacion.actId", !usuario.CanInsert());

        if (!IsPostBack)
        {
            TDesde.Text= THasta.Text= Query.GetMySQLDateFormat(DateTime.Now);
#if DEBUG
            TDesde.Text = THasta.Text = Query.GetMySQLDateFormat(new DateTime(2015, 10, 1));
#endif
            BActualizar_Click(sender, e);
        }
    }

    protected void BActualizar_Click(object sender, EventArgs e)
    {
        Title = Query.GetFromMySQLDate(TDesde.Text + " 00:00:00").ToShortDateString();
    }
}