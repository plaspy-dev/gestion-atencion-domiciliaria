using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class administrador_medicamentos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TCodigo.Focus();
        if (!IsPostBack)
        {
            Usuario usuario = Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();
            LTipos.DataBind();
            if (LTipos.Items.Count > 0)
            {
                LTipos.SelectedIndex = 0;
                LTipos_SelectedIndexChanged(sender, e);
            }
            else BAceptar.Enabled = false;
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("medicamentos");
        CConector conector = new CConector();
        string szQuery;
        string mensaje;

        query["nombre"] = TNombre.Text;
        query["forma"]=TForma.Text;
        query["codigo"]=TCodigo.Text;
        query["principio"]=TPrincipio.Text;
        query["concentracion"]=TConcentracion.Text;
        query["aclaracion"]=TAclaracion.Text;

        if (HId.Value.Length == 0)
        {
            query["tipo"] = LTipos.SelectedValue;
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

        ((MasterPageI)Master).SetTitulo(mensaje);
        BCancelar_Click(sender, e);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        HId.Value = "";
        TNombre.Text = "";
        TForma.Text="";
        TCodigo.Text = "";
        TPrincipio.Text = "";
        TConcentracion.Text = "";
        TAclaracion.Text = "";

        GResultado.SelectedIndex = -1;
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value = GResultado.SelectedDataKey.Value.ToString();
        TCodigo.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text);
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text);
        TPrincipio.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[4].Text);
        TForma.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[5].Text);        
        TConcentracion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[6].Text);
        TAclaracion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[7].Text);

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
    protected void LTipos_SelectedIndexChanged(object sender, EventArgs e)
    {
        LTipo.Text = LTipos.SelectedItem.Text;
    }
}
