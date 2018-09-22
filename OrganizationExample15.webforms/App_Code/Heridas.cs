using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;
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

    /*
    Funciones par ala pagina web
    */

    public static string GetTemporalPath(string pacienteId, string id, bool create, string tipo)
    {
        string archivo = Path.Combine(HomeCareVersion.FilesPath, tipo=="e" ? "evolucion" : "valoracion");
        if (create)
            Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, "temp");
        if (create)
            Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, pacienteId);
        if (create)
            Directory.CreateDirectory(archivo);
        archivo = Path.Combine(archivo, id);
        if (create)
            Directory.CreateDirectory(archivo);

        return archivo;
    }

    public static string GetFinalPath(string id, string idHerida, bool create, string tipo)
    {
        string archivo = Path.Combine(HomeCareVersion.FilesPath, tipo == "e" ? "evolucion" : "valoracion");
        if (string.IsNullOrEmpty(id))
        {
            archivo = Path.Combine(Path.GetTempPath(), tipo == "e" ? "evolucion" : "valoracion");
            if (create)
                Directory.CreateDirectory(archivo);
        }
        else
        {
            if (create)
                Directory.CreateDirectory(archivo);
            archivo = Path.Combine(archivo, id);
            if (create)
                Directory.CreateDirectory(archivo);
            archivo = Path.Combine(archivo, idHerida);
            if (create)
                Directory.CreateDirectory(archivo);
        }
        return archivo;
    }

    public static List<Heridas.Fotos> RebuildGalery(string pacienteId, string evolucionid, string heridaId, string tipo, DataList datalist=null)
    {
        List<Heridas.Fotos> fotos = new List<Heridas.Fotos>();
        if (string.IsNullOrEmpty(heridaId))
            heridaId = "-1";
        try
        {
            foreach (string archivo in Directory.GetFiles(GetTemporalPath(pacienteId, heridaId, false, tipo)))
            {
                Heridas.Fotos info = new Heridas.Fotos();
                info.Archivo = Path.GetFileName(archivo);
                info.Temporal = true;
                info.Id = heridaId;
                fotos.Add(info);
            }
        }
        catch { }
        try
        {
            foreach (string archivo in Directory.GetFiles(GetFinalPath(evolucionid, heridaId, false, tipo)))
            {
                Heridas.Fotos info = new Heridas.Fotos();
                info.Archivo = Path.GetFileName(archivo);
                info.Temporal = false;
                info.Id = heridaId;
                fotos.Add(info);
            }
        } catch { }
        if(datalist!= null)
        {
            datalist.DataSource = fotos;
            datalist.DataBind();
        }
        return fotos;
    }

    public static string ImprimirFotos(string pacienteId, string evolucionid, string heridaId, string tipo)
    {
        string resultado = "<table>";
        List<Heridas.Fotos> fotos = RebuildGalery(pacienteId, evolucionid, heridaId, tipo);
        if (fotos.Count == 0)
            return "No se encontro registro fotográfico.";
        for (int i = 0; i < fotos.Count; i += 3)
        {
            resultado += "<tr>";
            for (int j = i; j < i + 3 && j < fotos.Count; j++)
            {
                resultado += "<td>";
                resultado += string.Format("<img border=0 src='{5}{6}?t={7}&p={0}&i={1}&n={2}&hi={4}&d={3}&w=150&h=150'/>",
                                    pacienteId, evolucionid, fotos[j].Archivo, fotos[j].Temporal, fotos[j].Id
                                    , ConfigurationManager.AppSettings["servidor"], VirtualPathUtility.ToAbsolute("~/archivo/imagen.ashx")
                                    , tipo
                                    );
                resultado += "</td>";
            }
            resultado += "</tr>";
        }
        resultado += "</table>";
        return resultado;
    }

    public static StringBuilderEx RemoveSection(bool visible, string control, StringBuilderEx Contenido, string replaceString = "")
    {
        if (!visible)
        {
            Regex regx = new Regex(string.Format(".*<!--.*{0}.*-->(?<content>.*)<!--.*{0}End.*-->.*", control)
                , RegexOptions.IgnoreCase | RegexOptions.Singleline);
            Match match = regx.Match(Contenido.ToString());
            if (match.Success)
            {
                Contenido = Contenido.Replace(match.Groups["content"].Value, replaceString);
            }
        }
        return Contenido;
    }

    public static StringBuilderEx GetSection(string control, StringBuilder Contenido)
    {

        Regex regx = new Regex(string.Format(".*<!--.*{0}.*-->(?<content>.*)<!--.*{0}End.*-->.*", control)
                , RegexOptions.IgnoreCase | RegexOptions.Singleline);
        Match match = regx.Match(Contenido.ToString());
        if (match.Success)
        {
            return match.Groups["content"].Value;
        }
        return null;
    }
}
