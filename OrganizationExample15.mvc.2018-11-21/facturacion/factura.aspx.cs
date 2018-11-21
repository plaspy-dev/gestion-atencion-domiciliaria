using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using FileHelpers;

public partial class facturacion_factura : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            if (!string.IsNullOrEmpty(Request.QueryString["fid"])) {

                using (CConector conector = new CConector())
                {
                    Query query = new Query("factura");

                    query += "factura";
                    query += "importacion";

                    MySqlDataReader reader= conector.Query(query.GetSelect("factura=" + Query.GetValor(Request.QueryString["fid"])));
                    if (reader != null && reader.Read())
                    {
                        TFactura.Text = reader["factura"].ToString();
                        FixedFileEngine engine = new FixedFileEngine(typeof(SIIGOFile));
                        SIIGOFile[] siigo = (SIIGOFile[])engine.ReadString(reader["importacion"].ToString()); 
                        UCFactura.SetFactura(Convert.ToInt32(reader["factura"]), siigo.ToList(), true);
                        UCFactura.Visible = true;
                    }
                }
            }
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e) {

        Response.Redirect(Request.Url.AbsolutePath + "?fid=" + TFactura.Text);
    }
    
    public void BCancelar_Clicked(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
}
