using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using SDG.Componentes;

/// <summary>
/// Descripción breve de servicios
/// </summary>
[WebService(Namespace = "https://org-15.example.test/")]
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

    [WebMethod(EnableSession = true)]
    public List<CJSon> GetTercero(String q, int tipo)
    {
        List<CJSon> lista = new List<CJSon>();
        CConector conector = new CConector();

        string szTipo = "(0,1,2)";
        switch (tipo)
        {
            case 1:
                szTipo = "(0,2)";
                break;
            case 0:
                szTipo = "(1,2)";
                break;
        }
        string query = "SELECT id,IF(identificacion IS NULL,nombre, CONCAT(identificacion,'-',nombre)) AS nombre FROM tercero WHERE estado IS NULL AND tipo IN " + szTipo;
        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        for (int i = 0; i < split.Length; i++)
        {
            if (split[i].Length > 0)
            { // verificamos que no este vacio
                query += String.Format(" AND (identificacion LIKE '%{0}%' OR nombre LIKE '%{0}%' OR descripcion LIKE '%{0}%') ", split[i]);
            }
        }
        query += " ORDER BY nombre LIMIT 50;";
        MySqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            while (reader.Read())
            {
                CJSon info = new CJSon(reader["nombre"].ToString(), reader["id"].ToString());
                lista.Add(info);
            }
            reader.Close();
        }
        return lista;
    }


    [WebMethod]
    public List<CJSon> GetAutorizaciones(String q)
    {
        List<CJSon> lista = new List<CJSon>();

        CConectorMS conector = new CConectorMS();

        string query = "SELECT TOP 100 phdAutorizacion.autNumero,phdAutorizacion.autFecha,phdPaciente.pacNombres"
                + " FROM phdAutorizacion"
                + " LEFT JOIN phdPaciente ON (phdAutorizacion.pacId=phdPaciente.pacId)"
                + " WHERE phdAutorizacion.autNumero LIKE '%" + q.ToString()+ "%'"
                + " ORDER BY phdAutorizacion.autFecha DESC";
        SqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            while (reader.Read())
            {
                string valor = ((DateTime)reader["autFecha"]).ToShortDateString() + " - " + reader["autNumero"].ToString() + " - " + reader["pacNombres"].ToString();
                lista.Add(new CJSon(reader["autNumero"].ToString(), valor));
            }
            reader.Close();
        }
        return lista;
    }

    [WebMethod]
    public List<CJSon> GetPacienteI(String q, string e)
    {
        List<CJSon> lista = new List<CJSon>();

        CConectorMS conector = new CConectorMS();
        
        string query = "SELECT TOP 100 pacId id,pacDocumento AS documento, pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '') AS nombres,EstId AS estado FROM phdPaciente WHERE ";
        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        // solo permitimos busquedas para los usuarios configurados
        if(!string.IsNullOrEmpty(e)) 
            query += " entId IN (" + e + ") AND ( ";

        if (split.Length == 1)
        { // solo un dato puede ser un documento
            query += "pacDocumento LIKE '%" + q.Trim() + "%' OR ";
        }
        query += "(";

        for(int i=0; i<split.Length; i++) {

            if(split[i].Length>0) { // verificamos que no este vacio

                if (i > 0)
                    query += " AND ";
                query += String.Format(" (pacPNombre LIKE '%{0}%' OR pacSNombre LIKE '%{0}%' OR pacPapellido LIKE '%{0}%' OR pacSApellido LIKE '%{0}%') ", split[i]);
            }
        }
        if (!string.IsNullOrEmpty(e))
            query += ")";
        query += ") ORDER BY EstId,nombres";
        SqlDataReader reader = conector.Query(query);
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
    public List<CJSon> GetPaciente(String q, string e)
    {
        List<CJSon> lista = new List<CJSon>();

        string query = "SELECT TOP 100 pacId id,pacDocumento AS documento, pacPNombre + ' ' + isnull(pacSNombre,'') + ' ' + pacPapellido + ' ' + isnull(pacSApellido, '') AS nombres FROM phdPaciente WHERE EstId!=2";
        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        if (!string.IsNullOrEmpty(e))
            query += " AND entId IN (" + e + ")";

        query+=" AND (";

        if (split.Length == 1)
        { // solo un dato puede ser un documento
            query += "pacDocumento LIKE '%" + q.Trim() + "%' OR ";
        }
        query += "(";

        for (int i = 0; i < split.Length; i++)
        {

            if (split[i].Length > 0)
            { // verificamos que no este vacio

                if (i > 0)
                    query += " AND ";
                query += String.Format(" (pacPNombre LIKE '%{0}%' OR pacSNombre LIKE '%{0}%' OR pacPapellido LIKE '%{0}%' OR pacSApellido LIKE '%{0}%') ", split[i]);
            }
        }

        query+=")) ORDER BY nombres";

        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query(query);
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
    public List<CJSon> GetPersonal(String q) {
        return GetPersonalC(q, null, null);
    }

    [WebMethod]
    // [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<CJSon> GetPersonalC(String q, String c, String s)
    {
        List<CJSon> lista = new List<CJSon>();
        CConectorMS conector = new CConectorMS();

        string query = "SELECT TOP 100 perId AS id,perDocumento AS documento, perNombre AS nombres FROM admPersonalHS WHERE ";
        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        if (s != null)
        {
            if (s.Length == 0)
                return lista;
            CConector conectormy = new CConector();
            c = conectormy.QueryString("SELECT GROUP_CONCAT(area) FROM medicamento_area WHERE medicamento=" + Query.GetValor(s.Trim()));
        }

      if (c != null) {
            if (c.Length == 0)
                return lista;
            query += "carId IN (" + c.Trim() + ") AND ( ";
        }
        
        if (split.Length == 1)
        { // solo un dato puede ser un documento
            query += "perDocumento LIKE '%" + q.Trim() + "%' OR ";
        }
        query += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (split[i].Length > 0)
            { // verificamos que no este vacio
                if (i > 0)
                    query += " AND ";
                query += String.Format(" perNombre LIKE '%{0}%' ", split[i]);
            }
        }
        if (c != null)
            query += ")";
        query += ") ORDER BY perNombre";

        SqlDataReader reader = conector.Query(query);
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
        string query = "SELECT TOP 100 cieCodDx,[cieCodDx]+' - '+ [cirDescripcion] AS descripcion FROM phdCIE10 WHERE ";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        if (split.Length == 1)
        { // solo un dato puede ser un documento
            query += "cieCodDx LIKE '" + q.Trim() + "%' OR ";
        }
        query += "(";

        for (int i = 0; i < split.Length; i++)
        {
            if (split[i].Length > 0)
            { // verificamos que no este vacio
                if (i > 0)
                    query += " AND ";
                query += String.Format("cieCodDx LIKE '{0}%' OR cirDescripcion LIKE '%{0}%'", split[i]);
            }
        }

        query += ") ORDER BY cieCodDx;";

        SqlDataReader reader = conector.Query(query);
        if(reader!=null) {
            while(reader.Read()) {
                dDiagnosticos.Add(new CDiagnosticos(reader["cieCodDx"].ToString(), reader["descripcion"].ToString()));
            }
            reader.Close();
        }
        return dDiagnosticos;
    }

    [WebMethod]
    // [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public List<CJSon> GetMedicamentos(String q, String t)
    {
        List<CJSon> lista = new List<CJSon>();

        CConector conector = new CConector();
        String query = "SELECT id,nombre,principio,concentracion,forma,codigo FROM medicamentos WHERE tipo=" + Query.GetValor(t) +" AND estado IS NULL AND ";

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        for (int i = 0; i < split.Length; i++)
        {
            if (split[i].Length > 0)
            { // verificamos que no este vacio
                if (i > 0)
                    query += " AND ";
                query += String.Format(" (nombre LIKE '%{0}%' OR principio LIKE '%{0}%' OR concentracion LIKE '%{0}%' OR forma LIKE '%{0}%' OR codigo LIKE '%{0}%') ", split[i]);
            }
        }

        query += " ORDER BY nombre,codigo,principio,concentracion LIMIT 100";
        MySqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            string nombre="";
            while (reader.Read())
            {
                // PARACETAMOL [ACETAMINOFÉN], 100 mg/mL (10%) - SOLUCIÓN ORAL
                nombre = reader["codigo"].ToString() + " - ";
                nombre += reader["nombre"].ToString();
                if (reader["principio"].ToString().Length!=0)
                    nombre += " [" + reader["principio"].ToString() + "]";
                if (reader["concentracion"].ToString().Length!=0)
                    nombre += ", " + reader["concentracion"].ToString();
                if(reader["forma"].ToString().Length!=0)
                    nombre += "-" + reader["forma"].ToString();
                lista.Add(new CJSon(reader["id"].ToString(), nombre));
            }
            reader.Close();
        }
        return lista;
    }



    [WebMethod(EnableSession = true)]
    public List<Producto> GetProducto(String q)
    {
        List<Producto> lista = new List<Producto>();
        CConector conector = new CConector();

        string query = "SELECT id FROM producto WHERE estado IS NULL";
        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        for (int i = 0; i < split.Length; i++)
        {
            if (split[i].Length > 0)
            { // verificamos que no este vacio
                query += String.Format(" AND (codigo LIKE '%{0}%' OR descripcion LIKE '%{0}%' OR nombre LIKE '%{0}%' OR empresa LIKE '%{0}%') ", split[i]);
            }
        }
        query += " ORDER BY nombre LIMIT 50;";
        MySqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            while (reader.Read())
            {
                Producto info = new Producto(reader["id"].ToString());
                lista.Add(info);
            }
            reader.Close();
        }
        return lista;
    }

    [WebMethod(EnableSession = true)]
    public List<Producto> GetProductoDisponible(String almacen, bool auto, String q, String productos)
    {
        List<Producto> lista = new List<Producto>();
        CConector conector = new CConector();

        string query;
        if (auto)
            query = String.Format("SELECT estado{0}.producto,SUM(estado{0}.cantidad) AS cantidad FROM estado{0} LEFT JOIN producto ON (producto.id=estado{0}.producto) WHERE estado{0}.cantidad>0 ", almacen);
        else query = String.Format("SELECT estado{0}.producto,SUM(estado{0}.cantidad) AS cantidad,estado{0}.lote,IF(estado{0}.vence='0000-00-00',NULL,estado{0}.vence) AS vence,estado{0}.estado,estado{0}.szSerial FROM estado{0} LEFT JOIN producto ON (producto.id=estado{0}.producto) WHERE estado{0}.cantidad>0 ", almacen);

        string[] split = q.Trim().Split(new Char[] { ' ', '\0' });

        for (int i = 0; i < split.Length; i++)
        {
            if (split[i].Length > 0)
            { // verificamos que no este vacio
                query += " AND ";
                query += String.Format(" (codigo LIKE '%{0}%' OR descripcion LIKE '%{0}%' OR producto.nombre LIKE '%{0}%' OR producto.empresa LIKE '%{0}%') ", split[i]);
            }
        }
        if (auto)
            query += String.Format(" GROUP BY estado{0}.producto", almacen);
        else query += String.Format(" GROUP BY estado{0}.producto,estado{0}.lote,estado{0}.vence,estado{0}.estado,estado{0}.szSerial", almacen);
        query += " ORDER BY producto.nombre LIMIT 50;";
        MySqlDataReader reader = conector.Query(query);
        if (reader != null)
        {
            ProductoUsado productousado = new ProductoUsado(productos);
            while (reader.Read())
            {
                Decimal cantidad = Convert.ToDecimal(reader["cantidad"]);
                Producto info = new Producto(reader["producto"].ToString());
                if (auto)
                {
                    cantidad -= productousado.GetProductoUsado(info.id);
                }
                else
                {
                    info.lote = reader["lote"].ToString();
                    info.vence = CConector.GetFromMySQLDate(reader["vence"]);
                    info.serial = reader["szSerial"].ToString();
                    info.estado = Convert.ToInt32(reader["estado"]);
                    cantidad -= productousado.GetProductoUsado(info.id, info.lote, info.vence);
                }
                if (cantidad > 0.0000001m)
                {
                    info.cantidad = cantidad;
                    lista.Add(info);
                }
            }
            reader.Close();
        }
        return lista;
    }
}

