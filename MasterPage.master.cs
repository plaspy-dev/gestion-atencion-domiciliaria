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
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        if(usuario.GetForceURL().Length!=0) {

            CURLs url = new CURLs(usuario.GetForceURL().ToLower(), "", "");
            if (HttpContext.Current.Request.Url.ToString().ToLower().IndexOf(url.FullURL) == -1)
            {// es la misma
                Response.Redirect(usuario.GetForceURL());
                return;
            }
        }
        if(!IsPostBack) {

            RAlertas.DataSource = Alertas.GetAlertas();
            RAlertas.DataBind();
        }

        LVersion.Text = Version.GetVersion();
        usuario.CreateMenu(TMenu, Session["parametros"]==null ? "" : Session["parametros"].ToString());

        // Session.Remove("parametros");
        // lblNombre.Text = usuario.GetNombre();
        lblUsuario.Text = usuario.GetLogin();

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
            ViewState["excelgridview"] = null;
        }
        if(lnkImp.Visible==false) {

            ViewState["printgridview"] = null;
            ViewState["printfile"] = null;
        } else {
            if(Request.QueryString["p"]=="1" && Usuario.GetUsuario().CanPrint()) {
                // nos preparamos para redireccionar
                lnkImp_Click(sender, e);
            }
        }
        /*// actualizamos la contraseña
        Response.Cookies["contrasena"].Value = Session["passwdtemp"].ToString();
        Response.Cookies["contrasena"].Expires = DateTime.Now.AddMinutes(60);*/
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
        CConectorMS conectorms = new CConectorMS();
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        string id= conector.QueryString("SELECT id FROM usuario WHERE id='" + usuario.GetID()  + "' AND (estado IS NULL OR estado!=-1) AND contrasena=PASSWORD(" + Query.GetValor(TActual.Text) + ")");
        if (id.Length == 0)
        {
            SetMensaje("Contraseña actual equivocada");
            return;
        }
        if (conector.QueryMod("UPDATE usuario SET contrasena=PASSWORD(" + Query.GetValor(TNueva.Text) + ") WHERE id='" + usuario.GetID() + "'") == -1)
            return;
        if (conectorms.QueryMod("UPDATE seg_Usuarios SET usClave=" + Query.GetValor(Crypt.EncriptarDES(TNueva.Text, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4"))) + " WHERE usIdUsuario=" + Query.GetValor(usuario.GetLogin())) == -1)
            return;
        lblTitulo.Text = "Contraseña cambiada correctamente.";
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
        if (view != null)
        {
            lnkExcel.Visible = Usuario.GetUsuario().CanPrint();
            ViewState["excelgridview"] = view.ID;
        } else {
            lnkExcel.Visible = false;
            ViewState["excelgridview"] = null;
        }
    }

    public void Imprimir() {
        lnkImp.Visible = Usuario.GetUsuario().CanPrint();
    }

    public void Imprimir(GridView view)
    {
        if(view!=null) {
            lnkImp.Visible = Usuario.GetUsuario().CanPrint();
            lnkImp.OnClientClick = "";
            ViewState["printgridview"] = view.ID;
        } else {
            lnkImp.Visible = false;
            lnkImp.OnClientClick = "";
            ViewState["printgridview"] = null;
        }
    }

    public LinkButton GetPrintLink()
    {
        return lnkImp;
    }

    public LinkButton GetGuardarLink()
    {
        return lnkGuardar;
    }

    public void Imprimir(string archivo)
    {
        lnkPDF.Visible = lnkExcel.Visible = lnkImp.Visible = Usuario.GetUsuario().CanPrint();
        lnkImp.OnClientClick = "";
        lnkImp.Attributes["r"] = "1";
        ViewState["printfile"] = archivo;
    }

    protected void lnkImp_Click(object sender, EventArgs e) {

        if (ViewState["printgridview"] != null)
        {
            GridView view = (GridView) Utilidades.FindControlForId(Controls,ViewState["printgridview"].ToString());
            if (view != null)
            {
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
        else if (ViewState["printfile"] != null)
        {
            PrintEventArgs evento = new PrintEventArgs();
            StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString()));
            evento.Contenido = reader.ReadToEnd();
            reader.Close();

            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }

            evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);
            // agregamos el script para imprimir
#if DEBUG
            evento.Contenido= evento.Contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {}</script></body>");
            // contenido= contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();}window.history.back();}</script></body>");
#else
            evento.Contenido = evento.Contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.print) {window.print();}window.close();}</script></body>");
            // contenido = contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();venImp.close();}window.history.back();}</script></body>");
#endif
            // llamamos a la pagina cliente
            Response.Clear();
            Response.Write(evento.Contenido);
            Response.End();
        }
    }
    
    protected void lnkExcel_Click(object sender, EventArgs e)
    {
        PrintEventArgs evento = new PrintEventArgs();
        if (ViewState["excelgridview"] != null)
        {
            if (_ExcelClicked != null)
            {
                _ExcelClicked(this, evento);
            }
            Utilidades.ExportExcel(Response, (GridView)Utilidades.FindControlForId(Controls, ViewState["excelgridview"].ToString()), Page.Title);
        }
        else if (ViewState["printfile"] != null)
        {

            StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString()));
            evento.Contenido = reader.ReadToEnd();
            reader.Close();

            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }

            evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(Page.Title) + ".xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");
            Response.Write(evento.Contenido);
            Response.End();
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
        Response.AddHeader("content-disposition", "attachment;filename=" + HttpUtility.UrlEncode(Page.Title) + ".pdf");

        StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString()));
        evento.Contenido = reader.ReadToEnd();
        reader.Close();

        int pos= evento.Contenido.IndexOf("<head>");
        if(pos!=-1) {

            int posf= evento.Contenido.IndexOf("</head>");
            evento.Contenido = evento.Contenido.Substring(0, pos) + evento.Contenido.Substring(posf + "</head>".Length);
            pos = posf;
        }

        if (_ImprimirClicked != null)
        {
            _ImprimirClicked(this, evento);
        }

        evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);
        
        Directory.SetCurrentDirectory(Server.MapPath(""));

        Document document = new Document(PageSize.LETTER, 10, 10, 10, 10);
        PdfWriter writer = PdfWriter.GetInstance(document, Response.OutputStream);

        document.AddTitle(Page.Title);
        document.AddSubject(Request.Url.ToString());
        document.AddCreator("OrganizationExample15: " + Version.GetVersion());
        document.AddAuthor(Usuario.GetUsuario().GetNombre());

        document.Open();

        // HTMLWorker htmlparser = new HTMLWorker(document);

        /*IDictionary<string, object> providers = new Dictionary<string, object>();
        providers.Add(HTMLWorker.FONT_PROVIDER, new DefaultFontProvider("Arial"));
        htmlparser.SetProviders(providers);*/

        StringReader sr = new StringReader(evento.Contenido);
        // htmlparser.Parse(sr);

        XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, sr);
        document.Close();

        Response.End();
    }

    protected void OnAlerta_Click(object sender, EventArgs e)
    {
        LinkButton link= (LinkButton)sender;
        SAlertas.SelectCommand = link.CommandName;
        GAlertas.DataBind();
        ((HyperLinkField)GAlertas.Columns[0]).DataNavigateUrlFormatString = link.CommandArgument;
        PAlertas.Visible = true;
    }
}
