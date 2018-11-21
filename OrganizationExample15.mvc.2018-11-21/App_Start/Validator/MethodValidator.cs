using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace SDG.Componentes.Validator
{
    public class MethodValidator : ValidationAttribute, IClientValidatable
    {
        protected string Number = "";
        protected string FunctionName { get; set; }

        protected MethodValidator(string functionName, string number) : this(functionName)
        {
            Number= number;
        }

        public MethodValidator(string functionName) {
            FunctionName = functionName;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            MethodInfo methodInfo= validationContext.ObjectType.GetMethod(FunctionName);
            object _params = null;
            if (methodInfo.GetParameters().Length == 1)
                _params = new object[] { value };
            else if(methodInfo.GetParameters().Length == 2)
                _params= new object[] { value, this };
            bool? valid = methodInfo.Invoke(validationContext.ObjectInstance, _params as object[]) as bool?;
            return valid.Value ? ValidationResult.Success : new ValidationResult(ErrorMessage);
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(ModelMetadata metadata, ControllerContext context)
        {
            ModelClientValidationRule mvr = new ModelClientValidationRule();
            mvr.ErrorMessage = ErrorMessage;
            mvr.ValidationType = "methodvalidator" + Number;
            mvr.ValidationParameters["method"] = Char.ToLower(FunctionName[0]) + FunctionName.Substring(1);
            return new[] { mvr };
        }

        /*public void AddValidation(ClientModelValidationContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            context.Attributes["data-val"] = "true";
            context.Attributes["data-val-methodvalidator" + Number] = ErrorMessage;
            context.Attributes["data-val-methodvalidator" + Number + "-method"] = FunctionName;
        }*/
    }

    public class MethodValidator1 : MethodValidator
    {
        public MethodValidator1(string functionName) : base(functionName, "a")
        {
        }
    }

    public class MethodValidator2 : MethodValidator
    {
        public MethodValidator2(string functionName) : base(functionName, "b")
        {
        }
    }

    public class MethodValidator3 : MethodValidator
    {
        public MethodValidator3(string functionName) : base(functionName, "b")
        {
        }
    }

    public class MethodValidator4 : MethodValidator
    {
        public MethodValidator4(string functionName) : base(functionName, "c")
        {
        }
    }
}
