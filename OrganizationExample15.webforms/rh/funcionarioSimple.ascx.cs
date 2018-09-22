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
    public bool ReadOnly {
        set {
            TFuncionario.ReadOnly = value;
            TFuncionarioID.ReadOnly = value;
        }
        get {
            return TFuncionario.ReadOnly;
        }
    }
    public string IdFuncionario
    {
        set
        {
            TFuncionario.Text = "";
            TFuncionarioID.Text = "";
            if (!string.IsNullOrEmpty(value))
            {
                using (CConector conector = new CConector())
                {
                    TFuncionarioID.Text = value;
                    TFuncionario.Text = conector.QueryString("SELECT CONCAT(perDocumento, ' - ', perNombre) FROM recurso_humano WHERE perId=" + Query.GetValor(value));
                }
            }
        }
        get { return TFuncionarioID.Text; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.ClientScript.IsClientScriptIncludeRegistered("funcionarioSimple"))
            Page.ClientScript.RegisterClientScriptInclude("funcionarioSimple", ResolveUrl("~/rh/funcionarioSimple.ascx.js"));
        Page.ClientScript.RegisterClientScriptBlock(typeof(string), "fs" + ID, "initFuncionario('" + TFuncionario.ClientID + "', '" + TFuncionarioID.ClientID + "');", true);
    }
}
