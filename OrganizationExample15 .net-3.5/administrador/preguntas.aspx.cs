using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class administrador_preguntas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();
            LTipos.DataBind();
            if(LTipos.Items.Count==0) {
                BAceptar.Enabled = false;
            }
            LTipos.SelectedIndex = 0;
            LTipos_SelectedIndexChanged(sender, e);
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("varios");
        using (CConector conector = new CConector())
        {
            string szQuery;
            string mensaje;

            query["nombre"] = TNombre.Text;
            query["descripcion"] = TDescripcion.Text;
            query["parametro1"] = LTipos.SelectedValue;

            if (HId.Value.Length == 0)
            {
                query["tipo"] = "16";
                szQuery = query.GetInsert();
                mensaje = TNombre.Text + " ingresado";
            }
            else
            {
                szQuery = query.GetUpdate("id='" + HId.Value + "'");
                mensaje = TNombre.Text + " editado";
            }
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            if (HId.Value.Length == 0)
                HId.Value = res.ToString();
            if (conector.InsertModificacion(HId.Value) == -1)
                return;

            GResultado.DataBind();
            Procedimientos.RemoveVarios(HId.Value);
            ((MasterPageI)Master).SetTitulo(mensaje);
        }
        BCancelar_Click(sender, e);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        HId.Value = "";
        TNombre.Text = "";
        TDescripcion.Text = "";
        GResultado.SelectedIndex = -1;
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value = GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
    protected void LTipos_SelectedIndexChanged(object sender, EventArgs e)
    {
        LTipo.Text = LTipos.SelectedItem.Text;
    }
}
