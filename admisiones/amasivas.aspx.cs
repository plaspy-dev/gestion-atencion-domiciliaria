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
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack) {

            TPaciente.Focus();
            ViewState["AMasivasPaciente"] = new List<string>();
            BAceptar.Enabled = Usuario.GetUsuario().CanInsert();

            Usuario usuario = Usuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];

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

        using (CConectorMS conector = new CConectorMS())
        {

            Paciente actual = Paciente.GetPaciente(idpaciente);
            string valor = actual.documento + " - " + actual.NombreCompleto;

            List<string> pacientes = (List<string>)ViewState["AMasivasPaciente"];
            pacientes.Add(idpaciente);

            ArrayList listadocompleto = new ArrayList();
            for (int i = 0; i < pacientes.Count; i++)
                listadocompleto.Add(Paciente.GetPaciente(pacientes[i]));

            if (TPacientes.Text.Length > 0)
                TPacientes.Text += ";";
            TPacientes.Text += idpaciente;

            GPacientes.DataSource = listadocompleto;
            GPacientes.DataBind();
        }
    }

    protected void BAgregar_Click(object sender, EventArgs e) {

        Validate("paciente");
        if (!IsValid)
            return;
        List<string> pacientes = (List<string>)ViewState["AMasivasPaciente"];

        for (int i = 0; i < pacientes.Count; i++)
        {
            if (pacientes[i]== TPacienteID.Text)
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

        List<string> pacientes = (List<string>)ViewState["AMasivasPaciente"];
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

        using(CConector conectormysql= new CConector()) 
        using (CConectorMS conector = new CConectorMS())
        {
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

            for (int i = 0; i < pacientes.Count; i++)
            {

                DateTime tiempo = Convert.ToDateTime(TFecha.Text);
                string autorizacion = conector.QueryString(
                    String.Format("SELECT 'AD{0}'+RIGHT('000'+CAST(ISNULL(MAX(CONVERT(int,SUBSTRING(autNumero,9,LEN(autnumero)-8))), 0)+1 AS VARCHAR(3)),3)"
                            + " FROM phdAutorizacion"
                            + " WHERE autNumero LIKE 'AD{0}%'", tiempo.ToString("yyMMdd")));

                query["autNumero"] = autorizacion;
                query["pacId"] = pacientes[i];
                query["entId"] = Paciente.GetPaciente(pacientes[i]).entidadId;

                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                if (conectormysql.InsertModificacion(res.ToString(), null, "~/admisiones/autorizaciones.aspx") == -1)
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

            for (int i = 0; i < pacientes.Count; i++)
            {
                Paciente.RemovePaciente(pacientes[i]);
                Autorizaciones.RemoveAutorizaciones(pacientes[i]);
            }
            Session["amasivas_paciente"] = 1;
            ((MasterPageI)Master).SetResultado(pacientes.Count + " programaciones agregadas.");
        }
    }

    protected void GPacientes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        List<string> pacientes = (List<string>)ViewState["AMasivasPaciente"];

        for(int i=0; i<pacientes.Count; i++) {

            if (pacientes[i].ToString()== GPacientes.DataKeys[e.RowIndex].Value.ToString())
            {
                TPacienteID.Text = pacientes[i];
                TPaciente.Text = Paciente.GetPaciente(pacientes[i]).NombreCompleto;
                pacientes.RemoveAt(i);
                break;
            }
        }
        e.Cancel = true;
        
        ArrayList listadocompleto = new ArrayList();
        for (int i = 0; i < pacientes.Count; i++)
            listadocompleto.Add(Paciente.GetPaciente(pacientes[i]));

        GPacientes.DataSource = listadocompleto;
        GPacientes.DataBind();
        TPaciente.Focus();
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

        IOrderedDictionary data = new OrderedDictionary();
        data.Add("procedimiento", TProcedimiento.Text);
        data.Add("tint", DIntensidad.SelectedItem == null ? "" : DIntensidad.SelectedItem.Text);
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
        BIntensidad_Clicked(sender, e);
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
        Utilidades.SelectInDropDown(DIntensidad, HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[7].Text).Trim());
        TProcedimientoID.Text = HttpUtility.HtmlDecode(GActivades.SelectedRow.Cells[2].Text).Trim();

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
