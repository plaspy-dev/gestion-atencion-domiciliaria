using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;
using System.Globalization;
using FileHelpers;
using MySql.Data.MySqlClient;

public partial class farmacia_informes : System.Web.UI.Page
{
    public int NIT_OrganizationExample15 = 830063394;

    public static int m_nAlmacen = 1;
    public int m_nPaciente = -1;
    public int m_nConsulta = -1;

    protected void BSiigo_Click(object sender, EventArgs e) {

        LMensaje.Text = "";

        Dictionary<string, Producto> productosNoEncontrados = new Dictionary<string, Producto>();
        List<SIIGOFile> entradas = new List<SIIGOFile>();
        List<SIIGOFile> salidas = new List<SIIGOFile>();
        List<SIIGOFile> devoluciones = new List<SIIGOFile>();

        // esta variable es solo para depuracion.
        // int documentoactual = 0;
        
        using (CConector conector = new CConector()) {

            List<SIIGOFile> lista = new List<SIIGOFile>();

            for (int i = 0; i < GResultados.Rows.Count; i++) {

                try
                {
                    Producto producto= Producto.GetProducto(GResultados.DataKeys[i].Values["IdProducto"].ToString());
                    if (string.IsNullOrEmpty(producto.CodigoSIIGO) || string.IsNullOrEmpty(producto.CuentaInventario) || string.IsNullOrEmpty(producto.CuentaCosto))
                    {
                        // este producto no tiene codigo siigo
                        productosNoEncontrados[producto.id] = producto;
                        continue;
                    }

                    Int64 paciente = 0;
                    Int64 tercero = 0;
                    HyperLink h= (HyperLink)GResultados.Rows[i].FindControl("f");
                    DateTime fecha = Convert.ToDateTime(h.Text);
                    string szTercero = "";
                    foreach (char dig in GResultados.DataKeys[i].Values["tercero"].ToString()) {
                        if (Char.IsDigit(dig)) 
                            szTercero += dig;
                        if (dig == '-')
                            break;
                    }

                    string nombreProducto = producto.nombre;
                    if (!string.IsNullOrEmpty(producto.unidad))
                        nombreProducto += " (" + producto.unidad + ")";

                    Paciente pPaciente = Paciente.GetPaciente(GResultados.DataKeys[i].Values["IdPaciente"].ToString());

                    try { paciente = Convert.ToInt64(pPaciente.documento); } catch { }
                    try { tercero= Convert.ToInt64(szTercero); } catch { }

                    SIIGOFile salida = new SIIGOFile(Convert.ToInt32(GResultados.DataKeys[i].Values["id"]), paciente
                        , fecha, Convert.ToInt64(producto.CodigoSIIGO), nombreProducto
                        , Decimal.Parse(GResultados.GetGridCellText("Costo", i), NumberStyles.Currency)
                        , Convert.ToDecimal(GResultados.GetGridCellText("Cantidad", i)));
                    SIIGOFile salidaCosto = new SIIGOFile(salida.Documento, salida.NIT, salida.Fecha, salida.CodigoProducto, salida.DescripcionDelMovimiento, salida.ValorMovimiento, salida.Cantidad);

                    /*if (documentoactual!=0 && documentoactual != salida.Documento)
                        break;
                    documentoactual = salida.Documento;*/

                    SIIGOFile entrada = new SIIGOFile(salida);
                    entrada.NIT = tercero;

                    try { entrada.CuentaContable = Convert.ToInt64(producto.CuentaInventario); } catch {}
                    try { salida.CuentaContable = Convert.ToInt64(producto.CuentaInventario); } catch {}
                    // solo la segunda salida lleva la segunda salida
                    try { salidaCosto.CuentaContable = Convert.ToInt64(producto.CuentaCosto); } catch {}

                    int CentrodeCosto=0;
                    try
                    {
                        CentrodeCosto = Convert.ToInt32(GResultados.DataKeys[i].Values["costoSIIGO"].ToString());
                    } catch { }

                    switch (GResultados.DataKeys[i].Values["consulta"].ToString()) {
                        case "1": // Entradas
                            entrada.DescripcionDelMovimiento = "E" + entrada.Documento + " " + entrada.DescripcionDelMovimiento;
                            entrada.Secuencia = entradas.Count(x => x.Documento == entrada.Documento) + 1;
                            /*if (entrada.NIT == 0)
                                entrada.NIT = NIT_OrganizationExample15;*/
                            lista.Add(entrada);

                            entradas.Add(entrada);
                            // return "Entrada";
                            break;
                        case "2": // Orden de compra
                            if (paciente != 0)
                            {
                                entrada.DescripcionDelMovimiento = "OC" + entrada.Documento + " " + entrada.DescripcionDelMovimiento;
                                salida.DescripcionDelMovimiento = "OC" + salida.Documento + " " + salida.DescripcionDelMovimiento;
                                salidaCosto.DescripcionDelMovimiento = salida.DescripcionDelMovimiento;

                                entrada.Documento += 1000000000;
                                entrada.Secuencia = entradas.Count(x => x.Documento == entrada.Documento) + 1;
                                salida.Documento += 1000000000;
                                salidaCosto.Documento += 1000000000;
                                
                                // if (documentoactual == 0)
                                lista.Add(entrada);

                                salida.Secuencia = salidas.Count(x => x.Documento == salida.Documento) + 1;
                                lista.Add(salida);

                                // solo la segunda salida lleva el centro de costo.
                                salidaCosto.CentroDeCosto = CentrodeCosto;
                                if (salidaCosto.CentroDeCosto == 0)
                                    salidaCosto.CentroDeCosto = 6;
                                salidaCosto.Secuencia = salida.Secuencia + 1;
                                salidaCosto.TipoDocumentoPedido = "0";
                                salidaCosto.DebitoCredito = "D";
                                lista.Add(salidaCosto);

                                // if (documentoactual == 0)
                                entradas.Add(entrada);
                                salidas.Add(salida);
                                salidas.Add(salidaCosto);
                            }
                            // return "Orden de compra";
                            break;
                        case "3": // Requisicion
                            salida.CodigoTipoDocumento = 1;
                            salida.DescripcionDelMovimiento = "R" + salida.Documento + " " + salida.DescripcionDelMovimiento;
                            salidaCosto.DescripcionDelMovimiento = salida.DescripcionDelMovimiento;

                            salida.Secuencia = salidas.Count(x => x.Documento == salida.Documento) + 1;

                            if (salida.NIT == 0)
                                salidaCosto.NIT= salida.NIT = NIT_OrganizationExample15;

                            lista.Add(salida);

                            // solo la segunda salida lleva el centro de costo.
                            salidaCosto.CentroDeCosto = CentrodeCosto;
                            if (salidaCosto.CentroDeCosto == 0)
                                salidaCosto.CentroDeCosto = 6;
                            salidaCosto.Secuencia = salida.Secuencia + 1;
                            salidaCosto.TipoDocumentoPedido = "0";
                            salidaCosto.DebitoCredito = "D";
                            lista.Add(salidaCosto);

                            salidas.Add(salida);
                            salidas.Add(salidaCosto);
                            // return "Requisición";
                            break;
                        case "4": // Devolucion
                            entrada.DescripcionDelMovimiento = "DV" + entrada.Documento + " " + entrada.DescripcionDelMovimiento;
                            entrada.Documento += 2000000000;
                            entrada.Secuencia = devoluciones.Count(x => x.Documento == entrada.Documento) + 1;
                            entrada.NIT = paciente;

                            entrada.CodigoTipoDocumento = 6;

                            salida.Tipo = "E";
                            salida.DescripcionDelMovimiento = "DV" + salida.Documento + " " + salida.DescripcionDelMovimiento;
                            salida.Documento += 2000000000;
                            salida.CodigoTipoDocumento = 6;
                            salida.Secuencia = entrada.Secuencia + 1;
                            salida.NIT = paciente;
                            salida.CentroDeCosto = CentrodeCosto;
                            if (salida.CentroDeCosto == 0)
                                salida.CentroDeCosto = 6;
                            salida.CuentaContable = salidaCosto.CuentaContable;
                            salida.TipoDocumentoPedido = "0";

                            lista.Add(entrada);
                            lista.Add(salida);

                            devoluciones.Add(entrada);
                            devoluciones.Add(salida);
                            // return "Devolución";
                            break;
                    }
                }
                catch (Exception ex)
                {
                    LMensaje.Text = "Error en la línea " + i + ", " + ex.ToString();
                    return;
                }
            }
            if (productosNoEncontrados.Count != 0) {
                foreach (KeyValuePair<string, Producto> info in productosNoEncontrados) {
                    if (LMensaje.Text.Length != 0)
                        LMensaje.Text += "<br/>";
                    LMensaje.Text += "Producto sin código SIIGO: " + info.Value.id + " - " + info.Value.NombreCompleto;
                }
                return;
            }

            // totalizamos las entradas
            while(entradas.Count>0) {
                int documento = entradas[0].Documento;
                List<SIIGOFile> listae = entradas.Where(x => x.Documento == documento).ToList();
                SIIGOFile resumen = new SIIGOFile(listae);
                resumen.CuentaContable = 2205050000;
                // limpiamos la lista
                lista.Add(resumen);
                entradas.RemoveAll(x => x.Documento == documento);
            }

            lista= sender==BSiigoS ? lista.Where(x=>x.Tipo=="S").ToList() : lista.Where(x=>x.Tipo=="E").ToList();

            lista= lista.OrderBy(x=>x.Tipo).ThenBy(x => x.Documento).ThenBy(x => x.Secuencia).ToList();

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode("SIIGO_" + (sender == BSiigoS ? "S" : "E") + "-" + TDesde.Text + "-" + THasta.Text) + ".txt");
            Response.ContentType = "text/plain";
            Response.ContentEncoding = System.Text.Encoding.ASCII;

            FixedFileEngine engine = new FixedFileEngine(typeof(SIIGOFile));
            Response.Write(engine.WriteString(lista).Replace("\n", "\r\n"));
        }
        Response.End();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string consultas = "0";
        foreach (ListItem item in DVer.Items) {
            if (!string.IsNullOrEmpty(Request.QueryString["r"]))
                item.Selected = true;
            if (item.Selected) {
                consultas += "," + item.Value;
            }
        }
        SResultados.SelectCommand = String.Format(SResultados.SelectCommand, m_nAlmacen, m_nAlmacen).Replace("@consultas", consultas);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            // para el filtro por usuarios.
            ViewState["entidades"] = usuario["entidades"];
            if (string.IsNullOrEmpty(Request.QueryString["d"]))
                THasta.Text = DateTime.Now.ToShortDateString();
            else THasta.Text = Request.QueryString["d"];
            if (string.IsNullOrEmpty(Request.QueryString["f"]))
                TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            else TDesde.Text = Request.QueryString["f"];
            if (!string.IsNullOrEmpty(Request.QueryString["p"]))
            {
                TPacienteID.Text = Request.QueryString["p"];
                TPaciente.Text = Paciente.GetPaciente(TPacienteID.Text).DocumentoYNombres;
            }
            if (!string.IsNullOrEmpty(Request.QueryString["m"]))
                TNombre.Text = Producto.GetProducto(Request.QueryString["m"]).nombre;
            if (!string.IsNullOrEmpty(Request.QueryString["r"]))
            {
                BBuscar_Click(sender, e);
            }
        }
    }

    protected void Totalizar(List<GridViewRow> rows, string columna)
    {
        int col = GResultados.GetGridColumnIndex(columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : Convert.ToInt32(x.Cells[col].Text)).ToString();
    }
    protected void TotalizarDinero(List<GridViewRow> rows, string columna)
    {
        int col = GResultados.GetGridColumnIndex(columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = string.Format("{0:C0}", rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text, NumberStyles.Currency)));
    }
    protected void ContarDistinct(List<GridViewRow> rows, string columna, string control) {
        int col = GResultados.GetGridColumnIndex(columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Select(x => ((HyperLink)x.FindControl(control)).Text).Distinct().Count().ToString();
    }
    protected void ContarDistinct(List<GridViewRow> rows, string columna)
    {
        int col = GResultados.GetGridColumnIndex(columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Select(x => x.Cells[col].Text).Distinct().Count().ToString();
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        LMensaje.Text = "";
        LSIIGO.Visible = 
        BSiigoS.Visible= 
        BSiigoE.Visible = false;
        GResultados.Visible = true;
        GResultados.DataSourceID = "SResultados";

        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            LSIIGO.Visible= 
            BSiigoS.Visible = 
            BSiigoE.Visible = true;
            // ((MasterPageI)Master).Imprimir(GResultados);
            ((MasterPageI)Master).Excel(GResultados);
            List<GridViewRow> rows=GResultados.Rows.Cast<GridViewRow>().ToList();
            Totalizar(rows, "Cantidad");
            TotalizarDinero(rows, "Costo");
            TotalizarDinero(rows, "Precio");
            TotalizarDinero(rows, "Utilidad");
            ContarDistinct(rows, "Tipo", "t");
            ContarDistinct(rows, "Número", "n");
            ContarDistinct(rows, "Fecha", "f");
            ContarDistinct(rows, "Paciente");
            ContarDistinct(rows, "Asegurador");
            ContarDistinct(rows, "Centro costos");
            ContarDistinct(rows, "Proveedor");
            ContarDistinct(rows, "Productos");
        }
    }

    public string GetNavigateURL(string consulta, string id) {

        switch (consulta)
        {
            case "1":
                return "~/farmacia/entrada.aspx?ei=" + id;
            case "2":
                return "~/farmacia/ordendecompra.aspx?oci=" + id;
            case "3":
                return "~/farmacia/salida.aspx?si=" + id;
            case "4":
                return "~/farmacia/devolucion.aspx?di=" + id;
        }
        return null;
    }

    public string GetNombreTipo(string consulta) {
        
        switch (consulta)
        {
            case "1":
                return "Entrada";
            case "2":
                return "Orden de compra";
            case "3":
                return "Requisición";
            case "4":
                return "Devolución";
        }
        return null;
    }
}
