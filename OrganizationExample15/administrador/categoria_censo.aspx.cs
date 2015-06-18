using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

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

            GProcedimientos.DataBind();
            ViewState["proc"] = new List<Miscelaneos>();
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("varios");
        using (CConector conector = new CConector())
        {
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

            Procedimientos.RemoveVarios(HId.Value);

            if (conector.QueryMod("DELETE FROM categoria_censo WHERE categoria=" + Query.GetValor(HId.Value)) == -1)
                return;

            query = new Query("categoria_censo");
            query["categoria"] = HId.Value;

            List<Miscelaneos> lista = (List<Miscelaneos>)ViewState["proc"];
            foreach (Miscelaneos info in lista) {
                query["hora"] = info.Id;
                if (conector.QueryMod(query.GetInsert()) == -1)
                    return;
            }
            
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
        HId.Value = GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();

        using (CConector conector = new CConector())
        {
            List<Miscelaneos> lista= new List<Miscelaneos>();

            MySqlDataReader reader= conector.Query("SELECT hora FROM categoria_censo WHERE categoria=" + HId.Value);
            if(reader!=null) {
                while(reader.Read()) {
                    lista.Add(new Miscelaneos(
                        reader["hora"].ToString(),
                        Procedimientos.GetProcedimiento(reader["hora"].ToString())
                    ));
                }
            }

            GProcedimientos.DataSource = lista;
            GProcedimientos.DataBind();
            ViewState["proc"] = lista;
        }

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }

    protected void BMas_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        List<Miscelaneos> lista= (List<Miscelaneos>) ViewState["proc"];

        if (lista.Exists(x => x.Id == TProcedimientoID.Text))
            return;

        lista.Add(new Miscelaneos(TProcedimientoID.Text, TProcedimiento.Text));

        TProcedimiento.Text =
        TProcedimientoID.Text = "";
        
        GProcedimientos.DataSource = lista;
        GProcedimientos.DataBind();
        ViewState["proc"] = lista;
    }
    protected void GProcedimientos_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        e.Cancel = true;
        List<Miscelaneos> lista = (List<Miscelaneos>)ViewState["proc"];

        Miscelaneos info= lista.Find(x => x.Id == GProcedimientos.DataKeys[e.RowIndex].Value.ToString());
        if (info == null)
            return;

        TProcedimiento.Text = info.Nombre;
        TProcedimientoID.Text = info.Id;

        lista.Remove(info);
        GProcedimientos.DataSource = lista;
        GProcedimientos.DataBind();
        ViewState["proc"] = lista;
    }
}
