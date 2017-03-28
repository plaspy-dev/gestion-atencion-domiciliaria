using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Net;

public partial class archivo_consultahistoria : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TKey.Text = Utilidades.QueryString(this, "key");
            BB_Click(sender, e);
        }
    }

    protected void BB_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(TKey.Text))
            return;

        LMessage.Text = "Historia no " + TKey.Text + " encontrada";
        string filename=  Archivo.GetHistoryFromCode(TKey.Text);
        if (string.IsNullOrEmpty(filename))
        {
            System.Threading.Thread.Sleep(3000);
            return;
        }

        Response.Clear();
        Response.ContentType = "application/pdf";
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.AddHeader("content-disposition", "attachment;filename=" + HttpUtility.UrlPathEncode(Page.Title) + ".pdf");
        using (MemoryStream ms = new MemoryStream(File.ReadAllBytes(filename)))
            ms.WriteTo(Response.OutputStream);
        File.Delete(filename);
        Response.End();
    }
}