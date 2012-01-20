using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Web.UI;
using SDG.Componentes;

/// <summary>
/// Descripción breve de CConectorMS
/// </summary>
public class CConectorMS : ConectorMS
{
    public CConectorMS() : base(ConfigurationManager.ConnectionStrings["connBD"].ConnectionString)
    {
    }
    static public CConectorMS GetConector()
    {
        return new CConectorMS();
    }
    public string GetConnectionString() {
        return m_szConexion;
    }
}
