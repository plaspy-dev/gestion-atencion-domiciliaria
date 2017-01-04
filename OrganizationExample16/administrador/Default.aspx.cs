using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SDG.Componentes;
using System.Globalization;
using System.Text.RegularExpressions;

public partial class administrador_Default : System.Web.UI.Page
{
    protected TreeNode Add(string titulo, Varios.Tipos tipo, TreeNode parent)
    {
        TreeNode hijo = new TreeNode(titulo);
        hijo.NavigateUrl = Request.Url.AbsolutePath + "?tipo=" + (int)tipo;
        hijo.Selected = ((int)tipo).ToString() == Request.QueryString["tipo"];
        parent.ChildNodes.Add(hijo);
        if (hijo.Selected)
        {
            HTipo.Value = ((int)tipo).ToString();
            LTipo.Text = titulo;
            parent.Expand();
        }
        return hijo;
    }

    protected TreeNode Add(string titulo)
    {
        TreeNode parent= new TreeNode(titulo);
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
            TreeNode parent = Add("Parámetros");

            foreach (Varios.Tipos info in Enum.GetValues(typeof(Varios.Tipos)).Cast<Varios.Tipos>().OrderBy(x => x.ToString()))
            {
                Add(GetHumanName(info.ToString()), info, parent);
            }

            if (Request.QueryString["tipo"] == null)
            {
                Response.Redirect(parent.ChildNodes[0].NavigateUrl);
                return;
            }

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled= usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();

            if (HTipo.Value.Length == 0)
                Response.Redirect(parent.ChildNodes[0].NavigateUrl);
        }
    }

    public static Regex RegexUpperCase= new Regex(@"
                (?<=[A-Z])(?=[A-Z][a-z]) |
                 (?<=[^A-Z])(?=[A-Z]) |
                 (?<=[A-Za-z])(?=[^A-Za-z])", RegexOptions.IgnorePatternWhitespace | RegexOptions.Compiled);

    public static string GetHumanName(string name) {
        return RegexUpperCase.Replace(name, " ");
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("varios");
        using (CConector conector = new CConector())
        {
            string szQuery;
            string mensaje;

            query["nombre"] = TNombre.Text;
            query["descripcion"] = TDescripcion.Text;

            if (HId.Value.Length == 0)
            {
                query["tipo"] = HTipo.Value;
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

            Session["szMensaje"] = mensaje;
            Response.Redirect(Request.Url.AbsolutePath + "?tipo=" + HTipo.Value);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?tipo=" + HTipo.Value);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value= GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
}
