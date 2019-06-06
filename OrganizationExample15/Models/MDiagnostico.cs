using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes.Validator;
using Newtonsoft.Json;

namespace OrganizationExample15.Models
{
    public class MDiagnostico : ProtectedField
    {
        public class CIE10 {
            public string Code { get; set; }
            public string Description {
                get {
                    return Procedimientos.GetCodigoCIE(Code);
                }
            }
        }

        [JsonIgnore]
        public bool ReadOnly { get; set; }
        [JsonIgnore]
        public string _CIE10 {
            get {
                return JsonConvert.SerializeObject(CIE10s, HomeCareVersion.JsonSerializerSettingsCamelCase);
            }
            set {
                CIE10s= JsonConvert.DeserializeObject<List<CIE10>>(value, HomeCareVersion.JsonSerializerSettingsCamelCase);
            }
        }
        public List<CIE10> CIE10s { get; set; } = new List<CIE10>();

        [JsonIgnore]
        public CIE10 Edit { get; set; } = new CIE10();

        [JsonIgnore]
        public bool Required
        {
            get
            {
                return ProtectedFields["r"] == "1";
            }
            set
            {
                ProtectedFields["r"] = value ? "1" : null;
            }
        }
    }
}