using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class clinicaheridas_informeeps : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TDesde.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            THasta.Text = DateTime.Now.ToShortDateString();
#if DEBUG
            BBuscar_Click(sender, e);
#endif
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir("informeEPS.html"); // .Excel(GResultados);
            // ((MasterPageI)Master).Imprimir(GResultados);
        }
    }

    static Dictionary<string, int> ColumnsIndex = new Dictionary<string, int>();

    public void ReplaceProducto(string columna, GridViewRow row) {

        int numero=-1;
        try { numero = ColumnsIndex[columna]; } catch { }
        if(numero==-1)
            ColumnsIndex[columna] = numero = GResultados.GetGridColumnIndex(columna);
        TableCell celda = row.Cells[numero];
        string texto = HttpUtility.HtmlDecode(celda.Text).Trim();
        if (!string.IsNullOrEmpty(texto))
            celda.Text = Producto.GetProducto(texto).NombreCompleto;
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            ReplaceProducto("INSUMO 1", e.Row);
            ReplaceProducto("INSUMO 2", e.Row);
            ReplaceProducto("INSUMO 3", e.Row);
            ReplaceProducto("INSUMO 4", e.Row);
        }
    }
}
