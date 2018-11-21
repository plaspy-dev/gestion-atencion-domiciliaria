using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models
{
    public class LogIn
    {
        [Required(ErrorMessage ="Por favor ingrese un nombre de usuario")]
        public string User { get; set; }
        [Required(ErrorMessage ="Por favor ingrese una contraseña")]
        public string Password { get; set; }
    }
}