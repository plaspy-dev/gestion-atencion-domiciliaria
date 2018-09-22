using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using SDG.Componentes;

namespace SDG.Componentes.Validator
{
    public class DateLessThan : ValidationAttribute, IClientValidatable
    {
        protected List<string> Fields { get; set; }
        public DateLessThan(params string[] field)
        {
            Fields = field.ToList();
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            bool valid = true;
            DateTime date;
            try
            {
                date = Convert.ToDateTime(value);
                if (date > DateTime.Now) {
                    return new ValidationResult(string.Format(ErrorMessage, Query.GetFromMySQLDate(DateTime.Now,true)));
                }
            } catch {
                return new ValidationResult(ErrorMessage);
            }

            foreach (string field in Fields) {

                object fieldvalue = validationContext.ObjectType.GetProperty(field).GetValue(validationContext.ObjectInstance);
                try
                {
                    DateTime fielddate = Convert.ToDateTime(fieldvalue);
                    if(date>fielddate)
                        return new ValidationResult(string.Format(ErrorMessage, fielddate));
                } catch { }
            }
            return valid ? ValidationResult.Success : new ValidationResult(ErrorMessage);
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            ModelClientValidationRule mvr = new ModelClientValidationRule();
            mvr.ErrorMessage = ErrorMessage;
            mvr.ValidationType = "datelessthan";
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
            context.Attributes["data-val-datelessthan"] = ErrorMessage;
            context.Attributes["data-val-datelessthan-fields"] = string.Join(",", Fields);
        }*/
    }
}
