using System;
using System.IO;
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

            if (!string.IsNullOrEmpty(Request.QueryString["id"])) {

                Query query = new Query("usuario");

                query += "id";
                query += "nombre";
                query += "usuario";
                query += "grupo";
                query += "estado";

                using (CConector conector = new CConector())
                {
                    MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(Request.QueryString["id"])));
                    if (reader != null && reader.Read()) {

                        BAceptar.Enabled = usuario.CanUpdate();
                        RContrasena.Enabled = false;

                        HId.Value = reader["id"].ToString();
                        TNombres.Text= reader["nombre"].ToString();
                        TUsuario.Text = reader["usuario"].ToString();
                        DGrupos.DataBind();
                        Utilidades.SelectInDropDown(DGrupos, reader["grupo"]);
                        HUsuario.Value = TUsuario.Text;
                        switch (reader["estado"].ToString()) {
                            case "0":
                                LEstado.Text = "Inactivo";
                                break;
                            case "1":
                                LEstado.Text = "Eliminado";
                                break;
                            default:
                                LEstado.Text = "Activo";
                                break;
                        }

                        ((MasterPageI)Master).SetModificacion(HId.Value);
                    }
                }
            }
        }
    }
    protected void GUsuarios_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?id=" + GUsuarios.SelectedDataKey.Value.ToString());
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

            query["nombre"] = TNombres.Text;
            query["usuario"] = TUsuario.Text;
            query["grupo"] = DGrupos.SelectedValue;

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

            conector.Commit();
            ((MasterPageI)Master).SetResultado(mensaje);
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
