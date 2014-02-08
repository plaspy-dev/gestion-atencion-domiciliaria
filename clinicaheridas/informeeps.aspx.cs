using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class clinicaheridas_informeeps : System.Web.UI.Page
{
    int paciente = -1;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TDesde.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            THasta.Text = DateTime.Now.ToShortDateString();
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        if (Utilidades.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            if (paciente == -1)
                paciente = Utilidades.GetGridColumnIndex(GResultados, "Paciente");
            /*if (documento == -1)
                documento = Utilidades.GetGridColumnIndex(GResultados, "Documento");
            if (medicamento == -1)
                medicamento = Utilidades.GetGridColumnIndex(GResultados, "Medicamento");*/

            Paciente info = Paciente.GetPaciente(HttpUtility.HtmlDecode(e.Row.Cells[paciente].Text).Trim());
            e.Row.Cells[paciente].Text = info.NombreCompleto;
            // e.Row.Cells[documento].Text = info.documento;

            // e.Row.Cells[medicamento].Text = Procedimientos.GetProcedimiento(HttpUtility.HtmlDecode(e.Row.Cells[medicamento].Text).Trim());
        }
    }
}
