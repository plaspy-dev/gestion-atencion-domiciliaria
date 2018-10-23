using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace OrganizationExample15.Models.terapeutico
{
    public class ListadoCuentas : ProtectedField
    {
        public MFuncionarioSimple Funcionario { get; set; }
        [RegularExpression("^(((\\d{4})(-)(0[13578]|10|12)(-)(0[1-9]|[12][0-9]|3[01]))|((\\d{4})(-)(0[469]|11)(-)(0[1-9]|[12][0-9]|30))|((\\d{4})(-)(02)(-)(0[1-9]|[12][0-9]|2[0-8]))|(([02468][048]00)(-)(02)(-)(29))|(([13579][26]00)(-)(02)(-)(29))|(([0-9][0-9][0][48])(-)(02)(-)(29))|(([0-9][0-9][2468][048])(-)(02)(-)(29))|(([0-9][0-9][13579][26])(-)(02)(-)(29)))$")]
        public string Desde { get; set; }
        [RegularExpression("^(((\\d{4})(-)(0[13578]|10|12)(-)(0[1-9]|[12][0-9]|3[01]))|((\\d{4})(-)(0[469]|11)(-)(0[1-9]|[12][0-9]|30))|((\\d{4})(-)(02)(-)(0[1-9]|[12][0-9]|2[0-8]))|(([02468][048]00)(-)(02)(-)(29))|(([13579][26]00)(-)(02)(-)(29))|(([0-9][0-9][0][48])(-)(02)(-)(29))|(([0-9][0-9][2468][048])(-)(02)(-)(29))|(([0-9][0-9][13579][26])(-)(02)(-)(29)))$")]
        public string Hasta { get; set; }
        public uint? Estado { get; set; }

        public ListadoCuentas() {
            Funcionario = new MFuncionarioSimple();
        }
    }
}