using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models
{
    public class MPacienteSimple : ProtectedField
    {
        [RequiredIf("Required", ErrorMessage = "Por favor seleccione un paciente")]
        public string Id { get; set; }
        [RequiredIf("Required", ErrorMessage = "Por favor ingrese un funcionario")]
        public string Nombre {
            get {
                if (string.IsNullOrEmpty(Id))
                    return null;
                return Paciente.GetPaciente(Id).DocumentoYNombres;
            }
        }
        public string Entidades
        {
            get
            {
                return ProtectedFields["e"];
            }
            set
            {
                ProtectedFields["e"] = value;
            }
        }

        public bool Required
        {
            get
            {
                return ProtectedFields["r"] == "1";
            }
            set
            {
                ProtectedFields["r"] = value ? "1" : null;
            }
        }

        public bool ShowLabel {
            get
            {
                return ProtectedFields["l"] == "1";
            }
            set {
                ProtectedFields["l"] = value ? "1" : null;
            }
        }
    }
}