using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models
{
    public class MFuncionario
    {
        public bool ReadOnly { get; set; }
        public string Id { get; set; }
        public string Nombre {
            get {
                if (string.IsNullOrEmpty(Id))
                    return null;
                return Funcionario.GetFuncionario(Id).DocumentoYNombres;
            }
        }
    }
}