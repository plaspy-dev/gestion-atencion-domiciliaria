using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Data.SqlClient;

public partial class admisiones_autorizaciones : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PPaciente.Visible = false;
            TNumero.Focus();
            BEliminar.Visible= PAutorizaciones.Visible = false;
            GPagos.Visible = false;
            BAgregar.Visible = false;
            BSuspender.Visible = false;
            
            Usuario usuario = Usuario.GetUsuario();
            CConectorMS conector = new CConectorMS();
            CGenerar.Visible= conector.QueryString("SELECT perIdPermiso FROM segPermisoEspecial WHERE usIdUsuario='" + usuario.GetLogin() + "' AND perIdPermiso='AUT_AUTOMATICA'")!="";
            RAutorizacion.Visible= RPreautorizacion.Visible = conector.QueryString("SELECT perIdPermiso FROM segPermisoEspecial WHERE usIdUsuario='" + usuario.GetLogin() + "' AND perIdPermiso='AUT_SELPREAUT'")!="";

            if (Request.QueryString["aut"] != null)
            {
                Query query = new Query("phdAutorizacion");

                query += "autNumero";
                query += "pacId";
                query += "autFecha";
                query += "autFechaVenc";
                query += "total";
                query += "autObservaciones";
                query += "entId";
                query += "autActivo";
                query += "autFechaSuspension";
                query += "id";

                SqlDataReader reader= conector.Query(query.GetSelect("autNumero=" + Query.GetValor(Request.QueryString["aut"])));
                if(reader!=null && reader.Read()) {

                    CGenerar.Visible = false;
                    GPagos.Visible = true;
                    BAgregar.Visible = usuario.CanInsert();
                    BAceptar.Enabled = usuario.CanUpdate();
                    BEliminar.Visible = usuario.CanDelete();
                    BSuspender.Visible = usuario.CanDelete();
                    TFSuspender.Text = DateTime.Now.ToShortDateString();

                    GPagos.Columns[0].Visible = usuario.CanUpdate();
                    GPagos.Columns[1].Visible = usuario.CanDelete();

                    HIdAutorizacion.Value = Request.QueryString["aut"];
                    HId.Value = reader["id"].ToString();
                    ((MasterPageI)Master).SetModificacion(HId.Value);

                    HIdEntidad.Value = reader["entId"].ToString();
                    TNumero.Text = reader["autNumero"].ToString();
                    TPaciente.Text = reader["pacId"].ToString();
                    TFecha.Text = reader["autFecha"].ToString();
                    TVencimiento.Text = reader["autFechaVenc"].ToString();
                    TValor.Text = reader["total"].ToString();
                    TObservaciones.Text = reader["autObservaciones"].ToString();
                    if (reader["autActivo"].ToString().ToLower()=="false") {

                        if (reader["autFechaSuspension"].ToString().Length==0)
                            LEstado.Text = "Anulada";
                        else LEstado.Text = "Suspendida hasta el " + CConector.GetFromMySQLDate(reader["autFechaSuspension"]);
                    } else {
                        DateTime vencimiento = (DateTime)reader["autFechaVenc"];
                        if(vencimiento==null) {
                            vencimiento = (DateTime)reader["autFecha"];
                            vencimiento = vencimiento.AddDays(30);
                        }
                        LEstado.Text = DateTime.Now.Date>vencimiento ? "Vencida" : "Activa";
                    }
                    BIr_Click(sender, e);
                }
            }

        }
    }
    protected void BAgregar_Click(object sender, EventArgs e)
    {
        CConectorMS conector = new CConectorMS();
        
        string temp = TAbono.Text.Replace(",", "");
        if (temp.Length != 0 && Convert.ToDouble(temp) > 0) // verificamos que tenga algun valor
        {
            Query pago = new Query("pago_autorizacion");

            pago["autNumero"] = TNumero.Text;
            pago["valor"] = temp;
            pago["recibo"] = TRecibo.Text;

            if (GPagos.SelectedIndex == -1) {
                if (conector.QueryMod(pago.GetInsert()) == -1)
                    return;
            } else {
                if (conector.QueryMod(pago.GetUpdate("id=" + GPagos.SelectedDataKey.Value.ToString() )) == -1)
                    return;
            }
            if (new CConector().InsertModificacion(HId.Value) == -1)
                return;
            GPagos.DataBind();
        }

        BAgregar.Text = "Agregar";
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        CConectorMS conector = new CConectorMS();
        Query query = new Query("phdAutorizacion");
        conector.StartTransaction();

        // realizamos la validaciones
        if (!CGenerar.Checked && TNumero.Text.Trim().Length == 0)
        {
            TNumero.Focus();
            LError.Text = "Por favor ingrese un número de autorización.";
            return;
        }
        if(HIdPaciente.Value.Length==0) {
            TPaciente.Focus();
            LError.Text = "Por favor ingrese un paciente.";
            return;
        }
        string temp= TAbono.Text.Replace(",", "");
        if (temp.Length != 0 && Convert.ToDouble(temp) > 0) // verificamos que tenga algun valor
        {
            if(TRecibo.Text.Length==0) {

                TRecibo.Focus();
                LError.Text = "Por favor ingrese un numero de recibo.";
                return;
            }
        }
        bool actividad = false;
        for (int i = 0; i < GActivades.Rows.Count; i++)
        {
            string numero = ((TextBox)GActivades.Rows[i].FindControl("TNSesiones")).Text;
            if (numero == "" || numero == "0")
                continue;
            actividad = true;
            break;
        }
        if(!actividad) {
            LError.Text = "Por favor ingrese por lo menos una actividad.";
            return;
        }
        if (HIdAutorizacion.Value.Length == 0 && TNumero.Text.Length > 0)
        {
            if (conector.QueryString("SELECT autNumero FROM phdAutorizacion WHERE autNumero='" + TNumero.Text + "'").Length != 0)
            {
                TNumero.Focus();
                LError.Text = "Este numero de autorización ya existe.";
                return;
            }
        }
        // empezamos la insercion.

        if(CGenerar.Checked) {

            DateTime tiempo= Convert.ToDateTime(TFecha.Text);
            TNumero.Text = conector.QueryString(
                String.Format("SELECT 'AD{0}'+RIGHT('000'+CAST(ISNULL(MAX(CONVERT(int,SUBSTRING(autNumero,9,LEN(autnumero)-8))), 0)+1 AS VARCHAR(3)),3)"
                        + " FROM phdAutorizacion"
                        + " WHERE autNumero LIKE 'AD{0}%'", tiempo.ToString("yyMMdd")));
        }

        query["autNumero"] = TNumero.Text;
        query["pacId"] = HIdPaciente.Value;
        query["autFecha"] = TFecha.Text;
        query["autFechaVenc"] = TVencimiento.Text;
        query["total"] = TValor.Text.Replace(",","");
        query["autObservaciones"] = TObservaciones.Text;
        query["entId"] = HIdEntidad.Value;
        query["autActivo"] = "1";

        if(HIdAutorizacion.Value.Length==0) {

            query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
            query["segFechaIngreso"] = "GETDATE()";
            if (CGenerar.Checked && RPreautorizacion.Visible && RPreautorizacion.Checked)
            {
                if (HIdEntidad.Value == "36" || HIdEntidad.Value == "29") {

                    query["segUsuarioConfirma"] = Usuario.GetUsuario().GetLogin();
                    query["segFechaConfirma"] = "GETDATE()";
                } else {
                    query["autProvisional"] = "1";
                }
            }
            int res=conector.QueryMod(query.GetInsert(), true);
            if(res==-1)
                return;
            HId.Value = res.ToString();
            HIdAutorizacion.Value= TNumero.Text;
        } else {

            query["segUsuarioModifica"] = Usuario.GetUsuario().GetLogin();
            query["segFechaModifica"] = "GETDATE()";
            if(conector.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(HIdAutorizacion.Value)))==-1)
                return;
        }
        if(new CConector().InsertModificacion(HId.Value)==-1)
            return;

        if (GPagos.Rows.Count==0)
        {
            temp= TAbono.Text.Replace(",", "");
            if (temp.Length != 0 && Convert.ToDouble(temp) > 0) // verificamos que tenga algun valor
            {
                Query pago = new Query("pago_autorizacion");

                pago["autNumero"] = TNumero.Text;
                pago["valor"] = temp;
                pago["recibo"] = TRecibo.Text;

                if (conector.QueryMod(pago.GetInsert()) == -1)
                    return;
            }
        }

        Query act= new Query("phdDetalleAutorizacion");
        act["autNumero"]= TNumero.Text;

        for(int i=0; i<GActivades.Rows.Count; i++) {

            string numero=((TextBox)GActivades.Rows[i].FindControl("TNSesiones")).Text;
            string condicion = "FROM phdDetalleAutorizacion WHERE autNumero='" + HIdAutorizacion.Value + "' AND actId='" + GActivades.DataKeys[i].Value.ToString() + "'";
            if (numero == "" || numero == "0")
            {
                if (conector.QueryMod("DELETE " + condicion) == -1)
                    return;
                continue;
            }
            string id = conector.QueryString("SELECT actId " + condicion);
            act["actId"]= GActivades.DataKeys[i].Value.ToString();
            act["autNumSesiones"]= numero;
            act["autSesionesDia"]= ((TextBox)GActivades.Rows[i].FindControl("TSDia")).Text;

            if (id.Length == 0)
            { // no existe
                if (conector.QueryMod(act.GetInsert()) == -1)
                    return;
            } else {
                if (conector.QueryMod(act.GetUpdate("autNumero='" + HIdAutorizacion.Value + "' AND actId='" + GActivades.DataKeys[i].Value.ToString() + "'")) == -1)
                    return;
            }
        }
        conector.Commit();
        ((MasterPageI)Master).SetResultado("Número de autorización " + TNumero.Text + " editada.");
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BIr_Click(object sender, EventArgs e)
    {
        string id = TPaciente.Text;

        HIdPaciente.Value = "";
        LCategoria.Text = "";
        LPorcentaje.Text = "";
        LMaximoServicio.Text = "";
        LMaximoano.Text = "";
        LNombrePaciente.Text = "";
        HIdEntidad.Value = "";
        LInactivo.Visible = false;
        PAutorizaciones.Visible = false;

        Query query = new Query("phdPaciente");

        query["pacId"] = "phdPaciente.pacId";
        query["tdocId"] = "phdPaciente.tdocId";
        query["pacDocumento"] = "phdPaciente.pacDocumento";
        query["pacPApellido"] = "phdPaciente.pacPApellido";
        query["pacSApellido"] = "phdPaciente.pacSApellido";
        query["pacPNombre"] = "phdPaciente.pacPNombre";
        query["pacSNombre"] = "phdPaciente.pacSNombre";
        query["pacTipoAfiliado"] = "phdPaciente.pacTipoAfiliado";
        query["entId"] = "phdPaciente.entId";
        query["entidad"] = "admEntidad.entNombre";
        query["categoria"] = "phdPaciente.categoria";
        query["estado"] = "phdPaciente.EstId";

        CConectorMS conector = new CConectorMS();
        CConector conectormysql = new CConector();

        SqlDataReader reader = conector.Query(query.GetSelect("phdPaciente.pacId=" + Query.GetValor(id) + ""
            , "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)"));
        if (reader != null && reader.Read())
        {
            double maximo = 0;
            PPaciente.Visible = true;
            HIdPaciente.Value = id;
            HIdEntidad.Value = reader["entId"].ToString();

            TPaciente.Text = reader["pacDocumento"].ToString();
            LNombrePaciente.Text = reader["pacPApellido"].ToString() +
                " " + reader["pacSApellido"].ToString() +
                " " + reader["pacPNombre"].ToString() +
                " " + reader["pacSNombre"].ToString();

            LInactivo.Visible = reader["estado"].ToString() == "2";
            
            // LMaximo.Text = reader[""];

            LEntidad.Text = reader["entidad"].ToString();
            CultureInfo culture = new CultureInfo("en-US");

            if(reader["categoria"].ToString()!="") {

                MySqlDataReader rtopes= conectormysql.Query("SELECT varios.nombre AS categoria,topes.nombre AS por, topes.descripcion AS tser, topes.szReservado AS tano "
                                                        + " FROM varios"
                                                        + " LEFT JOIN varios AS topes ON (topes.tipo=14 AND topes.parametro1=varios.id)"
                                                        + " WHERE varios.id=" + reader["categoria"].ToString());
                if (rtopes != null && rtopes.Read())
                {
                    LCategoria.Text= "<b>" + rtopes["categoria"].ToString() + "</b>";
                    LPorcentaje.Text = string.Format("{0:p}", Convert.ToDouble(rtopes["por"].ToString(), culture.NumberFormat) / 100);
                    LMaximoServicio.Text = string.Format("{0:c}", Convert.ToDouble(rtopes["tser"].ToString(), culture.NumberFormat));
                    maximo = Convert.ToDouble(rtopes["tano"].ToString(), culture.NumberFormat);
                    LMaximoano.Text = string.Format("{0:c}", maximo);
                }
            }
            if (reader["pacTipoAfiliado"].ToString() != "")
                LCategoria.Text += "/" + (reader["pacTipoAfiliado"].ToString() == "1" ? "Cotizante" : "Beneficiario");

            TFecha.Focus();
            GAutorizaciones.DataBind();
            LAutorizaciones.Text =GAutorizaciones.Rows.Count +  " Autorizaci";
            LAutorizaciones.Text += GAutorizaciones.Rows.Count == 1 ? "ón" : "ones";
            PAutorizaciones.Visible = GAutorizaciones.Rows.Count>0;

            string valor= conector.QueryString("SELECT SUM(valor) FROM pago_autorizacion LEFT JOIN phdAutorizacion ON (phdAutorizacion.autNumero=pago_autorizacion.autNumero) WHERE pacId=" + HIdPaciente.Value + " AND YEAR(phdAutorizacion.autFecha)=YEAR(GETDATE())");
            if (valor == "")
                valor = "0";
            maximo -= Convert.ToDouble(valor, culture.NumberFormat);
            LAcumulado.Text = string.Format("{0:c}", Convert.ToDouble(valor, culture.NumberFormat));
            LMaximo.Text = string.Format("{0:c}", maximo);
        }
    }

    protected void GPagos_SelectedIndexChanged(object sender, EventArgs e)
    {
        TRecibo.Text= HttpUtility.HtmlDecode(GPagos.SelectedRow.Cells[2].Text);
        TAbono.Text = HttpUtility.HtmlDecode(GPagos.SelectedRow.Cells[3].Text);
        BAgregar.Text = "Editar";
    }
    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/admisiones/autorizaciones.aspx?aut=" + ((ImageButton)sender).CommandArgument);
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        CConectorMS conector = new CConectorMS();
        conector.StartTransaction();
        if (conector.QueryMod("DELETE FROM pago_autorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
        {
            return;
        }
        if (conector.QueryMod("DELETE FROM phdDetalleAutorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
        {
            return;
        }
        if (conector.QueryMod("DELETE FROM phdAutorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
        {
            return;
        }
        if (new CConector().InsertModificacion(HId.Value) == -1)
            return;
        conector.Commit();
        ((MasterPageI)Master).SetResultado("Autorización " + HIdAutorizacion.Value + " eliminada.");
    }

    protected void BASuspencion_Click(object sender, EventArgs e)
    {
        Query query = new Query("phdAutorizacion");
        CConectorMS conector= new CConectorMS();
        
        query["autActivo"] = "0";
        query["autObservacionesAnul"] = TMotivo.Text;
        if (RSuspender.Checked)
            query["autFechaSuspension"] = TFSuspender.Text;

        if (conector.QueryMod(query.GetUpdate("autNumero='" + HIdAutorizacion.Value + "'")) == -1)
            return;

        if (new CConector().InsertModificacion(HId.Value) == -1)
            return;

        ((MasterPageI)Master).SetResultado("Autorización " + HIdAutorizacion.Value + (RSuspender.Checked ? " suspendida." : " anulada." ));
    }
}
