using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class admisiones_recibos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            TNumero.Text = Request.QueryString["aut"];
            TNumero.Focus();
            if (!string.IsNullOrEmpty(TNumero.Text)) {

                using (CConector conector = new CConector())
                {
                    Query query = new Query("autorizacion");

                    query += "autNumero";
                    query += "pacId";
                    /*query += "autFecha";
                    query += "autFechaVenc";*/
                    query += "total";
                    query += "pago";
                    /*query += "autObservaciones";
                    query += "entId";
                    query += "autActivo";
                    query += "autFechaSuspension";
                    query += "id";
                    query += "formulacion";*/

                    MySqlDataReader reader = conector.Query(query.GetSelect("autNumero=" + Query.GetValor(TNumero.Text)));
                    if (reader != null && reader.Read())
                    {
                        decimal total = 0, pagado = 0;
                        Decimal.TryParse(reader["total"].ToString(), out total);
                        Decimal.TryParse(reader["pago"].ToString(), out pagado);

                        ViewState["autNumero"] = reader["autNumero"].ToString();
                        HA.NavigateUrl = "~/admisiones/autorizaciones.aspx?aut=" + reader["autNumero"].ToString();
                        PD.Visible = true;
                        CCDetallePaciente.Visible = true;
                        CCDetallePaciente.IdPaciente= reader["pacId"].ToString();
                        LValor.Text = string.Format("{0:C}", total);
                        LPagado.Text = string.Format("{0:C}", pagado);

                        SPagos.SelectParameters["autorizacion"].DefaultValue = TNumero.Text;

                        TAbono.Text = (total-pagado).ToString();
                        TFecha.Text = Query.GetFromMySQLDate(DateTime.Now);
                        TRecibo.Focus();
                    }
                }
            }
        }
    }

    protected void GPagos_SelectedIndexChanged(object sender, EventArgs e)
    {
        string id= GPagos.DataKeys[GPagos.SelectedIndex].Value.ToString();
        using (CConector conector = new CConector())
        {
            Query pago = new Query("pago_autorizacion");

            pago += "valor";
            pago += "recibo";
            pago += "fecha";

            MySqlDataReader reader= conector.Query(pago.GetSelect("id=" + Query.GetValor(id)));
            if (reader != null && reader.Read()) {
                TAbono.Text= reader["valor"].ToString();
                TRecibo.Text = reader["recibo"].ToString();
                TFecha.Text = Query.GetFromMySQLDate(reader["fecha"]);
                TRecibo.Focus();
            }
        }
    }

    protected void BAgregar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            string temp = TAbono.Text.Replace(",", "").Replace("$", "");
            if (temp.Length != 0 && Convert.ToDouble(temp) > 0) // verificamos que tenga algun valor
            {
                string id = "";
                Query pago = new Query("pago_autorizacion");

                pago["autNumero"] = ViewState["autNumero"];
                pago["valor"] = temp;
                pago["recibo"] = TRecibo.Text;
                pago["fecha"] = Query.GetMySQLDateFormat(TFecha.Text);

                if (GPagos.SelectedIndex == -1)
                {
                    int res = conector.QueryMod(pago.GetInsert());
                    if ( res== -1)
                        return;
                    id = res.ToString();
                } else {
                    id = GPagos.SelectedDataKey.Value.ToString();
                    if (conector.QueryMod(pago.GetUpdate("id=" + id)) == -1)
                        return;
                }
                if (conector.InsertModificacion(id) == -1)
                    return;
                Autorizaciones.UpdateSesiones(conector, (string)ViewState["autNumero"]);
            }
            TRecibo.Focus();
            BAgregar.Text = "Agregar";
        }
        Response.Redirect("~/admisiones/recibos.aspx?aut=" + TNumero.Text);
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        if(GPagos.SelectedIndex==-1)
            Response.Redirect("~/admisiones/recibos.aspx"); 
        else Response.Redirect("~/admisiones/recibos.aspx?aut=" + TNumero.Text);
    }

    protected void GPagos_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        using (CConector conector = new CConector())
            Autorizaciones.UpdateSesiones(conector, (string)ViewState["autNumero"]);
    }
}