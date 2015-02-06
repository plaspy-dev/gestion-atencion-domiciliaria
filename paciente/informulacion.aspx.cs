using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class paciente_informulacion : System.Web.UI.Page
{
    int paciente=-1, documento=-1;
    int medicamento = -1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1) { 
            if(paciente==-1)
                paciente = GResultados.GetGridColumnIndex("Paciente");
            if(documento==-1)
                documento = GResultados.GetGridColumnIndex("Documento");
            if (medicamento == -1)
                medicamento = GResultados.GetGridColumnIndex("Medicamento");
            
            Paciente info= Paciente.GetPaciente(HttpUtility.HtmlDecode(e.Row.Cells[paciente].Text).Trim());
            e.Row.Cells[paciente].Text=info.NombreCompleto;
            e.Row.Cells[documento].Text= info.documento;

            e.Row.Cells[medicamento].Text = Procedimientos.GetProcedimiento(HttpUtility.HtmlDecode(e.Row.Cells[medicamento].Text).Trim());
        }
    }
}
