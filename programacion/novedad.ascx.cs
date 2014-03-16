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
        ScriptManager.RegisterStartupScript(this, typeof(string), ClientID, "RegisterStarUpScript('dscriptNovedad');", true);
        BAceptar.Enabled = Usuario.GetUsuario().CanUpdate();
    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdNovedad
    {
        get { return HId.Value; }
        set { HId.Value = value; }
    }

    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public string IdServicio
    {
        get { return HIdServicio.Value; }
        set { HIdServicio.Value = value; }
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
    [Bindable(true), Category("Appearance"), DefaultValue("")]
    public bool Editable {
        set { PEdicion2.Visible= PEdicion.Visible = BAceptar.Visible = value; }
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
        Query query = new Query("programacion_novedad");
        using (CConector conector = new CConector())
        {
            string[] programacion = HIdProgramacion.Value == "" ? HIdProgramaciones.Value.Split(',') : HIdProgramacion.Value.Split(',');

            int tipo = (Convert.ToInt32(TTipo.Text) + 1);
            if (tipo > 2) // no hay tipo 3
                tipo++;
            query["novTipo"] = tipo.ToString();
            query["novObs"] = TObservaciones.Text;
            query["segUsuarioRegistro"] = Usuario.GetUsuario().GetLogin();
            query["segFechaRegistro"] = "SYSDATE()";
            query["novId"] = "2";
            query["prgTipo"] = "1";

            Query qprogramacion = new Query("programacion");

            for (int i = 0; i < programacion.Length; i++)
            {
                query["prgId"] = programacion[i];
                query["perIdAnt"] = conector.QueryString("SELECT perId FROM programacion WHERE prgId=" + programacion[i] + "");

                if (TTipo.Text == "0")
                {
                    query["cnoId"] = DCausa1.SelectedValue;
                    qprogramacion["prgActivo"] = "0";
                }
                else if (TTipo.Text == "1")
                {
                    query["cnoId"] = DCausa2.SelectedValue;
                    if (TProfesionalID.Text.Length == 0)
                        return;
                    qprogramacion["perId"] = TProfesionalID.Text;
                    query["perId"] = TProfesionalID.Text;
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
                    query["actId"] = TProcedimientoID.Text;
                    qprogramacion["actId"] = TProcedimientoID.Text;
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
                string szQueryProgramacion = qprogramacion.GetUpdate("prgId=" + programacion[i]);
                if (szQueryProgramacion.Length > 0)
                    if (conector.QueryMod(szQueryProgramacion) == -1)
                        return;
                HId.Value = "";
            }
            TObservaciones.Text = "";
            HId.Value = "";
            HIdProgramacion.Value = "";
            HIdServicio.Value = "";
            HIdProgramaciones.Value = "";
            TProfesional.Text = "";
            TProfesionalID.Text = "";
            Visible = false;
            EventHandler handler = (EventHandler)base.Events[_AceptarClicked];
            if (handler != null)
            {
                handler(this, e);
            }
        }
    }
    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Visible = false;
        HId.Value = "";
        TObservaciones.Text = "";
        TProfesionalID.Text = "";
        TProfesional.Text = "";
        HIdProgramacion.Value = "";
        HIdServicio.Value = "";
        HIdProgramaciones.Value = "";
        EventHandler handler = (EventHandler)base.Events[_CancelarClicked];
        if (handler != null)
        {
            handler(this, e);
        }
    }
}
