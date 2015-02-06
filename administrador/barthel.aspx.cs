using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class administrador_barthel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DGrupo.Focus();
        if(!IsPostBack) {

            foreach (Calificacion.Escalas info in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
            {
                DIndice.Items.Add(new ListItem(Calificacion.GetNombreEscala(info), ((int)info).ToString()));
            }

            if (!string.IsNullOrEmpty(Request.QueryString["ioe"]))
                Utilidades.SelectInDropDown(DIndice, Request.QueryString["ioe"]);

            if (!string.IsNullOrEmpty(Request.QueryString["ig"]))
            {
                DGrupo.SelectedValue = Request.QueryString["ig"];
            }
            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            RModificar.NavigateUrl="~/administrador/Default.aspx?tipo=" + (Convert.ToInt32(DIndice.SelectedValue)-1);

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
        using (CConector conector = new CConector())
        {
            string szQuery;
            string mensaje;

            query["nombre"] = TConcepto.Text;
            query["descripcion"] = TCalificacion.Text;
            query["parametro1"] = DGrupo.SelectedValue;

            if (HId.Value.Length == 0)
            {
                query["tipo"] = DIndice.SelectedValue;
                szQuery = query.GetInsert();
                mensaje = TConcepto.Text + " ingresado";
            }
            else
            {
                szQuery = query.GetUpdate("id='" + HId.Value + "'");
                mensaje = TConcepto.Text + " editado";
            }
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            if (HId.Value.Length == 0)
                HId.Value = res.ToString();
            if (conector.InsertModificacion(HId.Value) == -1)
                return;
            Procedimientos.RemoveVarios(HId.Value);
            ((MasterPageI)Master).SetResultado(mensaje, false);
            Response.Redirect(Request.Url.AbsolutePath + "?ioe=" + DIndice.SelectedValue + "&ig=" + DGrupo.SelectedValue);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value= GResultado.SelectedDataKey.Value.ToString();
        CConector.SelectInComboText(DGrupo, HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text));
        TConcepto.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text);
        TCalificacion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[4].Text);

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
    protected void DIndice_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?ioe=" + DIndice.SelectedValue);
    }
}
