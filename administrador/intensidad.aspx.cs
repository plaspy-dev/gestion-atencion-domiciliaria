using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class administrador_intensidad : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();
            ViewState["entidades"]="";
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("varios");
        CConector conector = new CConector();
        conector.StartTransaction();
        
        string szQuery;
        string mensaje;
        string id = GResultado.SelectedIndex == -1 ? "" : GResultado.SelectedDataKey.Values["id"].ToString();

        query["nombre"] = TNombre.Text;
        query["parametro1"] = TProcedimientoID.Text;

        if (id.Length == 0)
        {
            query["tipo"] = "21";
            szQuery = query.GetInsert();
            mensaje = TNombre.Text + " ingresado";
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            id = res.ToString();
        }
        else
        {
            szQuery = query.GetUpdate("id='" + id + "'");
            mensaje = TNombre.Text + " editado";
            if (conector.QueryMod(szQuery) == -1)
                return;
        }
        if (new CConector().InsertModificacion(id) == -1)
            return;

        // agregamos los cargos que puede programar el usuario
        if (conector.QueryMod("DELETE FROM intensidad_valor WHERE intensidad=" + id) == -1)
            return;

        Query valores = new Query("intensidad_valor");
        valores["intensidad"] = id;

        for (int i = 0; i < GEntidades.Rows.Count; i++)
        {
            TextBox costo = (TextBox)GEntidades.Rows[i].FindControl("TCosto");

            if (costo.Text.Length > 0)
            {
                valores["entidad"] = GEntidades.DataKeys[i].Value.ToString();
                valores["costo"] = costo.Text.Replace(",", "");
                if (conector.QueryMod(valores.GetInsert()) == -1)
                    return;
                /*if (conectorms.QueryMod("UPDATE programacion SET costo=" + Query.GetValor(costo.Text.Replace(",", ""))
                                        + " WHERE actId=" + HId.Value + " AND costo IS NULL AND entId=" + GEntidades.DataKeys[i].Value.ToString()) == -1)
                    return;
                if (conector.QueryMod("UPDATE medicamento_formulacion LEFT JOIN formulacion ON (medicamento_formulacion.formulacion=formulacion.id) "
                    + " SET medicamento_formulacion.costo=" + Query.GetValor(costo.Text.Replace(",", ""))
                    + " WHERE medicamento_formulacion.medicamento=" + HId.Value + " formulacion.asegurador=" + GEntidades.DataKeys[i].Value.ToString() + " AND medicamento_formulacion.costo IS NULL") == -1)
                    return;*/
            }
            // limpiamos los temporales
            Procedimientos.RemoveCostoIntensidad(GEntidades.DataKeys[i].Value.ToString(), id);
        }

        Procedimientos.RemoveVarios(id);
        Procedimientos.RemoveIntensidad(TProcedimientoID.Text);

        conector.Commit();
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[Utilidades.GetGridColumnIndex(GResultado, "Nombre")].Text).Trim();
        TProcedimiento.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[Utilidades.GetGridColumnIndex(GResultado, "Procedimiento")].Text).Trim();
        TProcedimientoID.Text= GResultado.DataKeys[GResultado.SelectedIndex].Values["idproc"].ToString();

        using (CConector conector = new CConector())
        {
            ViewState["entidades"] = conector.QueryString("SELECT GROUP_CONCAT(entidad) FROM intensidad_valor WHERE intensidad=" + GResultado.DataKeys[GResultado.SelectedIndex].Values["id"].ToString() + " ORDER BY intensidad");
            ViewState["costos"] = conector.QueryString("SELECT GROUP_CONCAT(costo) FROM intensidad_valor WHERE intensidad=" + GResultado.DataKeys[GResultado.SelectedIndex].Values["id"].ToString() + " ORDER BY intensidad");
        }

        GEntidades.DataBind();

        ((MasterPageI)Master).SetModificacion(GResultado.SelectedDataKey.Value.ToString());
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
                    valores = ViewState["costos"].ToString().Split(',');
                    text.Text = valores[i];
                    break;
                }
            }
        }
    }
    protected void GResultado_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        Procedimientos.RemoveIntensidad(e.Keys["idproc"].ToString());
    }
}
