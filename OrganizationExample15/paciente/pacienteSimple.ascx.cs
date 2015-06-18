using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

[ValidationPropertyAttribute("IdPaciente")]
public partial class paciente_pacienteSimple : System.Web.UI.UserControl
{
    public string IdPaciente {
        set {
            TPaciente.Text = "";
            TPacienteID.Text = "";
            if (!string.IsNullOrEmpty(value))
            {
                Paciente paciente = Paciente.GetPaciente(value);
                TPacienteID.Text = paciente.Id;
                TPaciente.Text = paciente.DocumentoYNombres;
            }
        }
        get { return TPacienteID.Text; }
    }

    public bool ReadOnly {
        get {
            return TPaciente.ReadOnly;
        }
        set {
            TPaciente.ReadOnly = TPacienteID.ReadOnly = value;
        }
    }

    public string IdAsegurador {

        get {
            return Paciente.GetPaciente(TPacienteID.Text).entidadId;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.ClientScript.IsClientScriptIncludeRegistered("pacienteSimple"))
            Page.ClientScript.RegisterClientScriptInclude("pacienteSimple", ResolveUrl("~/paciente/pacienteSimple.ascx.js"));
        Page.ClientScript.RegisterClientScriptBlock(typeof(string), "pacienteSimpleI", "initPaciente('" + TPaciente.ClientID + "', '" + TPacienteID.ClientID + "', '" + CUsuario.GetUsuario()["entidades"] + "');", true);
    }
}
