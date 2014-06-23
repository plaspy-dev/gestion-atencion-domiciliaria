using System;
using System.Collections;
using System.Globalization;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class farmacia_estado : System.Web.UI.Page
{
    public static int m_nAlmacen = 1;

    protected class Kardex
    {

        protected decimal _entradas = 0;
        protected decimal _salidas = 0;
        protected decimal _saldos = 0;

        public string fecha { get; set; }
        public bool bEntradas = false;
        public decimal entradas { get { return _entradas; } set { bEntradas = true; _entradas = value; } }
        public bool bSalidas = false;
        public decimal salidas { get { return _salidas; } set { bSalidas = true; _salidas = value; } }
        public bool bSaldos = false;
        public decimal saldo { get { return _saldos; } set { bSaldos = true; _saldos = value; } }

        public Kardex(string szFecha)
        {
            fecha = szFecha;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // CConector.ReplaceConnectionString(Master.Controls);
        // ((MasterPageI)Master).CheckAlmacen();
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["vid"]))
            {
                Producto info = Producto.GetProducto(Request.QueryString["vid"]);
                TProductoID.Text = info.id;
                TProducto.Text = info.NombreCompleto;
                CDetallado.Checked = true;

                TVence.Text = DateTime.Now.ToShortDateString();
            }
            /*else if (!string.IsNullOrEmpty(Request.QueryString["pvid"]))
            {
                Producto info = Producto.GetProducto(Request.QueryString["pvid"]);
                TProductoID.Text = info.id;
                TProducto.Text = info.NombreCompleto;

                using (CConector conector = new CConector())
                {
                    string dias = conector.QueryString("SELECT dias_alerta FROM producto WHERE id=" + Query.GetValor(info.id));
                    try
                    {
                        TVence.Text = DateTime.Now.AddDays(Convert.ToInt32(dias)).ToShortDateString();
                    }
                    catch { }
                }
                CDetallado.Checked = true;
            }*/
            else if (!string.IsNullOrEmpty(Request.QueryString["gpid"]))
            {

                Producto info = Producto.GetProducto(Request.QueryString["gpid"]);
                TProductoID.Text = info.id;
                TProducto.Text = info.NombreCompleto;
            }

            // ((MasterPageI)Master).InitAlmacen();
            ((MasterPageI)Master).RestoreState();
        }

        SKardex.SelectCommand = String.Format(SKardex.SelectCommand, m_nAlmacen.ToString());

        
        SResultados.SelectCommand = String.Format(SResultados.SelectCommand, m_nAlmacen.ToString(), m_nAlmacen.ToString());
        SResultados1.SelectCommand = String.Format(SResultados1.SelectCommand, m_nAlmacen.ToString(), m_nAlmacen.ToString());

        if (!IsPostBack)
        {

            CConfiguracion configuracion = CConfiguracion.GetConfiguracion();

            // costo
            Utilidades.GetGridColumn(GResultados, "Costo").Visible = configuracion.nCosto != 0;

            // vencimiento
            TVence.Visible = LVence.Visible = configuracion.bVencimiento;

            // ubicacion
            TUbicacion.Visible = TUbicacionID.Visible = LUbicacion.Visible = configuracion.nUbicacion != 0;

            if (!string.IsNullOrEmpty(Request.QueryString["pid"]))
            { // Kardex

                Utilidades.GetGridColumn(GKardex, "Costo U.E.").Visible =
                Utilidades.GetGridColumn(GKardex, "Costo T.E.").Visible =
                Utilidades.GetGridColumn(GKardex, "Costo U.S.").Visible =
                Utilidades.GetGridColumn(GKardex, "Costo T.S.").Visible =
                Utilidades.GetGridColumn(GKardex, "Costo U.").Visible =
                Utilidades.GetGridColumn(GKardex, "Costo T.").Visible =
                chart_costos.Visible =
                configuracion.nCosto != 0;

                if (TDesde.Text.Length == 0)
                {
                    TDesde.Text = DateTime.Now.AddDays(-DateTime.Now.Day + 1).ToShortDateString();
                    THasta.Text = DateTime.Now.ToShortDateString();
                }

                PKardex.Visible = true;
                PBuscar.Visible = false;
                Page.Title = "Kardex de " + Producto.GetProducto(Request.QueryString["pid"]).nombre;

                BActualizar_Click(sender, e);
            }
            else
            {
                PKardex.Visible = false;
                PBuscar.Visible = true;
                BBuscar_Click(sender, e);
            }
        }
    }

    protected Kardex GetFecha(List<Kardex> grafica, string fecha)
    {

        Kardex kardex = null;
        List<Kardex> resultado = (from p in grafica where p.fecha == fecha select p).ToList();
        if (resultado.Count == 0)
        {
            kardex = new Kardex(fecha);
            grafica.Add(kardex);
        }
        else kardex = resultado[0];
        return kardex;
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.DataSourceID = CDetallado.Checked ? "SResultados1" : "SResultados";

        Utilidades.GetGridColumn(GResultados, "Lote").Visible = CDetallado.Checked && CConfiguracion.GetConfiguracion().bLote;
        Utilidades.GetGridColumn(GResultados, "Vence").Visible = CDetallado.Checked && CConfiguracion.GetConfiguracion().bVencimiento;

        if (Utilidades.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir("estado.html", true);
        }
        else
        {
            ((MasterPageI)Master).Imprimir((string)null);
        }
    }
    protected void GKardex_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {

            String id = e.Row.Cells[1].Text;
            e.Row.Cells[1].Text = "";
            HyperLink link = new HyperLink();
            link.Target = "_blank";
            switch (DataBinder.Eval(e.Row.DataItem, "tipo").ToString())
            {
                case "1":
                    link.Text = "Entrada No. " + id;
                    link.NavigateUrl = "~/farmacia/entrada.aspx?ei=" + id;
                    break;
                case "2":
                    link.Text = "Traslado No. " + id;
                    link.NavigateUrl = "~/farmacia/traslado.aspx?ti=" + id;
                    break;
                case "3":
                    link.Text = "Remisión No. " + id;
                    link.NavigateUrl = "~/farmacia/salida.aspx?si=" + id;
                    break;
                case "4":
                case "5":
                    link.Text = "Transformación No. " + id;
                    link.NavigateUrl = "~/farmacia/transformaciones.aspx?tri=" + id;
                    break;
                case "6":
                    link.Text = "Devolución No. " + id;
                    link.NavigateUrl = "~/farmacia/devolucion.aspx?di=" + id;
                    break;
                case "-1":
                    e.Row.Cells[0].Text = TDesde.Text;
                    e.Row.Cells[1].Text = "Corte a " + TDesde.Text;
                    return;
            }
            e.Row.Cells[1].Controls.Add(link);
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {

        ViewState["producto"] = null;
        GResultados.SelectedIndex = -1;
    }

    protected void GResultados_SelectedIndexChanged(object sender, EventArgs e)
    {
    }
    
    protected void BActualizar_Click(object sender, EventArgs e)
    {
        try
        {
            if (!IsValid)
                return;
        }
        catch { }

        GKardex.DataBind();
        if (GKardex.Rows.Count > 0)
            ((MasterPageI)Master).Imprimir("kardex.html", true);
        else ((MasterPageI)Master).Imprimir((string)null);

        LSalidas.Text = "";
        LCostos.Text = "";
        LEntradas.Text = "";
        LSaldos.Text = "";

        Decimal saldo = 0, entradas = 0, salidas = 0, costosaldo = 0, costoentradas = 0, costosalidas = 0, costop = 0;

        int columnafecha = Utilidades.GetGridColumnIndex(GKardex, "Fecha");
        int columnasalida = Utilidades.GetGridColumnIndex(GKardex, "Salida");
        int columnaentrada = Utilidades.GetGridColumnIndex(GKardex, "Entrada");
        int columnasaldo = Utilidades.GetGridColumnIndex(GKardex, "Saldo");
        int columnaCostoUEntrada = Utilidades.GetGridColumnIndex(GKardex, "Costo U.E.");
        int columnaCostoTEntrada = Utilidades.GetGridColumnIndex(GKardex, "Costo T.E.");
        int columnaCostoTSalida = Utilidades.GetGridColumnIndex(GKardex, "Costo T.S.");
        int columnaCostoTSaldo = Utilidades.GetGridColumnIndex(GKardex, "Costo T.");
        int columnaCostoPromedio = Utilidades.GetGridColumnIndex(GKardex, "Costo U.");
        int columnaCostoUSalida = Utilidades.GetGridColumnIndex(GKardex, "Costo U.S.");

        List<Kardex> grafica = new List<Kardex>();

        Decimal saldoa = 0, costosaldoa = 0;

        if (new Producto(Request.QueryString["pid"]).GetAcumulado(m_nAlmacen.ToString(), Query.GetMySQLDateFormat(TDesde.Text)
            , ref costosaldoa, ref saldoa, ref costop))
        {
            int index = GKardex.Rows.Count - 1;
            GKardex.Rows[index].Cells[columnaentrada].Text = saldoa.ToString();
            GKardex.Rows[index].Cells[columnaCostoUEntrada].Text = string.Format("{0:C}", costop);
            GKardex.Rows[index].Cells[columnaCostoTEntrada].Text = string.Format("{0:C}", costosaldoa);
            costop = 0;
        }

        for (int i = GKardex.Rows.Count - 1; i >= 0; i--)
        {

            string fecha = GKardex.Rows[i].Cells[columnafecha].Text;
            try
            {
                decimal valor = Convert.ToDecimal(GKardex.Rows[i].Cells[columnasalida].Text);
                salidas += valor;
                saldo -= valor;

                GetFecha(grafica, fecha).salidas += valor;

                // calculamos el valor a que salio el producto.
                valor = costop * valor;

                GKardex.Rows[i].Cells[columnaCostoUSalida].Text = string.Format("{0:C}", costop);
                GKardex.Rows[i].Cells[columnaCostoTSalida].Text = string.Format("{0:C}", valor);

                costosalidas += valor;
                costop = costosaldo -= valor;
            }
            catch { }
            try
            {
                decimal valor = Convert.ToDecimal(GKardex.Rows[i].Cells[columnaentrada].Text);
                entradas += valor;
                saldo += valor;

                GetFecha(grafica, fecha).entradas += valor;

                valor = decimal.Parse(GKardex.Rows[i].Cells[columnaCostoTEntrada].Text, NumberStyles.Currency);
                costoentradas += valor;
                costosaldo += valor;

                LCostos.Text += string.Format(",['{0}', {1}]"
                    , fecha
                    , decimal.Parse(GKardex.Rows[i].Cells[columnaCostoUEntrada].Text, NumberStyles.Currency).ToString(CultureInfo.InvariantCulture));
            }
            catch { }

            GetFecha(grafica, fecha).saldo = saldo;

            if (saldo > 0)
                costop = costosaldo / saldo;
            GKardex.Rows[i].Cells[columnasaldo].Text = saldo.ToString();
            GKardex.Rows[i].Cells[columnaCostoTSaldo].Text = string.Format("{0:C}", costosaldo);
            GKardex.Rows[i].Cells[columnaCostoPromedio].Text = string.Format("{0:C}", costop);
        }

        for (int i = 0; i < grafica.Count; i++)
        {
            Kardex kardex = grafica[i];
            if (kardex.bSalidas)
                LSalidas.Text += string.Format(",['{0}', {1}]"
                    , kardex.fecha
                    , kardex.salidas.ToString(CultureInfo.InvariantCulture)
                    );

            if (kardex.bEntradas)
                LEntradas.Text += string.Format(",['{0}', {1}]"
                    , kardex.fecha
                    , kardex.entradas.ToString(CultureInfo.InvariantCulture)
                    );
            if (kardex.bSaldos)
                LSaldos.Text += string.Format(",['{0}', {1}]"
                    , kardex.fecha
                    , kardex.saldo.ToString(CultureInfo.InvariantCulture)
                    );
        }

        // LCostos.Text = ",['2012/02/02', 15.15],['2012/02/01', 16.15]";
        if (GKardex.FooterRow != null)
        {
            GKardex.FooterRow.Cells[Utilidades.GetGridColumnIndex(GKardex, "Concepto")].Text = "Total sin acumulado";
            GKardex.FooterRow.Cells[columnaentrada].Text = string.Format("{0:F}", entradas - saldoa);
            GKardex.FooterRow.Cells[columnasalida].Text = string.Format("{0:F}", salidas);
            GKardex.FooterRow.Cells[columnaCostoTEntrada].Text = string.Format("{0:C}", costoentradas - costosaldoa);
            GKardex.FooterRow.Cells[columnaCostoTSalida].Text = string.Format("{0:C}", costosalidas);
            GKardex.FooterRow.Cells[columnasaldo].Text = string.Format("{0:F}", entradas - saldoa - salidas);
            //GKardex.FooterRow.Cells[columnaCostoPromedio].Text = costop.ToString();
            GKardex.FooterRow.Cells[columnaCostoTSaldo].Text = string.Format("{0:C}", costoentradas - costosaldoa - costosalidas);
        }

        LDias.Text = LRotacion.Text = "";
        try
        {
            decimal rotacion = salidas / (entradas / 2);
            LRotacion.Text = string.Format("Índice de rotación: {0:F}.", rotacion);

            TimeSpan span = Convert.ToDateTime(THasta.Text) - Convert.ToDateTime(TDesde.Text);
            decimal diaseni = span.Days / rotacion;
            LDias.Text = string.Format("<br/>{0:F} días en el inventario.", diaseni);
        }
        catch { }
    }
}
