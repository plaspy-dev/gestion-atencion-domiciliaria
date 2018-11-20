using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SDG.Componentes;
using MySql.Data.MySqlClient;

namespace OrganizationExample15.Controllers
{
    public class InicioController : BaseController
    {
        public ActionResult Index()
        {
            CUsuario user = ViewBag.User;
            if (user["cumpleanos"] == "1")
            {
                using (CConector conector = new CConector())
                {

                    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

                    MySqlDataReader reader = conector.Query(@"SELECT per.perId AS id,per.perNombre AS nombres
				,CASE DAY(perFechaNac)
				WHEN DAY(NOW()) THEN 'Hoy'
				WHEN DAY(NOW())-1 THEN 'Ayer'
				WHEN DAY(NOW())-2 THEN 'Anteayer'
				WHEN DAY(NOW())+1 THEN 'Mañana'
				END AS dia
				,cargo.carDescripcion AS cargo,perCorreoElectronico,per.perCelular AS celular
                FROM recurso_humano per
                LEFT JOIN cargo on per.carId = cargo.carId
				WHERE per.eEstId=1
                AND DATE_ADD(perFechaNac, 
                INTERVAL YEAR(NOW())-YEAR(perFechaNac)
                         + IF(DAYOFYEAR(NOW()) > DAYOFYEAR(perFechaNac),1,0)
                YEAR)  
                BETWEEN NOW()-INTERVAL 2 DAY AND DATE_ADD(NOW(), INTERVAL 1 DAY)
				ORDER BY DAY(perFechaNac)*100+DAY(perFechaNac);");
                    if (reader != null)
                    {
                        while (reader.Read())
                        {
                            Dictionary<string, object> values = new Dictionary<string, object>();
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                values[reader.GetName(i)] = reader[i];
                            }
                            list.Add(values);
                        }
                    }
                    ViewBag.list = list;
                }
            }
            return View();
        }
    }
}