using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Globalization;
using FileHelpers;

public partial class farmacia_gastos : System.Web.UI.Page
{
    public static int m_nAlmacen = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        SResultados.SelectCommand = String.Format(SResultados.SelectCommand, m_nAlmacen, m_nAlmacen);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            // para el filtro por usuarios.
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            if (((MasterPageI)Master).RestoreState()) {
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

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        GResultados.DataSourceID = "SResultados";

        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir("gastos.html", true);
            List<GridViewRow> rows = GResultados.Rows.Cast<GridViewRow>().ToList();
            Totalizar(rows, "Cantidad");
            TotalizarDinero(rows, "Costo");
            TotalizarDinero(rows, "Precio");
            TotalizarDinero(rows, "Utilidad");
        } else {
            ((MasterPageI)Master).Imprimir((string)null);
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
        }
    }

    protected void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;

        evento.Contenido= evento.Contenido.Replace("$szEntidad$", Entidad.GetEntidad(Paciente.GetPaciente(UCPaciente.IdPaciente).entidadId).Nombre);

        Utilidades.GetGridColumn(GResultados, "Costo").Visible = false;
        Utilidades.GetGridColumn(GResultados, "Utilidad").Visible = false;
    }
}
