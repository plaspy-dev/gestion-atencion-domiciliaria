using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;
using System.Collections;
using MySql.Data.MySqlClient;

[Serializable]
public class Paciente
{
    public string Id { get; set; }
    public string tipodoc { get; set; }
    public string documento { get; set; }
    public string pApellido { get; set; }
    public string sApellido { get; set; }
    public string pNombre { get; set; }
    public string sNombre { get; set; }
    public string sexoId { get; set; }
    public string FechaNac { get; set; }
    public string Direccion { get; set; }
    public string Telefono { get; set; }
    public string Celular { get; set; }
    public string Carne { get; set; }
    public string Barrio { get; set; }
    public string FamiliarResponsable { get; set; }
    public string parentesco { get; set; }
    public string entidadId { get; set; }
    public string NombreEntidad { get { return Entidad.GetEntidad(entidadId).Nombre; } }
    public string estado { get; set; }
    public string tipopago { get; set; }
    public string Grado { get; set; }
    public string Grupo { get; set; }
    public string Categoria { get; set; }
    public DateTime FechaDefuncion { get; set; }
    public string TipoAfiliacion { get; set; }
    public ArrayList cie10 { get; set; }
    public bool Activo { get { return estado == "1"; } }
    public string NombreCompleto { get {
        string Nombres = pApellido +
                " " + sApellido +
                " " + pNombre +
                " " + sNombre;
        return Nombres.Trim();
    } }
    public string tipoDocNombre { get {
        using (CConector conector = new CConector()) {
            return conector.QueryString(string.Format("SELECT tdocDescripcion FROM tipo_documento WHERE tdocId='{0}';", tipodoc));
        }
    } }
    public string DocumentoYNombres { 
        get {
            string resultado= documento + " - " + NombreCompleto;
            if (estado == "2")
                resultado = "Inactivo - " + resultado;
            return resultado==" - " ? "" : resultado;
        }
    }
    public int Edad {
        get {
            if (string.IsNullOrEmpty(FechaNac))
                return -1;
            int edad = -1;
            try {
                DateTime birthDate = Convert.ToDateTime(FechaNac);
                DateTime now = DateTime.Now;
                edad = now.Year - birthDate.Year;

                if (now.Month < birthDate.Month || (now.Month == birthDate.Month && now.Day < birthDate.Day))
                    --edad;

            } catch {}
            return edad;
        }
    }
    public Decimal MaximoPaciente {
        get { return Entidad.GetEntidad(entidadId).MaximoPaciente; }
    }
    public Decimal MaximoEntidad {
        get { return Entidad.GetEntidad(entidadId).MaximoEntidad; }
    }


    public bool IsAlive { 
        get {
            return FechaDefuncion == DateTime.MinValue;
        }
    }
    

    public Paciente()
    {
    }

