using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SDG.Componentes.Validator
{
    public class RequiredIf : ValidationAttribute, IClientValidatable
    {
        protected string[] Fields { get; set; }
        public RequiredIf(params string[] fields)
        {
            Fields = fields;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            bool required = false;
            bool valid = true;
            foreach (string Field in Fields)
            {
                object fieldvalue = validationContext.ObjectType.GetProperty(Field).GetValue(validationContext.ObjectInstance);
                if (fieldvalue is string)
                {
                    required = !string.IsNullOrEmpty((string)fieldvalue);
                }
                else
                {
                    required = fieldvalue != null;
                }
                if (required)
                    break;
            }
            if (required) {
                if (value is null) {
                    valid = !string.IsNullOrEmpty((string)value);
                } else {
                    valid = value != null;
                }
            }
            return valid ? ValidationResult.Success : new ValidationResult(ErrorMessage);
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            ModelClientValidationRule mvr = new ModelClientValidationRule();
            mvr.ErrorMessage = ErrorMessage;
            mvr.ValidationType = "requiredif";
            mvr.ValidationParameters["fields"] = string.Join(",", Fields);
            return new[] { mvr };
        }

        /*public void AddValidation(ClientModelValidationContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            context.Attributes["data-val"] = "true";
            context.Attributes["data-val-requiredif"] = ErrorMessage;
            context.Attributes["data-val-requiredif-fields"] = string.Join(",", Fields);
        }*/
    }
}
