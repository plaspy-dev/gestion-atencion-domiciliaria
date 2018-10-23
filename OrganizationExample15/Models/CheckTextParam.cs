using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OrganizationExample15.Models.Administrador;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models
{
    public class CheckTextParam : ProtectedField
    {
        public uint? Id { get; set; }
        public bool Check { get; set; }
        public string Name {
            get {
                if (Id==null)
                    return null;
                return MVarios.GetItem(Id.ToString()).Nombre;
            }
        }

        [RequiredIf("Required", ErrorMessage = "Por favor ingrese un texto")]
        public string Text { get; set; }

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
    }
}