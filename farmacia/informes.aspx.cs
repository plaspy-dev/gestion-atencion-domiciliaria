using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Globalization;
using FileHelpers;
using MySql.Data.MySqlClient;

public partial class farmacia_informes : System.Web.UI.Page
{
    [FixedLengthRecord]
    public class SIIGOFile
    {

        public class NumberConverter : ConverterBase
        {
            private int mDecimals = 2;

            public NumberConverter(int decimals)
            {
                mDecimals = decimals;
            }

            public NumberConverter() { }

            public override object StringToField(string from)
            {
                return Convert.ToDecimal(Decimal.Parse(from) / (10 ^ mDecimals));
            }

            public override string FieldToString(object fieldValue)
            {
                return Convert.ToInt32(Convert.ToDouble(fieldValue) * Math.Pow(10, mDecimals)).ToString();
            }
        }

        [FieldFixedLength(1)]
        protected string Tipo = "S";
        [FieldFixedLength(3)]
        protected int Codigo = 3;
        [FieldFixedLength(11)]
        public int Documento;
        [FieldFixedLength(5)]
        protected int Secuencia = 1;
        [FieldFixedLength(13)]
        public Int64 NIT;
        [FieldFixedLength(3)]
        protected int Sucursal = 0;
        [FieldFixedLength(10)]
        public Int64 CuentaContable = 0;
        [FieldFixedLength(13)] // revisar porque el manual dice que son 13
        public Int64 CodigoProducto;
        [FieldFixedLength(8)]
        [FieldConverter(ConverterKind.Date, "yyyyMMdd")]
        public DateTime Fecha;
        [FieldFixedLength(4)]
        public int CentroDeCosto = 0;
        [FieldFixedLength(3)]
        protected int SubCentroDeCosto = 0;
        [FieldFixedLength(50)]
        public string DescripcionDelMovimiento;
        [FieldFixedLength(1)]
        protected string DebitoCredito = "C";
        [FieldFixedLength(15)]
        [FieldConverter(typeof(NumberConverter))]
        public decimal ValorMovimiento;
        [FieldFixedLength(15)]
        [FieldConverter(typeof(NumberConverter))]
        protected decimal ValorBase = 0;
        [FieldFixedLength(4)]
        protected int CodigoVendedor = 1;
        [FieldFixedLength(4)]
        protected int CodigoCiudad = 1;
        [FieldFixedLength(3)]
        protected int CodigoZona = 0;
        [FieldFixedLength(4)]
        protected int CodigoBodega = 1;
        [FieldFixedLength(3)]
        protected int CodigoUbicacion = 0;
        [FieldFixedLength(15)]
        [FieldConverter(typeof(NumberConverter), 5)]
        protected decimal nCantidad;


        // de aqui para adelante no se usan.
        [FieldFixedLength(1)]
        protected string TipoDocumentoCruze;
        [FieldFixedLength(3)]
        protected string CodigoComprobanteCruze;
        [FieldFixedLength(11)]
        protected Int64 NumeroDocumentoCruze;
        [FieldFixedLength(3)]
        protected int SecuenciaDocumentoCruze;
        [FieldFixedLength(8)]
        // [FieldConverter(ConverterKind.Date, "yyyyMMdd")] // esta en ceros
        protected int FechaDocumentoCruze;
        [FieldFixedLength(4)]
        protected int CodigoFormaPago;
        [FieldFixedLength(2)]
        protected int CodigoDelBanco;
        [FieldFixedLength(1)]
        protected string TipoDocumentoPedido;
        [FieldFixedLength(3)]
        protected int CodigoComprobantePedido;

        // pagina 2
        [FieldFixedLength(111)]
        protected int Relleno1;
        [FieldFixedLength(1)]
        protected string sRelleno1;
        [FieldFixedLength(12)]
        protected int Relleno2;
        [FieldFixedLength(6)]
        protected string sRelleno2;
        [FieldFixedLength(1)]
        protected int Relleno3;
        [FieldFixedLength(1)]
        protected string sRelleno3;
        [FieldFixedLength(2)]
        protected int Relleno4;
        [FieldFixedLength(4)]
        protected string sRelleno4;
        [FieldFixedLength(11)]
        protected int Relleno5;
        [FieldFixedLength(10)]
        protected string sRelleno5;
        [FieldFixedLength(44)]
        protected int Relleno6;
        [FieldFixedLength(1)]
        protected string sRelleno6;
        [FieldFixedLength(3)]
        protected int Relleno7;
        [FieldFixedLength(13)]
        protected string sRelleno7;
        [FieldFixedLength(48)]
        protected int Relleno8;
        [FieldFixedLength(1)]
        protected string sRelleno8;
        [FieldFixedLength(18)]
        [FieldConverter(typeof(NumberConverter), 5)]
        protected decimal nCantidad2;
        [FieldFixedLength(21)]
        protected int Relleno9;
        [FieldFixedLength(6)]
        protected string sRelleno9;
        [FieldFixedLength(4)]
        protected int Relleno10;
        [FieldFixedLength(83)]
        protected string sRelleno10;

