using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class administrador_ubicacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TNombre.Focus();
            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();
        }
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("ubicacion");
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            string szQuery;
            string mensaje;

            query["nombre"] = TNombre.Text;

            if (string.IsNullOrEmpty((string)ViewState["id"]))
            {
                query["almacen"] = "1";
                szQuery = query.GetInsert();
                mensaje = TNombre.Text + " ingresado";
            }
            else
            {
                szQuery = query.GetUpdate("id='" + ViewState["id"].ToString() + "'");
                mensaje = TNombre.Text + " editado";
            }
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            if (string.IsNullOrEmpty((string)ViewState["id"]))
                ViewState["id"] = res.ToString();
            if (conector.InsertModificacion(ViewState["id"].ToString()) == -1)
                return;

            conector.Commit();
            ((MasterPageI)Master).SetResultado(mensaje);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        ViewState["id"]= GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();

        ((MasterPageI)Master).SetModificacion(ViewState["id"].ToString());
    }
}
