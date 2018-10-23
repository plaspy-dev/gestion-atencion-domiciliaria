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
using System.Diagnostics;

public partial class MasterPageI : System.Web.UI.MasterPage
{
    // private static readonly object _ImprimirClicked = new object();
    public event EventHandler _ImprimirClicked = null;
    public event EventHandler _ExcelClicked = null;

    protected void Page_Load(object sender, EventArgs e)
    {
#if DEBUG
        LMonoFix.Text="<style type='text/css'>.red{background-color: Red;}</style>";
#endif
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        if(!string.IsNullOrEmpty(usuario.GetForceURL())) {
            if (HttpContext.Current.Request.Url.ToString().ToLower().IndexOf(HttpUtility.UrlDecode(ResolveClientUrl(usuario.GetForceURL()).ToLower()).Replace(" ", "+")) == -1)
            {// es la misma
                Response.Redirect(usuario.GetForceURL());
                return;
            }
        }
        if(!IsPostBack) {

            Type t = Type.GetType("Mono.Runtime");
            if (t != null) // se esta ejecutando en mono
                LMonoFix.Text += string.Format("<script type='text/javascript' src='{0}'></script>", ResolveClientUrl("~/js/mono.js"));

            lPropiedades.Visible=
            MModificaciones.Visible = Usuario.GetInstance().GetPermisosRaiz("~/modificaciones.ascx") > 0;
            RAlertasReal.DataSource= RAlertas.DataSource = Alertas.GetAlertas();
            RAlertas.DataBind();
            RAlertasReal.DataBind();
            LTotalAlertas.Text = RAlertasReal.Items.Count.ToString();
            PTotalAlerta.Visible= lnkAlertas.Visible =
            LTotalAlertas.Visible = RAlertasReal.Items.Count > 0;
            // lnkAlertas.Text = RAlertasReal.Items.Count==1 ? "Alerta" : "Alertas";
        }

        LVersion.Text = HomeCareVersion.Number;
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

    public void SetMensaje(String mensaje, string titulo=null) {

        if (string.IsNullOrEmpty(titulo))
            dialog_message.Attributes["title"] = titulo;
        LMensaje.Text = mensaje;
    }

    public void SetResultado(String titulo, string parametros=null, bool redirect=true) {

        Session["szMensaje"] = titulo;
        if (redirect)
        {
            if(string.IsNullOrEmpty(parametros))
                Response.Redirect(Request.Url.AbsolutePath);
            else Response.Redirect(Request.Url.AbsolutePath + "?" + parametros);
        }
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
            lnkPDF.PostBackUrl = Request.Url.AbsolutePath + Request.Url.Query;
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

        PrintEventArgs evento = new PrintEventArgs();
        bool close = true;

        if (ViewState["printgridview"] != null)
        {
            // GridView view = (GridView) Utilidades.FindControlForId(Controls,ViewState["printgridview"].ToString());
            evento.Contenido = string.Format("<html><body>${0}$</body></html>", ViewState["printgridview"]);
            close = false;
        }
        else if (ViewState["printfile"] != null) {
            using (StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString())))
            {
                evento.Contenido = reader.ReadToEnd();
                reader.Close();
            }
        }

        if (evento.Contenido.StringBuilder!=null && evento.Contenido.StringBuilder.Length != 0) {

            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }

            evento.Contenido = evento.Contenido
                .Replace("~/css/", ResolveClientUrl("~/css/"))
                .Replace("~/js/", ResolveClientUrl("~/js/"))
                .Replace("~/", ResolveUrl("~/"))
                .Replace("$SYSDATE()$", Query.GetMySQLDateFormat(DateTime.Now, true));

            // agregamos el script para imprimir
#if DEBUG
            evento.Contenido= evento.Contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {}</script></body>");
            // contenido= contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();}window.history.back();}</script></body>");
#else
            evento.Contenido = evento.Contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () { if (window.print) { window.print(); {0} } }</script></body>".Replace("{0}", close ? "setTimeout(function () { window.close(); }, 1);": ""));
            // contenido = contenido.Replace("</body>", "<script type='text/javascript'>window.onload = function () {if(window.name=='popup')return;var venImp = window.open('../imp.htm', 'popup');venImp.document.write(document.documentElement.innerHTML);venImp.document.close();if(venImp.print) {venImp.print();venImp.close();}window.history.back();}</script></body>");
#endif

