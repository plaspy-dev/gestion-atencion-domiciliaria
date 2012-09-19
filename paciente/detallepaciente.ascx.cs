using System;
using System.Collections.Generic;
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
    public string Documento { get; set; }
    public string Nombres { 
        get { return ViewState["phd_detallepaciente_nombres"]==null ? "" : ViewState["phd_detallepaciente_nombres"].ToString(); }
        set { ViewState["phd_detallepaciente_nombres"] = value; }
    }
    public bool Activo {
        get { return (bool)ViewState["phd_detallepaciente_activo"]; }
        set { ViewState["phd_detallepaciente_activo"] = value;  }
    }
    public string AsegurdadorID {
        get {
            return ViewState["paciente_asegurador"].ToString();
        }
    }
    public double TopeAsegurador
    {
        get {
            return (double)ViewState["paciente_asegurador_tope"];
        }
    }
    public double TopePaciente {
        get {
            return (double)ViewState["paciente_asegurador_tope_paciente"];
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

    public string IdPaciente {
        get {
            return HIdPaciente.Value;
        }
        set {

            HIdPaciente.Value = "";
            ViewState["paciente_asegurador"] = "";
            ViewState["paciente_asegurador_tope_paciente"] = (double)0;
            ViewState["paciente_asegurador_tope"] = (double)0;
            ViewState["paciente_costo_paciente_actual"] = null;
            ViewState["paciente_costo_aseguradora_actual"] = null;
            if (value==null || value.Length == 0)
                return;

            Query query = new Query("phdPaciente");

            query["pacId"] = "phdPaciente.pacId";
            query["tdocId"] = "phdPaciente.tdocId";
            query["pacDocumento"] = "phdPaciente.pacDocumento";
            query["pacPApellido"] = "phdPaciente.pacPApellido";
            query["pacSApellido"] = "phdPaciente.pacSApellido";
            query["pacPNombre"] = "phdPaciente.pacPNombre";
            query["pacSNombre"] = "phdPaciente.pacSNombre";
            query["sexoId"] = "phdPaciente.sexoId";
            query["pacFechaNac"] = "phdPaciente.pacFechaNac";
            query["pacDireccion"] = "phdPaciente.pacDireccion";
            query["pacTelefono"] = "phdPaciente.pacTelefono";
            query["pacCelular"] = "phdPaciente.pacCelular";
            query["pacCarne"] = "phdPaciente.pacCarne";
            query["pacBarrio"] = "phdPaciente.pacBarrio";
            query["pacFamilarResponsable"] = "phdPaciente.pacFamilarResponsable";
            query["pacParentesco"] = "phdPaciente.pacParentesco";
            query["cieCodDx"] = "phdPaciente.cieCodDx";
            query["cieCodDx_1"] = "phdPaciente.cieCodDx_1";
            query["cieCodDx_2"] = "phdPaciente.cieCodDx_2";
            query["entidad"] = "admEntidad.entNombre";
            query["tipopago"] = "phdPagoDirecto.pdirDescripcion";
            query["estId"] = "phdPaciente.estId";
            query["entId"] = "phdPaciente.entId";
            query["maximo_paciente"] = "admEntidad.maximo_paciente";
            query["maximo_mensual"] = "admEntidad.maximo_mensual";

            CConectorMS conector = new CConectorMS();

            SqlDataReader reader = conector.Query(query.GetSelect("phdPaciente.pacId=" + Query.GetValor(value) + "",
                "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)" +
                " LEFT JOIN phdPagoDirecto ON (phdPagoDirecto.pdirId=phdPaciente.pdirId)"));

            if (reader != null && reader.Read())
            {
                HIdPaciente.Value = UCAutorizaciones.Value = reader["pacId"].ToString();

                ViewState["paciente_asegurador"]= reader["entId"].ToString();
                Documento= reader["pacDocumento"].ToString();
                Nombres = reader["pacPApellido"].ToString() +
                    " " + reader["pacSApellido"].ToString() +
                    " " + reader["pacPNombre"].ToString() +
                    " " + reader["pacSNombre"].ToString();
                Activo= reader["estId"].ToString() == "1";
                if (!Activo)
                    Nombres += " (Inactivo)";
                LFechaNacimiento.Text = ConectorMS.GetDate(reader["pacFechaNac"]) + " ";
                if (reader["pacFechaNac"] != null && reader["pacFechaNac"].ToString().Length != 0)
                {
                    DateTime birthDate = (DateTime)reader["pacFechaNac"];
                    DateTime now = DateTime.Now;
                    int years = now.Year - birthDate.Year;

                    if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                        --years;

                    LEdad.Text = years + " años";
                }
                LSexo.Text = reader["sexoId"].ToString() == "1" ? "F" : "M";
                LAsegurador.Text = reader["entidad"].ToString();
                LCarnet.Text = reader["pacCarne"].ToString();
                LDireccion.Text = reader["pacDireccion"].ToString();
                LBarrio.Text = reader["pacBarrio"].ToString();
                LTelefono.Text = reader["pacTelefono"].ToString();
                LMovil.Text = reader["pacCelular"].ToString();
                LTipoPago.Text = reader["tipopago"].ToString();
                // SELECT eEstId codigo,eEstDesc descripcion FROM dbo.admEstadoEstancia
                // LEstancia.Text = reader[""].ToString();
                LFamiliar.Text = reader["pacFamilarResponsable"].ToString();
                LParentesco.Text = reader["pacParentesco"].ToString();
                double paciente=reader["maximo_paciente"].ToString()=="" ? 0 : Convert.ToDouble(reader["maximo_paciente"].ToString());
                double asegurador = reader["maximo_mensual"].ToString() == "" ? 0 : Convert.ToDouble(reader["maximo_mensual"].ToString());
                ViewState["paciente_asegurador_tope_paciente"] = paciente;
                ViewState["paciente_asegurador_tope"] = asegurador;

                string cie1 = reader["cieCodDx"].ToString();
                string cie2 = reader["cieCodDx_1"].ToString();
                string cie3 = reader["cieCodDx_2"].ToString();
                cie1 = Procedimientos.GetCodigoCIE(cie1, conector);
                cie2 = Procedimientos.GetCodigoCIE(cie2, conector);
                cie3 = Procedimientos.GetCodigoCIE(cie3, conector);
                LCIE10.Text += cie1;
                if (cie2.Length > 0 && LCIE10.Text.Length > 0)
                    LCIE10.Text += "<br/>";
                LCIE10.Text += cie2;
                if (cie3.Length > 0 && LCIE10.Text.Length > 0)
                    LCIE10.Text += "<br/>";
                LCIE10.Text += cie3;

                /*CConector conectormysql = new CConector();
                MySqlDataReader readermysql = conectormysql.Query("SELECT codigo FROM ingreso_paciente LEFT JOIN codigos_ingreso ON (codigos_ingreso.ingreso_paciente=ingreso_paciente.id) WHERE paciente="+ HIdPaciente.Value);
                if(readermysql!=null) {
                    bool primero=true;
                    while (readermysql.Read())
                    {
                        if(primero) {
                            LCIE10.Text = "";
                            primero = false;
                        }
                        if (LCIE10.Text.Length > 0)
                            LCIE10.Text += "<br/>";
                        LCIE10.Text += GetCodigoCIE(readermysql["codigo"].ToString(), conector);
                    }
                }*/
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if(ViewState["paciente_asegurador"]==null) {
                ViewState["paciente_asegurador"] = "";
                ViewState["paciente_asegurador_tope_paciente"] = (double)0;
                ViewState["paciente_asegurador_tope"] = (double)0;
            }
        }
    }
}
