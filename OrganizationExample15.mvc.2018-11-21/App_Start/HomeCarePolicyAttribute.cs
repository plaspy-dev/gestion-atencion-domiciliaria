using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace OrganizationExample15
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple = true)]
    public class HomeCarePolicyAttribute : Attribute
    {
        public string OverWritePath { get; set; }
        public CUsuario.Permisos Privileges { get; set; }
        public HomeCarePolicyAttribute(string overwritepath, CUsuario.Permisos privilege = CUsuario.Permisos.None)
        {
            OverWritePath = overwritepath;
            Privileges = privilege;
        }

        public static List<HomeCarePolicyAttribute> GetHSPolicy(ActionDescriptor ActionDescriptor)
        {

            if (ActionDescriptor != null)
            {
                List<HomeCarePolicyAttribute> list = new List<HomeCarePolicyAttribute>();
                foreach (Attribute attribute in ActionDescriptor.GetCustomAttributes(false))
                {
                    HomeCarePolicyAttribute attr = attribute as HomeCarePolicyAttribute;
                    if (attr != null && !string.IsNullOrEmpty(attr.OverWritePath))
                    {
                        list.Add(attr);
                    }
                }
                return list.Count == 0 ? null : list;
            }
            return null;
        }

        public static List<HomeCarePolicyAttribute> GetHSPolicy(MethodBase MethodInfo)
        {

            if (MethodInfo != null)
            {
                List<HomeCarePolicyAttribute> list = new List<HomeCarePolicyAttribute>();
                foreach (Attribute attribute in MethodInfo.GetCustomAttributes(false))
                {
                    HomeCarePolicyAttribute attr = attribute as HomeCarePolicyAttribute;
                    if (attr != null && !string.IsNullOrEmpty(attr.OverWritePath))
                    {
                        list.Add(attr);
                    }
                }
                return list.Count == 0 ? null : list;
            }
            return null;
        }

        public static List<HomeCarePolicyAttribute> GetHSPolicy(TypeInfo TypeInfo)
        {

            if (TypeInfo != null)
            {
                List<HomeCarePolicyAttribute> list = new List<HomeCarePolicyAttribute>();
                foreach (Attribute attribute in TypeInfo.GetCustomAttributes(false))
                {
                    HomeCarePolicyAttribute attr = attribute as HomeCarePolicyAttribute;
                    if (attr != null && !string.IsNullOrEmpty(attr.OverWritePath))
                    {
                        list.Add(attr);
                        // return attr;
                    }
                }
                return list.Count == 0 ? null : list;
            }
            return null;
        }

        public bool CanAccess(CUsuario user)
        {
            if (!string.IsNullOrEmpty(OverWritePath))
                return OverWritePath == "*" || (Privileges == CUsuario.Permisos.None ? user.CanAccess(OverWritePath) : user.Can(OverWritePath, Privileges));
            return false;
        }
    }
}