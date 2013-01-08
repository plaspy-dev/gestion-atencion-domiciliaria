using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class auditoria_OrganizationExample51 : System.Web.UI.Page
{
    CConectorMS conectorms = null;
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.DataBind();
        int rows = GResultados.Rows.Count;

        LTotal.Text = rows + " paciente" + (rows == 1 ? "" : "s");

        if (GResultados.Rows.Count > 0)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowIndex!=-1) {
            
            string texto = "";
            try
            {
                DateTime birthDate = Convert.ToDateTime(e.Row.Cells[1].Text);
                DateTime now = DateTime.Now;
                int years = now.Year - birthDate.Year;

                if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                    --years;

                texto = years.ToString();
            } catch {}
            e.Row.Cells[1].Text= texto; // edad

            if (conectorms == null)
                conectorms = new CConectorMS();
            texto = "";
            string []cie10 = e.Row.Cells[4].Text.Split(',');
            for (int i = 0; i < cie10.Length; i++) {
                string temp= Procedimientos.GetCodigoCIE(cie10[i], conectorms);
                if(temp.Length!=0) {
                    if (texto.Length > 0)
                        texto += "<br/>";
                    texto += temp;
                }
            }
            e.Row.Cells[4].Text = texto; // diagnostico
        }
    }
}
