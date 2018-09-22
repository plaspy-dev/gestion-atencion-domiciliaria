using SDG.Componentes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO.Compression;
using System.Net;
using System.IO;
using System.Text;

public partial class paciente_informemipres : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            GResultados.Visible = false;
            TDesde.Text = Query.GetFromMySQLDate(DateTime.Now.AddDays(-30));
            THasta.Text = Query.GetFromMySQLDate(DateTime.Now);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        LDownload.Visible = false;
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
            LDownload.Visible = true;
        }
    }

    public void WritePDFActa(ZipArchive zipArchive, string id, string pacId, string numero)
    {
        try
        {
            string url = HomeCareVersion.GetURLLocalhost() + ResolveUrl("~/paciente/mipres.aspx?pid=") + pacId + "&ampid=" + id + "&pdf=1&uId=" + Usuario.GetInstance().Id;

            HttpWebRequest httpWebRequest = (HttpWebRequest)HttpWebRequest.Create(url);

            httpWebRequest.ContentType = "application/x-www-form-urlencoded";
            httpWebRequest.Method = "GET";
            //get response 
            WebResponse webResponse = httpWebRequest.GetResponse();
            //get result and release source 
            using (Stream myStreamReader = webResponse.GetResponseStream())
            {
                string tarName = numero + ".pdf";

                ZipArchiveEntry zipEntry = zipArchive.CreateEntry(tarName);
                using (Stream zipStream = zipEntry.Open())
                {
                    myStreamReader.CopyTo(zipStream);
                }
                if (!Response.IsClientConnected)
                    return;
                Response.Flush();
            }
        }
        catch (Exception ex)
        {
            Logs.DefaultLogger.DebugFormat("PDFODS: {0}", ex.ToString());
        }
    }

    protected void LDownload_Click(object sender, EventArgs e)
    {
        Server.ScriptTimeout = 60*60*8* 1000;
        Request.Headers.Remove("Accept-Encoding");
        Response.Clear();
        Response.ContentType = "application/zip";
        Response.AddHeader("Last-Modified", DateTime.Now.ToUniversalTime().ToString("r"));
        Response.AddHeader("Content-Disposition", "attachment; filename=" + HttpUtility.UrlPathEncode("actas.zip"));
        Response.Flush();

        using (CConector conector = new CConector())
        using (var outputStream = new PositionWrapperStream(Response.OutputStream))
        using (var zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
        {
            for (int i = 0; i < GResultados.Columns.Count; i++)
            {
                string id = GResultados.DataKeys[i].Values["id"].ToString();
                string pacId = GResultados.DataKeys[i].Values["pacId"].ToString();
                string numero = GResultados.DataKeys[i].Values["numero"].ToString();


                WritePDFActa(zipArchive, id, pacId, numero);
            }
        }

        Response.End();
    }
}