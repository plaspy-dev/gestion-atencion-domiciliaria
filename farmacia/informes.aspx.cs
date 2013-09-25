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

    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados1.SelectCommand = String.Format(SResultados1.SelectCommand, m_nAlmacen, m_nAlmacen);
        SResultados3.SelectCommand = String.Format(SResultados3.SelectCommand, m_nAlmacen, m_nAlmacen);
        SResultados2.SelectCommand = String.Format(SResultados2.SelectCommand, m_nAlmacen, m_nAlmacen);

        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];
            THasta.Text = DateTime.Now.ToShortDateString();
            TDesde.Text = DateTime.Now.AddDays(-30).ToShortDateString();
            BBuscar_Click(sender, e);
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.DataSourceID = "SResultados" + DVer.SelectedValue;
        switch (DVer.SelectedValue)
        {
            case "1":
                GResultados.Columns[2].Visible = false;
                GResultados.Columns[3].Visible = true;
                GResultados.Columns[4].Visible = true;
                GResultados.Columns[5].Visible = false;
                break;
            case "2":
                GResultados.Columns[2].Visible = false;
                GResultados.Columns[3].Visible = true;
                GResultados.Columns[4].Visible = true;
                GResultados.Columns[5].Visible = true;
                break;
            case "3":
                GResultados.Columns[2].Visible = false;
                GResultados.Columns[3].Visible = true;
                GResultados.Columns[4].Visible = false;
                GResultados.Columns[5].Visible = true;
                break;
        }

        if (Utilidades.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir(GResultados);
            ((MasterPageI)Master).Excel(GResultados);
        }
    }
    protected void GResultados_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if (m_nPaciente == -1)
                m_nPaciente = Utilidades.GetGridColumnIndex(GResultados, "Paciente");
            e.Row.Cells[m_nPaciente].Text= Paciente.GetPaciente(HttpUtility.HtmlDecode(e.Row.Cells[m_nPaciente].Text).Trim()).DocumentoYNombres;

            string url = "";
            switch (DVer.SelectedValue)
            {
                case "1":
                    url = "~/farmacia/entrada.aspx?ei=";
                    break;
                case "2":
                    url = "~/farmacia/ordendecompra.aspx?oci=";
                    break;
                case "3":
                    url = "~/farmacia/salida.aspx?si=";
                    break;
            }
            url += DataBinder.Eval(e.Row.DataItem, "id").ToString();

            String texto = e.Row.Cells[0].Text;
            e.Row.Cells[0].Text = "";
            HyperLink link = new HyperLink();
            link.Text = texto;
            link.NavigateUrl = url;
            e.Row.Cells[0].Controls.Add(link);

            texto = e.Row.Cells[1].Text;
            e.Row.Cells[1].Text = "";
            link = new HyperLink();
            link.Text = texto;
            link.NavigateUrl = url;
            e.Row.Cells[1].Controls.Add(link);
        }
    }
}
