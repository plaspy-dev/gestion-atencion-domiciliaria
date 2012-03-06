using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class paciente_SeleccionarPaciente : System.Web.UI.UserControl
{
    public string Documento {
        set { TPaciente.Text = value; }
    }
    public string Nombre {
        set { LPaciente.Text = value; }
    }
    public bool Inactivos {
        set { ViewState["pinactivo"] = value; }
        get { return ViewState["pinactivo"]==null || (bool)ViewState["pinactivo"]==true; }
    }
    public string PacienteURL {

        get { return Inactivos ? "'../webservices/servicios.asmx/GetPacienteI'" : "'../webservices/servicios.asmx/GetPaciente'"; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
            TPaciente.Focus();
    }
}
