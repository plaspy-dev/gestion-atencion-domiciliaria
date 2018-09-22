using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models
{
    public class MPaciente
    {
        public string Id { get; set; }
        public string Nombre {
            get {
                if (string.IsNullOrEmpty(Id))
                    return null;
                return Paciente.GetPaciente(Id).DocumentoYNombres;
            }
        }
    }
}