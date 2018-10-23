using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models.Shared
{
    public class BootGridColumn {
        public enum Aligns {
            right,
            left
        }
        public enum Order {
            asc,
            desc
        }

        public string Titulo { get; set; }
        public string Data { get; set; }
        public string CssClass { get; set; }
        public string HeaderCssClass { get; set; }
        public Order? DataOrder { get; set; }
        public string Formatter { get; set; }
        public Aligns? Align { get; set; }
        public BootGridColumn() { }
        public BootGridColumn(string titulo, string data) {
            Titulo = titulo;
            Data = data;
        }
    }
    public class Historial
    {
        public string Titulo { get; set; }
        public int Numero { get; set; }
        public string URLQuery { get; set; }
        public string URLLink { get; set; }
        public List<BootGridColumn> Columns { get; set; } = new List<BootGridColumn>();
        public Dictionary<string, string> QueryParams { get; set; } = new Dictionary<string, string>();

        public Historial() { }
        public Historial(int numero, string titulo, string urlquery, string urllink) {
            Titulo = titulo;
            Numero = numero;
            URLQuery = urlquery;
            URLLink = urllink;
        }
    }
}