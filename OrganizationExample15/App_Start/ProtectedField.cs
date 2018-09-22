using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15
{
    public class ProtectedField
    {
        public NameValueCollection ProtectedFields { get; set; }
        private Dictionary<string, string> _ProtectedFields
        {
            get
            {
                if (ProtectedFields == null)
                    return null;
                Dictionary<string, string> dictionary = new Dictionary<string, string>();
                foreach (string key in ProtectedFields.AllKeys)
                {
                    dictionary[key] = ProtectedFields[key];
                }
                return dictionary;
            }
            set
            {
                ProtectedFields = new NameValueCollection();
                foreach (var keypair in value)
                {
                    ProtectedFields[keypair.Key] = keypair.Value;
                }
            }
        }
        public string _gk
        {
            get
            {
                return _ProtectedFields == null ? null : Crypt.Protect(JsonConvert.SerializeObject(_ProtectedFields));
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    throw new Exception("ProtectedFields t is empty");
                }
                _ProtectedFields = JsonConvert.DeserializeObject<Dictionary<string, string>>(Crypt.Unprotect(value));
                if (string.IsNullOrEmpty(ProtectedFields["_t"]))
                {
                    throw new Exception("ProtectedFields t now found");
                }
            }
        }

        public ProtectedField()
        {
            ProtectedFields = new NameValueCollection();
            ProtectedFields["_t"] = Query.GetMySQLDateFormat(DateTime.Now, true);
        }
    }
}