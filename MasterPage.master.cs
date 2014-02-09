using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
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
            if (HttpContext.Current.Request.Url.ToString().ToLower().IndexOf(HttpUtility.UrlDecode(url.FullURL).Replace(" ","+")) == -1)
            {// es la misma
                Response.Redirect(usuario.GetForceURL());
                return;
            }
        }
        if(!IsPostBack) {

            RAlertasReal.DataSource= RAlertas.DataSource = Alertas.GetAlertas();
            RAlertas.DataBind();
            RAlertasReal.DataBind();
            LTotalAlertas.Text = RAlertasReal.Items.Count.ToString();
            PTotalAlerta.Visible= lnkAlertas.Visible =
            LTotalAlertas.Visible = RAlertasReal.Items.Count > 0;
            lnkAlertas.Text = RAlertasReal.Items.Count==1 ? "Alerta" : "Alertas";
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
            } else if (Request.QueryString["pdf"] == "1" && Usuario.GetUsuario().CanPrint()) {
                // nos preparamos para redireccionar
                lnkPDF_Click(sender, e);
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

    public void SetResultado(String titulo, bool redirect) {

        Session["szMensaje"] = titulo;
        if(redirect)
            Response.Redirect(Request.Url.AbsolutePath);
    }
    public void SetResultado(String titulo)
    {
        SetResultado(titulo, true);
    }

    public void SetAuxDiag(String titulo, String texto) {

        titulo_aux.Attributes["title"] = titulo;
        LAuxDiag.Text = texto;
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

    public void Imprimir(string archivo, bool savestate) {
        
        lnkPDF.Visible = lnkExcel.Visible = lnkImp.Visible = Usuario.GetUsuario().CanPrint();
        lnkImp.OnClientClick = "";
        lnkImp.Attributes["r"] = "1";
        ViewState["printfile"] = archivo;

        if (savestate)
        {
            string estado=HttpUtility.UrlEncode(Crypt.EncriptarDES(Utilidades.SaveState(cph.Controls), System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_2")));
            lnkImp.Attributes["s"] = estado;
            lnkPDF.PostBackUrl = Request.Url.ToString();
            if (Request.Url.Query.Length == 0)
                lnkPDF.PostBackUrl += "?";
            else lnkPDF.PostBackUrl += "&";
            lnkImp.PostBackUrl = lnkPDF.PostBackUrl;
            lnkPDF.PostBackUrl += "ss=" + estado;
            lnkImp.PostBackUrl += "ss=" + estado;
        }
    }
    
    public void Imprimir(string archivo)
    {
        Imprimir(archivo, false);
    }

    public bool RestoreState()
    {
        try
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ss"]))
                return Utilidades.RestoreState(cph.Controls, Crypt.DesencriptarDES(Request.QueryString["ss"], System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_2")));
        } catch { }
        return false;
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
            using (StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString())))
            {
                evento.Contenido = reader.ReadToEnd();
                reader.Close();
            }

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

            using (StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString())))
            {
                evento.Contenido = reader.ReadToEnd();
                reader.Close();
            }

            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }

            evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(Page.Title).Replace("+", "%20") + ".xls");
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
        Response.AddHeader("content-disposition", "attachment;filename=" + HttpUtility.UrlEncode(Page.Title).Replace("+","%20") + ".pdf");

        using (StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString())))
        {
            evento.Contenido = reader.ReadToEnd();
            reader.Close();
        }

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

        using (StreamReader cssReader = new StreamReader(Server.MapPath("~/css/pdf.css")))
        {
            using (MemoryStream stream = new MemoryStream()) {
                using (StreamWriter swriter = new StreamWriter(stream))
                {
                    swriter.Write(evento.Contenido);
                    swriter.Flush();
                    stream.Position = 0;
                    XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, stream, cssReader.BaseStream);
                }
            }
            cssReader.Close();
        }
        document.Close();
        Directory.SetCurrentDirectory(Server.MapPath("~/"));
        Response.End();
    }

    protected void OnAlerta_Click(object sender, EventArgs e)
    {
        LinkButton link= (LinkButton)sender;
        List<Alertas> resultado = (from x in Alertas.GetAlertas()
            where x.Id == link.CssClass.Replace("ac","") select x).ToList();
        if(resultado.Count==0)
            return;
        Alertas info= resultado.First();
        dAlertas.Attributes["title"] = info.Nombre;
        SAlertas.SelectCommand = info.SelectCommand;
        SAlertas.ConnectionString = ConfigurationManager.ConnectionStrings[info.MySQLDB ? "MySQLConnectionString" : "connBD"].ConnectionString;
        SAlertas.ProviderName = ConfigurationManager.ConnectionStrings[info.MySQLDB ? "MySQLConnectionString" : "connBD"].ProviderName;
        GAlertas.DataBind();
        ((HyperLinkField)GAlertas.Columns[0]).DataNavigateUrlFormatString = info.URL;
        PAlertas.Visible = true;

        ScriptManager.RegisterClientScriptBlock(PAlertas, typeof(string), "alerta", "addDialog('#" + PAlertas.ClientID + "', '#" + dAlertas.ClientID +"', true);", true);
    }

    protected void GAlertas_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            HyperLink link = (HyperLink)e.Row.Cells[0].Controls[0];
            int inicio=link.Text.IndexOf("$InPac$");
            if (inicio != -1) {
                int final = link.Text.IndexOf("$FinPac$");
                if (final != -1) {
                    string idPaciente= link.Text.Substring(inicio + 7, final - inicio-7);
                    link.Text = link.Text.Replace(string.Format("$InPac${0}$FinPac$", idPaciente), Paciente.GetPaciente(idPaciente).NombreCompleto);
                }
            }
        }
    }
}
