using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Configuration;

public partial class administrador_usuario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombres.Focus();
        if(!IsPostBack) {
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GUsuarios.Columns[1].Visible = usuario.CanDelete();
            GUsuarios.Columns[0].Visible = usuario.CanUpdate();
            ViewState["cargos"] = "";
            ViewState["entidades"] = "";
        }
    }
    protected void GUsuarios_SelectedIndexChanged(object sender, EventArgs e)
    {
        RContrasena.Enabled = false;
        HId.Value = GUsuarios.SelectedDataKey.Value.ToString();
        CConector.SelectInComboText(DGrupos, HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[4].Text));
        TNombres.Text = HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[2].Text);
        TUsuario.Text = HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[3].Text);
        TIdPersonal.Text= HttpUtility.HtmlDecode(GUsuarios.SelectedRow.Cells[6].Text).Trim();
        CCumpleanos.Checked = ((CheckBox)GUsuarios.SelectedRow.FindControl("C")).Checked;
        CForceChange.Checked = false;
        HUsuario.Value = TUsuario.Text;
        using (CConector conector = new CConector())
        {
            ViewState["cargos"] = conector.QueryString("SELECT cargos FROM usuario WHERE id=" + HId.Value);
            ViewState["entidades"] = conector.QueryString("SELECT entidades FROM usuario WHERE id=" + HId.Value);
        }
        GCargos.DataBind();
        GEntidades.DataBind();
        IFirma.Visible = true;
        IFirma.ImageUrl = "~/archivo/firma.ashx?ui=" + HId.Value;
        
        ((MasterPageI)Master).SetModificacion(HId.Value);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("usuario");
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();

            string szQuery;
            string mensaje;
            string cargos = "";
            string entidad = "";

            query["nombre"] = TNombres.Text;
            query["usuario"] = TUsuario.Text;
            query["grupo"] = DGrupos.SelectedValue;
            query["personal"] = TIdPersonal.Text;
            query["cumpleanos"] = CCumpleanos.Checked ? "1" : "";
            if (CForceChange.Checked)
                query["forceurl"] = "~/contrasena.aspx";

            // agregamos los cargos que puede programar el usuario
            for (int i = 0; i < GCargos.Rows.Count; i++)
            {

                CheckBox box = (CheckBox)GCargos.Rows[i].FindControl("CCargo");
                if (box.Checked)
                {
                    if (cargos.Length > 0)
                        cargos += ",";
                    cargos += GCargos.DataKeys[i].Value.ToString();
                }
            }
            query["cargos"] = cargos;
            // agregamos las entidades que puede ver el usuario
            for (int i = 0; i < GEntidades.Rows.Count; i++)
            {
                CheckBox box = (CheckBox)GEntidades.Rows[i].FindControl("CEntidad");
                if (box.Checked)
                {
                    if (i == 0) // todas las entidades estan chuleadas
                        break;
                    if (entidad.Length > 0)
                        entidad += ",";
                    entidad += GEntidades.DataKeys[i].Value.ToString();
                }
            }
            query["entidades"] = entidad;


            if (TContrasena.Text.Length > 0)
                query.AddCampo("contrasena", "PASSWORD(" + Query.GetValor(TContrasena.Text) + ")", false);

            if (HId.Value.Length == 0)
            {
                szQuery = query.GetInsert();
                mensaje = TNombres.Text + " ingresado";
            }
            else
            {
                szQuery = query.GetUpdate("id='" + HId.Value + "'");
                mensaje = TNombres.Text + " editado";
            }
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            if (HId.Value.Length == 0)
                HId.Value = res.ToString();
            if (conector.InsertModificacion(HId.Value) == -1)
                return;

            if (conector.QueryMod("DELETE FROM usuario_alerta WHERE usIdUsuario='" + HUsuario.Value + "'") == -1)
                return;

            Query alertas = new Query("usuario_alerta");
            alertas["usIdUsuario"] = TUsuario.Text;

            for (int i = 0; i < GAlertas.Rows.Count; i++)
            {
                if (((CheckBox)GAlertas.Rows[i].FindControl("CPermiso")).Checked)
                {
                    alertas["tarId"] = GAlertas.DataKeys[i].Value.ToString();
                    if (conector.QueryMod(alertas.GetInsert()) == -1)
                        return;
                }
            }

            if (FFirma.HasFile)
            {
                string archivo = ConfigurationManager.AppSettings["pathFiles"] + "firmas\\";
                System.IO.Directory.CreateDirectory(archivo);
                archivo += HId.Value + ".jpg";
                FFirma.SaveAs(archivo);
            }

            conector.Commit();
            ((MasterPageI)Master).SetResultado(mensaje);
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GCargos_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowIndex!=-1) {
            string []valores= ViewState["cargos"].ToString().Split(',');
            for (int i = 0; i < valores.Length; i++) {

                if (valores[i] == GCargos.DataKeys[e.Row.RowIndex].Value.ToString())
                {
                    CheckBox box = (CheckBox)e.Row.FindControl("CCargo");
                    box.Checked = true;
                    break;
                }
            }
        }
    }
    protected void GEntidades_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowIndex!=-1) {
            if (string.IsNullOrEmpty((string)ViewState["entidades"]))
            {
                CheckBox box = (CheckBox)e.Row.FindControl("CEntidad");
                box.Checked = true;
            }
            else
            {
                string[] valores = ViewState["entidades"].ToString().Split(',');
                for (int i = 0; i < valores.Length; i++)
                {

                    if (valores[i] == GEntidades.DataKeys[e.Row.RowIndex].Value.ToString())
                    {
                        CheckBox box = (CheckBox)e.Row.FindControl("CEntidad");
                        box.Checked = true;
                        break;
                    }
                }
            }
        }
    }
}
