using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using OrganizationExample15.Models.Administrador;
using Newtonsoft.Json;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models
{
    public class ParameterBase
    {
        public string Id { get; set; }
        [JsonIgnore]
        public string Name
        {
            get
            {
                return MVarios.GetItem(Id).Nombre;
            }
        }
        [JsonIgnore]
        public string Description {
            get
            {
                return MVarios.GetItem(Id).Descripcion;
            }
        }
    }

    public class ParameterCheck : ParameterBase
    {
        public bool Selected { get; set; }
    }

    public class ParameterValueRequired : ParameterBase
    {
        [Required(ErrorMessage ="Por favor seleccione una opción")]
        public string Value { get; set; }
    }

    public class ParameterValueOpcional : ParameterBase
    {
        public string Value { get; set; }
    }

    public class ParameterSelect : ParameterBase
    {
        [Required(ErrorMessage = "Por favor seleccione un estado")]
        public string Selection { get; set; }
    }

    public class CheckTextParam : ProtectedField
    {
        public uint? Id { get; set; }
        public bool Check { get; set; }
        [JsonIgnore]
        public string Name
        {
            get
            {
                if (Id == null)
                    return null;
                return MVarios.GetItem(Id.ToString()).Nombre;
            }
        }

        [RequiredIf("Required", ErrorMessage = "Por favor ingrese un texto")]
        public string Text { get; set; }

        [JsonIgnore]
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