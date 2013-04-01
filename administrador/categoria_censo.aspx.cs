using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class administrador_categoria_censo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if(!IsPostBack) {

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
        Query query = new Query("varios");
        CConector conector = CConector.GetConector();
        conector.StartTransaction();
        string szQuery;
        string mensaje;

        query["nombre"] = TNombre.Text;
        query["descripcion"] = TDescripcion.Text;

        if (HId.Value.Length == 0)
        {
            query["tipo"] = "33";
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


        if (conector.QueryMod("DELETE FROM categoria_censo WHERE categoria=" + Query.GetValor(HId.Value)) == -1)
            return;

        query = new Query("categoria_censo");
        query["categoria"] = HId.Value;

        for (int i = 0; i < CHoras.Items.Count; i++)
        {
            if (CHoras.Items[i].Selected)
            {
                query["hora"] = CHoras.Items[i].Value;
                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
            }
        }

        conector.Commit();
        ((MasterPageI)Master).SetResultado(mensaje);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value = GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();

        CConector conector = new CConector();
        string texto = conector.QueryString("SELECT GROUP_CONCAT(hora) FROM categoria_censo WHERE categoria=" + HId.Value); 
        ViewState["horas"] = texto;

        CHoras.DataBind();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }

    protected void LHoras_DataBound(object sender, EventArgs e)
    {
        string horas = (string)ViewState["horas"];
        if (!string.IsNullOrEmpty(horas))
        {
            string[] cons = horas.Split(',');
            for (int i = 0; i < CHoras.Items.Count; i++)
            {
                for (int j = 0; j < cons.Length; j++)
                {
                    if (cons[j] == CHoras.Items[i].Value.ToString())
                    {
                        CHoras.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }
    }
}
