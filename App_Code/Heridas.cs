using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;

[Serializable]
public class Heridas
{
    public class Fotos
    {
        public string Archivo { get; set; }
        public string Ruta { get; set; }
        public bool Temporal { get; set; }
        public string Id { get; set; }
    };

    public string Nombre { get; set; }
    public string Id { get; set; }
    public string IdTemp { get; set; }
    public string IdTabla { get; set; }
    public Query query { get; set; }
    public bool eliminado { get; set; }
    public bool Existe { get; set; }

    public Heridas(string id, string nombre, string idTabla)
    {
        Existe = true;
        query = new Query("valoracion_herida_herida");
        Nombre = nombre;
        Id = id;
        IdTabla = idTabla;
    }
    public Heridas(string id, string nombre, string idTabla,string nombre_tabla, bool existe)
    {
        Existe = existe;
        query = new Query(nombre_tabla);
        Nombre = nombre;
        Id = id;
        IdTabla = idTabla;
    }
    public Heridas(string id, string nombre)
    {
        Existe = false;
        query = new Query("valoracion_herida_herida");
        Nombre = nombre;
        Id = id;
    }
}
