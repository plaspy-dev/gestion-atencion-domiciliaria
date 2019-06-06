using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models
{
    public class MFuncionarioSimple : ProtectedField
    {
        protected string _Nombre { get; set; }
        [JsonIgnore]
        public bool ReadOnly { get; set; }
        [RequiredIf("Required", ErrorMessage ="Por favor seleccione un funcionario")]
        public string Id { get; set; }
        [RequiredIf("Required", ErrorMessage = "Por favor ingrese un funcionario")]
        public string Nombre {
            get {
                if (string.IsNullOrEmpty(Id))
                    return null;
                if (string.IsNullOrEmpty(_Nombre))
                    _Nombre = Funcionario.GetFuncionario(Id).DocumentoYNombres;
                return _Nombre;
            }
            set {
                _Nombre = value;
            }
        }
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