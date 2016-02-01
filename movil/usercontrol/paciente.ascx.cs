using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class usercontrol_paciente : System.Web.UI.UserControl
{
    public string IdPaciente
    {
        get { return I.Text; }
        set
        {
            I.Text = "";
            P.Text = "";
            Paciente paciente = Paciente.GetPaciente(value);
            if (!string.IsNullOrEmpty(paciente.Id))
            {
                if (!((CUsuario)Usuario.GetUsuario()).CheckEntidad(paciente.entidadId))
                    return;

                I.Text = paciente.Id;
                P.Text = paciente.documento;
                
                // esto es para mostrar los detalles del paciente
                HP.NavigateUrl = "#" + PD.ClientID;
                HP.Visible = PD.Visible = true;

                LDocumento.Text = paciente.tipoDocNombre + ": " + paciente.documento;
                HP.Text = paciente.NombreCompleto;
                LPaciente.Text = paciente.NombreCompleto;
                LNacimiento.Text = "";
                try
                {
                    LNacimiento.Text = Convert.ToDateTime(paciente.FechaNac).ToShortDateString() + " ";
                }
                catch { }
                if (paciente.Edad != -1)
                    LNacimiento.Text += "(" + paciente.Edad + " años)";

                LSexo.Text = paciente.sexoId == "1" ? "Femenino" : "Masculino";
                LAsegurador.Text = paciente.NombreEntidad;
                LCarne.Text = paciente.Carne;
                LDireccion.Text = paciente.Direccion;
                LBarrio.Text = paciente.Barrio;
                LTelefono.Text = paciente.Telefono;
                LCelular.Text = paciente.Celular;
                LPagoD.Text = paciente.tipopago;
                LFamiliar.Text = paciente.FamiliarResponsable;
                LParentesco.Text = paciente.parentesco;

                LCIE10.Text = "";
                for (int i = 0; i < paciente.cie10.Count; i++)
                {
                    if (i != 0)
                        LCIE10.Text += "<br/>";
                    LCIE10.Text += Procedimientos.GetCodigoCIE(paciente.cie10[i].ToString());
                }
            }
        }
    }

    public bool ReadOnly
    {
        get { return I.ReadOnly; }
        set { I.ReadOnly = P.ReadOnly = true; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.ClientScript.IsClientScriptIncludeRegistered("paciente"))
            Page.ClientScript.RegisterClientScriptInclude("paciente", ResolveClientUrl("~/usercontrol/paciente.js"));
        A.Attributes["data-input"] = "#" + P.ClientID;
        Page.ClientScript.RegisterClientScriptBlock(typeof(string), "paciente" + ID,
            "initPaciente('" + ResolveUrl("~/") + "'"
            + ",'" + A.ClientID + "'"
            + ",'" + P.ClientID + "'"
            + ",'" + I.ClientID + "'"
            + ",'" + PD.ClientID + "'"
            + ",'" + CUsuario.GetInstance()["entidades"] + "'"
            + ");"
            , true);
    }
}