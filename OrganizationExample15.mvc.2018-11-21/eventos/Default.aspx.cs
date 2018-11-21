using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

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
            query["email"]=TEmail.Text;
            query["teltrabajo"]=TTelTrabajo.Text;
            query["cargo"]=TCargo.Text;

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

        TNombre.Text = GContacto.GetGridCellText("Nombre", GContacto.SelectedIndex);
        TEntidad.Text = GContacto.GetGridCellText("Organización", GContacto.SelectedIndex);
        TTelefono.Text = GContacto.GetGridCellText("Teléfono móvil", GContacto.SelectedIndex);
        TEmail.Text = GContacto.GetGridCellText("Correo electrónico", GContacto.SelectedIndex);
        TTelTrabajo.Text = GContacto.GetGridCellText("Teléfono trabajo", GContacto.SelectedIndex);
        TCargo.Text = GContacto.GetGridCellText("Cargo", GContacto.SelectedIndex);

        ((MasterPageI)Master).SetModificacion(GContacto.SelectedDataKey.Value.ToString());
    }
}
