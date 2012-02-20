using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class phd_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

            UCProgramacion.TipoServicio = ProgramacionTipo.TipoServicios.phd;
            if (Request.QueryString["pid"] != null)
            {
                CCDetallePaciente.IdPaciente = Request.QueryString["pid"];

                if (CCDetallePaciente.IdPaciente.Length == 0)
                {
                    Response.Redirect(Request.Url.AbsolutePath);
                }
                else
                {
                    ((MasterPageI)Master).SetParametros("?pid=" + Request.QueryString["pid"]);

                    Usuario usuario = Usuario.GetUsuario();
                    LNuevo.Visible = usuario.CanInsert();

                    GProgramacion.Columns[2].Visible = lnkelimMasivo.Visible = usuario.CanDelete();
                    GProgramacion.Columns[1].Visible = lnkNovedad.Visible = usuario.CanUpdate();

                    PDatos.Visible = true;
                    UCProgramacion.IdPaciente = CCDetallePaciente.IdPaciente;

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre=CCDetallePaciente.Nombres;

                    ((MasterPageI)Master).SetModificacion(CCDetallePaciente.IdPaciente);
                }
            }
        }
    }

    protected void lnkelimMasivo_Click(object sender, EventArgs e)
    {
        CConectorMS conector=new CConectorMS();

        for(int i=0; i<GProgramacion.Rows.Count; i++) {
            CheckBox check= (CheckBox) GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
            if(check.Checked) {
                conector.Query("DELETE phdProgramacion where prgId=" + GProgramacion.DataKeys[i].Value.ToString());
            }
        }
        GProgramacion.DataBind();
    }

    protected void lnkNovedad_Click(object sender, EventArgs e)
    {
        string seleccionados = "";
        for (int i = 0; i < GProgramacion.Rows.Count; i++)
        {
            CheckBox check= (CheckBox) GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
            if (check.Checked)
            {
                if (seleccionados.Length > 0)
                    seleccionados += ",";
                seleccionados += GProgramacion.DataKeys[i].Value.ToString();
            }
        }
        if (seleccionados.Length == 0)
            return;
        UCNovedad.IdProgramaciones = seleccionados;
        UCNovedad.Visible = true;
    }
    protected void LNuevo_Click(object sender, EventArgs e)
    {
        UCProgramacion.Visible = true;
    }

    protected void UCProgramacion_AceptarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
        GProgramacion.DataBind();
    }
    protected void UCProgramacion_CancelarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
        UCProgramacion.IdProgramacion = "";
    }
    protected void GProgramacion_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GProgramacion.SelectedIndex = e.NewEditIndex;
        UCNovedad.IdProgramacion = GProgramacion.DataKeys[e.NewEditIndex].Value.ToString();
        UCNovedad.Visible = true;
        e.Cancel = true;
    }

    protected void UCNovedad_AceptarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
        GProgramacion.DataBind();
    }
    protected void UCNovedad_CancelarClicked(object sender, EventArgs e)
    {
        GProgramacion.SelectedIndex = -1;
    }

    protected void GProgramacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        UCProgramacion.IdProgramacion = GProgramacion.DataKeys[GProgramacion.SelectedIndex].Value.ToString();
        UCProgramacion.Visible = true;
    }
}
