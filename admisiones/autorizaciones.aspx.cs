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
                        if(reader["autFechaVenc"].ToString()!="") {
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
                    reader = conector.Query("SELECT phdDetalleAutorizacion.actId,phdActividad.actDescripcion,phdDetalleAutorizacion.autNumSesiones,phdDetalleAutorizacion.autSesionesDia, phdDetalleAutorizacion.intensidad"
                        + " FROM phdDetalleAutorizacion"
                        + " LEFT JOIN phdActividad ON (phdDetalleAutorizacion.actId=phdActividad.actId)"
                        + " WHERE phdDetalleAutorizacion.autNumero=" + Query.GetValor(HIdAutorizacion.Value)
                        + " ORDER BY phdActividad.actDescripcion;"
                        );
                    if (reader != null) {

                        while (reader.Read()) {
                            TProcedimientoID.Text = reader["actId"].ToString();
                            TProcedimiento.Text = reader["actDescripcion"].ToString();
                            conector.SelectInDropDown(DIntensidad, reader["intensidad"]);
                            TSesionesDia.Text = reader["autSesionesDia"].ToString();
                            TNumeroSesiones.Text = reader["autNumSesiones"].ToString();
                            if (TProcedimiento.Text.Length == 0)
                                TProcedimiento.Text= Procedimientos.GetProcedimiento(TProcedimientoID.Text);

                            BProcedimiento_Click(sender, e);
                        }
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

    protected void BSi_Click(object sender, EventArgs e) {

        // guardamos la autorizacion
        BNo_Click(sender, e);
    }

    protected void BNo_Click(object sender, EventArgs e) {

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
        if (HIdPaciente.Value.Length == 0)
        {
            TPaciente.Focus();
            LError.Text = "Por favor ingrese un paciente.";
            return;
        }
        string temp = TAbono.Text.Replace(",", "");
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
            if (conector.QueryString("SELECT autNumero FROM phdAutorizacion WHERE autNumero='" + TNumero.Text + "'").Length != 0)
            {
                TNumero.Focus();
                LError.Text = "Este numero de autorización ya existe.";
                return;
            }
        }
        // empezamos la insercion.

        if (CGenerar.Checked)
        {
            DateTime tiempo = Convert.ToDateTime(TFecha.Text);
            TNumero.Text = conector.QueryString(
                String.Format("SELECT 'AD{0}'+RIGHT('000'+CAST(ISNULL(MAX(CONVERT(int,SUBSTRING(autNumero,9,LEN(autnumero)-8))), 0)+1 AS VARCHAR(3)),3)"
                        + " FROM phdAutorizacion"
                        + " WHERE autNumero LIKE 'AD{0}%'", tiempo.ToString("yyMMdd")));
        }

        query["autNumero"] = TNumero.Text;
        query["pacId"] = HIdPaciente.Value;
        query["autFecha"] = TFecha.Text;
        query["autFechaVenc"] = TVencimiento.Text;
        query["total"] = TValor.Text.Replace(",", "");
        query["autObservaciones"] = TObservaciones.Text;
        query["entId"] = HIdEntidad.Value;
        query["autActivo"] = "1";

        if (HIdAutorizacion.Value.Length == 0)
        {

            query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
            query["segFechaIngreso"] = "GETDATE()";
            if (CGenerar.Checked && RPreautorizacion.Visible && RPreautorizacion.Checked)
            {
                if (HIdEntidad.Value == "36" || HIdEntidad.Value == "29")
                {

                    query["segUsuarioConfirma"] = Usuario.GetUsuario().GetLogin();
                    query["segFechaConfirma"] = "GETDATE()";
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
            query["segFechaModifica"] = "GETDATE()";
            if (conector.QueryMod(query.GetUpdate("autNumero=" + Query.GetValor(HIdAutorizacion.Value))) == -1)
                return;
        }
        if (new CConector().InsertModificacion(HId.Value) == -1)
            return;

        if (GPagos.Rows.Count == 0)
        {
            temp = TAbono.Text.Replace(",", "");
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

        ArrayList profesionales = new ArrayList();

        if (sender == BSi)
        {
            DataTable dataTable = SActividades.GetTable();
            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                DataRow row = dataTable.Rows[i];
                if (row["sqlexists"].ToString().Length == 0)
                {
                    if (Procedimientos.GetAutomatico(row["proc_id"].ToString()))
                    {
                        string intensidad = row["idint"].ToString();
                        if (intensidad == "")
                        {
                            intensidad = " IS NULL";
                        }
                        else
                        {
                            intensidad = "=" + intensidad;
                        }
                        string personal = conector.QueryString("SELECT TOP 1 perId FROM programacion WHERE pacId=" + HIdPaciente.Value + " AND actId=" + row["proc_id"].ToString() + " AND intensidad" + intensidad + " ORDER BY prgFechaProg DESC;");
                        if (personal.Length > 0)
                        { // se encontro programacion antigua
                            
                            string nombre = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId=" + personal + " AND eEstId=1 AND perCorreoElectronico IS NOT NULL AND perCorreoElectronico!='';");
                            if (nombre.Length > 0)
                            { // se encontro el correo

                                Query programacion = new Query("programacion");
                                string entidad = conector.QueryString("SELECT entId FROM phdPaciente WHERE pacId=" + HIdPaciente.Value);

                                programacion["pacId"] = HIdPaciente.Value;
                                programacion["perId"] = personal;
                                programacion["prgObservaciones"] = TObservaciones.Text;
                                programacion["autNumero"] = TNumero.Text;
                                programacion["prgNumSesion"] = "1";
                                programacion["prgActivo"] = "1";
                                programacion["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
                                programacion["segFechaIngreso"] = "GETDATE()";
                                programacion["entId"] = entidad;

                                programacion["actId"] = row["proc_id"].ToString();
                                programacion["intensidad"] = row["idint"].ToString();
                                string costo = Procedimientos.GetCosto(row["proc_id"].ToString(), entidad).ToString(CultureInfo.InvariantCulture);
                                if (costo.Length > 0)
                                    programacion["costo"] = costo;

                                int numero = Convert.ToInt32(row["numerosesiones"]);
                                int periodicidad = 1;
                                DateTime inicio = DateTime.Now;
                                int dias=30;
                                for (int total = numero; total > 0;)
                                {
                                    inicio= inicio.AddDays(periodicidad);
                                    if (numero < 5)
                                    { // cada semana
                                        switch (inicio.DayOfWeek)
                                        {
                                            case DayOfWeek.Sunday:
                                            case DayOfWeek.Saturday:
                                                continue;
                                        }
                                        periodicidad = 7;
                                    }
                                    else if (numero < 9)
                                    { // martes y jueves
                                        switch (inicio.DayOfWeek)
                                        {
                                            case DayOfWeek.Thursday:
                                            case DayOfWeek.Tuesday:
                                                break;
                                            default:
                                                continue;
                                        }
                                    }
                                    else if (numero < 13)
                                    { // lunes martes  y miercoles
                                        switch (inicio.DayOfWeek)
                                        {
                                            case DayOfWeek.Monday:
                                            case DayOfWeek.Wednesday:
                                            case DayOfWeek.Friday:
                                                break;
                                            default:
                                                continue;
                                        }
                                    }
                                    else if (numero < 17) // de lunes a jueves
                                    {
                                        switch (inicio.DayOfWeek)
                                        {
                                            case DayOfWeek.Monday:
                                            case DayOfWeek.Thursday:
                                            case DayOfWeek.Wednesday:
                                            case DayOfWeek.Tuesday:
                                            case DayOfWeek.Friday:
                                                break;
                                            default:
                                                continue;
                                        }
                                    }
                                    else if (numero < 21)
                                    { // todos los dias habiles
                                        switch (inicio.DayOfWeek)
                                        {
                                            case DayOfWeek.Sunday:
                                            case DayOfWeek.Saturday:
                                                continue;
                                        }
                                    }
                                    else if (total/2>dias)
                                    {
                                        programacion["prgNumSesion"]="3";
                                        total--;
                                        total--;
                                    }
                                    else if (total>dias)
                                    {
                                        programacion["prgNumSesion"] = "2";
                                        total--;
                                    } else {
                                        programacion["prgNumSesion"] = "1";
                                    }

                                    programacion["prgFechaProg"] = inicio.ToShortDateString();
                                    if (conector.QueryMod(programacion.GetInsert(), true) == -1)
                                        return;

                                    total--;
                                    dias--;
                                }

                                profesionales.Add(new Procedimiento(personal, row["proc_id"].ToString(), row["idint"].ToString(), row["verificacion"].ToString()));
                            }
                        }
                    }
                }
            }
        }

        // limpiamos los servicioes anteriores
        if (conector.QueryMod("DELETE FROM phdDetalleAutorizacion WHERE autNumero=" + Query.GetValor(HIdAutorizacion.Value)) == -1)
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

        conector.Commit();

        for (int i = 0; i < profesionales.Count; i++ ) 
        { // se realizo alguna programacion

            Procedimiento procedimiento = (Procedimiento)profesionales[i];
            SqlDataReader reader = conector.Query("SELECT perNombre,perCorreoElectronico FROM admPersonalHS WHERE perId=" + procedimiento.profesional + " AND eEstId=1;");
            if(reader!=null && reader.Read()) {

                string nombre= reader["perNombre"].ToString();
                string correo= reader["perCorreoElectronico"].ToString();
                if (IsValidEmail(correo))
                {
#if DEBUG
                    correo="demo@example.invalid";
#endif

                    MailMessage msg = new MailMessage(new MailAddress("demo@example.invalid", "Contratistas OrganizationExample15")
                                , new MailAddress(correo, nombre));

                    // msg.Bcc.Add(new MailAddress("demo@example.invalid"));
                    msg.IsBodyHtml = true;
                    msg.ReplyTo = new MailAddress("demo@example.invalid");

                    StreamReader archivo = new StreamReader(Server.MapPath("programacion.html"));
                    msg.Body = archivo.ReadToEnd();
                    archivo.Close();

                    msg.Body = ((MasterPageI)Master).ReplaceContenido(this.Controls, msg.Body);

                    string programacion = "";
                    
                    programacion = "<table border='1'>\n";
                    programacion += "<tr>\n";
                    programacion += "<td><strong>Fecha</strong></td>";
                    programacion += "<td><strong>Actividad</strong></td>";
                    programacion += "</tr>\n";

                    string intensidad="";
                    if (procedimiento.intensidad.Length==0)
                        intensidad = "intensidad IS NULL";
                    else intensidad = "intensidad=" + procedimiento.intensidad;

                    reader = conector.Query("SELECT prgFechaProg FROM programacion WHERE autNumero=" + Query.GetValor(TNumero.Text) + " AND perId=" + procedimiento.profesional + " AND actId=" + procedimiento.procedimiento + " ORDER BY prgFechaProg;");
                    if (reader != null)
                    {
                        while (reader.Read())
                        {
                            DateTime fecha = (DateTime)reader["prgFechaProg"];
                            intensidad = Procedimientos.GetVarios(procedimiento.intensidad);
                            if(intensidad.Length>0) 
                                intensidad = "-" + intensidad;

                            programacion += "<tr>\n";
                            programacion += "<td>" + fecha.ToLongDateString() + "</td>";
                            programacion += "<td>" + Procedimientos.GetProcedimiento(procedimiento.procedimiento) + intensidad + "</td>";
                            programacion += "</tr>\n";
                        }
                    }

                    programacion+= "</table>";

                    query = new Query("phdPaciente");

                    query["TPaciente"] = "phdPaciente.pacDocumento";
                    query["LPaciente"] = "phdPaciente.pacNombres";
                    query["sexoId"] = "phdPaciente.sexoId";
                    query["pacFechaNac"] = "phdPaciente.pacFechaNac";
                    query["LAsegurador"] = "admEntidad.entNombre";
                    query["szTipoAfiliacion"] = "CASE pacTipoAfiliado WHEN 1 THEN 'Cotizante' WHEN 2 THEN 'Beneficiario' ELSE '' END";
                    query["LDireccion"] = "phdPaciente.pacDireccion";
                    query["LBarrio"] = "phdPaciente.pacBarrio";
                    query["LTipoPago"] = "phdPagoDirecto.pdirDescripcion";
                    query["LTelefono"] = "phdPaciente.pacTelefono";
                    query["LFamiliar"] = "phdPaciente.pacFamilarResponsable";
                    query["LParentesco"] = "phdPaciente.pacParentesco";
                    query["cieCodDx"] = "phdPaciente.cieCodDx";
                    query["cieCodDx_1"] = "phdPaciente.cieCodDx_1";
                    query["cieCodDx_2"] = "phdPaciente.cieCodDx_2";


                    reader = conector.Query(query.GetSelect("phdPaciente.pacId=" + HIdPaciente.Value + "",
                                                "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)" +
                                                " LEFT JOIN phdPagoDirecto ON (phdPagoDirecto.pdirId=phdPaciente.pdirId)"));
                    if (reader != null && reader.Read())
                    {
                        msg.Subject = "Programación paciente " + reader["LPaciente"].ToString();

                        for (int h = 0; h < reader.FieldCount; h++)
                        {
                            msg.Body = msg.Body.Replace("$" + reader.GetName(h) + "$", reader[h].ToString());
                        }

                        if (reader["pacFechaNac"] != null && reader["pacFechaNac"].ToString().Length != 0)
                        {
                            DateTime birthDate = (DateTime)reader["pacFechaNac"];
                            DateTime now = DateTime.Now;
                            int years = now.Year - birthDate.Year;

                            if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                                --years;
                            msg.Body = msg.Body.Replace("$LFechaNacimiento$", years + " años");
                        }
                        else msg.Body = msg.Body.Replace("$LFechaNacimiento$", "");
                        msg.Body= msg.Body.Replace("$LSexo$", reader["sexoId"].ToString() == "1" ? "F" : "M");

                        string cie1 = reader["cieCodDx"].ToString();
                        string cie2 = reader["cieCodDx_1"].ToString();
                        string cie3 = reader["cieCodDx_2"].ToString();
                        cie1 = Procedimientos.GetCodigoCIE(cie1, conector);
                        cie2 = Procedimientos.GetCodigoCIE(cie2, conector);
                        cie3 = Procedimientos.GetCodigoCIE(cie3, conector);
                        if (cie2.Length > 0 && cie1.Length > 0)
                            cie1+= "<br/>";
                        cie1+= cie2;
                        if (cie3.Length > 0 && cie1.Length > 0)
                            cie1 += "<br/>";
                        cie1 += cie3;
                        msg.Body = msg.Body.Replace("$LCIE10$", cie1);
                    }

                    msg.Body = msg.Body.Replace("$GProgramacion$", programacion);
                    msg.Body = msg.Body.Replace("$servidor$", ConfigurationManager.AppSettings["ServidorNotificacion"] + "notificacion/");
                    msg.Body = msg.Body.Replace("$Autorizacion$", TNumero.Text);
                    msg.Body = msg.Body.Replace("$key$", procedimiento.key);

                    // build message contents 
                    SmtpClient client = new SmtpClient();
                    client.Send(msg);
                }
            }
        }
        
        ((MasterPageI)Master).SetResultado("Número de autorización " + TNumero.Text + " editada.");
    }
    
    public bool IsValidEmail(string emailaddress)
    {
        try
        {
            MailAddress m = new MailAddress(emailaddress);
            return true;
        }
        catch (FormatException)
        {
            return false;
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        CConectorMS conector = new CConectorMS();
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
        string temp = TAbono.Text.Replace(",", "");
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
            if (conector.QueryString("SELECT autNumero FROM phdAutorizacion WHERE autNumero='" + TNumero.Text + "'").Length != 0)
            {
                TNumero.Focus();
                LError.Text = "Este numero de autorización ya existe.";
                return;
            }
        }

        LConfirmar.Text = "";
        ArrayList fechas = new ArrayList();
        DataTable dataTable = SActividades.GetTable();
        for (int i = 0; i < dataTable.Rows.Count; i++)
        {
            DataRow row = dataTable.Rows[i];
            if (row["sqlexists"].ToString().Length == 0)
            {
                if (Procedimientos.GetAutomatico(row["proc_id"].ToString()))
                {

                    string intensidad = row["idint"].ToString();
                    if (intensidad == "")
                    {
                        intensidad = " IS NULL";
                    }
                    else
                    {
                        intensidad = "=" + intensidad;
                    }
                    string personal = conector.QueryString("SELECT TOP 1 perId FROM programacion WHERE pacId=" + HIdPaciente.Value + " AND actId=" + row["proc_id"].ToString() + " AND intensidad" + intensidad + " ORDER BY prgFechaProg DESC;");
                    if (personal.Length > 0)
                    { // se encontro programacion antigua

                        string correo = conector.QueryString("SELECT perNombre FROM admPersonalHS WHERE perId=" + personal + " AND eEstId=1;");
                        if (correo.Length > 0)
                        { // se encontro el correo
                            if (LConfirmar.Text.Length > 0)
                                LConfirmar.Text += "<br/>";
                            LConfirmar.Text += correo + "<br/>";
#if DEBUG
                            correo="demo@example.invalid";
#endif
                            int numero = Convert.ToInt32(row["numerosesiones"]);
                            int periodicidad = 1;
                            DateTime inicio = DateTime.Now;
                            int dias = 30;
                            string sessionespordia = "";
                            for (int total = numero; total > 0;)
                            {
                                inicio= inicio.AddDays(periodicidad);
                                if (numero < 5)
                                { // cada semana
                                    switch (inicio.DayOfWeek)
                                    {
                                        case DayOfWeek.Sunday:
                                        case DayOfWeek.Saturday:
                                            continue;
                                    }
                                    periodicidad = 7;
                                }
                                else if (numero < 9)
                                { // martes y jueves
                                    switch (inicio.DayOfWeek)
                                    {
                                        case DayOfWeek.Thursday:
                                        case DayOfWeek.Tuesday:
                                            break;
                                        default:
                                            continue;
                                    }
                                }
                                else if (numero < 13)
                                { // lunes martes  y miercoles
                                    switch (inicio.DayOfWeek)
                                    {
                                        case DayOfWeek.Monday:
                                        case DayOfWeek.Wednesday:
                                        case DayOfWeek.Friday:
                                            break;
                                        default:
                                            continue;
                                    }
                                }
                                else if (numero < 17) // de lunes a jueves
                                {
                                    switch (inicio.DayOfWeek)
                                    {
                                        case DayOfWeek.Monday:
                                        case DayOfWeek.Thursday:
                                        case DayOfWeek.Wednesday:
                                        case DayOfWeek.Tuesday:
                                        case DayOfWeek.Friday:
                                            break;
                                        default:
                                            continue;
                                    }
                                }
                                else if (numero < 21)
                                { // todos los dias habiles
                                    switch (inicio.DayOfWeek)
                                    {
                                        case DayOfWeek.Sunday:
                                        case DayOfWeek.Saturday:
                                            continue;
                                    }
                                }
                                if (total!=numero)
                                    LConfirmar.Text += ", ";

                                if (total/2>dias)
                                {
                                    sessionespordia = "(3)";
                                    total--;
                                    total--;
                                } else if(total>dias) {
                                    sessionespordia = "(2)";
                                    total--;
                                } else {
                                    sessionespordia = "";
                                }
                                total--;
                                dias--;

                                LConfirmar.Text += inicio.ToShortDateString() + sessionespordia;
                                fechas.Add(inicio.ToShortDateString());
                            }
                        }
                    }
                }
            }
        }

        if (fechas.Count>0)
            PConfirmar.Visible = true;
        else BNo_Click(sender, e);
    }

    protected void BCancelarP_Click(object sender, EventArgs e)
    {
        PConfirmar.Visible = false;
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
        PDatos.Visible = false;
        if (reader != null && reader.Read())
        {
            PDatos.Visible = true;
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
        if (conector.QueryMod("DELETE FROM programacion WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
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
        query["autProvisional"] = "1";
        if (RSuspender.Checked)
            query["autFechaSuspension"] = TFSuspender.Text;

        if (conector.QueryMod(query.GetUpdate("autNumero='" + HIdAutorizacion.Value + "'")) == -1)
            return;
        if (conector.QueryMod("UPDATE programacion SET prgActivo=0 WHERE autNumero='" + HIdAutorizacion.Value + "'") == -1)
            return;

        if (new CConector().InsertModificacion(HId.Value) == -1)
            return;

        ((MasterPageI)Master).SetResultado("Autorización " + HIdAutorizacion.Value + (RSuspender.Checked ? " suspendida." : " anulada." ));
    }

    protected void BProcedimiento_Click(object sender, EventArgs e)
    {
        Page.Validate("procedimiento");
        if (!Page.IsValid)
            return;

        for(int i=0; i<GActivades.Rows.Count; i++) { // verificamos que el servicio no se encuentre duplicado
            if (GActivades.Rows[i].Cells[2].Text == TProcedimientoID.Text && DIntensidad.SelectedItem.Text == HttpUtility.HtmlDecode(GActivades.Rows[i].Cells[6].Text).Trim() && GActivades.SelectedIndex != i)
            {
                LMensaje.Text = "Ya existe este procedimiento";
                TProcedimiento.Focus();
                return;
            }
        }

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("procedimiento", TProcedimiento.Text);
        data.Add("tint", DIntensidad.SelectedItem.Text);
        data.Add("idint", DIntensidad.SelectedValue.Length == 0 ? null : DIntensidad.SelectedValue);
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
        DIntensidad.SelectedIndex = 0;
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
        CConector.SelectInDropDown(DIntensidad, HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[7].Text).Trim());
        TProcedimientoID.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[2].Text).Trim();

        BProcedimiento.Text = "Editar";
        TProcedimiento.Focus();
    }
    protected void GAutorizaciones_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1) {

            int pos = e.Row.Cells[3].Text.IndexOf("%%");
            while(pos!=-1) {
                
                string texto = "";
                for (int i = pos+2; i < e.Row.Cells[3].Text.Length; i++) {
                    if (e.Row.Cells[3].Text[i] == ' ')
                        break;
                    texto+=e.Row.Cells[3].Text[i];
                }
                e.Row.Cells[3].Text= e.Row.Cells[3].Text.Replace("%%" + texto, Procedimientos.GetProcedimiento(texto));
                pos = e.Row.Cells[3].Text.IndexOf("%%");
            }
            e.Row.Cells[3].Text= e.Row.Cells[3].Text.Replace(",", "<br/>");
        }
    }
}
