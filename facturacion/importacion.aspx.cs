using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FileHelpers;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using System.Globalization;

public partial class facturacion_importacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) { 

        }
    }

    public void BSubir_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        PDatos.Visible = false;

        FixedFileEngine engine = new FixedFileEngine(typeof(SIIGOFile));
        SIIGOFile[] siigo = (SIIGOFile[])engine.ReadStream(new StreamReader(FArchivo.FileContent));
        List<SIIGOFile> lista=  siigo.ToList(); // quitamos todos los resumenes de las factura y tambien las deducciones
        ViewState["lista"] = lista;
        List<SIIGOFile> facturas = lista.Where(x => x.TipoDocumentoCruze == "F" && x.DebitoCredito == "D").ToList();
        GFacturas.DataSource = facturas;
        GFacturas.DataBind();

        if (facturas.Count > 0)
        {
            PDatos.Visible = true;
            GFacturas.SelectedIndex=0;
            GFacturas_SelectedIndexChanged(sender, e);
        }
    }

    public void BCancelar_Clicked(object sender, EventArgs e) {
        
        if (GFacturas.SelectedIndex + 1 < GFacturas.Rows.Count)
        {
            GFacturas.SelectedIndex++;
            GFacturas_SelectedIndexChanged(sender, e);
        } else {
            PDatos.Visible = false;
            LMensaje.Text = "Se ha terminado la importación de archivos";
        }
    }

    protected void GFacturas_SelectedIndexChanged(object sender, EventArgs e) {

        // cancelamos todo lo anterior
        UCFactura.SetFactura((int)GFacturas.SelectedDataKey.Values["_Documento"], (List<SIIGOFile>)ViewState["lista"]);
    }
}
