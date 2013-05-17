using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Globalization;
using SDG.Componentes;
using MySql.Data.MySqlClient;

public partial class phd_detallepaciente : System.Web.UI.UserControl
{
    public string Nombres {
        get { 
            Paciente paciente= Paciente.GetPaciente(HIdPaciente.Value);
            string nombre = paciente.NombreCompleto;
            if (!paciente.Activo)
                nombre+= " (Inactivo)";
            return nombre;
        }
    }
    public bool Activo {
        get { return Paciente.GetPaciente(HIdPaciente.Value).Activo; }
    }
    public string AsegurdadorID {
        get {
            return Paciente.GetPaciente(HIdPaciente.Value).entidadId;
        }
    }
    public string Documento
    {
        get
        {
            return Paciente.GetPaciente(HIdPaciente.Value).documento;
        }
    }
    public double TopeAsegurador
    {
        get {
            return Convert.ToDouble(Paciente.GetPaciente(HIdPaciente.Value).MaximoEntidad);
        }
    }
    public double TopePaciente {
        get {
            return Convert.ToDouble(Paciente.GetPaciente(HIdPaciente.Value).MaximoPaciente);
        }
    }
    public bool ShowServicios {
        get {
            return tServicios.Visible;
        }
        set {
            tServicios.Visible = UCAutorizaciones.Visible = value;
        }
    }
    public double GetCostoPacienteActual {
        get { 
            double total= 0;
            if (ViewState["paciente_costo_paciente_actual"] == null)
            {
                string sTotal= new CConectorMS().QueryString("SELECT SUM(costo) FROM programacion WHERE pacId=" + IdPaciente + " AND prgFechaProg>GETDATE()-30");
                if (sTotal.Length == 0)
                    total = 0;
                else total = Convert.ToDouble(sTotal);
                // agregamos el valor formulado
                sTotal = new CConector().QueryString("SELECT SUM(medicamento_formulacion.costo*medicamento_formulacion.formulada) FROM formulacion LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id) WHERE formulacion.paciente=" + IdPaciente + " AND fecha>DATE_ADD(DATE(SYSDATE()), INTERVAL -30 DAY);");
                if (sTotal.Length == 0)
                    total = 0;
                else total+= Convert.ToDouble(sTotal);
                ViewState["paciente_costo_paciente_actual"]=total;
            }
            else {
                total = (double)ViewState["paciente_costo_paciente_actual"];
            }
            return total;
        }
        set
        {
            if(value>0)
                ViewState["paciente_costo_paciente_actual"] = value;
            else ViewState["paciente_costo_paciente_actual"] = null;
        }
    }
    public double GetCostoAseguradoraActual
    {
        get
        {
            double total = 0;
            if (ViewState["paciente_costo_aseguradora_actual"] == null)
            {
                string sTotal = new CConectorMS().QueryString("SELECT SUM(costo) FROM programacion WHERE entId='" + AsegurdadorID + "' AND prgFechaProg>GETDATE()-30");
                if (sTotal.Length == 0)
                    total = 0;
                else total = Convert.ToDouble(sTotal);
                // agregamos el valor formulado
                sTotal = new CConector().QueryString("SELECT SUM(medicamento_formulacion.costo*medicamento_formulacion.formulada) FROM formulacion LEFT JOIN medicamento_formulacion ON (medicamento_formulacion.formulacion=formulacion.id) WHERE formulacion.asegurador='" + AsegurdadorID + "' AND fecha>DATE_ADD(DATE(SYSDATE()), INTERVAL -30 DAY);");
                if (sTotal.Length == 0)
                    total = 0;
                else total += Convert.ToDouble(sTotal);
                ViewState["paciente_costo_aseguradora_actual"] = total;
            }
            else
            {
                total = (double)ViewState["paciente_costo_aseguradora_actual"];
            }
            return total;
        }
        set {
            if (value > 0)
                ViewState["paciente_costo_aseguradora_actual"] = value;
            else ViewState["paciente_costo_aseguradora_actual"] = null;
        }
    }

    public string Sexo {
        get {
            return LSexo.Text;
        }
    }
    public int Edad {
        get {
            int edad=-1;
            if(LEdad.Text.Length>0) {
                string []sedad= LEdad.Text.Split(' ');
                if(sedad.Length>0) {
                    try
                    {
                        edad = Convert.ToInt32(sedad[0]);
                    } catch {}
                }
            }
            return edad;
        }
    }

    public string IdPaciente {
        get {
            return HIdPaciente.Value;
        }
        set {

            HIdPaciente.Value = "";

            ViewState["paciente_costo_paciente_actual"] = null;
            ViewState["paciente_costo_aseguradora_actual"] = null;
            if (value==null || value.Length == 0)
                return;

            Paciente paciente = Paciente.GetPaciente(value);

            if (!((CUsuario)Usuario.GetUsuario()).CheckEntidad(paciente.entidadId))
                return;
            UCAutorizaciones.Value = HIdPaciente.Value = value;

            try
            {
                LFechaNacimiento.Text = ConectorMS.GetDate(Convert.ToDateTime(paciente.FechaNac)) + " ";
            } catch {}
            if(paciente.Edad!=-1)
                LEdad.Text = paciente.Edad + " años";
            
            LSexo.Text = paciente.sexoId == "1" ? "F" : "M";
            LAsegurador.Text = paciente.NombreEntidad;
            LCarnet.Text = paciente.Carne;
            LDireccion.Text = paciente.Direccion;
            LBarrio.Text = paciente.Barrio;
            LTelefono.Text = paciente.Telefono;
            LMovil.Text = paciente.Celular;
            LTipoPago.Text = paciente.tipopago;
            LFamiliar.Text = paciente.FamiliarResponsable;
            LParentesco.Text = paciente.parentesco;
            LGrupo.Text = paciente.Grupo;

            for (int i = 0; i < paciente.cie10.Count; i++)
            {
                if (i != 0)
                    LCIE10.Text += "<br/>";
                LCIE10.Text += Procedimientos.GetCodigoCIE(paciente.cie10[i].ToString());
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
    }
}
