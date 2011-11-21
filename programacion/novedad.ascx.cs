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

public partial class phd_novedad : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
            HIdTipoNovedad.Value = ((int)ProgramacionTipo.TipoServicio).ToString();
        if (ProgramacionTipo.TipoServicio == ProgramacionTipo.TipoServicios.medico)
        {
            SNuevoServicio.SelectCommand = SNuevoServicio.SelectCommand.Replace("tpaTipoServicio=1", "tpaTipoServicio=3");
            SProfesional.SelectCommand = SProfesional.SelectCommand.Replace("(areaid=2 or carId in (8,11,25,27))", "carId in (6,8,29,27,19,18,9,45)");
        }
        else if (ProgramacionTipo.TipoServicio == ProgramacionTipo.TipoServicios.apoyo)
        {
            SNuevoServicio.SelectCommand = SNuevoServicio.SelectCommand.Replace("tpaTipoServicio=1", "tpaTipoServicio=2");
            SProfesional.SelectCommand = SProfesional.SelectCommand.Replace("(areaid=2 or carId in (8,11,25,27))", "(areaid=1 OR carId IN (4,23))");
        }
        BAceptar.Enabled= Usuario.GetUsuario().CanUpdate();
    }
    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdNovedad
    {
        get { return HId.Value; }
        set { HId.Value = value; }
    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdProgramacion
    {
        get { return HIdProgramacion.Value; }
        set { HIdProgramacion.Value = value; }
    }
    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdProgramaciones
    {
        get { return HIdProgramaciones.Value; }
        set { HIdProgramaciones.Value = value; }
    }

    private static readonly object _AceptarClicked = new object();
    private static readonly object _CancelarClicked = new object();

    [Category("Acciones"), Description("Aceptar_OnClick")]
    public event EventHandler AceptarClicked
    {
        add
        {
            base.Events.AddHandler(_AceptarClicked, value);
        }
        remove
        {
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

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        Query query = new Query("phdNovedad");
        CConectorMS conector = new CConectorMS();
        string []programacion= HIdProgramacion.Value=="" ? HIdProgramaciones.Value.Split(',') : HIdProgramacion.Value.Split(',');
        query["prgTipo"] = HIdTipoNovedad.Value;

        int tipo=(Convert.ToInt32(TTipo.Text) + 1);
        if(tipo>2) // no hay tipo 3
            tipo++;
        query["novTipo"] = tipo.ToString();
        query["novObs"] = TObservaciones.Text;
        query["segUsuarioRegistro"] = Usuario.GetUsuario().GetLogin();
        query["segFechaRegistro"] = "GETDATE()";
        query["novId"] = "2";

        Query qprogramacion = new Query(ProgramacionTipo.GetNombreTabla());

        for (int i = 0; i < programacion.Length; i++)
        {
            query["prgId"] = programacion[i];
            query["perIdAnt"] = conector.QueryString("SELECT perId FROM " + ProgramacionTipo.GetNombreTabla() + " WHERE prgId=" + programacion[i] + "");

            if (TTipo.Text == "0")
            {
                query["cnoId"] = DCausa1.SelectedValue;
                qprogramacion["prgActivo"] = "0";
            }
            else if (TTipo.Text == "1")
            {
                query["cnoId"] = DCausa2.SelectedValue;
                if (DProfesional.SelectedIndex == -1 || DProfesional.SelectedValue.Length==0)
                    return;
                qprogramacion["perId"] = DProfesional.SelectedValue;
                query["perId"] = DProfesional.SelectedValue;
            }
            else if (TTipo.Text == "2")
            {
                query["cnoId"] = DCausa3.SelectedValue;
                query["novNS"] = TNumero.Text;
                qprogramacion["prgNumSesion"] = TNumero.Text;
            }
            else if (TTipo.Text == "3")
            {
                query["cnoId"] = DCausa4.SelectedValue;
                qprogramacion["perId"] = "0";
            }
            else if (TTipo.Text == "4")
            {
                query["cnoId"] = DCausa5.SelectedValue;
                query["actId"] = DNuevoServicio.SelectedValue;
                qprogramacion["actId"] = DNuevoServicio.SelectedValue;
            }

            if (HId.Value.Length > 0)
            {
                if (conector.QueryMod(query.GetUpdate("novIden=" + HId.Value)) == -1)
                    return;
            }
            else
            {
                int res = conector.QueryMod(query.GetInsert(), true);
                if (res == -1)
                    return;
                HId.Value = res.ToString();
            }
            // no se actualizo nada
            string szQueryProgramacion=qprogramacion.GetUpdate("prgId=" + programacion[i]);
            if(szQueryProgramacion.Length>0)
                if (conector.QueryMod(szQueryProgramacion)==-1)
                    return;
            HId.Value = "";
        }
        TObservaciones.Text = "";
        HId.Value = "";
        HIdProgramacion.Value = "";
        HIdProgramaciones.Value = "";
        DProfesional.SelectedIndex = -1;
        Visible = false;
        EventHandler handler = (EventHandler)base.Events[_AceptarClicked];
        if (handler != null)
        {
            handler(this, e);
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Visible = false;
        HId.Value = "";
        TObservaciones.Text = "";
        DProfesional.SelectedIndex = -1;
        HIdProgramacion.Value = "";
        HIdProgramaciones.Value = "";
        EventHandler handler = (EventHandler)base.Events[_CancelarClicked];
        if (handler != null)
        {
            handler(this, e);
        }
    }
    protected void GNovedades_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if(e.Row.RowIndex>-1) {
            string nombre=e.Row.Cells[1].Text;
            if(nombre=="1") {
                nombre="Cancelación Programación";
            }
            else if (nombre == "2")
            {
                nombre = "Reasignación";
            }
            else if (nombre == "4")
            {
                nombre = "Cambio en num. sesiones";
            }
            else if (nombre == "5")
            {
                nombre = "Paciente desprotegido";
            }
            else if (nombre == "6")
            {
                nombre = "Cambio Servicio";
            }
            else 
            {
                nombre = "Otro";
            }
            e.Row.Cells[1].Text = nombre;
        }
    }
    protected void DProfesional_DataBinding(object sender, EventArgs e)
    {
        
    }
}
