using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class vehiculos_vehiculo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {

            CUsuario usuario = (CUsuario)Usuario.GetUsuario();
            BAceptar.Enabled = usuario.CanInsert();
            GVehiculos.Columns[1].Visible = usuario.CanDelete();

            if (!string.IsNullOrEmpty(Request.QueryString["vpl"])) { 

                using(CConector conector= new CConector()) {
                    Query query=new Query("vehiculo");

                    query += "vehPlaca";
                    query += "vehPlaca";
                    query += "vehFabricante";
                    query += "vehModelo";
                    query += "vehCilindraje";
                    query += "vehNroMotor";
                    query += "vehNroSerie";
                    query += "vehLinea";
                    query += "vehFechaExpSoat";
                    query += "vehFechaVenSoat";
                    query += "vehFechaExpOtro";
                    query += "vehFechaVenOtro";
                    query += "vclId";
                    query += "perId";
                    query += "vehActivo";

                    MySqlDataReader reader = conector.Query(query.GetSelect("vehPlaca=" + Query.GetValor(Request.QueryString["vpl"])));
                    if (reader != null && reader.Read()) {

                        BAceptar.Enabled = usuario.CanUpdate();
                        ViewState["id"] = reader["vehPlaca"].ToString();
                        TPlaca.Text = reader["vehPlaca"].ToString();
                        TFabricante.Text = reader["vehFabricante"].ToString();
                        TModelo.Text = reader["vehModelo"].ToString();
                        TCilindraje.Text = reader["vehCilindraje"].ToString();
                        TMotor.Text = reader["vehNroMotor"].ToString();
                        TSerie.Text = reader["vehNroSerie"].ToString();
                        TLinea.Text = reader["vehLinea"].ToString();
                        TExpedicionSOAT.Text = Query.GetFromMySQLDate(reader["vehFechaExpSoat"]);
                        TVencimientoSOAT.Text = Query.GetFromMySQLDate(reader["vehFechaVenSoat"]);
                        TExpedicionCertificado.Text = Query.GetFromMySQLDate(reader["vehFechaExpOtro"]);
                        TVencimientoCertificado.Text = Query.GetFromMySQLDate(reader["vehFechaVenOtro"]);
                        TClase.Text = reader["vclId"].ToString();
                        Utilidades.SelectInDropDown(DConductor, reader["perId"]);
                        CActivo.Checked = reader["vehActivo"].ToString()=="True";
                    }
                }
            }
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using(CConector conector= new CConector()) {
            
            conector.StartTransaction();

            string placa= (string)ViewState["id"];
            Query query = new Query("vehiculo");

            query["vehPlaca"] = TPlaca.Text;
            query["vehFabricante"] = TFabricante.Text;
            query["vehModelo"] = TModelo.Text;
            query["vehCilindraje"] = TCilindraje.Text;
            query["vehNroMotor"] = TMotor.Text;
            query["vehNroSerie"] = TSerie.Text;
            query["vehLinea"] = TLinea.Text;
            query["vehFechaExpSoat"] = Query.GetMySQLDateFormat(TExpedicionSOAT.Text);
            query["vehFechaVenSoat"] = Query.GetMySQLDateFormat(TVencimientoSOAT.Text);
            query["vehFechaExpOtro"] = Query.GetMySQLDateFormat(TExpedicionCertificado.Text);
            query["vehFechaVenOtro"] = Query.GetMySQLDateFormat(TVencimientoCertificado.Text);
            query["vclId"] = TClase.Text.Length == 0 ? "1" : TClase.Text;
            query["perId"] = DConductor.SelectedValue;
            query["vehActivo"] = CActivo.Checked ? "1": "0";
            if(string.IsNullOrEmpty(placa)) {
                if(conector.QueryMod(query.GetInsert())==-1)
                    return;
            } else {
                if (conector.QueryMod(string.Format("UPDATE vehiculo_recorrido SET vehPlaca={0} WHERE vehPlaca={1}", Query.GetValor(TPlaca.Text), Query.GetValor(placa))) == -1)
                    return;
                if (conector.QueryMod(query.GetUpdate("vehPlaca=" + Query.GetValor(placa))) == -1)
                    return;
            }
            conector.Commit();
            ((MasterPageI)Master).SetResultado("Vehiculo " + TPlaca.Text + " Editado.");
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void GVehiculos_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?vpl=" +
            GVehiculos.DataKeys[GVehiculos.SelectedIndex].Values["vehPlaca"].ToString());
    }
}