        [FieldFixedLength(36)]
        protected int Relleno11;
        [FieldFixedLength(3)]
        protected string sRelleno11;
        [FieldFixedLength(15)]
        protected int Relleno12;
        [FieldFixedLength(24)]
        protected string sRelleno12;
        [FieldFixedLength(30)]
        protected int Relleno13;
        [FieldFixedLength(67)]
        protected string sRelleno13;
        [FieldFixedLength(15)]
        protected int Relleno14;

        /*[FieldFixedLength()]
        protected string sRelleno14;
        [FieldFixedLength()]
        protected int Relleno15;
        [FieldFixedLength()]
        protected string sRelleno15;
        [FieldFixedLength()]
        protected int Relleno16;
        [FieldFixedLength()]
        protected string sRelleno16;
        [FieldFixedLength()]
        protected int Relleno17;
        [FieldFixedLength()]
        protected string sRelleno17;
        [FieldFixedLength()]
        protected int Relleno18;
        [FieldFixedLength()]
        protected string sRelleno18;
        [FieldFixedLength()]
        protected int Relleno19;
        [FieldFixedLength()]
        protected string sRelleno19;*/



        public decimal Cantidad
        {
            set { nCantidad = nCantidad2 = value; }
            get { return nCantidad; }
        }

        public SIIGOFile()
        {
        }

        public SIIGOFile(bool entrada)
        {
            if (entrada)
            {
                Tipo = "E";
                DebitoCredito = "D";
            }
        }

        // esta funcion es para crear la salida
        public SIIGOFile(SIIGOFile salida) {
            
            Tipo = "E";
            DebitoCredito = "D";
            Documento = salida.Documento;
            NIT = salida.NIT;
            Fecha = salida.Fecha;
            CodigoProducto = salida.CodigoProducto;
            DescripcionDelMovimiento = salida.DescripcionDelMovimiento;
            ValorMovimiento = salida.ValorMovimiento;
            Cantidad = salida.Cantidad;
            ValorBase = ValorMovimiento;
            CuentaContable = 0; // la cuenta de la entrada
        }

        public SIIGOFile(int documento, Int64 nit, DateTime fecha, Int64 codigoProducto, string descripcionProducto, decimal valor, decimal cantidad)
        {
            Documento = documento;
            NIT = nit;
            Fecha = fecha;
            CodigoProducto = codigoProducto;
            DescripcionDelMovimiento = descripcionProducto;
            ValorMovimiento = valor;
            Cantidad = cantidad;
        }
    }

    public static int m_nAlmacen = 1;
    public int m_nPaciente = -1;
    public int m_nConsulta = -1;

