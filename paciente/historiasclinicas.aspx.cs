using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using System.IO;


public partial class paciente_historiasclinicas : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TDesde.Text = DateTime.Now.AddYears(-1).ToShortDateString();
            THasta.Text = DateTime.Now.ToShortDateString();
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        int rows = GridUtils.GetRowsCount(GResultados);
        LTotal.Text = rows + " paciente" + (rows == 1 ? "" : "s");

        if (rows > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            int paciente = GResultados.GetGridColumnIndex("Paciente");
            int documento = GResultados.GetGridColumnIndex("Documento");

            Paciente info = Paciente.GetPaciente(HttpUtility.HtmlDecode(e.Row.Cells[paciente].Text).Trim());
            e.Row.Cells[paciente].Text = info.NombreCompleto;
            e.Row.Cells[documento].Text = info.documento;
        }
    }
    protected void BDescargar_Click(object sender, EventArgs e)
    {
        int paciente = GResultados.GetGridColumnIndex("Paciente");
        int documento = GResultados.GetGridColumnIndex("Documento");

        string ruta= Path.Combine(Path.GetTempPath(), "historias");
        Directory.CreateDirectory(ruta);
        /*DirectoryInfo contenido= new DirectoryInfo(ruta);
        foreach(FileInfo file in contenido.GetFiles())
            file.Delete();*/
        using(WebClient client= new WebClient()) {
            client.Headers.Add(HttpRequestHeader.Cookie, string.Format("loginOrganizationExample15={0};contrasena={1}", Request.Cookies["loginOrganizationExample15"].Value, Request.Cookies["contrasena"].Value));
            for (int i = 0; i < GResultados.Rows.Count; i++) {
                string rutafinal =
                    Path.Combine(ruta, 
                    GResultados.Rows[i].Cells[documento].Text
                    + "-"
                    + GResultados.Rows[i].Cells[paciente].Text
                    + ".pdf");
                
                if (File.Exists(rutafinal))
                    continue;

                HyperLink link= (HyperLink)GResultados.Rows[i].Cells[0].Controls[0];
                try
                {
                    client.DownloadFile("http://localhost" + link.ResolveUrl(link.NavigateUrl), rutafinal);
                } catch { }
            }
        }
    }
}
