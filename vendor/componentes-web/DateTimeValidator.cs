using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using System.Web.UI.Design.WebControls;
using System.Drawing.Design;
using SDG.Componentes;

namespace SDG.Web.UI.WebControls
{
    public class DateTimeValidator : CustomValidator
    {
        public DateTime? MaximunValue
        {
            set {
                Utilidades.GetViewState()[ClientID + "_max" ] = value;
            }
            get {
                return (DateTime ?)Utilidades.GetViewState()[ClientID + "_max"];
            }
        }

        public DateTime? MinumunValue
        {
            set {
                Utilidades.GetViewState()[ClientID + "_min"] = value;
            }
            get {
                return (DateTime?)Utilidades.GetViewState()[ClientID + "_min"];
            }
        }

        public DateTimeValidator() {
            ServerValidate += new ServerValidateEventHandler(OnValidate_DateTime);
            ClientValidationFunction = "onValidate_DateTime";
        }
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            if (!MaximunValue.HasValue && !MinumunValue.HasValue)
                throw new Exception("No se ha definido ningun valor para MinumunValue o MaximunValue [" + ID + "]");
            if (MinumunValue.HasValue && MaximunValue.HasValue) {
                if (MaximunValue.Value < MinumunValue.Value)
                    throw new Exception("El valor MaximunValue no puede ser menor al MinumunValue [" + ID + "] M(" + MaximunValue.ToString() + ") m(" + MinumunValue.ToString() + ")");
            }
            if(MinumunValue.HasValue)
                Page.ClientScript.RegisterExpandoAttribute(ClientID, "minimunValue", MinumunValue.Value.ToString("dd/MM/yyyy HH:mm"));
            if(MaximunValue.HasValue)
                Page.ClientScript.RegisterExpandoAttribute(ClientID, "maximunValue", MaximunValue.Value.ToString("dd/MM/yyyy HH:mm"));
            if (!Page.ClientScript.IsClientScriptIncludeRegistered("datetimevalidator")) { 
                Page.ClientScript.RegisterClientScriptInclude("datetimevalidator",
                    Page.ClientScript.GetWebResourceUrl(this.GetType(), "SDG.Componentes.DateTimeValidator.js"));
            }
        }

        public void OnValidate_DateTime(object sender, ServerValidateEventArgs args)
        {
            if (!MaximunValue.HasValue && !MinumunValue.HasValue)
                throw new Exception("No se ha definido ningun valor para MinumunValue o MaximunValue (" + ID + ")");
            try
            {
                DateTime fecha = DateTime.Parse(args.Value);
                if (args.Value.Contains(':'))
                    fecha.AddSeconds(1);
                if (MaximunValue.HasValue)
                {
                    if (fecha > MaximunValue.Value)
                    {
                        args.IsValid = false;
                        ErrorMessage = "Por favor ingrese una fecha menor a " + MaximunValue;
                        return;
                    }
                }
                if (MinumunValue.HasValue)
                {
                    if (fecha.Hour == 0 && fecha.Minute == 0 && fecha.Second==0)
                        fecha= fecha.AddHours(23).AddMinutes(59).AddSeconds(59);
                    if (fecha < MinumunValue.Value)
                    {
                        args.IsValid = false;
                        ErrorMessage = "Por favor ingrese una fecha mayor a " + MinumunValue;
                        return;
                    }
                }
                args.IsValid = true;
            } catch {
                args.IsValid = false;
            }
        }
    }
}
