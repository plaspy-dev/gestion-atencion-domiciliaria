using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using SDG.Componentes;

public partial class phd_detallepaciente : System.Web.UI.UserControl
{
    public string Documento { get; set; }
    public string Nombres { get; set; }

    public string AsegurdadorID {
        get {
            return HIdAsegurador.Value;
        }
    }

    public string IdPaciente {
        get {
            return HIdPaciente.Value;
        }
        set {

            HIdPaciente.Value = "";
            HIdAsegurador.Value = "";
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

            CConectorMS conector = new CConectorMS();

            SqlDataReader reader = conector.Query(query.GetSelect("phdPaciente.pacId=" + Query.GetValor(value) + "",
                "LEFT JOIN admEntidad ON (admEntidad.entId=phdPaciente.entId)" +
                " LEFT JOIN phdPagoDirecto ON (phdPagoDirecto.pdirId=phdPaciente.pdirId)"));

            if (reader != null && reader.Read())
            {
                HIdPaciente.Value = UCAutorizaciones.Value = reader["pacId"].ToString();

                HIdAsegurador.Value = reader["entId"].ToString();
                Documento= reader["pacDocumento"].ToString();
                Nombres = reader["pacPApellido"].ToString() +
                    " " + reader["pacSApellido"].ToString() +
                    " " + reader["pacPNombre"].ToString() +
                    " " + reader["pacSNombre"].ToString();
                if (reader["estId"].ToString() == "2")
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

                string cie1 = reader["cieCodDx"].ToString();
                string cie2 = reader["cieCodDx_1"].ToString();
                string cie3 = reader["cieCodDx_2"].ToString();
                cie1 = GetCodigoCIE(cie1, conector);
                cie2 = GetCodigoCIE(cie2, conector);
                cie3 = GetCodigoCIE(cie3, conector);
                LCIE10.Text += cie1;
                if (cie2.Length > 0 && LCIE10.Text.Length > 0)
                    LCIE10.Text += "<br/>";
                LCIE10.Text += cie2;
                if (cie3.Length > 0 && LCIE10.Text.Length > 0)
                    LCIE10.Text += "<br/>";
                LCIE10.Text += cie3;
            }
        }
    }

    static protected string GetCodigoCIE(string text, CConectorMS conector)
    {
        if (text.Length > 0)
        {
            string codigo = conector.QueryString("SELECT [cieCodDx]+' - '+ [cirDescripcion] FROM phdCIE10 WHERE cieCodDx='" + text + "'");
            if (codigo.Length > 0)
                return codigo;
        }
        return text;
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}
