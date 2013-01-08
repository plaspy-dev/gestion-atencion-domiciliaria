using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using System.Data.SqlClient;
using SDG.Componentes;
using System.Collections.Specialized;

public partial class admisiones_amasivas : System.Web.UI.Page
{
    [Serializable]
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
            ViewState["AMasivasPaciente"] = new ArrayList();
            BAceptar.Enabled = Usuario.GetUsuario().CanInsert();
            
            if(Session["amasivas_paciente"]==null) {
                string szPacientes = CConector.GetCookie("amasivas_paciente", "");
                if (szPacientes.Length != 0)
                {
                    // agregamos los pacientes
                    string[] pacientes = szPacientes.Split(';');
                    for (int i = 0; i < pacientes.Length; i++)
                    {
                        AddPaciente(pacientes[i]);
                    }
                }
            } else {
                CConector.SetCookie("amasivas_paciente", "");
                Session["amasivas_paciente"] = null;
            }
        }
    }

    protected void AddPaciente(string idpaciente) {

        CConectorMS conector= new CConectorMS();
        SqlDataReader reader = conector.Query("SELECT admEntidad.entId,admEntidad.entNombre,pacDocumento AS documento, pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '') AS nombres,EstId AS estado FROM phdPaciente LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId) WHERE pacId=" + Query.GetValor(idpaciente));
        if(reader!=null && reader.Read()) {
            string valor = reader["documento"].ToString() + " - " + reader["nombres"].ToString();
            if (reader["estado"].ToString() == "2")
                valor = "Inactivo - " + valor;

            ArrayList pacientes = (ArrayList)ViewState["AMasivasPaciente"];
            pacientes.Add(new Pacientes(idpaciente, valor, reader["entId"].ToString(), reader["entNombre"].ToString()));

            if (TPacientes.Text.Length > 0)
                TPacientes.Text += ";";
            TPacientes.Text += idpaciente;

            GPacientes.DataSource = pacientes;
            GPacientes.DataBind();
        }
    }

    protected void BAgregar_Click(object sender, EventArgs e) {

        Validate("paciente");
        if (!IsValid)
            return;
        ArrayList pacientes = (ArrayList)ViewState["AMasivasPaciente"];

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

        AddPaciente(TPacienteID.Text);
        
        TPacienteID.Text = TPaciente.Text="";
        TPaciente.Focus();
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Session["amasivas_paciente"] = 1;
        Response.Redirect(Request.Url.AbsolutePath);
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;

        ArrayList pacientes = (ArrayList)ViewState["AMasivasPaciente"];
        if(pacientes.Count==0) {

            TPaciente.Focus();
            LError.Text = "Por favor ingrese por lo menos un paciente.";
            return;
        }
        if (GActivades.Rows.Count==0)
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

        string[] querys = SActividades.GetQuerys();

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

            string szQuery;
            if (querys != null)
            {
                for (int j = 0; j < querys.Length; j++)
                {
                    szQuery = querys[j].Replace("@autorizacion", Query.GetValor(autorizacion));
                    if (conector.QueryMod(szQuery) == -1)
                        return;
                }
            }
        }
        conector.Commit();
        Session["amasivas_paciente"] = 1;
        ((MasterPageI)Master).SetResultado(pacientes.Count + " programaciones agregadas.");
    }

    protected void GPacientes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        ArrayList pacientes = (ArrayList)ViewState["AMasivasPaciente"];

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

    protected void BProcedimiento_Click(object sender, EventArgs e)
    {
        Page.Validate("procedimiento");
        if (!Page.IsValid)
            return;

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("procedimiento", TProcedimiento.Text);
        data.Add("tint", DIntensidad.SelectedItem.Text);
        data.Add("idint", DIntensidad.SelectedValue.Length == 0 ? null : DIntensidad.SelectedValue);
        data.Add("sesionesdia", TSesionesDia.Text.Length == 0 ? null : TSesionesDia.Text);
        data.Add("numerosesiones", TNumeroSesiones.Text);
        data.Add("proc_id", TProcedimientoID.Text);
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
            dataold.Add("sesionesdia", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[4].Text).Trim());
            dataold.Add("numerosesiones", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[5].Text).Trim());
            dataold.Add("tint", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[6].Text).Trim());
            dataold.Add("idint", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[7].Text).Trim());
            dataold.Add("proc_id", HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[2].Text).Trim());
            dataold.Add("id", GActivades.DataKeys[GActivades.SelectedIndex].Value);

            SActividades.GetView().Update(data, data, dataold, OnDataSourceOperationComplete);
        }
        GActivades.SelectedIndex = -1;
        GActivades.DataBind();

        TProcedimientoID.Text = TProcedimiento.Text = TSesionesDia.Text = TNumeroSesiones.Text = "";
        DIntensidad.SelectedIndex = 0;
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
        TSesionesDia.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[4].Text).Trim();
        TNumeroSesiones.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[5].Text).Trim();
        CConector.SelectInDropDown(DIntensidad, HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[7].Text).Trim());
        TProcedimientoID.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[2].Text).Trim();

        TProcedimiento.Focus();
    }
}
