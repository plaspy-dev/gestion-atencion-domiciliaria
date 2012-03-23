using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;
using System.IO;
using System.Collections;
using iTextSharp.text;
using iTextSharp.text.html;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using iTextSharp.text.xml;
using iTextSharp.tool.xml;

public partial class MasterPageI : System.Web.UI.MasterPage
{
    // private static readonly object _ImprimirClicked = new object();
    public event EventHandler _ImprimirClicked = null;
    public event EventHandler _ExcelClicked = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

            CConectorMS conector = new CConectorMS();
            CConectorMS conectorc = new CConectorMS();

            SqlDataReader consultas = conectorc.Query("SELECT genTareas.tarTitulo AS nombre,genTareas.consulta,genTareas.url FROM GenUsuarioTarea LEFT JOIN genTareas ON (genTareas.tarId=GenUsuarioTarea.tarId) WHERE usIdUsuario='" + Usuario.GetUsuario().GetLogin() + "' AND genTareas.consulta IS NOT NULL;");
            if(consultas!=null) {

                while(consultas.Read()) {

                    MenuItem parent = new MenuItem(consultas["nombre"].ToString());
                    SqlDataReader reader = conector.Query(consultas["consulta"].ToString());
                    if (reader != null)
                    {
                        while (reader.Read())
                        {
                            MenuItem item = new MenuItem(reader["nombre"].ToString());
                            item.NavigateUrl = consultas["url"].ToString() + reader["id"].ToString();
                            parent.ChildItems.Add(item);
                        }
                        if (parent.ChildItems.Count > 0)
                            MAlertas.Items.Add(parent);
                    }
                }
            }
        }

        LVersion.Text = Version.GetVersion();

        Usuario usuario = Usuario.GetUsuario();
        usuario.CreateMenu(TMenu, Session["parametros"]==null ? "" : Session["parametros"].ToString());

        // Session.Remove("parametros");
        lblNombre.Text = usuario.GetNombre();

        titulo_aux.Attributes["title"] = "";
        LAuxDiag.Text = "";

        if (Session["szMensaje"] != null)
        {
            lblTitulo.Text += " " + Session["szMensaje"].ToString();
            Session["szMensaje"] = null;
        } else {
            lblTitulo.Text = Page.Title;
        }
        if (lnkExcel.Visible == false)
        {
            Session["excelgridview"] = null;
        }
        if(lnkImp.Visible==false) {
            
            Session["printgridview"] = null;
            Session["printfile"] = null;
        } else {
            if(Request.QueryString["p"]=="1" && Usuario.GetUsuario().CanPrint()) {
                // nos preparamos para redireccionar
                lnkImp_Click(sender, e);
            }
        }
        // actualizamos la contraseña
        Response.Cookies["contrasena"].Value = Session["passwdtemp"].ToString();
        Response.Cookies["contrasena"].Expires = DateTime.Now.AddMinutes(10);
    }

    public void SetParametros(string parametros) {

        Session["parametros"] = parametros;
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
        string id= conector.QueryString("SELECT id FROM usuario WHERE id='" + usuario.GetID()  + "' AND (estado IS NULL OR estado!=-1) AND contrasena=PASSWORD(" + Query.GetValor(TActual.Text) + ")");
        if (id.Length == 0)
        {
            SetMensaje("Contraseña actual equivocada");
            return;
        }
        if (conector.QueryMod("UPDATE usuario SET contrasena=PASSWORD(" + Query.GetValor(TNueva.Text) + ") WHERE id='" + usuario.GetID() + "'") == -1)
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

    public string ReplaceContenido(ControlCollection controles, string contenido)
    {

        for (int i = 0; i < controles.Count; i++)
        {
            string id = controles[i].ID;
            string valor = "";
            if (controles[i].Controls.Count > 0)
            {
                contenido = ReplaceContenido(controles[i].Controls, contenido);
                continue;
            }
            if (id == null || id.Length == 0)
                continue;
            id = "$" + controles[i].ID + "$";
            if (controles[i].GetType() == typeof(TextBox))
            {
                valor = ((TextBox)controles[i]).Text;
            }
            else if (controles[i].GetType() == typeof(CheckBox))
            {
                valor = ((CheckBox)controles[i]).Checked ? "X" : "";
            }
            else if (controles[i].GetType() == typeof(Label))
            {
                valor = ((Label)controles[i]).Text;
            }
            else if (controles[i].GetType() == typeof(DropDownList))
            {
                if (((DropDownList)controles[i]).SelectedItem == null)
                    ((DropDownList)controles[i]).DataBind(); // solo para depuracion
                valor = ((DropDownList)controles[i]).SelectedItem.Text;
            }
            else if (controles[i].GetType() == typeof(HiddenField))
            {
                valor = ((HiddenField)controles[i]).Value;
            }
            if (contenido.IndexOf(id) != -1)
            {
                contenido = contenido.Replace(id, valor);
            }
        }
        return contenido;
    }

    public void Imprimir(string archivo)
    {
        lnkPDF.Visible = lnkExcel.Visible = lnkImp.Visible = Usuario.GetUsuario().CanPrint();
        lnkImp.OnClientClick = "";
        lnkImp.Attributes["r"] = "1";
        Session["printfile"] = archivo;
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
        else if (Session["printfile"] != null)
        {
            PrintEventArgs evento = new PrintEventArgs();
            StreamReader reader = new StreamReader(Server.MapPath(Session["printfile"].ToString()));
            evento.Contenido = reader.ReadToEnd();
            reader.Close();

            evento.Contenido = ReplaceContenido(cph.Controls, evento.Contenido);
            // agregamos el script para imprimir
#if DEBUG
            evento.Contenido= evento.Contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {}</script></body>");
            // contenido= contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();}window.history.back();}</script></body>");
#else
            evento.Contenido = evento.Contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.print) {window.print();}window.close();}</script></body>");
            // contenido = contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();venImp.close();}window.history.back();}</script></body>");
#endif
            // llamamos a la pagina cliente
            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }
            Response.Clear();
            Response.Write(evento.Contenido);
            Response.End();
        }
    }
    
    protected void lnkExcel_Click(object sender, EventArgs e)
    {
        if (Session["excelgridview"]!=null)
        {
            RenderView((GridView)Session["excelgridview"]);
        } else if(Session["printfile"]!=null) {

            PrintEventArgs evento = new PrintEventArgs();

            StreamReader reader = new StreamReader(Server.MapPath(Session["printfile"].ToString()));
            evento.Contenido = reader.ReadToEnd();
            reader.Close();

            evento.Contenido = ReplaceContenido(cph.Controls, evento.Contenido);

            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }

            Response.Clear();
            Response.AddHeader("Content-Disposition", "inline;filename=" + Page.Title + ".xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");
            Response.Write(evento.Contenido);
            Response.End();
        }
    }

    class DefaultFontProvider : FontFactoryImp {
      private String Default;
      public DefaultFontProvider(String def) {
        Default = def;
      }

      // I believe this is the correct override, but there are quite a few others.
      override public Font GetFont(String fontName, String encoding, bool embedded, float size, int style, BaseColor color,bool cached) {
        if (fontName == null || fontName.Length == 0) {
          fontName = Default;
        }
        size = 8;
        return base.GetFont(fontName, encoding, embedded, size, style, color, cached);
      }
    }

    
    protected void lnkPDF_Click(object sender, EventArgs e) {

        /*Response.ContentType = "application/pdf";
        Response.AddHeader("content-disposition", "attachment;filename=GridViewExport.pdf");
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        StringWriter sw = new StringWriter();
        HtmlTextWriter hw = new HtmlTextWriter(sw);

        GridView1.AllowPaging = false;
        GridView1.DataBind();
        GridView1.RenderControl(hw);

        StringReader sr = new StringReader(sw.ToString());
        Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
        HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
        PdfWriter.GetInstance(pdfDoc, Response.OutputStream);

        pdfDoc.Open();
        htmlparser.Parse(sr);
        pdfDoc.Close();

        Response.Write(pdfDoc);
        Response.End();  */

        PrintEventArgs evento = new PrintEventArgs(true);
        Response.Clear();
        Response.ContentType = "application/pdf";
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.AddHeader("content-disposition", "attachment;filename=" + Page.Title + ".pdf");

        StreamReader reader = new StreamReader(Server.MapPath(Session["printfile"].ToString()));
        evento.Contenido = reader.ReadToEnd();
        reader.Close();

        int pos= evento.Contenido.IndexOf("<head>");
        if(pos!=-1) {

            int posf= evento.Contenido.IndexOf("</head>");
            evento.Contenido = evento.Contenido.Substring(0, pos) + evento.Contenido.Substring(posf + "</head>".Length);
            pos = posf;
        }
        
        evento.Contenido= ReplaceContenido(cph.Controls, evento.Contenido);

        if (_ImprimirClicked != null)
        {
            _ImprimirClicked(this, evento);
        }
        Directory.SetCurrentDirectory(Server.MapPath(""));

        Document document = new Document(PageSize.LETTER, 10, 10, 10, 10);
        PdfWriter writer = PdfWriter.GetInstance(document, Response.OutputStream);

        document.AddTitle(Page.Title);
        document.AddSubject(Request.Url.ToString());
        document.AddCreator("OrganizationExample15: " + Version.GetVersion());
        document.AddAuthor(Usuario.GetUsuario().GetNombre());

        // HTMLWorker htmlparser = new HTMLWorker(document);

        document.Open();

        /*IDictionary<string, object> providers = new Dictionary<string, object>();
        providers.Add(HTMLWorker.FONT_PROVIDER, new DefaultFontProvider("Arial"));
        htmlparser.SetProviders(providers);*/

        StringReader sr = new StringReader(evento.Contenido);
        // htmlparser.Parse(sr);
        XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, sr);
        document.Close();

        // step 3: we parse the document
        document.Close();
        Response.End();
    }
}
