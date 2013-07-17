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

            using (CConectorMS conector = new CConectorMS())
            {
                SqlDataReader reader = conector.Query("SELECT perId,perNombre,perDocumento FROM admPersonalHS WHERE perId=" + Query.GetValor(value));
                HIdFuncionario.Value = "";
                TFuncionario.Text = "";
                if (reader != null && reader.Read())
                {

                    HIdFuncionario.Value = reader["perId"].ToString();
                    LNombre.Text = reader["perNombre"].ToString();
                    TFuncionario.Text = reader["perDocumento"].ToString();
                }
            }
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
