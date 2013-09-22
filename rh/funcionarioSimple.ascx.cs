using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

[ValidationPropertyAttribute("IdFuncionario")]
public partial class rh_funcionarioSimple : System.Web.UI.UserControl
{
    public string IdPaciente
    {
        set
        {
            TFuncionario.Text = "";
            TFuncionarioID.Text = "";
            if (!string.IsNullOrEmpty(value))
            {
                using (CConectorMS conector = new CConectorMS())
                {
                    TFuncionarioID.Text = value;
                    TFuncionario.Text = conector.QueryString("SELECT perDocumento + ' - ' + perNombre FROM admPersonalHS WHERE perId=" + Query.GetValor(value));
                }
            }
        }
        get { return TFuncionarioID.Text; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.ClientScript.IsClientScriptIncludeRegistered("funcionarioSimple"))
            Page.ClientScript.RegisterClientScriptInclude("funcionarioSimple", ResolveUrl("~/rh/funcionarioSimple.ascx.js"));
        Page.ClientScript.RegisterClientScriptBlock(typeof(string), "funcionarioSimpleI", "initFuncionario('" + TFuncionario.ClientID + "', '" + TFuncionarioID.ClientID + "');", true);
    }
}
