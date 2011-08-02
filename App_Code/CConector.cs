using System;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using componentes;

public class CConector : Conector
{
    public CConector() : base(ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString)
    {
    }

    static public CConector GetConector() 
    {
        if (HttpContext.Current.Session["Conector"] == null)
        {
            CConector conector = new CConector();
            HttpContext.Current.Session["Conector"] = conector;
        }
        return (CConector)HttpContext.Current.Session["Conector"];
    }
}
