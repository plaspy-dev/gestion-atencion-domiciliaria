using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class eventos_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Usuario usuario= Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            GContacto.Columns[0].Visible = usuario.CanUpdate();
            GContacto.Columns[1].Visible = usuario.CanDelete();
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            Query query = new Query("contacto");

            query["nombre"] = TNombre.Text;
            query["direccion"] = TEntidad.Text;
            query["telefono"] = TTelefono.Text;

            int id = -1;
            if (GContacto.SelectedIndex == -1)
            {
                id = conector.QueryMod(query.GetInsert(), true);
                if (id == -1)
                    return;
            }
            else
            {
                id = Convert.ToInt32(GContacto.SelectedDataKey.Value);
                if (conector.QueryMod(query.GetUpdate("id='" + id.ToString() + "'")) == -1)
                    return;
            }

            if (conector.InsertModificacion(id.ToString()) == -1)
                return;
        }
        ((MasterPageI)Master).SetResultado("Evento " + TNombre.Text + " editado");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GContacto_SelectedIndexChanged(object sender, EventArgs e)
    {
        BAceptar.Enabled = Usuario.GetUsuario().CanUpdate();

        TNombre.Text = HttpUtility.HtmlDecode(GContacto.SelectedRow.Cells[2].Text);
        TEntidad.Text = HttpUtility.HtmlDecode(GContacto.SelectedRow.Cells[3].Text);
        TTelefono.Text = HttpUtility.HtmlDecode(GContacto.SelectedRow.Cells[4].Text);

        ((MasterPageI)Master).SetModificacion(GContacto.SelectedDataKey.Value.ToString());
    }
}
