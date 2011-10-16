using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data.SqlClient;

/// <summary>
/// Descripción breve de servicios
/// </summary>
[WebService(Namespace = "http://org-15.example.test/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
[System.Web.Script.Services.ScriptService]
public class servicios : System.Web.Services.WebService
{

    public servicios()
    {
    }

    public class CJSon {

        public String item {set; get;}
        public String value {set; get;}
        public CJSon() {
        }
        public CJSon(String v, String i) {
            item = i;
            value = v;
        }
    }

    public class CDiagnosticos
    {
        String _codigo;
        String _descripcion;
        public CDiagnosticos() {
            _codigo = "";
            _descripcion = "";
        }
        public CDiagnosticos(String codigo, String descripcion)
        {
            _codigo = codigo;
            _descripcion = descripcion;
        }

        public String Value
        {
            get
            {
                return _codigo;
            }
            set {
                _codigo = Value;
            }
        } 
        public String Name
        {
            get
            {
                return _descripcion;
            }
            set {
                _descripcion = value;
            }
        }
    };

    [WebMethod]
    public List<CJSon> GetPacienteI(String q)
    {
        List<CJSon> lista = new List<CJSon>();

        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query("SELECT TOP 100 pacId id,pacDocumento AS documento, pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '') AS nombres,EstId AS estado FROM phdPaciente WHERE pacDocumento LIKE '%" + q + "%' OR (pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '')) LIKE '%" + q + "%' ORDER BY EstId,nombres");
        if (reader != null)
        {
            while (reader.Read())
            {
                string valor= reader["documento"].ToString() + " - " + reader["nombres"].ToString();
                if (reader["estado"].ToString() == "2")
                    valor = "Inactivo - " + valor;
                lista.Add(new CJSon(reader["id"].ToString(), valor));
            }
            reader.Close();
        }
        return lista;
    }
    [WebMethod]
    // [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<CJSon> GetPaciente(String q)
    {
        List<CJSon> lista = new List<CJSon>();

        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query("SELECT TOP 100 pacId id,pacDocumento AS documento, pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '') AS nombres FROM phdPaciente WHERE pacDocumento LIKE '%" + q + "%' OR (pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '')) LIKE '%" + q + "%' ORDER BY nombres");
        if (reader != null)
        {
            while (reader.Read())
            {
                lista.Add(new CJSon(reader["id"].ToString(), reader["documento"].ToString() + " - " + reader["nombres"].ToString()));
            }
            reader.Close();
        }
        return lista;
    }

    [WebMethod]
    // [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<CJSon> GetPersonal(String q)
    {
        List<CJSon> lista = new List<CJSon>();

        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query("SELECT TOP 100 perId AS id,perDocumento AS documento, perNombre AS nombres FROM admPersonalHS WHERE perDocumento LIKE '%" + q + "%' OR perNombre LIKE '%" + q + "%' ORDER BY perNombre");
        if (reader != null)
        {
            while (reader.Read())
            {
                lista.Add(new CJSon(reader["id"].ToString(), reader["documento"].ToString() + " - " + reader["nombres"].ToString()));
            }
            reader.Close();
        }
        return lista;
    }

    [WebMethod]
    // [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<CDiagnosticos> GetCodigoDiagnosticos(String q)
    {
        List<CDiagnosticos> dDiagnosticos = new List<CDiagnosticos>();
        
        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query("SELECT TOP 100 cieCodDx,[cieCodDx]+' - '+ [cirDescripcion] AS descripcion FROM phdCIE10 WHERE cieCodDx LIKE '" + q + "%' OR cirDescripcion LIKE '%" + q + "%' ORDER BY cieCodDx;");
        if(reader!=null) {
            while(reader.Read()) {
                dDiagnosticos.Add(new CDiagnosticos(reader["cieCodDx"].ToString(), reader["descripcion"].ToString()));
            }
            reader.Close();
        }
        return dDiagnosticos;
    }

}

