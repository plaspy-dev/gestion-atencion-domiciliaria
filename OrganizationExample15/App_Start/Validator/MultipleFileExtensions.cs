using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SDG.Componentes.Validator
{
    public class MultipleFileExtensions : ValidationAttribute, IClientValidatable
    {
        protected List<string> Extensions { get; set; }
        public MultipleFileExtensions(string extensions)
        {
            Extensions = new List<string>();
            foreach (string ext in extensions.Split(new char[] { ',', '|' }, StringSplitOptions.RemoveEmptyEntries))
            {
                Extensions.Add((ext.StartsWith(".") ? ext : ("." + ext)).ToLower());
            }
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            HttpPostedFileBase file = value as HttpPostedFileBase;

            if (string.IsNullOrEmpty(file?.FileName))
                return ValidationResult.Success;

            return Extensions.Contains(Path.GetExtension(file.FileName).ToLower()) ? ValidationResult.Success : new ValidationResult(ErrorMessage);
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            ModelClientValidationRule mvr = new ModelClientValidationRule();
            mvr.ErrorMessage = ErrorMessage;
            mvr.ValidationType = "fileextensions";
            mvr.ValidationParameters["extensions"] = string.Join(",", Extensions);
            return new[] { mvr };
        }
    }
}