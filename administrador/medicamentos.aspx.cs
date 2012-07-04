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
            ViewState["cargos"] = "";
            ViewState["costos"] = "";
            ViewState["entidades"] = "";

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

                MySqlDataReader reader= conector.Query("SELECT id, nombre, forma,codigo, principio, concentracion, aclaracion,area,tipo,grupo FROM medicamentos WHERE id="+ Query.GetValor(Request.QueryString["imp"].Trim()));

                if (reader != null && reader.Read()) {
                    
                    HId.Value = reader["id"].ToString();
                    TCodigo.Text = reader["codigo"].ToString();
                    TNombre.Text = reader["nombre"].ToString();
                    TPrincipio.Text = reader["principio"].ToString();
                    TForma.Text = reader["forma"].ToString();
                    TConcentracion.Text = reader["concentracion"].ToString();
                    TAclaracion.Text = reader["aclaracion"].ToString();
                    CConector.SelectInDropDown(DGrupo, reader["grupo"]);

                    ListItem item= LTipos.Items.FindByValue(reader["tipo"].ToString());
                    if (item != null)
                    {
                        LTipos.SelectedIndex = -1;
                        item.Selected = true;
                    }
                    LTipos_SelectedIndexChanged(sender, e);
                    ViewState["cargos"] = conector.QueryString("SELECT GROUP_CONCAT(area) FROM medicamento_area WHERE medicamento=" + HId.Value);
                    ViewState["costos"] = conector.QueryString("SELECT GROUP_CONCAT(costo) FROM medicamento_valor WHERE medicamento=" + HId.Value+ " ORDER BY medicamento");
                    ViewState["entidades"] = conector.QueryString("SELECT GROUP_CONCAT(entidad) FROM medicamento_valor WHERE medicamento=" + HId.Value + " ORDER BY medicamento");

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
        CConectorMS conectorms = new CConectorMS();

        string szQuery;
        string mensaje;

        query["nombre"] = TNombre.Text;
        query["forma"]=TForma.Text;
        query["codigo"]=TCodigo.Text;
        query["principio"]=TPrincipio.Text;
        query["concentracion"]=TConcentracion.Text;
        query["aclaracion"]=TAclaracion.Text;
        query["grupo"] = DGrupo.SelectedValue;

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

        // agregamos los cargos que puede programar el usuario
        if (conector.QueryMod("DELETE FROM medicamento_area WHERE medicamento=" + HId.Value) == -1)
            return;

        Query areas = new Query("medicamento_area");
        areas["medicamento"] = HId.Value;

        for (int i = 0; i < GCargos.Rows.Count; i++)
        {
            CheckBox box = (CheckBox)GCargos.Rows[i].FindControl("CCargo");
            if (box.Checked)
            {
                areas["area"]= GCargos.DataKeys[i].Value.ToString();
                if (conector.QueryMod(areas.GetInsert()) == -1)
                    return;
            }
        }

        // agregamos los cargos que puede programar el usuario
        if (conector.QueryMod("DELETE FROM medicamento_valor WHERE medicamento=" + HId.Value) == -1)
            return;

        Query valores = new Query("medicamento_valor");
        valores["medicamento"] = HId.Value;

        for (int i = 0; i < GEntidades.Rows.Count; i++)
        {
            TextBox texto = (TextBox)GEntidades.Rows[i].FindControl("TCosto");

            if(texto.Text.Length>0) {
                valores["entidad"] = GEntidades.DataKeys[i].Value.ToString();
                valores["costo"] = texto.Text.Replace(",", "");
                if (conector.QueryMod(valores.GetInsert()) == -1)
                    return;
                if (conectorms.QueryMod("UPDATE programacion SET costo=" + Query.GetValor(texto.Text.Replace(",", ""))
                                        + " WHERE actId=" + HId.Value + " AND costo IS NULL AND entId=" + GEntidades.DataKeys[i].Value.ToString()) == -1)
                    return;
            }
        }

        GResultado.DataBind();

        ((MasterPageI)Master).SetTitulo(mensaje);
        BCancelar_Click(sender, e);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        ViewState["cargos"] = "";
        ViewState["costos"] = "";
        ViewState["entidades"] = "";

        HId.Value = "";
        TNombre.Text = "";
        TForma.Text="";
        TCodigo.Text = "";
        TPrincipio.Text = "";
        TConcentracion.Text = "";
        TAclaracion.Text = "";
        DGrupo.SelectedValue = "";
        GCargos.DataBind();
        GEntidades.DataBind();
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
        CConector.SelectInComboText(DGrupo, HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[8].Text).Trim());

        CConector conector = new CConector();
        ViewState["cargos"] = conector.QueryString("SELECT GROUP_CONCAT(area) FROM medicamento_area WHERE medicamento=" + HId.Value);
        ViewState["costos"] = conector.QueryString("SELECT GROUP_CONCAT(costo) FROM medicamento_valor WHERE medicamento=" + HId.Value + " ORDER BY medicamento");
        ViewState["entidades"] = conector.QueryString("SELECT GROUP_CONCAT(entidad) FROM medicamento_valor WHERE medicamento=" + HId.Value + " ORDER BY medicamento");
        GCargos.DataBind();
        GEntidades.DataBind();

        BAceptar.Enabled = CUsuario.GetUsuario().CanUpdate();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
    protected void LTipos_SelectedIndexChanged(object sender, EventArgs e)
    {
        LTipo.Text = LTipos.SelectedItem.Text;
    }

    protected void GEntidades_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            string[] valores = ViewState["entidades"].ToString().Split(',');
            for (int i = 0; i < valores.Length; i++)
            {
                if (valores[i] == GEntidades.DataKeys[e.Row.RowIndex].Value.ToString())
                {
                    TextBox text = (TextBox)e.Row.FindControl("TCosto");
                    valores= ViewState["costos"].ToString().Split(',');
                    text.Text= valores[i];
                    break;
                }
            }
        }
    }
    protected void GCargos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            string[] valores = ViewState["cargos"].ToString().Split(',');
            for (int i = 0; i < valores.Length; i++)
            {
                if (valores[i] == GCargos.DataKeys[e.Row.RowIndex].Value.ToString())
                {
                    CheckBox box = (CheckBox)e.Row.FindControl("CCargo");
                    box.Checked = true;
                    break;
                }
            }
        }
    }
}
