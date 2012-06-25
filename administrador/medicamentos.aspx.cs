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
            TCodigo.Focus();
            CUsuario usuario = CUsuario.GetUsuario();

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

            if (Request.QueryString["imp"] != null && Request.QueryString["imp"].Length > 0) {

                CConector conector = new CConector();

                MySqlDataReader reader= conector.Query("SELECT id, nombre, forma,codigo, principio, concentracion, aclaracion,area,tipo FROM medicamentos WHERE id="+ Query.GetValor(Request.QueryString["imp"].Trim()));

                if (reader != null && reader.Read()) {
                    
                    HId.Value = reader["id"].ToString();
                    TCodigo.Text = reader["codigo"].ToString();
                    TNombre.Text = reader["nombre"].ToString();
                    TPrincipio.Text = reader["principio"].ToString();
                    TForma.Text = reader["forma"].ToString();
                    TConcentracion.Text = reader["concentracion"].ToString();
                    TAclaracion.Text = reader["aclaracion"].ToString();
                    CConector.SelectInDropDown(DCargo, reader["area"]);

                    ListItem item= LTipos.Items.FindByValue(reader["tipo"].ToString());
                    if (item != null)
                    {
                        LTipos.SelectedIndex = -1;
                        item.Selected = true;
                    }
                    LTipos_SelectedIndexChanged(sender, e);

                    BAceptar.Enabled = CUsuario.GetUsuario().CanUpdate();

                    ((MasterPageI)Master).SetModificacion(HId.Value);
                }
            }
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
        query["area"] = DCargo.SelectedValue;

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
        Conector.SelectInComboText(DCargo, "");
        BAceptar.Enabled = CUsuario.GetUsuario().CanInsert();

        GResultado.SelectedIndex = -1;
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value = GResultado.SelectedDataKey.Value.ToString();
        TCodigo.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();
        TPrincipio.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[4].Text).Trim();
        TForma.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[5].Text).Trim();
        TConcentracion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[6].Text).Trim();
        TAclaracion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[7].Text).Trim();
        Conector.SelectInComboText(DCargo, HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[8].Text).Trim());

        BAceptar.Enabled = CUsuario.GetUsuario().CanUpdate();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
    protected void LTipos_SelectedIndexChanged(object sender, EventArgs e)
    {
        LTipo.Text = LTipos.SelectedItem.Text;
    }
    protected void GResultado_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1) {
            if (HttpUtility.HtmlDecode(e.Row.Cells[8].Text).Trim().Length != 0)
            {
                CConectorMS conector = new CConectorMS();
                e.Row.Cells[8].Text= conector.QueryString("SELECT carDescripcion FROM admCargo WHERE carId=" + HttpUtility.HtmlDecode(e.Row.Cells[8].Text).Trim());
            }
        }
    }
}
