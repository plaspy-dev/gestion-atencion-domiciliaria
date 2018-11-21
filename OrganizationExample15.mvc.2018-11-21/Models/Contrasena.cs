using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models
{
    public class Contrasena
    {
        [Required(ErrorMessage ="Por favor ingrese su contraseña actual")]
        public string CurrentPassword { get; set; }

        [Required(ErrorMessage = "Por favor ingrese una nueva contraseña")]
        [RegularExpression("^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).*$", ErrorMessage ="Por favor ingrese una contraseña valida")]
        public string Password { get; set; }

        [Compare("Password", ErrorMessage ="La confirmación de la nueva contraseña no coincide")]
        [Required(ErrorMessage ="Por favor confirme la contraseña")]
        [DataType(DataType.Password)]
        public string ConfirmPassword { get; set; }
    }
}