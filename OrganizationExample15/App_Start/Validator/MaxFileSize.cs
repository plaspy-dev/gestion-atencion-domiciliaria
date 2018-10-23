using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SDG.Componentes.Validator
{
    public class MaxFileSize : ValidationAttribute, IClientValidatable
    {
        protected int FileSize { get; set; }
        public MaxFileSize(int maxFileSizeKB)
        {
            FileSize = maxFileSizeKB*1024;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            HttpPostedFileBase file = value as HttpPostedFileBase;
            if (file == null)
                return ValidationResult.Success;
            return file.ContentLength>FileSize ? new ValidationResult(string.Format(ErrorMessage, FileSize/1024)): ValidationResult.Success;
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            ModelClientValidationRule mvr = new ModelClientValidationRule();
            mvr.ErrorMessage = ErrorMessage;
            mvr.ValidationType = "maxfilesize";
            mvr.ValidationParameters["size"] = FileSize/1024;
            return new[] { mvr };
        }
    }
}