    public static Paciente GetPaciente(string id) {

        Paciente paciente = (Paciente)HttpRuntime.Cache["p" + id];
        if(paciente==null) {
            paciente = new Paciente();

            Query query = new Query("paciente");

            query["tdocId"] = "paciente.tdocId";
            query["pacDocumento"] = "paciente.pacDocumento";
            query["pacPApellido"] = "paciente.pacPApellido";
            query["pacSApellido"] = "paciente.pacSApellido";
            query["pacPNombre"] = "paciente.pacPNombre";
            query["pacSNombre"] = "paciente.pacSNombre";
            query["sexoId"] = "paciente.sexoId";
            query["pacFechaNac"] = "paciente.pacFechaNac";
            query["pacDireccion"] = "paciente.pacDireccion";
            query["pacTelefono"] = "paciente.pacTelefono";
            query["pacCelular"] = "paciente.pacCelular";
            query["pacCarne"] = "paciente.pacCarne";
            query["pacBarrio"] = "paciente.pacBarrio";
            query["pacFamilarResponsable"] = "paciente.pacFamilarResponsable";
            query["pacParentesco"] = "paciente.pacParentesco";
            query["cieCodDx"] = "paciente.cieCodDx";
            query["cieCodDx_1"] = "paciente.cieCodDx_1";
            query["cieCodDx_2"] = "paciente.cieCodDx_2";
            query["tipopago"] = "paciente_tipo_pago.pdirDescripcion";
            query["estId"] = "paciente.estId";
            query["entId"] = "paciente.entId";
            query["pacGrado"] = "paciente.pacGrado";
            query["categoria"] = "paciente.categoria";
            query["szTipoAfiliacion"] = "CASE pacTipoAfiliado WHEN 1 THEN 'Cotizante' WHEN 2 THEN 'Beneficiario' ELSE '' END";

            using (CConector conector = new CConector())
            {
                MySqlDataReader reader = conector.Query(query.GetSelect("paciente.pacId=" + Query.GetValor(id) + "",
                    " LEFT JOIN paciente_tipo_pago ON (paciente_tipo_pago.pdirId=paciente.pdirId)"));

                if (reader != null && reader.Read())
                {
                    paciente.Id = id;
                    paciente.tipodoc = reader["tdocId"].ToString();
                    paciente.documento = reader["pacDocumento"].ToString();
                    paciente.pApellido = reader["pacPApellido"].ToString();
                    paciente.sApellido = reader["pacSApellido"].ToString();
                    paciente.pNombre = reader["pacPNombre"].ToString();
                    paciente.sNombre = reader["pacSNombre"].ToString();
                    paciente.sexoId = reader["sexoId"].ToString();
                    paciente.FechaNac = reader["pacFechaNac"].ToString();
                    paciente.Direccion = reader["pacDireccion"].ToString();
                    paciente.Telefono = reader["pacTelefono"].ToString();
                    paciente.Celular = reader["pacCelular"].ToString();
                    paciente.Carne = reader["pacCarne"].ToString();
                    paciente.Barrio = reader["pacBarrio"].ToString();
                    paciente.FamiliarResponsable = reader["pacFamilarResponsable"].ToString();
                    paciente.parentesco = reader["pacParentesco"].ToString();
                    paciente.tipopago = reader["tipopago"].ToString();
                    paciente.estado = reader["estId"].ToString();
                    paciente.entidadId = reader["entId"].ToString();
                    paciente.TipoAfiliacion = reader["szTipoAfiliacion"].ToString();
                    paciente.Categoria = reader["categoria"].ToString();
                    paciente.Grado = reader["pacGrado"].ToString();

                    paciente.cie10 = Procedimientos.GetCodigosCIE10(id);

                    if (paciente.cie10.Count == 0)
                    {
                        paciente.cie10 = Procedimientos.AddCIE10(paciente.cie10, reader["cieCodDx"].ToString());
                        paciente.cie10 = Procedimientos.AddCIE10(paciente.cie10, reader["cieCodDx_1"].ToString());
                        paciente.cie10 = Procedimientos.AddCIE10(paciente.cie10, reader["cieCodDx_2"].ToString());
                    }

                    try {
                        paciente.FechaDefuncion = DateTime.MinValue;
                        paciente.FechaDefuncion = Convert.ToDateTime(conector.QueryString("SELECT egrFecha FROM paciente_egreso WHERE pacId=" + paciente.Id + " AND cegId=1 ORDER BY egrFecha DESC LIMIT 1;"));
                    } catch {}

                    paciente.Grupo = conector.QueryString("SELECT "
                                            + " CASE WHEN SUM(autorizacion_detalle.autNumSesiones)<17 THEN 'Grupo 1' "
                                            + " WHEN SUM(autorizacion_detalle.autNumSesiones)<49 THEN 'Grupo 2'"
                                            + " WHEN SUM(autorizacion_detalle.autNumSesiones)<75 THEN 'Grupo 3'"
                                            + " ELSE 'Grupo 4' END"
                                            + " FROM autorizacion_detalle "
                                            + " LEFT JOIN autorizacion ON (autorizacion.autNumero=autorizacion_detalle.autNumero)"
                                            + " WHERE "
                                            + " autorizacion.pacId=" + id
                                            + " AND autorizacion_detalle.actId IN (5028,5029,5030,5031)"
                                            + " GROUP BY autorizacion_detalle.autNumero,autorizacion.autFecha ORDER BY autorizacion.autFecha DESC LIMIT 1;");
                }
            }

            HttpRuntime.Cache.Insert("p" + id, paciente);
        }
        return paciente;
    }
    public static void RemovePaciente(string id) {

        HttpRuntime.Cache.Remove("p" + id);
    }
}
