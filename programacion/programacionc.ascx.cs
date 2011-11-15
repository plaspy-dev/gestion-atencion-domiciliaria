using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Collections;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class phd_programacionc : System.Web.UI.UserControl
{
    public ProgramacionTipo.TipoServicios TipoServicio
    {
        get
        {
            return ProgramacionTipo.TipoServicio;
        }
        set
        {
            ProgramacionTipo.TipoServicio = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        SAutorizacion.SelectCommand = SAutorizacion.SelectCommand.Replace("phdProgramacion", ProgramacionTipo.GetNombreTabla());
        SActividad.SelectCommand = SActividad.SelectCommand.Replace("phdProgramacion", ProgramacionTipo.GetNombreTabla());
        if (ProgramacionTipo.TipoServicio == ProgramacionTipo.TipoServicios.medico)
        {
            SAutorizacion.SelectCommand = SAutorizacion.SelectCommand.Replace("AND phdTipoActividad.tpaTipoServicio=1", "AND phdTipoActividad.tpaTipoServicio=3");
            SActividad.SelectCommand = SActividad.SelectCommand.Replace("AND phdTipoActividad.tpaTipoServicio=1", "AND phdTipoActividad.tpaTipoServicio=3");
            SProfesional.SelectCommand = SProfesional.SelectCommand.Replace("(areaid=2 or carId in (8,11,25,27))", "carId in (6,8,29,27,19,18,9,45)");
        } else  if (ProgramacionTipo.TipoServicio == ProgramacionTipo.TipoServicios.apoyo)
        {
            SAutorizacion.SelectCommand = SAutorizacion.SelectCommand.Replace("AND phdTipoActividad.tpaTipoServicio=1", "AND phdTipoActividad.tpaTipoServicio=2");
            SActividad.SelectCommand = SActividad.SelectCommand.Replace("AND phdTipoActividad.tpaTipoServicio=1", "AND phdTipoActividad.tpaTipoServicio=2");
            SProfesional.SelectCommand = SProfesional.SelectCommand.Replace("(areaid=2 or carId in (8,11,25,27))", "(areaid=1 or carId in (4,23))");
        }
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
                Query query = new Query(ProgramacionTipo.GetNombreTabla());

                query += "prgFechaProg";
                query += "perId";
                query += "actId";
                query += "prgObservaciones";
                query += "autNumero";
                query += "prgNumSesion";

                CConectorMS conector = new CConectorMS();

                SqlDataReader reader = conector.Query(query.GetSelect("prgId=" + HId.Value));
                if (reader != null && reader.Read())
                {
                    CRecurrente.Checked = false;
                    TFechaFinal.Text= TFecha.Text = reader["prgFechaProg"].ToString();
                    TObservaciones.Text = reader["prgObservaciones"].ToString();
                    TSesiones.Text = reader["prgNumSesion"].ToString();

                    conector.SelectInDropDown(DAutorizacion, reader["autNumero"], "SELECT '" + reader["autNumero"].ToString() + "'");
                    conector.SelectInDropDown(DProfesional, reader["perId"], "SELECT perNombre FROM dbo.admPersonalHS where perId='" + reader["perId"].ToString() + "'");
                    conector.SelectInDropDown(DActividad, reader["actId"].ToString(), "SELECT actDescripcion FROM phdActividad WHERE actId='" + reader["actId"].ToString() + "'");

                    DAutorizacion_SelectedIndexChanged(null, null);
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
        CConectorMS conector= new CConectorMS();
        ArrayList fechas = new ArrayList();
        Session["phd_programacion"] = fechas;

        if (CRecurrente.Checked) {

            Label m = (Label)RActividad.Items[DActividad.SelectedIndex].FindControl("LMaximo");
            Label r = (Label)RActividad.Items[DActividad.SelectedIndex].FindControl("LRealizadas");
            int maximo= Convert.ToInt32(m.Text)-Convert.ToInt32(r.Text);
            int sesiones = Convert.ToInt32(TSesiones.Text);
            if (sesiones > 0)
                maximo /= sesiones;

            DateTime inicio= Convert.ToDateTime(TFecha.Text);
            DateTime fin = Convert.ToDateTime(TFechaFinal.Text);

            if (RPeriodicidad.SelectedValue == "1" || RPeriodicidad.SelectedValue == "2")
            {
                int dias = 1;
                if (RPeriodicidad.SelectedValue == "2")
                    dias = Convert.ToInt32(TDias.Text);
                while (inicio <= fin)
                {
                    AddFecha(fechas, inicio.ToShortDateString(),maximo);
                    inicio= inicio.AddDays(dias);
                }
            } else { // dias en especial
                while (inicio <= fin)
                {
                    for(int i=0; i<CSemana.Items.Count; i++) { // verificamos que sea un dia de las semana
                        if (CSemana.Items[i].Selected && inicio.DayOfWeek.ToString() == CSemana.Items[i].Value)
                        {
                            AddFecha(fechas, inicio.ToShortDateString(), maximo);
                        }
                    }
                    inicio= inicio.AddDays(1);
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
        } else {
            fechas.Add(TFecha.Text);
            BSi_Click(sender, e);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        CRecurrente.Checked = false;
        TFecha.Text = "";
        TFechaFinal.Text = "";
        TSesiones.Text = "1";
        DProfesional.SelectedIndex = -1;
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
            CConectorMS conector = new CConectorMS();
            SqlDataReader reader = conector.Query("SELECT autFecha,autFechaVenc FROM phdAutorizacion WHERE autNumero='" + DAutorizacion.SelectedValue + "'");
            if (reader != null && reader.Read())
            {
                RFechaFinal.MinimumValue = RFecha.MinimumValue = CConectorMS.GetDate(reader["autFecha"]);
                RFechaFinal.MaximumValue = RFecha.MaximumValue = CConectorMS.GetDate(reader["autFechaVenc"]);
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
        Usuario usuario = Usuario.GetUsuario();
        CConectorMS conector = new CConectorMS();

        Query query = new Query(ProgramacionTipo.GetNombreTabla());

        query["pacId"] = HIdPaciente.Value;
        query["perId"] = DProfesional.SelectedValue;
        query["actId"] = DActividad.SelectedValue;
        query["prgObservaciones"] = TObservaciones.Text;
        query["autNumero"] = DAutorizacion.SelectedValue;
        query["prgNumSesion"] = TSesiones.Text;
        query["prgActivo"] = "1";
        query["segUsuarioIngreso"] = usuario.GetLogin();
        query["segFechaIngreso"] = "GETDATE()";
        query["entId"] = conector.QueryString("SELECT entId FROM phdPaciente WHERE pacId=" + HIdPaciente.Value);

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
            (new CConector()).InsertModificacion(HId.Value);
            HId.Value = "";
        }

        BCancelar_Click(sender, e);
        EventHandler handler = (EventHandler)base.Events[_AceptarClicked];
        if (handler != null)
        {
            handler(this, e);
        }
    }
    protected void BNo_Click(object sender, EventArgs e)
    {
        PConfirmar.Visible = false;
    }
    protected void DAutorizacion_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (DAutorizacion.SelectedIndex != -1)
        {
            CConectorMS conector = new CConectorMS();
            SqlDataReader reader = conector.Query("SELECT autFecha,autFechaVenc FROM phdAutorizacion WHERE autNumero='" + DAutorizacion.SelectedValue + "'");
            if (reader != null && reader.Read())
            {
                DateTime autorizacion= (DateTime)reader["autFecha"];
                DateTime final = (DateTime)reader["autFechaVenc"];
                if(final==null) 
                    final = autorizacion.AddDays(30);
                RFechaFinal.MinimumValue = RFecha.MinimumValue = CConectorMS.GetDate(autorizacion);
                RFechaFinal.MaximumValue = RFecha.MaximumValue = CConectorMS.GetDate(final);
            }
        }
    }
    protected void DAutorizacion_DataBound(object sender, EventArgs e)
    {
        if(DAutorizacion.Items.Count>0)
            DAutorizacion_SelectedIndexChanged(sender, e);
    }
}
