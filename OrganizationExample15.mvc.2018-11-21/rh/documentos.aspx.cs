using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class rh_documentos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            string fields = "";
            string joins = "";
            MySqlDataReader reader = conector.Query("SELECT docId,docDesc FROM funcionario_documentos WHERE docTipoEntrega=1;");
            if (reader != null)
            {
                int index = 0;

                while (reader.Read())
                {

                    fields += string.Format(",IF(r{1}.docId IS NULL,'', IFNULL(r{1}.vencimiento,'X')) a{1}", reader["docId"], index);
                    joins += string.Format("LEFT JOIN recurso_humano_documento r{1} ON (r{1}.perId=recurso_humano.perId AND r{1}.docId={0}) ", reader["docId"], index);

                    BoundField column = new BoundField();
                    column.HeaderText = reader["docDesc"].ToString();
                    column.DataField = "a" + index;
                    column.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                    column.SortExpression = "a" + index++;
                    GResultados.Columns.Add(column);
                }
            }

            SResultados.SelectCommand =
            SResultados.SelectCommand.Replace("FROM recurso_humano", fields + " FROM recurso_humano")
            .Replace("WHERE ", joins + "WHERE ");
            ;
        }

        if (!IsPostBack)
        {
            ((MasterPageI)Master).Excel(GResultados);
            ((MasterPageI)Master).Imprimir(GResultados);
        }
    }
}