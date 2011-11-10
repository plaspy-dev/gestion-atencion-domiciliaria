using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class MasterPageI : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LVersion.Text = Version.GetVersion();

        Usuario usuario = Usuario.GetUsuario();
        usuario.CreateMenu(TMenu, Session["parametros"]==null ? "" : Session["parametros"].ToString());

        Session.Remove("parametros");
        lblNombre.Text = usuario.GetNombre();

        titulo_aux.Attributes["title"] = "";
        LAuxDiag.Text = "";

        if (Session["szMensaje"] != null)
        {
            lblTitulo.Text += " " + Session["szMensaje"].ToString();
            Session["szMensaje"] = null;
        }
        if (lnkExcel.Visible == false)
        {
            Session["excelgridview"] = null;
        }
        if(lnkImp.Visible==false) {
            
            Session["printgridview"] = null;
        }
        // actualizamos la contraseña
        Response.Cookies["contrasena"].Value = Request.Cookies["contrasena"].Value;
        Response.Cookies["contrasena"].Expires = DateTime.Now.AddMinutes(10);
    }

    public void SetTitulo(string titulo)
    {
        lblTitulo.Text = titulo;
    }

    public void SetModificacion(string idModificaciones)
    {
        MModificaciones.IdModificacion = idModificaciones;
    }

    public void SetMensaje(String mensaje) {

        LMensaje.Text = mensaje;
    }

    public void SetResultado(String titulo) {

        Session["szMensaje"] = titulo;
        Response.Redirect(Request.Url.AbsolutePath);
    }

    public void SetAuxDiag(String titulo, String texto) {

        titulo_aux.Attributes["title"] = titulo;
        LAuxDiag.Text = texto;
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        CConector conector = CConector.GetConector();
        Usuario usuario = Usuario.GetUsuario();
        string id= conector.QueryString("SELECT id FROM usuario WHERE id='" + usuario.GetID()  + "' AND (estado IS NULL OR estado!=-1) AND contrasena=PASSWORD('" + TActual.Text + "')");
        if (id.Length == 0)
        {
            SetMensaje("Contraseña actual equivocada");
            return;
        }
        if (conector.QueryMod("UPDATE usuario SET contrasena=PASSWORD('" + TNueva.Text + "') WHERE id='" + usuario.GetID() + "'") == -1)
            return;
        lblTitulo.Text += "Contraseña cambiada correctamente.";
    }

    public LinkButton GetExcelLink()
    {
        return lnkExcel;
    }

    public void Nuevo(String url) {

        lnkNuevo.Visible = url.Length > 0;
        lnkNuevo.PostBackUrl = url;
    }

    public void Excel(GridView view)
    {
        lnkExcel.Visible = Usuario.GetUsuario().CanPrint();
        Session["excelgridview"] = view;
    }

    public void Imprimir() {
        lnkImp.Visible = Usuario.GetUsuario().CanPrint();
    }

    public void Imprimir(GridView view)
    {
        lnkImp.Visible = Usuario.GetUsuario().CanPrint();
        lnkImp.OnClientClick = "";
        Session["printgridview"] = view;
    }

    public LinkButton GetPrintLink()
    {
        return lnkImp;
    }

    public LinkButton GetGuardarLink()
    {
        return lnkGuardar;
    }

    protected void RenderView(GridView view) {

        bool paging = view.AllowPaging;
        if (paging)
        {
            view.AllowPaging = false;
            view.DataBind();
        }

        Response.Clear();
        Response.AddHeader("Content-Disposition", "inline;filename=" + Page.Title + ".xls");
        Response.ContentType = "application/vnd.ms-excel";
        Response.ContentEncoding = System.Text.Encoding.GetEncoding("ISO-8859-1");

        Response.Write("<html>");
        Response.Write("<body>\n");
        Response.Write("<table border='1'>\n");
        Response.Write("<tr>\n");
        for (int i = 0; i < view.Columns.Count; i++)
        {

            Response.Write("<td><strong>");
            Response.Write(view.Columns[i].HeaderText);
            Response.Write("</strong></td>");
        }
        Response.Write("</tr>\n");

        for (int i = 0; i < view.Rows.Count; i++)
        {
            Response.Write("<tr>\n");
            for (int j = 0; j < view.Columns.Count; j++)
            {
                Response.Write("<td>");
                if (view.Columns[j].GetType() == typeof(HyperLinkField))
                {
                    HyperLink link = (HyperLink)view.Rows[i].Cells[j].Controls[0];
                    Response.Write(link.Text);
                }
                else if (view.Columns[j].GetType() == typeof(CheckBoxField))
                {
                    CheckBox check = (CheckBox)view.Rows[i].Cells[j].Controls[0];
                    Response.Write(check.Checked ? "X" : "");
                }
                else
                {
                    Response.Write(view.Rows[i].Cells[j].Text);
                }
                Response.Write("</td>");
            }
            Response.Write("</tr>\n");
        }
        Response.Write("</body></html>\n");
        
        Response.End();

        if (paging)
        {
            view.AllowPaging = true;
        }
    }

    protected void lnkImp_Click(object sender, EventArgs e) {

        if (Session["printgridview"] != null)
        {
            GridView view = (GridView)Session["printgridview"];
            bool paging = view.AllowPaging;
            if (paging)
            {
                view.AllowPaging = false;
                view.DataBind();
            }
            LAuxDiag.Text = "<script type='text/javascript'>\n";
            LAuxDiag.Text += "$(function() { imprimir(); });\n";
            LAuxDiag.Text += "</script>\n";
        }
    }
    
    protected void lnkExcel_Click(object sender, EventArgs e)
    {
        if (Session["excelgridview"]!=null)
        {
            RenderView((GridView)Session["excelgridview"]);
        }
    }
}
