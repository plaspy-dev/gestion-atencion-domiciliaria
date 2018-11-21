using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class rh_funcionarioc : System.Web.UI.UserControl
{
    public string IdFuncionario
    {
        set {
            Funcionario info = Funcionario.GetFuncionario(value);
            HIdFuncionario.Value = info.Id;
            LNombre.Text = info.Nombres;
            TFuncionario.Text = info.Documento;
        }
        get { return HIdFuncionario.Value; }
    }
    public string Nombre
    {
        get { return LNombre.Text; }
    }
    public string Documento {
        get { return TFuncionario.Text; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
}
