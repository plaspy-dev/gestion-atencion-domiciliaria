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
    [Serializable]
    public class Servicio {
        public int Id { get; set; }
        public string ActividadId { get; set; }
        public string Actividad { get; set; }
        public int? NumeroSesiones { get; set; }
        public int? SesionesPorDia { get; set; }

        public Servicio() { }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            PPaciente.Visible = false;
            TNumero.Focus();
            BEliminar.Visible= PAutorizaciones.Visible = false;
            BSuspender.Visible = false;

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
                    query += "pago";

                    MySqlDataReader reader = conector.Query(query.GetSelect("autNumero=" + Query.GetValor(Request.QueryString["aut"])));
                    if (reader != null && reader.Read())
                    {

                        CGenerar.Visible = false;
                        BAceptar.Enabled = usuario.CanUpdate();
                        BEliminar.Visible = usuario.CanDelete();
                        BSuspender.Visible = usuario.CanDelete();
                        TFSuspender.Text = DateTime.Now.ToShortDateString();

                        HIdAutorizacion.Value = Request.QueryString["aut"];
                        HId.Value = reader["id"].ToString();
                        ((MasterPageI)Master).SetModificacion(HId.Value);

                        HIdEntidad.Value = reader["entId"].ToString();
                        TNumero.Text = reader["autNumero"].ToString();
                        TPaciente.Text = reader["pacId"].ToString();
                        TFecha.Text = Query.GetFromMySQLDate(reader["autFecha"]);
                        TVencimiento.Text = Query.GetFromMySQLDate(reader["autFechaVenc"]);
                        TValor.Text = reader["total"].ToString();
                        LRecibido.Text = string.Format("{0:C}", reader["pago"]);
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
                        reader = conector.Query("SELECT autorizacion_detalle.actId,medicamentos.nombre,autorizacion_detalle.autNumSesiones,autorizacion_detalle.autSesionesDia"
                            + " FROM autorizacion_detalle"
                            + " LEFT JOIN medicamentos ON (autorizacion_detalle.actId=medicamentos.id)"
                            + " WHERE autorizacion_detalle.autNumero=" + Query.GetValor(HIdAutorizacion.Value)
                            + " ORDER BY medicamentos.nombre;"
                            );
                        if (reader != null)
                        {
                            List<Servicio> servicios = new List<Servicio>();
                            while (reader.Read())
                            {
                                Servicio info = new Servicio();
                                info.ActividadId = reader["actId"].ToString();
                                info.Actividad = reader["nombre"].ToString();
                                try { info.NumeroSesiones = Convert.ToInt32(reader["autNumSesiones"]); } catch { }
                                try { info.SesionesPorDia = Convert.ToInt32(reader["autSesionesDia"]); } catch { }

                                servicios.Add(info);
                            }

                            int index = 0;
                            servicios.ForEach(x => x.Id = index++);
                            ViewState["services"] = servicios;
                            GActivades.DataSource = servicios;
                            GActivades.DataBind();
                        }
                        BIr_Click(sender, e);
                    }
                }
            }

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

            string autorizacion = HIdAutorizacion.Value;

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

            if (string.IsNullOrEmpty(autorizacion))
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
                autorizacion = TNumero.Text;
            }
            else
            {
                query["segUsuarioModifica"] = Usuario.GetUsuario().GetLogin();
                query["segFechaModifica"] = "SYSDATE()";
                if (conector.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(autorizacion))) == -1)
                    return;
                autorizacion = TNumero.Text;
                // Actualizamos la programacion
                if (conector.QueryMod(string.Format("UPDATE pago_autorizacion SET autNumero={0} WHERE autNumero={1}", Query.GetValor(autorizacion), Query.GetValor(HIdAutorizacion.Value))) == -1)
                    return;
                if (conector.QueryMod(string.Format("UPDATE autorizacion_detalle SET autNumero={0} WHERE autNumero={1}", Query.GetValor(autorizacion), Query.GetValor(HIdAutorizacion.Value))) == -1)
                    return;
                if (conector.QueryMod(string.Format("UPDATE programacion SET autNumero={0} WHERE autNumero={1}", Query.GetValor(autorizacion), Query.GetValor(HIdAutorizacion.Value))) == -1)
                    return;
            }

            if (conector.InsertModificacion(HId.Value) == -1)
                return;

            // limpiamos los servicioes anteriores
            if (conector.QueryMod("DELETE FROM autorizacion_detalle WHERE autNumero=" + Query.GetValor(autorizacion)) == -1)
                return;

            query = new Query("autorizacion_detalle");

            if (conector.QueryMod(query.GetDelete("autNumero={0}", Query.GetValor(autorizacion))) == -1)
                return;

            query["autNumero"] = autorizacion;

            List<Servicio> servicios = ViewState["services"] as List<Servicio>;
            if (servicios != null) {

                foreach (Servicio info in servicios) {

                    query["actId"] = info.ActividadId;
                    query["autNumSesiones"] = info.NumeroSesiones;
                    query["autSesionesDia"] = info.SesionesPorDia;

                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                }
            }

            // activamos el paciente
            if (conector.QueryMod("UPDATE paciente SET estId=1 WHERE pacId=" + Query.GetValor(HIdPaciente.Value)) == -1)
                return;

            // desactivamos pacientes que no tengan autorizaciones
            if (conector.QueryMod("SET @uids:='0'") == -1)
                return;

            // string ids1 = conector.QueryString("SELECT TRIM(LEADING ',' FROM @uids);");

            if (conector.QueryMod(@"UPDATE paciente set estId=2
                WHERE paciente.estId=1 
                AND (SELECT MAX(IFNULL(autFechaVenc,autFecha+INTERVAL 1 MONTH)) FROM autorizacion WHERE pacId=paciente.pacId)<(NOW()-INTERVAL 5 DAY)
                AND CONCAT_WS(',', @uids, paciente.pacId)=(SELECT @uids := CONCAT_WS(',', @uids, paciente.pacId) )") == -1)
                return;

            string ids = conector.QueryString("SELECT @uids");
            Autorizaciones.UpdateSesiones(conector, autorizacion);
            conector.Commit();

            foreach (string pacienteId in ids.Split(',')) 
                Paciente.RemovePaciente(pacienteId);
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
                string valor = conector.QueryString("SELECT SUM(valor) FROM pago_autorizacion LEFT JOIN autorizacion ON (autorizacion.autNumero=pago_autorizacion.autNumero) WHERE pacId=" + HIdPaciente.Value + " AND YEAR(autorizacion.autFecha)=YEAR(NOW())");
                if (valor == "")
                    valor = "0";
                maximo -= Convert.ToDouble(valor, culture.NumberFormat);
                LAcumulado.Text = string.Format("{0:c}", Convert.ToDouble(valor, culture.NumberFormat));
                // LMaximo.Text = string.Format("{0:c}", maximo);
            }
        }
    }

    protected void IIr_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/admisiones/autorizaciones.aspx?aut=" + ((LinkButton)sender).CommandArgument);
    }

    protected void BEliminar_Click(object sender, EventArgs e)
    {
        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            if (conector.QueryMod("DELETE FROM pago_autorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
                return;
            if (conector.QueryMod("DELETE FROM autorizacion_detalle WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
                return;
            if (conector.QueryMod("DELETE FROM autorizacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
                return;
            if (conector.QueryMod("DELETE FROM programacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
                return;
            if (!Funcionario.RebuildDirectorio(conector))
                return;
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
            conector.StartTransaction();

            query["autActivo"] = "0";
            query["autObservacionesAnul"] = TMotivo.Text;
            query["autProvisional"] = "1";
            if (RSuspender.Checked)
                query["autFechaSuspension"] = TFSuspender.Text;

            if (conector.QueryMod(query.GetUpdate("autNumero='" + HIdAutorizacion.Value + "'")) == -1)
                return;
            if (conector.QueryMod("UPDATE programacion SET prgActivo=0 WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
                return;
            if (!Funcionario.RebuildDirectorio(conector))
                return;
            if (conector.InsertModificacion(HId.Value) == -1)    
                return;

            conector.Commit();
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
        }

        List<Servicio> servicios = ViewState["services"] as List<Servicio> ?? new List<Servicio>();

        if(GActivades.SelectedIndex==-1 && servicios.Exists(x=>x.ActividadId==TProcedimientoID.Text)) {
            LMensaje.Text = "Ya existe este procedimiento";
            TProcedimiento.Focus();
            return;
        }

        
        Servicio info = GActivades.SelectedIndex==-1 ? null : servicios.Find(x => x.Id.ToString() == GActivades.SelectedDataKey.Values["Id"].ToString());

        if (info == null) {
            info = new Servicio();
            servicios.Add(info);
        }

        info.Actividad= TProcedimiento.Text;
        info.ActividadId = TProcedimientoID.Text;
        info.SesionesPorDia = null;
        info.NumeroSesiones = null;
        try { info.SesionesPorDia = Convert.ToInt32(TSesionesDia.Text); } catch { }
        try { info.NumeroSesiones = Convert.ToInt32(TNumeroSesiones.Text); } catch { }

        GActivades.SelectedIndex = -1;
        int index = 0;
        servicios.ForEach(x => x.Id = index++);
        ViewState["services"] = servicios;
        GActivades.DataSource = servicios;
        GActivades.DataBind();

        LMensaje.Text= TProcedimientoID.Text = TProcedimiento.Text = TSesionesDia.Text = TNumeroSesiones.Text = "";
        BProcedimiento.Text = "Agregar";
        TProcedimiento.Focus();
    }

    protected void GActivades_SelectedIndexChanged(object sender, EventArgs e)
    {
        List<Servicio> servicios = ViewState["services"] as List<Servicio> ?? new List<Servicio>();
        Servicio info = servicios.Find(x => x.Id.ToString() == GActivades.SelectedDataKey.Values["Id"].ToString());
        if(info!=null)
        {
            TProcedimiento.Text = info.Actividad;
            TProcedimientoID.Text = info.ActividadId;
            TNumeroSesiones.Text = info.NumeroSesiones==null ? "" : info.NumeroSesiones.ToString();
            TSesionesDia.Text = info.SesionesPorDia==null ? "" : info.SesionesPorDia.ToString();
        }        

        BProcedimiento.Text = "Editar";
        TProcedimiento.Focus();
    }

    protected void GActivades_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<Servicio> servicios = ViewState["services"] as List<Servicio> ?? new List<Servicio>();

        servicios.RemoveAll(x => x.Id.ToString() == e.Keys["Id"].ToString());

        GActivades.SelectedIndex = -1;
        int index = 0;
        servicios.ForEach(x => x.Id = index++);
        ViewState["services"] = servicios;
        GActivades.DataSource = servicios;
        GActivades.DataBind();

        e.Cancel = true;
    }
}
