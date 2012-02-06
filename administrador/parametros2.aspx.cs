using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Data.SqlClient;

public partial class administrador_parametros2 : System.Web.UI.Page
{
    protected TreeNode Add(string titulo, string tipo, TreeNode parent, string campos)
    {
        TreeNode hijo = new TreeNode(titulo);
        hijo.NavigateUrl = Request.Url.AbsolutePath + "?tipo=" + tipo;
        hijo.Selected = tipo.ToString() == Request.QueryString["tipo"];
        parent.ChildNodes.Add(hijo);
        if (hijo.Selected)
        {
            ViewState["parametros"] = campos;
            HTipo.Value = tipo;
            LTipo.Text = titulo;
            parent.Expand();
        }
        return hijo;
    }

    protected TreeNode Add(string titulo)
    {
        TreeNode parent = new TreeNode(titulo);
        parent.Collapse();
        parent.SelectAction = TreeNodeSelectAction.Expand;
        TTipo.Nodes.Add(parent);
        return parent;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if (!IsPostBack)
        {
            if (Request.QueryString["tipo"] == null)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?tipo=admCargo");
                return;
            }

            Usuario usuario = Usuario.GetUsuario();

            BAceptar.Enabled = usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();

            TreeNode parent = Add("Personal");

            Add("Cargos", "admCargo", parent, "carId,carDescripcion");

            if (HTipo.Value.Length == 0)
                Response.Redirect(Request.Url.AbsolutePath + "?tipo=admCargo");
        }

        string[] parametros = ViewState["parametros"].ToString().Split(',');

        Query query = new Query(HTipo.Value);

        query["id"] = parametros[0];
        query["nombre"] = parametros[1];
        query.AddCampo("descripcion", "''", false);

        SResultado.SelectCommand = query.GetSelect("", "ORDER BY " + parametros[1]);
        SResultado.DeleteCommand = query.GetDelete(parametros[0] + "=@id");
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query(HTipo.Value);
        CConectorMS conector = new CConectorMS();
        string mensaje;

        string[] parametros = ViewState["parametros"].ToString().Split(',');
        query[parametros[1]] = TNombre.Text;

        if (HId.Value.Length == 0)
        {
            int res=conector.QueryMod(query.GetInsert(), true);
            if (res==-1)
                return;
            HId.Value = res.ToString();
            mensaje = TNombre.Text + " ingresado";
        }
        else
        {
            if (conector.QueryMod(query.GetUpdate(parametros[0] + "='" + HId.Value + "'")) == -1)
                return;
            mensaje = TNombre.Text + " editado";
        }
        if (new CConector().InsertModificacion(HId.Value) == -1)
            return;
        Session["szMensaje"] = mensaje;
        Response.Redirect(Request.Url.AbsolutePath + "?tipo=" + HTipo.Value);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?tipo=" + HTipo.Value);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value = GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
}
