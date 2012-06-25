using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using SDG.Componentes;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Descripción breve de Archivos
/// </summary>
public class Archivos
{
    protected byte[] _contenido=null;
    public string Nombre { get; set; }
    public string Tipo { get; set; }
    public int Id { get; set;}
    public DateTime Fecha { get; set; }
    public string RealId { get; set; }
    public string QueryFile { get; set; }
    public byte[] Contenido {
        get {
            if (_contenido==null && QueryFile.Length>0 && RealId.Length>0) {

                CConectorMS conector = new CConectorMS();

                SqlConnection connection = new SqlConnection(conector.GetConnectionString());
                connection.Open();
                SqlCommand command = new SqlCommand(String.Format(QueryFile, RealId), connection);
                _contenido = (byte[])command.ExecuteScalar();
            }
            return _contenido;
        }
    }

    public Archivos(byte[] archivo, int id) {
        
        Nombre = "Foto";
        Tipo = "image/jpeg";
        Id = id;

        _contenido = archivo;

        Fecha = DateTime.Now;
        RealId = "";
        QueryFile = "";
    }

	public Archivos(HttpPostedFile archivo, int id)
	{
        Nombre = archivo.FileName;
        Tipo= archivo.ContentType;
        Id = id;

        _contenido = new byte[archivo.ContentLength];
        archivo.InputStream.Read(_contenido, 0, archivo.ContentLength);

        Fecha = DateTime.Now;
        RealId = "";
        QueryFile = "";
	}

    public Archivos(string query, string queryfile)
    {
        CConectorMS conector = new CConectorMS();
        SqlDataReader reader = conector.Query(query);
        if (reader != null && reader.Read())
        {
            Id = 0;

            Nombre = reader["nombre"].ToString();
            RealId = reader["id"].ToString();
            Tipo = reader["tipo"].ToString();
            Fecha = DateTime.Now;
            QueryFile = queryfile;
        }
    }

    protected Archivos(string id, string nombre, string tipo, DateTime fecha, string queryfile) {

        Id = 0;

        Nombre = nombre;
        RealId = id;
        Tipo = tipo;
        Fecha = fecha;
        QueryFile = queryfile;
    }

    public void ShowFile(HttpResponse Response) {

        Response.Clear();
        Response.AddHeader("Content-Disposition", "attachment;filename=" + Nombre);
        Response.ContentType = Tipo;
        Response.BinaryWrite(Contenido);
        Response.End();
    }

    public bool SaveFile(Query query)
    {
        if (Contenido != null && Contenido.Length > 0)
        {
            query["nombre"] = Nombre;
            query["tipo"] = Tipo;
            query.AddCampo("archivo", "@archivo", false);

            CConectorMS conector = new CConectorMS();

            SqlConnection connection = new SqlConnection(conector.GetConnectionString());
            connection.Open();
            string szQuery = Id==0 ? query.GetInsert() : query.GetUpdate(string.Format(HttpContext.Current.Session["foto_id"].ToString() + "={0}", Id));
            SqlCommand cmd = new SqlCommand(szQuery, connection);
            cmd.Parameters.Add("@archivo", SqlDbType.VarBinary, _contenido.Length);
            cmd.Parameters["@archivo"].Value = _contenido;
            cmd.ExecuteNonQuery();
            cmd.Dispose();
            connection.Close();
            RealId = "1"; // se marca para no volver a guardarlo.
            return true;
        }
        return false;
    }

    static public int SaveArchivos(Query query, ArrayList archivos)
    {
        int resultado = 0;
        
        query["fecha"] = "SYSDATE()"; // agregamos los dos campos para todos

        for (int i = 0; i < archivos.Count; i++)
        {
            Archivos info = (Archivos)archivos[i];
            if(info.RealId.Length==0) {

                if(info.SaveFile(query))
                    resultado++;
            }
        }
        return resultado;
    }

    static public ArrayList GetArchivos( string query, string queryfile) {

        ArrayList archivos = new ArrayList();
        CConectorMS conector = new CConectorMS();
        SqlDataReader reader= conector.Query(query);
        if(reader!=null) {
            while(reader.Read()) {

                Archivos info = new Archivos(reader["id"].ToString(),
                                    reader["nombre"].ToString(),
                                    reader["tipo"].ToString(),
                                    (DateTime)reader["fecha"],
                                    queryfile);
                info.Id = archivos.Count;
                archivos.Add(info);
            }
        }
        return archivos;
    }
}
