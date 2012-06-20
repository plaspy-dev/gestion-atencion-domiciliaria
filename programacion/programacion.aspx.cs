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

                    Usuario usuario = Usuario.GetUsuario();
                    LNuevo.Visible = usuario.CanInsert();

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
        CConectorMS conector = new CConectorMS();

        for (int i = 0; i < GProgramacion.Rows.Count; i++)
        {
            CheckBox check = (CheckBox)GProgramacion.Rows[i].Cells[0].FindControl("CSeleccionar");
            if (check.Checked)
            {
                conector.Query("DELETE phdProgramacion where prgId=" + GProgramacion.DataKeys[i].Value.ToString());
            }
        }
        GProgramacion.DataBind();
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
                seleccionados += GProgramacion.DataKeys[i].Value.ToString();
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
        UCProgramacion.IdProgramacion = GProgramacion.DataKeys[GProgramacion.SelectedIndex].Value.ToString();
        UCProgramacion.Visible = true;
    }
    protected void GProgramacion_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1) {

            if (HttpUtility.HtmlDecode(e.Row.Cells[8].Text).Trim().Length==0)
            {
                CConector conector = new CConector();
                e.Row.Cells[8].Text = HttpUtility.HtmlEncode(conector.QueryString("SELECT CONCAT(codigo,'-',nombre) FROM medicamentos WHERE id=" + Query.GetValor(HttpUtility.HtmlDecode(e.Row.Cells[10].Text).Trim())));
            }
        }
    }
    protected void DProgramaciones_DataBound(object sender, EventArgs e)
    {
        CConector conector = new CConector();
        for (int i = 0; i < DProgramaciones.Items.Count; i++)
        {
            if (DProgramaciones.Items[i].Text.Length == 0)
                DProgramaciones.Items[i].Text = conector.QueryString("SELECT CONCAT(codigo, '-', nombre) FROM medicamentos WHERE id=" + DProgramaciones.Items[i].Value);
        }
    }
}
