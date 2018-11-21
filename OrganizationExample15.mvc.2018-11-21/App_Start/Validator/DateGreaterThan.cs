using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SDG.Componentes.Validator
{
    public class DateGreaterThan : ValidationAttribute, IClientValidatable
    {
        protected List<string> Fields { get; set; }
        public DateGreaterThan(string field, params string[] fields)
        {
            Fields = new List<string>();
            Fields.Add(field);
            if(fields!=null)
                Fields.AddRange(fields);
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            bool valid = true;
            DateTime date;
            if (value == null)
                return ValidationResult.Success;
            try
            {
                date = Convert.ToDateTime(value);
                if (date.Minute == 0 && date.Hour == 0 && date.Second == 0) {
                    date= date.AddHours(23).AddMinutes(59).AddSeconds(59);
                }
            } catch {
                return new ValidationResult(ErrorMessage);
            }

            foreach (string field in Fields) {

                object fieldvalue = validationContext.ObjectType.GetProperty(field).GetValue(validationContext.ObjectInstance);
                try
                {
                    DateTime fielddate = Convert.ToDateTime(fieldvalue);
                    if(date<fielddate)
                        return new ValidationResult(string.Format(ErrorMessage, fielddate));
                } catch { }
            }
            return valid ? ValidationResult.Success : new ValidationResult(ErrorMessage);
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            ModelClientValidationRule mvr = new ModelClientValidationRule();
            mvr.ErrorMessage = ErrorMessage;
            mvr.ValidationType = "dategreaterthan";
            mvr.ValidationParameters["fields"]= string.Join(",", Fields);
            return new[] { mvr };
        }

        /*public void AddValidation(ClientModelValidationContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            context.Attributes["data-val"] = "true";
            context.Attributes["data-val-dategreaterthan"] = ErrorMessage;
            context.Attributes["data-val-dategreaterthan-fields"] = string.Join(",", Fields);
        }*/
    }
}
