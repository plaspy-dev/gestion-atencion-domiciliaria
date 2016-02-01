using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class usercontrol_funcionario : System.Web.UI.UserControl
{
    public string IdFuncionario {
        get { return I.Text; }
        set {
            I.Text = "";
            P.Text = "";
            Funcionario funcionario= Funcionario.GetFuncionario(value);
            if (!string.IsNullOrEmpty(funcionario.Id)) {
                I.Text = funcionario.Id;
                P.Text = funcionario.DocumentoYNombres;
            }
        }
    }

    public bool ReadOnly {
        get { return I.ReadOnly; }
        set { I.ReadOnly = P.ReadOnly = true; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.ClientScript.IsClientScriptIncludeRegistered("funcionario"))
            Page.ClientScript.RegisterClientScriptInclude("funcionario", ResolveClientUrl("~/usercontrol/funcionario.js"));
        A.Attributes["data-input"] = "#" + P.ClientID;
        Page.ClientScript.RegisterClientScriptBlock(typeof(string), "funcionario" + ID, 
            "initFuncionario('" + ResolveUrl("~/") + "'"
            + ",'" + A.ClientID + "'"
            + ",'" + P.ClientID + "'"
            + ",'" + I.ClientID + "'"
            + ");"
            , true);
    }
}