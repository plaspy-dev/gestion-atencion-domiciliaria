using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;

public partial class auditoria_OrganizationExample51 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void BindGridView(GridView gview)
    {
        GColmedica.Visible= GOrganizationExample51.Visible = false;
        gview.Visible = true;
        int rows = Utilidades.GetRowsCount(gview);
        LTotal.Text = rows + " paciente" + (rows == 1 ? "" : "s");

        if (rows > 0)
        {
            ((MasterPageI)Master).Excel(gview);
            ((MasterPageI)Master).Imprimir(gview);
        } else {
            ((MasterPageI)Master).Excel(null);
            ((MasterPageI)Master).Imprimir("");
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        BindGridView((GridView)Utilidades.FindControlForId(Controls, DTipo.SelectedValue));
    }
    protected void GColmedica_RowDataBound(object sender, GridViewRowEventArgs e) {
        if (e.Row.RowIndex != -1)
        {
            e.Row.Cells[0].Text= (e.Row.RowIndex+1).ToString();
            string texto = "";
            try
            {
                DateTime birthDate = Convert.ToDateTime(e.Row.Cells[11].Text);
                DateTime now = DateTime.Now;
                int years = now.Year - birthDate.Year;

                if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                    --years;

                texto = years.ToString();
            }
            catch { }
            e.Row.Cells[11].Text = texto; // edad
        }
    }
    protected void GOrganizationExample51_RowDataBound(object sender, GridViewRowEventArgs e)
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

            texto = "";
            string []cie10 = e.Row.Cells[4].Text.Split(',');
            for (int i = 0; i < cie10.Length; i++) {
                string temp= Procedimientos.GetCodigoCIE(cie10[i]);
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
