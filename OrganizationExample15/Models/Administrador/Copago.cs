using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models.Administrador
{
    public class Copago : MVarios
    {
        public MVarios _Valores { get; set; }
        public MVarios Valores {
            get {
                if (_Valores == null)
                {
                    _Valores = MVarios.GetList(Tipo.CopagoCategoriaEPS).Find(x=>x.parametro1?.ToString()==Id);
                }
                return _Valores;
            }
            set {
                _Valores = value;
            }
        }
    }
}