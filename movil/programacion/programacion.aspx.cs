using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class programacion_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Procedimientos.SetProcedimientos(SProgramacion, "programacion.actId");
        Procedimientos.SetProcedimientos(SProgramaciones, "programacion.actId");

        if (!IsPostBack) {
            if (!string.IsNullOrEmpty(Request.QueryString["pid"])) {
                UP.IdPaciente = Request.QueryString["pid"];
                if (string.IsNullOrEmpty(UP.IdPaciente))
                    Response.Redirect(Request.Url.AbsolutePath);
                ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);
                CUsuario usuario = (CUsuario)Usuario.GetUsuario();
                DProgramaciones.Visible = true;
            }
        }
    }
}