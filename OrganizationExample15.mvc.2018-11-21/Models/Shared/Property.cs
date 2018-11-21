using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models.Shared
{
    public class Property
    {
        public string User { get; set; }
        public DateTime Date { get; set; }
    }
    public class Properties
    {
        public List<Property> Modifications { get; set; }
    }
}