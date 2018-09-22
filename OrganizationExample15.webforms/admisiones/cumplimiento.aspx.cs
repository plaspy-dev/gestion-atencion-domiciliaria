using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class admisiones_cumplimiento : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SResultados.SelectCommand = SResultados.SelectCommand.Replace("@area", DArea.SelectedValue);
        if (!IsPostBack) {
            TInicio.Text = Query.GetFromMySQLDate(DateTime.Now.AddDays(-30));
            TFin.Text= Query.GetFromMySQLDate(DateTime.Now);
            BBuscar_Click(sender, e);
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        int columna= Utilidades.GetGridColumnIndex(GResultados, "% de cumplimiento");
        int[] totales = new int[5];
        for (int i = 0; i < totales.Length; i++)
            totales[i] = 0;
        GridUtils.GetRowsCount(GResultados, LTotal);
        for (int i = 0; i < GResultados.Rows.Count; i++) {
            double valor = Utilidades.ParseDouble(GResultados.Rows[i].Cells[columna].Text);
            if (valor > 75)
                totales[4]++;
            else if (valor > 50)
                totales[3]++;
            else if (valor > 25)
                totales[2]++;
            else if (valor > 0)
                totales[1]++;
            else 
                totales[0]++;
        }

        LChart.Text = "";
        LChart.Text += string.Format("['{0}', {1}]", "0%", totales[0]);
        LChart.Text += string.Format(",['{0}', {1}]", "1%-25%", totales[1]);
        LChart.Text += string.Format(",['{0}', {1}]", "26%-50%", totales[2]);
        LChart.Text += string.Format(",['{0}', {1}]", "51%-75%", totales[3]);
        LChart.Text += string.Format(",['{0}', {1}]", "75%-100%", totales[4]);
    }
}