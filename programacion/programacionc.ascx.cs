using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Collections;
using System.Data.SqlClient;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class phd_programacionc : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), ClientID, "RegisterStarUpScript('dscriptProgramacion');", true);

        Procedimientos.SetProcedimientos(SAutorizacion, "autorizacion_detalle.actId");
        Procedimientos.SetProcedimientos(SActividad, "autorizacion_detalle.actId");
        if(!IsPostBack) {
            Session["phd_programacion"] = null;
        }
    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdProgramacion
    {
        get { return HId.Value; }
        set { 
            HId.Value = value;
            if (HId.Value.Length > 0)
            {
                Query query = new Query("programacion");

                query += "prgFechaProg";
                query += "perId";
                query+="actId";
                query += "prgObservaciones";
                query += "autNumero";
                query += "prgNumSesion";

                using (CConector conector = new CConector())
                {
                    MySqlDataReader reader = conector.Query(query.GetSelect("prgId=" + HId.Value));
                    if (reader != null && reader.Read())
                    {
                        CRecurrente.Checked = false;
                        TFechaFinal.Text = TFecha.Text = reader["prgFechaProg"].ToString();
                        TSesiones.Text = reader["prgNumSesion"].ToString();
                        ViewState["perId"] = 
                            TProfesionalID.Text = reader["perId"].ToString();

                        DAutorizacion.DataBind();
                        Utilidades.SelectInDropDown(DAutorizacion, reader["autNumero"], reader["autNumero"].ToString());
                        DAutorizacion_SelectedIndexChanged(null, null);

                        string procedimiento= Procedimientos.GetProcedimiento(reader["actId"].ToString());

                        DActividad.DataBind();
                        Utilidades.SelectInDropDown(DActividad, reader["actId"].ToString(), procedimiento);

                        TObservaciones.Text = reader["prgObservaciones"].ToString();
                        TProfesional.Text = conector.QueryString("SELECT perNombre FROM recurso_humano where perId='" + reader["perId"].ToString() + "'");
                        ViewState["maximo"] = TSesiones.Text;
                    }
                }
            }
        }
    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdPaciente
    {
        get { return HIdPaciente.Value; }
        set { HIdPaciente.Value = value; }
    }

    private static readonly object _AceptarClicked = new object();
    private static readonly object _CancelarClicked = new object();

    [Category("Acciones"), Description("Button_OnClick")]
    public event EventHandler AceptarClicked
    {
        add {
            base.Events.AddHandler(_AceptarClicked, value);
        }
        remove {
            base.Events.RemoveHandler(_AceptarClicked, value);
        }
    }

    [Category("Acciones"), Description("Cancelar_OnClick")]
    public event EventHandler CancelarClicked
    {
        add
        {
            base.Events.AddHandler(_CancelarClicked, value);
        }
        remove
        {
            base.Events.RemoveHandler(_CancelarClicked, value);
        }
    }

    protected bool AddFecha(ArrayList fechas, string fecha, int maximo) {

        if (fechas.Count >= maximo)
            return false;
        if (fecha == TExepcion1.Text)
            return false;
        if (fecha == TExepcion2.Text)
            return false;
        if (fecha == TExepcion3.Text)
            return false;
        if (fecha == TExepcion4.Text)
            return false;
        if (fecha == TExepcion5.Text)
            return false;
        if (fecha == TExepcion6.Text)
            return false;
        fechas.Add(fecha);
        return true;
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;
        using (CConector conector = new CConector())
        {
            ArrayList fechas = new ArrayList();
            Session["phd_programacion"] = fechas;

            int maximo;

            int sesiones = Convert.ToInt32(TSesiones.Text);
            if (RActividad.Items.Count > DActividad.SelectedIndex)
            {

                Label m = (Label)RActividad.Items[DActividad.SelectedIndex].FindControl("LMaximo");
                Label r = (Label)RActividad.Items[DActividad.SelectedIndex].FindControl("LRealizadas");
                maximo = Convert.ToInt32(m.Text) - Convert.ToInt32(r.Text);
            }
            else
            {
                maximo = Convert.ToInt32(ViewState["maximo"]);
            }

            if (CRecurrente.Checked)
            {

                if (sesiones > 0)
                    maximo /= sesiones;

                DateTime inicio = Convert.ToDateTime(TFecha.Text);
                DateTime fin = Convert.ToDateTime(TFechaFinal.Text);

                if (RPeriodicidad.SelectedValue == "1" || RPeriodicidad.SelectedValue == "2")
                {
                    int dias = 1;
                    if (RPeriodicidad.SelectedValue == "2")
                        dias = Convert.ToInt32(TDias.Text);
                    while (inicio <= fin)
                    {
                        AddFecha(fechas, Query.GetMySQLDateFormat(inicio), maximo);
                        inicio = inicio.AddDays(dias);
                    }
                }
                else
                { // dias en especial
                    // correccion para el mono que no guarda el estado de los elementos
                    for (int i = 0; i < CSemana.Items.Count; i++)
                    { // verificamos que sea un dia de las semana
                        if (!string.IsNullOrEmpty(Request.Form[CSemana.UniqueID + "$" + i]))
                            CSemana.Items[i].Selected = true;
                    }
                    while (inicio <= fin)
                    {
                        for (int i = 0; i < CSemana.Items.Count; i++)
                        { // verificamos que sea un dia de las semana
                            if (CSemana.Items[i].Selected && ((int)inicio.DayOfWeek).ToString() == CSemana.Items[i].Value)
                            {
                                AddFecha(fechas, Query.GetMySQLDateFormat(inicio), maximo);
                            }
                        }
                        inicio = inicio.AddDays(1);
                    }
                }
                LConfirmar.Text = "";
                for (int i = 0; i < fechas.Count; i++)
                {
                    if (i > 0)
                        LConfirmar.Text += "<br/>";
                    LConfirmar.Text += fechas[i].ToString();
                }
                PConfirmar.Visible = true;
            }
            else
            {
                fechas.Add(Query.GetMySQLDateFormat(TFecha.Text));
                if (sesiones > maximo)
                {
                    LMensaje.Text = "Máximo de sesiones permitidas " + maximo;
                    return;
                }
                BSi_Click(sender, e);
            }
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        CRecurrente.Checked = false;
        TFecha.Text = "";
        TFechaFinal.Text = "";
        TSesiones.Text = "1";
        TProfesional.Text = "";
        LMensaje.Text = "";
        TProfesionalID.Text = "";
        DActividad.SelectedIndex = -1;
        DAutorizacion.SelectedIndex = -1;
        DAutorizacion.DataBind();
        RActividad.DataBind();
        DActividad.DataBind();
        TObservaciones.Text = "";
        PConfirmar.Visible = false;
        Visible = false;
        HId.Value="";

        if (DAutorizacion.SelectedIndex != -1)
        {
            using (CConector conector = new CConector())
            {
                MySqlDataReader reader = conector.Query("SELECT autFecha,autFechaVenc FROM autorizacion WHERE autNumero='" + DAutorizacion.SelectedValue + "'");
                if (reader != null && reader.Read())
                {
                    RFechaFinal.MinimumValue = RFecha.MinimumValue = Query.GetFromMySQLDate(reader["autFecha"]);
                    RFechaFinal.MaximumValue = RFecha.MaximumValue = Query.GetFromMySQLDate(reader["autFechaVenc"]);
                }
            }
        }

        if (sender == BCancelar)
        {
            EventHandler handler = (EventHandler)base.Events[_CancelarClicked];
            if (handler != null)
            {
                handler(this, e);
            }
        }
    }

    protected void BSi_Click(object sender, EventArgs e)
    {
        ArrayList fechas= (ArrayList) Session["phd_programacion"];
        CUsuario usuario = (CUsuario) Usuario.GetUsuario();
        using (CConector conector = new CConector())
        {
            Query query = new Query("programacion");
            string entidad = Paciente.GetPaciente(HIdPaciente.Value).entidadId;

            query["pacId"] = HIdPaciente.Value;
            query["perId"] = TProfesionalID.Text;
            query["prgObservaciones"] = TObservaciones.Text;
            query["autNumero"] = DAutorizacion.SelectedValue;
            query["prgNumSesion"] = TSesiones.Text;
            query["prgActivo"] = "1";
            query["segUsuarioIngreso"] = usuario.GetLogin();
            query["segFechaIngreso"] = "SYSDATE()";
            query["entId"] = entidad;

            query["actId"] = DActividad.SelectedValue;
            string costo = Procedimientos.GetCosto(DActividad.SelectedValue, entidad).ToString(CultureInfo.InvariantCulture);
            if (costo.Length > 0)
                query["costo"] = costo;

            for (int i = 0; i < fechas.Count; i++)
            {
                query["prgFechaProg"] = fechas[i].ToString();
                if (HId.Value.Length == 0)
                {
                    int res = conector.QueryMod(query.GetInsert(), true);
                    if (res == -1)
                        return;
                    HId.Value = res.ToString();
                }
                else
                {
                    if (conector.QueryMod(query.GetUpdate("prgId=" + HId.Value)) == -1)
                        return;
                }
                using(CConector conectorm= new CConector()) 
                    conectorm.InsertModificacion(HId.Value);
                HId.Value = "";
            }
            Autorizaciones.UpdateSesiones(conector, DAutorizacion.SelectedValue);
            Funcionario.RebuildDirectorio(conector, TProfesionalID.Text);
            if(!string.IsNullOrEmpty((string)ViewState["perId"]))
                Funcionario.RebuildDirectorio(conector, ViewState["perId"].ToString());

            BCancelar_Click(sender, e);
            EventHandler handler = (EventHandler)base.Events[_AceptarClicked];
            if (handler != null)
            {
                handler(this, e);
            }
        }
    }
    protected void BNo_Click(object sender, EventArgs e)
    {
        PConfirmar.Visible = false;
    }

    public void DAutorizacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DAutorizacion.SelectedIndex != -1)
        {
            using (CConector conector = new CConector())
            {
                MySqlDataReader reader = conector.Query("SELECT autFecha,autFechaVenc,autObservaciones FROM autorizacion WHERE autNumero='" + DAutorizacion.SelectedValue + "'");
                if (reader != null && reader.Read())
                {
                    DateTime autorizacion = (DateTime)reader["autFecha"];
                    DateTime final;
                    if (reader["autFechaVenc"].ToString() == "")
                        final = autorizacion.AddDays(30);
                    else final = (DateTime)reader["autFechaVenc"];
                    if (HId.Value.Length == 0)
                        TObservaciones.Text = reader["autObservaciones"].ToString();
                    if (final == null || final < autorizacion)
                        final = autorizacion.AddDays(30);
                    RFechaFinal.MinimumValue = RFecha.MinimumValue = Query.GetFromMySQLDate(autorizacion);
                    RFechaFinal.MaximumValue = RFecha.MaximumValue = Query.GetFromMySQLDate(final);
                }
            }
        }
    }
    protected void DAutorizacion_DataBound(object sender, EventArgs e)
    {
        if(DAutorizacion.Items.Count>0)
            DAutorizacion_SelectedIndexChanged(sender, e);
    }
    protected void DActividad_DataBound(object sender, EventArgs e)
    {
        for (int i = 0; i < DActividad.Items.Count; i++) {
            if (DActividad.Items[i].Text.Length == 0)
                DActividad.Items[i].Text = Procedimientos.GetProcedimiento(DActividad.Items[i].Value);
        }
    }
}
