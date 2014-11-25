using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SDG.Componentes
{
    [Serializable]
    public class Miscelaneos
    {
        public String Id { set; get; }
        public String Nombre { set; get; }
        public Miscelaneos(string id, string nombre) {
            Id = id;
            Nombre = nombre;
        }
        public Miscelaneos()
        {
        }
    }
}
