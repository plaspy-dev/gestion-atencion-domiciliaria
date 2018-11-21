using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;

public partial class eventos_nomina : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void DEvento_SelectedIndexChanged(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            MySqlDataReader reader = conector.Query("SELECT inicio,fin FROM programacion_evento WHERE id=" + Query.GetValor(DEvento.SelectedValue));

            if (reader != null && reader.Read())
            {
                TDesde.Text = Query.GetFromMySQLDate(reader["inicio"]);
                THasta.Text = Query.GetFromMySQLDate(reader["fin"]);
            }
        }
        BIr_Click(sender, e);
    }

    public void SetResumen(GridView grilla, int inicio)
    {
        grilla.DataBind();
        if (grilla.Rows.Count == 0)
            return;
        grilla.FooterRow.Cells[inicio - 1].Text = "Totales";
        for (int j = inicio; j < grilla.Columns.Count; j++)
        {
            double total = 0;
            for (int i = 0; i < grilla.Rows.Count; i++)
            {
                try
                {
                    string texto = grilla.Rows[i].Cells[j].Text.Replace("$", "").Replace("%", "").Trim();
                    total += Convert.ToDouble(texto);
                } catch { }
            }
            string formato = ((BoundField)grilla.Columns[j]).DataFormatString;
            if (formato.Length == 0)
                formato = "{0:g}";
            if (formato.IndexOf("p") != -1)
                total /= 100;
            grilla.FooterRow.Cells[j].Text = string.Format(formato, total);
        }
        ((MasterPageI)Master).Excel(grilla);
    }

    protected void BIr_Click(object sender, EventArgs e)
    {
        SetResumen(GResultados, 2);
        SetResumen(GAmbulancias, 3);
    }
}
