using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class farmacia_informes : System.Web.UI.Page
{
    public static int m_nAlmacen = 1;
    public int m_nPaciente = -1;
    public int m_nConsulta = -1;

    protected void Page_Load(object sender, EventArgs e)
    {
        string consultas = "0";
        foreach (ListItem item in DVer.Items) {
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
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
        }
    }

    protected void Totalizar(List<GridViewRow> rows, string columna)
    {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        GResultados.FooterRow.Cells[col].Text = rows.Sum(x => HttpUtility.HtmlDecode(x.Cells[col].Text).Trim().Length == 0 ? 0 : Convert.ToInt32(x.Cells[col].Text)).ToString();
    }
    protected void ContarDistinct(List<GridViewRow> rows, string columna, string control) {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        GResultados.FooterRow.Cells[col].Text = rows.Select(x => ((HyperLink)x.FindControl(control)).Text).Distinct().Count().ToString();
    }
    protected void ContarDistinct(List<GridViewRow> rows, string columna)
    {
        int col = Utilidades.GetGridColumnIndex(GResultados, columna);
        GResultados.FooterRow.Cells[col].Text = rows.Select(x => x.Cells[col].Text).Distinct().Count().ToString();
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        GResultados.DataSourceID = "SResultados";

        if (Utilidades.GetRowsCount(GResultados, LTotal) > 0)
        {
            // ((MasterPageI)Master).Imprimir(GResultados);
            ((MasterPageI)Master).Excel(GResultados);
            List<GridViewRow> rows=GResultados.Rows.Cast<GridViewRow>().ToList();
            Totalizar(rows, "Cantidad");
            ContarDistinct(rows, "Tipo", "l0");
            ContarDistinct(rows, "Número", "l1");
            ContarDistinct(rows, "Fecha", "l2");
            ContarDistinct(rows, "Paciente");
            ContarDistinct(rows, "Proveedor");
            ContarDistinct(rows, "Productos");
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if (m_nPaciente == -1)
                m_nPaciente = Utilidades.GetGridColumnIndex(GResultados, "Paciente");
            if(m_nConsulta==-1)
                m_nConsulta= Utilidades.GetGridColumnIndex(GResultados, "Tipo");
            e.Row.Cells[m_nPaciente].Text= Paciente.GetPaciente(HttpUtility.HtmlDecode(e.Row.Cells[m_nPaciente].Text).Trim()).DocumentoYNombres;

            string url = "";
            string consulta = "";
            switch (GResultados.DataKeys[e.Row.RowIndex].Values["consulta"].ToString())
            {
                case "1":
                    url = "~/farmacia/entrada.aspx?ei=";
                    consulta = "Entrada";
                    break;
                case "2":
                    url = "~/farmacia/ordendecompra.aspx?oci=";
                    consulta = "Orden de compra";
                    break;
                case "3":
                    url = "~/farmacia/salida.aspx?si=";
                    consulta = "Requisición";
                    break;
                case "4":
                    url = "~/farmacia/devolucion.aspx?di=";
                    consulta = "Devolución";
                    break;
            }
            url += DataBinder.Eval(e.Row.DataItem, "id").ToString();

            String texto = consulta;
            e.Row.Cells[0].Text = "";
            HyperLink link = new HyperLink();
            link.ID = "l0";
            link.Text = texto;
            link.NavigateUrl = url;
            link.Target = "_blank";
            e.Row.Cells[0].Controls.Add(link);

            texto = e.Row.Cells[1].Text;
            e.Row.Cells[1].Text = "";
            link = new HyperLink();
            link.ID = "l1";
            link.Text = texto;
            link.Target = "_blank";
            link.NavigateUrl = url;
            e.Row.Cells[1].Controls.Add(link);

            texto = e.Row.Cells[2].Text;
            e.Row.Cells[2].Text = "";
            link = new HyperLink();
            link.ID = "l2";
            link.Text = texto;
            link.Target = "_blank";
            link.NavigateUrl = url;
            e.Row.Cells[2].Controls.Add(link);
        }
    }
}
