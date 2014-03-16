using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Specialized;
using System.Collections;
using System.Net.Mail;
using System.IO;
using System.Configuration;

public partial class admisiones_autorizaciones : System.Web.UI.Page
{
    public class Procedimiento {

        public string procedimiento;
        public string intensidad;
        public string key;
        public string profesional;

        public Procedimiento(string prof, string procid,string inten, string k) {
            
            procedimiento= procid;
            intensidad = inten;
            key = k;
            profesional = prof;
        }
    }

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
            GActivades.DataBind();

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];
            using (CConector conector = new CConector())
            {
                CGenerar.Visible = true;// conector.QueryString("SELECT perIdPermiso FROM segPermisoEspecial WHERE usIdUsuario='" + usuario.GetLogin() + "' AND perIdPermiso='AUT_AUTOMATICA'") != "";
                RAutorizacion.Visible = RPreautorizacion.Visible = true;// conector.QueryString("SELECT perIdPermiso FROM segPermisoEspecial WHERE usIdUsuario='" + usuario.GetLogin() + "' AND perIdPermiso='AUT_SELPREAUT'") != "";

                if (Request.QueryString["aut"] != null)
                {
                    Query query = new Query("autorizacion");

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
                    query += "formulacion";

                    MySqlDataReader reader = conector.Query(query.GetSelect("autNumero=" + Query.GetValor(Request.QueryString["aut"])));
                    if (reader != null && reader.Read())
                    {

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
                        if (reader["formulacion"].ToString().Length > 0)
                        {
                            HFormula.Text = "Orden médica";
                            HFormula.NavigateUrl = "~/paciente/formulacion.aspx?fid=" + reader["formulacion"].ToString();
                        }
                        if (reader["autActivo"].ToString().ToLower() == "false")
                        {

                            if (reader["autFechaSuspension"].ToString().Length == 0)
                                LEstado.Text = "Anulada";
                            else LEstado.Text = "Suspendida hasta el " + Query.GetFromMySQLDate(reader["autFechaSuspension"]);
                        }
                        else
                        {
                            if (reader["autFechaVenc"].ToString() != "")
                            {
                                DateTime vencimiento = (DateTime)reader["autFechaVenc"];
                                if (vencimiento == null)
                                {
                                    vencimiento = (DateTime)reader["autFecha"];
                                    vencimiento = vencimiento.AddDays(30);
                                }
                                LEstado.Text = DateTime.Now.Date > vencimiento ? "Vencida" : "Activa";
                            }
                        }
                        GActivades.DataBind();
                        // actualizamos los servicios
                        reader = conector.Query("SELECT autorizacion_detalle.actId,medicamentos.nombre,autorizacion_detalle.autNumSesiones,autorizacion_detalle.autSesionesDia, autorizacion_detalle.intensidad"
                            + " FROM autorizacion_detalle"
                            + " LEFT JOIN medicamentos ON (autorizacion_detalle.actId=medicamentos.id)"
                            + " WHERE autorizacion_detalle.autNumero=" + Query.GetValor(HIdAutorizacion.Value)
                            + " ORDER BY medicamentos.nombre;"
                            );
                        if (reader != null)
                        {

                            while (reader.Read())
                            {

                                IOrderedDictionary data = new OrderedDictionary();

                                // data.Add("id", TProcedimientoID.Text);

                                data.Add("procedimiento", Procedimientos.GetProcedimiento(reader["actId"].ToString()));
                                data.Add("tint", reader["intensidad"].ToString() == "" ? "" : Procedimientos.GetVarios(reader["intensidad"].ToString()));
                                data.Add("idint", reader["intensidad"].ToString() == "" ? null : reader["intensidad"].ToString());
                                data.Add("sesionesdia", reader["autSesionesDia"].ToString().Length == 0 ? null : reader["autSesionesDia"].ToString());
                                data.Add("numerosesiones", reader["autNumSesiones"].ToString());
                                data.Add("proc_id", reader["actId"].ToString());
                                data.Add("verificacion", Crypt.GetMD5("JuHU" + DateTime.Now.ToString() + "H0m3s4lud"));

                                SActividades.GetView().Insert(data, OnDataSourceOperationComplete);


                                BIntensidad_Clicked(sender, e);

                            }
                            GActivades.DataBind();
                        }
                        BIr_Click(sender, e);
                    }
                }
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
                Query pago = new Query("pago_autorizacion");

                pago["autNumero"] = TNumero.Text;
                pago["valor"] = temp;
                pago["recibo"] = TRecibo.Text;

                if (GPagos.SelectedIndex == -1)
                {
                    if (conector.QueryMod(pago.GetInsert()) == -1)
                        return;
                }
                else
                {
                    if (conector.QueryMod(pago.GetUpdate("id=" + GPagos.SelectedDataKey.Value.ToString())) == -1)
                        return;
                }
                using(CConector conectorm= new CConector()) 
                    if (conectorm.InsertModificacion(HId.Value) == -1)
                        return;
                GPagos.DataBind();
            }

            BAgregar.Text = "Agregar";
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        using (CConector conector = new CConector())
        {
            Query query = new Query("autorizacion");

            // realizamos la validaciones
            if (!CGenerar.Checked && TNumero.Text.Trim().Length == 0)
            {
                TNumero.Focus();
                LError.Text = "Por favor ingrese un número de autorización.";
                return;
            }
            if (HIdPaciente.Value.Length == 0)
            {
                TPaciente.Focus();
                LError.Text = "Por favor ingrese un paciente.";
                return;
            }
            string temp = TAbono.Text.Replace(",", "").Replace("$", "");
            if (temp.Length != 0 && Convert.ToDouble(temp) > 0) // verificamos que tenga algun valor
            {
                if (TRecibo.Text.Length == 0)
                {

                    TRecibo.Focus();
                    LError.Text = "Por favor ingrese un numero de recibo.";
                    return;
                }
            }
            if (GActivades.Rows.Count == 0)
            {
                LError.Text = "Por favor ingrese por lo menos una actividad.";
                return;
            }
            if (HIdAutorizacion.Value.Length == 0 && TNumero.Text.Length > 0)
            {
                if (conector.QueryString("SELECT autNumero FROM autorizacion WHERE autNumero='" + TNumero.Text + "'").Length != 0)
                {
                    TNumero.Focus();
                    LError.Text = "Este numero de autorización ya existe.";
                    return;
                }
            }

            Paciente paciente = Paciente.GetPaciente(HIdPaciente.Value);
            DateTime tiempo = Convert.ToDateTime(TFecha.Text);
            if (!paciente.IsAlive)
            {
                if (paciente.FechaDefuncion < tiempo)
                {
                    TFecha.Focus();
                    LError.Text = "La fecha de la autorización es posterior a la defunción " + paciente.FechaDefuncion.ToShortDateString() + ".";
                    return;
                }
            }
            // empezamos la insercion.

            if (CGenerar.Checked)
            {
                TNumero.Text = conector.QueryString(
                    String.Format("SELECT CONCAT('AD{0}',LPAD(IFNULL(MAX(REPLACE(autNumero,'AD{0}','')), 0)+1, 3, '0'))"
                            + " FROM autorizacion"
                            + " WHERE autNumero LIKE 'AD{0}%'", tiempo.ToString("yyMMdd")));
            }

            conector.StartTransaction();

            query["autNumero"] = TNumero.Text;
            query["pacId"] = HIdPaciente.Value;
            query["autFecha"] = Query.GetMySQLDateFormat(TFecha.Text);
            query["autFechaVenc"] = Query.GetMySQLDateFormat(TVencimiento.Text);
            query["total"] = TValor.Text.Replace(",", "").Replace("$", "");
            query["autObservaciones"] = TObservaciones.Text;
            query["entId"] = HIdEntidad.Value;
            query["autActivo"] = "1";
            if (HFormula.Text.Length > 0) // es una autorizacion de DMGEN
                query["autProvisional"] = "0";

            if (HIdAutorizacion.Value.Length == 0)
            {
                query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
                query["segFechaIngreso"] = "SYSDATE()";
                if (CGenerar.Checked && RPreautorizacion.Visible && RPreautorizacion.Checked)
                {
                    if (HIdEntidad.Value == "36" || HIdEntidad.Value == "29")
                    {

                        query["segUsuarioConfirma"] = Usuario.GetUsuario().GetLogin();
                        query["segFechaConfirma"] = "SYSDATE()";
                    }
                    else
                    {
                        query["autProvisional"] = "1";
                    }
                }
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HId.Value = res.ToString();
                HIdAutorizacion.Value = TNumero.Text;
            }
            else
            {
                query["segUsuarioModifica"] = Usuario.GetUsuario().GetLogin();
                query["segFechaModifica"] = "SYSDATE()";
                if (conector.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                    return;
            }
            using (CConector conectorm = new CConector())
                if (conectorm.InsertModificacion(HId.Value) == -1)
                    return;

            if (GPagos.Rows.Count == 0)
            {
                temp = TAbono.Text.Replace(",", "").Replace("$", "");
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

            // limpiamos los servicioes anteriores
            if (conector.QueryMod("DELETE FROM autorizacion_detalle WHERE autNumero=" + Query.GetValor(HIdAutorizacion.Value)) == -1)
                return;

            string[] querys = SActividades.GetQuerys();
            string szQuery;

            if (querys != null)
            {
                for (int i = 0; i < querys.Length; i++)
                {
                    szQuery = querys[i].Replace("@autorizacion", Query.GetValor(HIdAutorizacion.Value));
                    if (conector.QueryMod(szQuery) == -1)
                        return;
                }
            }
            Autorizaciones.UpdateSesiones(conector, HIdAutorizacion.Value);
            conector.Commit();

            Paciente.RemovePaciente(HIdPaciente.Value);
            Autorizaciones.RemoveAutorizaciones(HIdPaciente.Value);
        }
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

        Paciente paciente= Paciente.GetPaciente(id);

        PDatos.Visible = false;
        {
            PDatos.Visible = true;
            double maximo = 0;
            PPaciente.Visible = true;
            HIdPaciente.Value = id;
            HIdEntidad.Value = paciente.entidadId;

            TPaciente.Text = paciente.documento;
            LNombrePaciente.Text = paciente.NombreCompleto;

            LInactivo.Visible = !paciente.Activo;
            
            // LMaximo.Text = reader[""];

            LEntidad.Text = paciente.NombreEntidad;
            CultureInfo culture = new CultureInfo("en-US");

            if(paciente.Categoria!="") {

                using (CConector conectormysql = new CConector())
                {
                    MySqlDataReader rtopes = conectormysql.Query("SELECT varios.nombre AS categoria,topes.nombre AS por, topes.descripcion AS tser, topes.szReservado AS tano "
                                                            + " FROM varios"
                                                            + " LEFT JOIN varios AS topes ON (topes.tipo=14 AND topes.parametro1=varios.id)"
                                                            + " WHERE varios.id=" + paciente.Categoria);
                    if (rtopes != null && rtopes.Read())
                    {
                        LCategoria.Text = "<b>" + rtopes["categoria"].ToString() + "</b>";
                        LPorcentaje.Text = string.Format("{0:p}", Convert.ToDouble(rtopes["por"].ToString(), culture.NumberFormat) / 100);
                        LMaximoServicio.Text = string.Format("{0:c}", Convert.ToDouble(rtopes["tser"].ToString(), culture.NumberFormat));
                        maximo = Convert.ToDouble(rtopes["tano"].ToString(), culture.NumberFormat);
                        LMaximoano.Text = string.Format("{0:c}", maximo);
                    }
                }
            }
            if (paciente.TipoAfiliacion != "")
            {
                if (LCategoria.Text.Length > 0)
                    LCategoria.Text += "/";
                LCategoria.Text += (paciente.TipoAfiliacion == "1" ? "Cotizante" : "Beneficiario");
            }

            TFecha.Focus();
            GAutorizaciones.DataBind();
            LAutorizaciones.Text =GAutorizaciones.Rows.Count +  " Autorizaci";
            LAutorizaciones.Text += GAutorizaciones.Rows.Count == 1 ? "ón" : "ones";
            PAutorizaciones.Visible = GAutorizaciones.Rows.Count>0;

            using (CConector conector = new CConector())
            {
                string valor = conector.QueryString("SELECT SUM(valor) FROM pago_autorizacion LEFT JOIN autorizacion ON (autorizacion.autNumero=pago_autorizacion.autNumero) WHERE pacId=" + HIdPaciente.Value + " AND YEAR(autorizacion.autFecha)=YEAR(SYSDATE())");
                if (valor == "")
                    valor = "0";
                maximo -= Convert.ToDouble(valor, culture.NumberFormat);
                LAcumulado.Text = string.Format("{0:c}", Convert.ToDouble(valor, culture.NumberFormat));
                LMaximo.Text = string.Format("{0:c}", maximo);
            }
        }
    }

    protected void GPagos_SelectedIndexChanged(object sender, EventArgs e)
    {
        TRecibo.Text= HttpUtility.HtmlDecode(GPagos.SelectedRow.Cells[2].Text);
        TAbono.Text = HttpUtility.HtmlDecode(GPagos.SelectedRow.Cells[3].Text.Replace(",", "").Replace("$", ""));
        BAgregar.Text = "Editar";
    }
    protected void IIr_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("~/admisiones/autorizaciones.aspx?aut=" + ((ImageButton)sender).CommandArgument);
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM pago_autorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
            {
                return;
            }
            if (conector.QueryMod("DELETE FROM autorizacion_detalle WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
            {
                return;
            }
            if (conector.QueryMod("DELETE FROM autorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
            {
                return;
            }
            if (conector.QueryMod("DELETE FROM programacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
            {
                return;
            }
            using(CConector conectorm= new CConector()) 
                if (conectorm.InsertModificacion(HId.Value) == -1)
                    return;
            conector.Commit();
        }

        Paciente.RemovePaciente(HIdPaciente.Value);
        Autorizaciones.RemoveAutorizaciones(HIdPaciente.Value);

        ((MasterPageI)Master).SetResultado("Autorización " + HIdAutorizacion.Value + " eliminada.");
    }

    protected void BASuspencion_Click(object sender, EventArgs e)
    {
        Query query = new Query("autorizacion");
        using (CConector conector = new CConector())
        {

            query["autActivo"] = "0";
            query["autObservacionesAnul"] = TMotivo.Text;
            query["autProvisional"] = "1";
            if (RSuspender.Checked)
                query["autFechaSuspension"] = TFSuspender.Text;

            if (conector.QueryMod(query.GetUpdate("autNumero='" + HIdAutorizacion.Value + "'")) == -1)
                return;
            if (conector.QueryMod("UPDATE programacion SET prgActivo=0 WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
                return;

            if (conector.InsertModificacion(HId.Value) == -1)    
                return;
        }

        Paciente.RemovePaciente(HIdPaciente.Value);
        Autorizaciones.RemoveAutorizaciones(HIdPaciente.Value);

        ((MasterPageI)Master).SetResultado("Autorización " + HIdAutorizacion.Value + (RSuspender.Checked ? " suspendida." : " anulada." ));
    }

    protected void BProcedimiento_Click(object sender, EventArgs e)
    {
        if (sender == BProcedimiento)
        {
            Page.Validate("procedimiento");
            if (!Page.IsValid)
                return;
            if (Procedimientos.HasIntensidad(TProcedimientoID.Text) && DIntensidad.SelectedValue.Length == 0)
            {
                LMensaje.Text = "Por favor ingrese una intensidad para el procedimiento.";
                DIntensidad.Focus();
                return;
            }
        }

        for(int i=0; i<GActivades.Rows.Count; i++) { // verificamos que el servicio no se encuentre duplicado
            if (GActivades.Rows[i].Cells[2].Text == TProcedimientoID.Text && DIntensidad.SelectedValue == HttpUtility.HtmlDecode(GActivades.Rows[i].Cells[6].Text).Trim() && GActivades.SelectedIndex != i)
            {
                LMensaje.Text = "Ya existe este procedimiento";
                TProcedimiento.Focus();
                return;
            }
        }

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("procedimiento", TProcedimiento.Text);
        data.Add("tint", DIntensidad.SelectedItem==null ? "" : DIntensidad.SelectedItem.Text);
        data.Add("idint", DIntensidad.SelectedValue == "" ? null : DIntensidad.SelectedValue);
        data.Add("sesionesdia", TSesionesDia.Text.Length==0 ? null : TSesionesDia.Text);
        data.Add("numerosesiones", TNumeroSesiones.Text);
        data.Add("proc_id", TProcedimientoID.Text);
        data.Add("verificacion", Crypt.GetMD5("JuHU" + DateTime.Now.ToString() + "H0m3s4lud"));
        if (sender != BProcedimiento) 
            data.Add("id", TProcedimientoID.Text);

        if (GActivades.SelectedIndex == -1)
        {
            SActividades.GetView().Insert(data, OnDataSourceOperationComplete);
        }
        else
        {
            data.Add("id", GActivades.DataKeys[GActivades.SelectedIndex].Value);

            IOrderedDictionary dataold = new OrderedDictionary();
            dataold.Add("procedimiento", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[3].Text).Trim());
            dataold.Add("numerosesiones", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[4].Text).Trim());
            dataold.Add("sesionesdia", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[5].Text).Trim());            
            dataold.Add("tint", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[6].Text).Trim());
            dataold.Add("idint", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[7].Text).Trim());
            dataold.Add("proc_id", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[2].Text).Trim());
            dataold.Add("id", GActivades.DataKeys[GActivades.SelectedIndex].Value);

            SActividades.GetView().Update(data, data, dataold, OnDataSourceOperationComplete);
        }
        GActivades.SelectedIndex = -1;
        GActivades.DataBind();

        LMensaje.Text= TProcedimientoID.Text = TProcedimiento.Text = TSesionesDia.Text = TNumeroSesiones.Text = "";
        BIntensidad_Clicked(sender, e);
        BProcedimiento.Text = "Agregar";
        TProcedimiento.Focus();
    }

    private bool OnDataSourceOperationComplete(int count, Exception e)
    {
        if (e != null)
        {
            throw e;
        }
        return false;
    }

    protected void GActivades_SelectedIndexChanged(object sender, EventArgs e)
    {
        TProcedimiento.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[3].Text).Trim();
        TNumeroSesiones.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[4].Text).Trim();
        TSesionesDia.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[5].Text).Trim();
        TProcedimientoID.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[2].Text).Trim();
        Utilidades.SelectInDropDown(DIntensidad, HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[7].Text).Trim());
        

        BProcedimiento.Text = "Editar";
        TProcedimiento.Focus();
    }

    protected void BIntensidad_Clicked(object sender, EventArgs e)
    {
        DIntensidad.DataBind();
        RIntensidad.Visible = DIntensidad.Items.Count > 0;
        DIntensidad.Items.Insert(0, new ListItem("(Ninguna)", ""));
        DIntensidad.SelectedIndex = 0;
    }
}
