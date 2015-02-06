using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class paciente_atendidos : System.Web.UI.Page
{
    int paciente = -1, documento = -1, sexo = -1, edad = -1, direccion = -1, barrio = -1, telefono = -1, cie1 = -1, cie2 = -1, cie3 = -1;
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
        }
    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        int rows = GridUtils.GetRowsCount(GResultados);
        LTotal.Text = rows + " paciente" + (rows == 1 ? "" : "s");

        if (rows > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1) {
            if (paciente == -1)
                paciente = GResultados.GetGridColumnIndex("Paciente");
            if ( documento== -1)
                documento = GResultados.GetGridColumnIndex("Documento");
            if ( sexo== -1)
                sexo = GResultados.GetGridColumnIndex("Sexo");
            if ( edad== -1)
                edad = GResultados.GetGridColumnIndex("Edad");
            if ( direccion== -1)
                direccion = GResultados.GetGridColumnIndex("Dirección");
            if ( barrio== -1)
                barrio = GResultados.GetGridColumnIndex("Barrio");
            if ( telefono== -1)
                telefono = GResultados.GetGridColumnIndex("Teléfonos");
            if ( cie1== -1)
                cie1 = GResultados.GetGridColumnIndex("Diagnostico 1");
            if ( cie2== -1)
                cie2 = GResultados.GetGridColumnIndex("Diagnostico 2");
            if ( cie3== -1)
                cie3 = GResultados.GetGridColumnIndex("Diagnostico 3");

            Paciente info = Paciente.GetPaciente(HttpUtility.HtmlDecode(e.Row.Cells[paciente].Text).Trim());
            e.Row.Cells[paciente].Text= info.NombreCompleto;
            e.Row.Cells[documento].Text= info.documento;
            e.Row.Cells[sexo].Text = info.sexoId == "1" ? "F" : "M";
            e.Row.Cells[edad].Text= info.Edad.ToString();
            e.Row.Cells[direccion].Text= info.Direccion;
            e.Row.Cells[barrio].Text= info.Barrio;
            e.Row.Cells[telefono].Text= info.Telefono;
            e.Row.Cells[cie1].Text= info.cie10.Count>0 ? info.cie10[0].ToString() : "";
            e.Row.Cells[cie2].Text = info.cie10.Count>1 ? info.cie10[1].ToString() : "";
            e.Row.Cells[cie3].Text = info.cie10.Count >2 ? info.cie10[2].ToString() : "";
        }
    }
}
