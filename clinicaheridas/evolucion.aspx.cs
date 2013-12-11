using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class clinicaheridas_evolucion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) { 
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            // BAceptar.Enabled = false;

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];
                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    BAceptar.Enabled = usuario.CanInsert();
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    TFecha.Text = Conector.GetFromMySQLDate(DateTime.Now, true);
                    PDatos.Visible = true;

                    using (CConector conector = new CConector())
                    {
                    }
                }
            }
        }
    }
    
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
