using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using SDG.Componentes.Validator;

namespace OrganizationExample15.Models.terapeutico
{
    public class Documentos : ProtectedField
    {
        public MFuncionarioSimple Funcionario { get; set; } = new MFuncionarioSimple();

        [Required(ErrorMessage = "Por favor inserte una firma")]
        [MultipleFileExtensions("jpg,jpeg", ErrorMessage ="Por favor seleccione una imagen JPG valida")]
        [MaxFileSize(FileStorage.MaxFileLengthKB, ErrorMessage ="Por favor seleccione un archivo menor a {0} KB")]
        public HttpPostedFileBase Firma { get; set; }
        [Required(ErrorMessage = "Por favor inserte un sello")]
        [MultipleFileExtensions("jpg,jpeg", ErrorMessage = "Por favor seleccione una imagen JPG valida")]
        [MaxFileSize(FileStorage.MaxFileLengthKB, ErrorMessage = "Por favor seleccione un archivo menor a {0} KB")]
        public HttpPostedFileBase Sello { get; set; }
        [Required(ErrorMessage = "Por favor inserte un RUT")]
        [MultipleFileExtensions("pdf,jpg,jpeg", ErrorMessage = "Por favor seleccione una imagen JPG valida o un archivo PDF")]
        [MaxFileSize(FileStorage.MaxFileLengthKB, ErrorMessage = "Por favor seleccione un archivo menor a {0} KB")]
        public HttpPostedFileBase RUT { get; set; }
    }
}