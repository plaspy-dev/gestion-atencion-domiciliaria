using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class programacion_programacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Procedimientos.SetProcedimientos(SProgramacion, "programacion.actId");
        Procedimientos.SetProcedimientos(SProgramaciones, "programacion.actId");
        
        if (!IsPostBack)
        {
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

                    CUsuario usuario = (CUsuario) Usuario.GetUsuario();
                    LNuevo.Visible = usuario.CanInsert() && CCDetallePaciente.Activo;

                    GProgramacion.Columns[2].Visible = lnkelimMasivo.Visible = usuario.CanDelete();
                    GProgramacion.Columns[1].Visible = lnkNovedad.Visible = usuario.CanUpdate();

                    PDatos.Visible = true;
                    UCProgramacion.IdPaciente = CCDetallePaciente.IdPaciente;

                    SeleccionarPaciente.Documento = CCDetallePaciente.Documento;
                    SeleccionarPaciente.Nombre = CCDetallePaciente.Nombres;

                    ((MasterPageI)Master).SetModificacion(CCDetallePaciente.IdPaciente);
                }
            }
        }
    }

    protected void lnkelimMasivo_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            for (int i = 0; i < GProgramacion.Rows.Count; i++)
            {
                CheckBox check = (CheckBox)GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
                if (check.Checked)
                {
                    conector.Query("DELETE FROM programacion WHERE prgId=" + GProgramacion.DataKeys[i].Values["prgId"].ToString());
                    Funcionario.RebuildDirectorio(conector, GProgramacion.DataKeys[i].Values["perId"].ToString());
                    Autorizaciones.UpdateSesiones(conector, GProgramacion.DataKeys[i].Values["autNumero"].ToString());
                }
            }
            conector.Commit();
            GProgramacion.DataBind();
        }
    }

    protected void lnkNovedad_Click(object sender, EventArgs e)
    {
        string seleccionados = "";
        int inicial=-1;
        for (int i = 0; i < GProgramacion.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
            if (check.Checked)
            {
                inicial=i;
                if (seleccionados.Length > 0)
                    seleccionados += ",";
                seleccionados += GProgramacion.DataKeys[i].Values["prgId"].ToString();
            }
        }
        if (seleccionados.Length == 0)
            return;
        UCNovedad.IdProgramaciones = seleccionados;
        if(inicial!=-1)
            UCNovedad.IdServicio = HttpUtility.HtmlDecode(GProgramacion.Rows[inicial].Cells[10].Text).Trim();
        UCNovedad.Visible = true;
    }
    protected void LNuevo_Click(object sender, EventArgs e)
    {
        UCProgramacion.DAutorizacion_SelectedIndexChanged(null, null);
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
        UCNovedad.IdProgramacion = GProgramacion.DataKeys[e.NewEditIndex].Values["prgId"].ToString();
        UCNovedad.IdServicio = HttpUtility.HtmlDecode(GProgramacion.Rows[e.NewEditIndex].Cells[10].Text).Trim();
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
        UCProgramacion.IdProgramacion = GProgramacion.DataKeys[GProgramacion.SelectedIndex].Values["prgId"].ToString();
        UCProgramacion.Visible = true;
    }

    protected void DProgramaciones_DataBound(object sender, EventArgs e)
    {
        for (int i = 0; i < DProgramaciones.Items.Count; i++)
        {
            if (DProgramaciones.Items[i].Text.Length == 0) {
                DProgramaciones.Items[i].Text = Procedimientos.GetProcedimiento(DProgramaciones.Items[i].Value);
            }
        }
    }

    protected void GProgramacion_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        using (CConector conector = new CConector())
        {
            Funcionario.RebuildDirectorio(conector, e.Keys["perId"].ToString());
            Autorizaciones.UpdateSesiones(conector, e.Keys["autNumero"].ToString());
        }
    }
}
