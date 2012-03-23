using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class admisiones_amasivas : System.Web.UI.Page
{
    class Pacientes {

        public string Paciente { get; set; }
        public string entId { get; set; }
        public string pacId { get; set; }
        public string Entidad { get; set; }

        public Pacientes(string pacienteid, string paciente, string entidadid, string entidad)
        {
            Paciente = paciente;
            entId = entidadid;
            Entidad = entidad;
            pacId = pacienteid;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {
            TPaciente.Focus();
            Session["AMasivasPaciente"] = new ArrayList();
            BAceptar.Enabled = Usuario.GetUsuario().CanInsert();
        }
    }

    protected void BAgregar_Click(object sender, EventArgs e) {

        Validate("paciente");
        if (!IsValid)
            return;
        ArrayList pacientes = (ArrayList)Session["AMasivasPaciente"];

        for (int i = 0; i < pacientes.Count; i++)
        {
            Pacientes info = (Pacientes)pacientes[i];
            if (info.pacId == TPacienteID.Text)
            {
                TPacienteID.Text = TPaciente.Text = "";
                TPaciente.Focus();
                return;
            }
        }

        CConectorMS conector = new CConectorMS();
        SqlDataReader reader= conector.Query("SELECT admEntidad.entId,admEntidad.entNombre FROM phdPaciente LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId) WHERE pacId=" + Query.GetValor(TPacienteID.Text));
        if(reader!=null && reader.Read()) {
            pacientes.Add(new Pacientes(TPacienteID.Text, TPaciente.Text, reader["entId"].ToString(), reader["entNombre"].ToString()));
        }
        GPacientes.DataSource = pacientes;
        GPacientes.DataBind();
        TPacienteID.Text = TPaciente.Text="";
        TPaciente.Focus();
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath);
    }
    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        ArrayList pacientes = (ArrayList)Session["AMasivasPaciente"];
        if(pacientes.Count==0) {

            TPaciente.Focus();
            LError.Text = "Por favor ingrese por lo menos un paciente.";
            return;
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
        if (!actividad)
        {
            LError.Text = "Por favor ingrese por lo menos una actividad.";
            return;
        }

        CConectorMS conector = new CConectorMS();
        CConector conectormysql = new CConector();
        Query query = new Query("phdAutorizacion");
        conector.StartTransaction();

        query["autFecha"] = TFecha.Text;
        query["autFechaVenc"] = TVencimiento.Text;
        query["autObservaciones"] = TObservaciones.Text;
        query["autActivo"] = "1";
        query["segUsuarioIngreso"] = Usuario.GetUsuario().GetLogin();
        query["segFechaIngreso"] = "GETDATE()";
        query["segUsuarioConfirma"] = Usuario.GetUsuario().GetLogin();
        query["segFechaConfirma"] = "GETDATE()";

        for (int i=0; i<pacientes.Count; i++) {

            Pacientes paciente= (Pacientes)pacientes[i];

            DateTime tiempo = Convert.ToDateTime(TFecha.Text);
            string autorizacion = conector.QueryString(
                String.Format("SELECT 'AD{0}'+RIGHT('000'+CAST(ISNULL(MAX(CONVERT(int,SUBSTRING(autNumero,9,LEN(autnumero)-8))), 0)+1 AS VARCHAR(3)),3)"
                        + " FROM phdAutorizacion"
                        + " WHERE autNumero LIKE 'AD{0}%'", tiempo.ToString("yyMMdd")));

            query["autNumero"] = autorizacion;
            query["pacId"] = paciente.pacId;
            query["entId"] = paciente.pacId;

            int res = conector.QueryMod(query.GetInsert(), true);
            if (res == -1)
                return;
            if (conectormysql.InsertModificacion(res.ToString(), "~/admisiones/autorizaciones.aspx") == -1)
                return;

            Query act = new Query("phdDetalleAutorizacion");
            act["autNumero"] = autorizacion;

            for (int j = 0; j < GActivades.Rows.Count; j++)
            {
                string numero = ((TextBox)GActivades.Rows[j].FindControl("TNSesiones")).Text;
                if (numero == "" || numero == "0")
                    continue;
                act["actId"] = GActivades.DataKeys[j].Value.ToString();
                act["autNumSesiones"] = numero;
                act["autSesionesDia"] = ((TextBox)GActivades.Rows[j].FindControl("TSDia")).Text;

                if (conector.QueryMod(act.GetInsert()) == -1)
                    return;
            }
        }
        conector.Commit();
        ((MasterPageI)Master).SetResultado(pacientes.Count + " programaciones agregadas.");
    }
    protected void GPacientes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        ArrayList pacientes = (ArrayList)Session["AMasivasPaciente"];

        for(int i=0; i<pacientes.Count; i++) {

            Pacientes info= (Pacientes)pacientes[i];
            if(info.pacId==GPacientes.DataKeys[e.RowIndex].Value.ToString()) {

                TPacienteID.Text = info.pacId;
                TPaciente.Text = info.Paciente;
                pacientes.RemoveAt(i);
                break;
            }
        }
        e.Cancel = true;
        GPacientes.DataSource = pacientes;
        GPacientes.DataBind();
        TPaciente.Focus();
    }
}
