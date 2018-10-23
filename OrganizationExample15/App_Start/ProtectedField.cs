using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Reflection;
using System.Web;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15
{
    public class ProtectedField
    {
        public bool SkipGK { get; set; }
        public NameValueCollection ProtectedFields { get; set; }
#if DEBUG
        public string DebugValue {
            get {
                return JsonConvert.SerializeObject(_ProtectedFields);
            }
        }
#endif
        private Dictionary<string, string> _ProtectedFields
        {
            get
            {
                if (ProtectedFields == null)
                    return null;
                Dictionary<string, string> dictionary = new Dictionary<string, string>();
                foreach (string key in ProtectedFields.AllKeys)
                {
                    if(!string.IsNullOrEmpty(ProtectedFields[key]))
                        dictionary[key] = ProtectedFields[key];
                }
                Type type = typeof(ProtectedField);
                Type typelist = typeof(IEnumerable<ProtectedField>);

                foreach (PropertyInfo property in this.GetType().GetProperties()) {
                    if (property.PropertyType.IsSubclassOf(type)) {
                        ProtectedField protectedfield = property.GetValue(this) as ProtectedField;
                        if (protectedfield != null)
                        {
                            foreach (var keypar in protectedfield._ProtectedFields)
                            {
                                if (keypar.Key != "_t")
                                    dictionary[string.Format("{0}:{1}", property.Name, keypar.Key)] = keypar.Value;
                            }
                        }
                    } else if(typelist.IsAssignableFrom(property.PropertyType)) {
                        IEnumerable<ProtectedField> list= property.GetValue(this) as IEnumerable<ProtectedField>;
                        if (list != null)
                        {
                            int i = 0;
                            foreach (ProtectedField protectedfield in list)
                            {
                                foreach (var keypar in protectedfield._ProtectedFields)
                                {
                                    if (keypar.Key != "_t")
                                    {
                                        dictionary[string.Format("{0}:{1}:{2}", property.Name, keypar.Key, i)] = keypar.Value;
                                    }
                                }
                                i++;
                            }
                        }
                    }
                }
                return dictionary;
            }
            set
            {
                ProtectedFields = new NameValueCollection();
                Type type = typeof(ProtectedField);
                Type typelist = typeof(IEnumerable<ProtectedField>);

                foreach (var keypair in value)
                {
                    if (keypair.Key.Contains(":")) {
                        string[] parts= keypair.Key.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                        if (parts.Length > 2) {
                            foreach (PropertyInfo property in this.GetType().GetProperties())
                            {
                                if (property.Name == parts[0] && typelist.IsAssignableFrom(property.PropertyType))
                                {
                                    IEnumerable<ProtectedField> list = property.GetValue(this) as IEnumerable<ProtectedField>;
                                    if (list != null)
                                    {
                                        int i = 0;
                                        foreach (ProtectedField info in list)
                                        {
                                            if (i.ToString() == parts[2])
                                            {
                                                info.ProtectedFields[parts[1]] = keypair.Value;
                                                break;
                                            }
                                            i++;
                                        }
                                    }

                                    ProtectedField protectedfield = property.GetValue(this) as ProtectedField;
                                    if (protectedfield != null)
                                    {
                                        protectedfield.ProtectedFields[parts[1]] = keypair.Value;
                                        break;
                                    }
                                }
                            }
                            continue;
                        } else if (parts.Length > 1) {
                            foreach (PropertyInfo property in this.GetType().GetProperties())
                            {
                                if (property.Name == parts[0] && property.PropertyType.IsSubclassOf(type)) {
                                    ProtectedField protectedfield = property.GetValue(this) as ProtectedField;
                                    if (protectedfield != null)
                                    {
                                        protectedfield.ProtectedFields[parts[1]] = keypair.Value;
                                        break;
                                    }
                                }
                            }
                            continue;
                        }
                    }
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
                if (SkipGK)
                    return;
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