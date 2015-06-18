using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
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
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

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


            foreach (Procedimientos.TipoServicio info in (Procedimientos.TipoServicio[])Enum.GetValues(typeof(Procedimientos.TipoServicio)))
            {
                if (info == 0)
                    continue;
                DTipo.Items.Add(new ListItem(Procedimientos.GetNombreTipoServicio(info), ((int)info).ToString()));
            }
        
            if (Request.QueryString["imp"] != null && Request.QueryString["imp"].Length > 0)
            {

                using (CConector conector = new CConector())
                {

                    MySqlDataReader reader = conector.Query("SELECT id, nombre, forma,codigo, principio, concentracion, aclaracion,area,tipo,grupo,automatica,hoja_sola,precio_regulado,codigoSIIGO,cuenta_inventario,cuenta_costo,tipo_servicio FROM medicamentos WHERE id=" + Query.GetValor(Request.QueryString["imp"].Trim()));

                    if (reader != null && reader.Read())
                    {

                        HId.Value = reader["id"].ToString();
                        TCodigo.Text = reader["codigo"].ToString();
                        TCodigoSIIGO.Text = reader["codigoSIIGO"].ToString();
                        TCCosto.Text = reader["cuenta_costo"].ToString();
                        TCInventario.Text = reader["cuenta_inventario"].ToString();
                        TNombre.Text = reader["nombre"].ToString();
                        TPrincipio.Text = reader["principio"].ToString();
                        TForma.Text = reader["forma"].ToString();
                        TConcentracion.Text = reader["concentracion"].ToString();
                        TAclaracion.Text = reader["aclaracion"].ToString();
                        CAutomatica.Checked = reader["automatica"].ToString() == "1";
                        try { TPrecioRegulado.Text = Convert.ToDecimal(reader["precio_regulado"]).ToString(CultureInfo.InvariantCulture); } catch { }
                        CImprimirHoja.Checked = reader["hoja_sola"].ToString() == "1";
                        Utilidades.SelectInDropDown(DGrupo, reader["grupo"]);
                        Utilidades.SelectInDropDown(DTipo, reader["tipo_servicio"]);

                        ListItem item = LTipos.Items.FindByValue(reader["tipo"].ToString());
                        if (item != null)
                        {
                            LTipos.SelectedIndex = -1;
                            item.Selected = true;
                        }
                        LTipos_SelectedIndexChanged(sender, e);
                        ViewState["cargos"] = conector.QueryString("SELECT GROUP_CONCAT(area) FROM medicamento_area WHERE medicamento=" + HId.Value);
                        ViewState["costos"] = conector.QueryString("SELECT GROUP_CONCAT(CONCAT(IFNULL(costo,0),';',IFNULL(maxima,0)) ORDER BY entidad) FROM medicamento_valor WHERE medicamento=" + HId.Value);
                        ViewState["entidades"] = conector.QueryString("SELECT GROUP_CONCAT(entidad ORDER BY entidad) FROM medicamento_valor WHERE medicamento=" + HId.Value);

                        BAceptar.Enabled = Usuario.GetUsuario().CanUpdate();
                        SProveedor.SelectParameters["producto"].DefaultValue = HId.Value;

                        ((MasterPageI)Master).SetModificacion(HId.Value);
                    }
                }
            }
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("medicamentos");
        using(CConector conector= new CConector()) 
        {

            conector.StartTransaction();

            string szQuery;
            string mensaje;

            query["nombre"] = TNombre.Text;
            query["forma"] = TForma.Text;
            query["codigo"] = TCodigo.Text;
            query["codigoSIIGO"] = TCodigoSIIGO.Text;
            query["principio"] = TPrincipio.Text;
            query["concentracion"] = TConcentracion.Text;
            query["aclaracion"] = TAclaracion.Text;
            query["grupo"] = DGrupo.SelectedValue;
            query["automatica"] = CAutomatica.Checked ? "1" : "";
            query["hoja_sola"] = CImprimirHoja.Checked ? "1" : "";
            query["precio_regulado"] = TPrecioRegulado.Text.Replace(",", "").Replace("$", "");
            query["cuenta_costo"] = TCCosto.Text;
            query["cuenta_inventario"] = TCInventario.Text;
            query["tipo_servicio"] = DTipo.SelectedValue;

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
                    areas["area"] = GCargos.DataKeys[i].Value.ToString();
                    if (conector.QueryMod(areas.GetInsert()) == -1)
                        return;
                }
            }

            // agregamos los cargos que puede programar el usuario
            if (conector.QueryMod("DELETE FROM costo_proveedor WHERE producto=" + HId.Value) == -1)
                return;
            Query costos = new Query("costo_proveedor");
            costos["producto"] = HId.Value;
            
            for (int i = 0; i < GProveedor.Rows.Count; i++) {

                TextBox costo = (TextBox)GProveedor.Rows[i].FindControl("TCosto");
                if (costo.Text.Length != 0) {

                    costos["proveedor"] = GProveedor.DataKeys[i].Values["id"].ToString();
                    costos["costo"] = costo.Text.Replace("$", "").Replace(",", "");

                    if (conector.QueryMod(costos.GetInsert()) == -1)
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
                TextBox costo = (TextBox)GEntidades.Rows[i].FindControl("TCosto");
                TextBox maxima = (TextBox)GEntidades.Rows[i].FindControl("TMaxima");

                if (costo.Text.Length > 0 || maxima.Text.Length > 0)
                {
                    valores["entidad"] = GEntidades.DataKeys[i].Value.ToString();
                    valores["costo"] = costo.Text.Replace(",", "").Replace("$", "");
                    valores["maxima"] = maxima.Text.Replace(",", "").Replace("$", "");
                    if (conector.QueryMod(valores.GetInsert()) == -1)
                        return;
                    if (conector.QueryMod("UPDATE programacion SET costo=" + Query.GetValor(costo.Text.Replace(",", ""))
                                            + " WHERE actId=" + HId.Value + " AND costo IS NULL AND entId=" + GEntidades.DataKeys[i].Value.ToString()) == -1)
                        return;
                    if (conector.QueryMod("UPDATE medicamento_formulacion LEFT JOIN formulacion ON (medicamento_formulacion.formulacion=formulacion.id) "
                        + " SET medicamento_formulacion.costo=" + Query.GetValor(costo.Text.Replace(",", ""))
                        + " WHERE medicamento_formulacion.medicamento=" + HId.Value + " AND formulacion.asegurador=" + GEntidades.DataKeys[i].Value.ToString() + " AND medicamento_formulacion.costo IS NULL") == -1)
                        return;
                }
                // limpiamos los temporales
                Procedimientos.RemoveCostoProcedimiento(GEntidades.DataKeys[i].Value.ToString(), HId.Value);
                Procedimientos.RemoveMaximoProcedimiento(GEntidades.DataKeys[i].Value.ToString(), HId.Value);
            }

            GResultado.DataBind();

            Producto.RemoveProducto(HId.Value);
            conector.Commit();
            ((MasterPageI)Master).SetTitulo(mensaje);
            BCancelar_Click(sender, e);
        }
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
        TCodigoSIIGO.Text = "";
        TPrecioRegulado.Text = "";
        TCInventario.Text = "";
        TCCosto.Text = "";
        CImprimirHoja.Checked = false;
        GCargos.DataBind();
        GEntidades.DataBind();
        CAutomatica.Checked = false;
        DTipo.SelectedValue = "";
        BAceptar.Enabled = Usuario.GetUsuario().CanInsert();

        GResultado.SelectedIndex = -1;
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value = GResultado.SelectedDataKey.Value.ToString();

        Response.Redirect("~/administrador/medicamentos.aspx?imp=" + HId.Value, true);
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
                    TextBox maxima = (TextBox)e.Row.FindControl("TMaxima");
                    valores= ViewState["costos"].ToString().Split(',');
                    valores= valores[i].Split(';');
                    text.Text= valores[0];
                    maxima.Text = valores[1];
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