            Response.ContentType = "text/html";
            Response.BufferOutput =
            Response.Buffer = false;
            RenderPage.Render(Response, cph.Controls, evento.Contenido.ToString());
            // evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);
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
            // GridUtils.ExportExcelXML(Response, (GridView)Utilidades.FindControlForId(Controls, ViewState["excelgridview"].ToString()), Page.Title, "Vida");
            // GridUtils.ExportExcel(Response, (GridView)Utilidades.FindControlForId(Controls, ViewState["excelgridview"].ToString()), Page.Title);
            GridUtils.ExportExcelXLSX(Response, (GridView)Utilidades.FindControlForId(Controls, ViewState["excelgridview"].ToString()), Server.MapPath("~/xlsx/"), Page.Title, CUsuario.GetInstance().Nombre);
            return;
        }
        else if (ViewState["printfile"] != null)
        {
            bool xml = false;
            string file = Server.MapPath(ViewState["printfile"].ToString());
            string filexml = file.Replace(".html", ".xml").Replace(".htm", ".xml");
            if (File.Exists(filexml))
            {
                file = filexml;
                xml = true;
            }
            using (StreamReader reader = new StreamReader(file))
            {
                evento.Contenido = reader.ReadToEnd();
                reader.Close();
            }

            if (_ImprimirClicked != null)
            {
                _ImprimirClicked(this, evento);
            }

            evento.Contenido = evento.Contenido
                .Replace("~/css/", ResolveClientUrl("~/css/"))
                .Replace("~/js/", ResolveClientUrl("~/js/"))
                .Replace("~/", ResolveUrl("~/"))
                .Replace("$SYSDATE()$", Query.GetMySQLDateFormat(DateTime.Now, true));

            // evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(Page.Title) + ".xls");
            Response.ContentType = "application/vnd.ms-excel";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");
            Response.BufferOutput= 
            Response.Buffer = false;
            if (xml)
                RenderPage.RenderXML(Response, cph.Controls, evento.Contenido.ToString());
            else RenderPage.Render(Response, cph.Controls, evento.Contenido.ToString());
            /*Response.Write(evento.Contenido);
            Response.End();*/
        }
    }

    protected void lnkPDF_Click(object sender, EventArgs e) {

        PrintEventArgs evento = new PrintEventArgs(true);
        Response.Clear();
        Response.ContentType = "application/pdf";
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        using (StreamReader reader = new StreamReader(Server.MapPath(ViewState["printfile"].ToString())))
        {
            evento.Contenido = reader.ReadToEnd();
            reader.Close();
        }

        if (_ImprimirClicked != null)
        {
            _ImprimirClicked(this, evento);
        }

        Response.AddHeader("content-disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(Page.Title) + ".pdf");

        evento.Contenido = Utilidades.ReplaceContenido(cph.Controls, evento.Contenido);
        evento.Contenido = evento.Contenido
                .Replace("~/css/", Server.MapPath(ResolveClientUrl("~/css/")))
                .Replace("~/js/", Server.MapPath(ResolveClientUrl("~/js/")))
                .Replace("~/Image/", string.Format("{0}{1}", ConfigurationManager.AppSettings["servidor"], ResolveUrl("~/Image/")))
                .Replace("../", Server.MapPath("../"))
                .Replace("~/", Server.MapPath("~/"))
                .Replace("$SYSDATE()$", Query.GetMySQLDateFormat(DateTime.Now, true));

        Directory.SetCurrentDirectory(Path.GetDirectoryName(Server.MapPath(Request.Url.LocalPath)));

        Response.Flush();
        Response.BinaryWrite(PDFConverter.ConvertToPDFExe(evento.Contenido.ToString()));
        Response.Flush();

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
        SAlertas.ConnectionString = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString;
        SAlertas.ProviderName = ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ProviderName;
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
