using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models.Administrador
{
    public class Privilege
    {
        [Flags]
        public enum Privileges
        {
            None = 0x00,
            Read = 0x01,
            Print = 0x02,
            Insert = 0x04,
            Update = 0x08,
            Delete = 0x10,
            Admin = 0x20,
            All = 0xff
        };

        public Privileges Granted { get; set; }
        public string URL { get; set; }
        public bool? Hidden { get; set; }
        public string Title { get; set; }
        public List<Privilege> Childrens { get; set; } = new List<Privilege>();

        public bool Read { get { return Granted.HasFlag(Privileges.Read); } set { if (value) Granted |= Privileges.Read; else Granted &= ~Privileges.Read; } }
        public bool Print { get { return Granted.HasFlag(Privileges.Print); } set { if (value) Granted |= Privileges.Print; else Granted &= ~Privileges.Print; } }
        public bool Insert { get { return Granted.HasFlag(Privileges.Insert); } set { if (value) Granted |= Privileges.Insert; else Granted &= ~Privileges.Insert; } }
        public bool Update { get { return Granted.HasFlag(Privileges.Update); } set { if (value) Granted |= Privileges.Update; else Granted &= ~Privileges.Update; } }
        public bool Delete { get { return Granted.HasFlag(Privileges.Delete); } set { if (value) Granted |= Privileges.Delete; else Granted &= ~Privileges.Delete; } }
        public bool Admin { get { return Granted.HasFlag(Privileges.Admin); } set { if (value) Granted |= Privileges.Admin; else Granted &= ~Privileges.Admin; } }
        public bool All { get { return Granted.HasFlag(Privileges.All); } set { if (value) Granted |= Privileges.All; } }

        public Privilege() { }
    }
}