    protected void BSiigo_Click(object sender, EventArgs e) {

        LMensaje.Text = "";

        Dictionary<string, Producto> productosNoEncontrados = new Dictionary<string, Producto>();
        Dictionary<string, Int64> cuentaEntrada = new Dictionary<string, Int64>();
        Dictionary<string, Int64> cuentaSalida = new Dictionary<string, Int64>();

        using (CConector conector = new CConector()) {

            List<SIIGOFile> lista = new List<SIIGOFile>();

            for (int i = 0; i < GResultados.Rows.Count; i++) {

                try
                {
                    Producto producto= Producto.GetProducto(GResultados.DataKeys[i].Values["IdProducto"].ToString());
                    if (string.IsNullOrEmpty(producto.CodigoSIIGO))
                    {
                        // este producto no tiene codigo siigo
                        productosNoEncontrados[producto.id] = producto;
                        continue;
                    }

                    // buscamos la cuenta del producto
                    Int64? nCuentaEntrada = null, nCuentaSalida=null;

                    try { nCuentaEntrada= cuentaEntrada[producto.Tipo];} catch {}
                    try { nCuentaSalida= cuentaSalida[producto.Tipo];} catch {}
                    if (nCuentaEntrada == null)
                    {
                        string cuenta= conector.QueryString(string.Format("SELECT szReservado FROM varios WHERE id={0}", producto.Tipo));
                        string []cuentas= cuenta.Split('-');
                        Int64 centrada=0, csalida=0;
                        if (cuentas.Length > 1) {
                            try
                            {
                                centrada = Convert.ToInt64(cuentas[0]);
                                csalida = Convert.ToInt64(cuentas[1]);
                            } catch { }
                            cuentaEntrada[producto.Tipo] = centrada;
                            cuentaSalida[producto.Tipo] = csalida;
                        }
                        nCuentaEntrada = centrada;
                        nCuentaSalida = csalida;
                    }

                    Int64 paciente = 0;
                    Int64 tercero = 0;
                    HyperLink h= (HyperLink)GResultados.Rows[i].FindControl("f");
                    DateTime fecha = Convert.ToDateTime(h.Text);

                    try { paciente = Convert.ToInt64(GResultados.DataKeys[i].Values["IdPaciente"].ToString()); } catch { }
                    try { tercero= Convert.ToInt64(GResultados.DataKeys[i].Values["tercero"].ToString()); } catch { }

                    SIIGOFile salida = new SIIGOFile(Convert.ToInt32(GResultados.DataKeys[i].Values["id"]), paciente
                        , fecha, Convert.ToInt64(producto.CodigoSIIGO), producto.NombreCompleto
                        , Decimal.Parse(Utilidades.GetGridCellText(GResultados, "Costo", i), NumberStyles.Currency)
                        , Convert.ToDecimal(Utilidades.GetGridCellText(GResultados, "Cantidad", i)));

                    SIIGOFile entrada = new SIIGOFile(salida);
                    entrada.NIT = tercero;

                    entrada.CuentaContable = nCuentaEntrada==null ? 0 : nCuentaEntrada.Value;
                    salida.CuentaContable = nCuentaSalida == null ? 0 : nCuentaSalida.Value;
                    try
                    {
                        salida.CentroDeCosto =
                        entrada.CentroDeCosto = Convert.ToInt32(GResultados.DataKeys[i].Values["costoSIIGO"].ToString());
                    } catch { }

                    switch (GResultados.DataKeys[i].Values["consulta"].ToString()) {
                        case "1":
                            entrada.DescripcionDelMovimiento = "E" + entrada.Documento + " " + entrada.DescripcionDelMovimiento;
                            lista.Add(entrada);
                            // return "Entrada";
                            break;
                        case "2":
                            if (paciente != 0)
                            {
                                entrada.DescripcionDelMovimiento = "OC" + entrada.Documento + " " + entrada.DescripcionDelMovimiento;
                                salida.DescripcionDelMovimiento = "OC" + salida.Documento + " " + salida.DescripcionDelMovimiento;
                                lista.Add(entrada);
                                lista.Add(salida);
                            }
                            // return "Orden de compra";
                            break;
                        case "3":
                            salida.DescripcionDelMovimiento = "R" + salida.Documento + " " + salida.DescripcionDelMovimiento;
                            lista.Add(salida);
                            // return "Requisición";
                            break;
                        case "4":
                            entrada.DescripcionDelMovimiento = "DV" + entrada.Documento + " " + entrada.DescripcionDelMovimiento;
                            entrada.NIT = paciente;
                            lista.Add(entrada);
                            // return "Devolución";
                            break;
                    }
                }
                catch
                {
                    LMensaje.Text = "Error en la línea " + i;
                    return;
                }
            }
            if (productosNoEncontrados.Count != 0) {
                foreach (KeyValuePair<string, Producto> info in productosNoEncontrados) {
                    if (LMensaje.Text.Length != 0)
                        LMensaje.Text += "<br/>";
                    LMensaje.Text += "Producto sin código SIIGO: " + info.Value.NombreCompleto;
                }
                return;
            }

            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode("s3-SIIGO-" + TDesde.Text + "-" + THasta.Text) + ".txt");
            Response.ContentType = "text/plain";
            Response.ContentEncoding = System.Text.Encoding.GetEncoding("utf-8");

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
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : Convert.ToInt32(x.Cells[col].Text)).ToString();
    }
    protected void TotalizarDinero(List<GridViewRow> rows, string columna)
    {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = string.Format("{0:C0}", rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : decimal.Parse(x.Cells[col].Text, NumberStyles.Currency)));
    }
    protected void ContarDistinct(List<GridViewRow> rows, string columna, string control) {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Select(x => ((HyperLink)x.FindControl(control)).Text).Distinct().Count().ToString();
    }
    protected void ContarDistinct(List<GridViewRow> rows, string columna)
    {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        if(GResultados.FooterRow!=null) 
            GResultados.FooterRow.Cells[col].Text = rows.Select(x => x.Cells[col].Text).Distinct().Count().ToString();
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        LMensaje.Text = "";
        BSiigo.Visible = false;
        GResultados.Visible = true;
        GResultados.DataSourceID = "SResultados";

        if (Utilidades.GetRowsCount(GResultados, LTotal) > 0)
        {
            BSiigo.Visible = true;
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
