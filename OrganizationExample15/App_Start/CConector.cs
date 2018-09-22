using System;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.IO;

public class CConector : Conector
{
    public CConector() : base(ConfigurationManager.ConnectionStrings["MySQLConnectionString"].ConnectionString)
    {
        
    }

    public static bool UpgradeDBFromFile(string filename)
    {
        if (File.Exists(filename))
        {
            try
            {
                using (CConector conector = new CConector())
                    return conector.__UpgradeDB(File.ReadAllText(filename));
            }
            catch
            {
                return false;
            }
        }
        return true;
    }

    protected bool __UpgradeDB(string filecontent)
    {
        if (!string.IsNullOrEmpty(filecontent))
        {
            return __UpgradeDB(JsonConvert.DeserializeObject<List<List<string>>>(filecontent));
        }
        return true;
    }

    protected bool __UpgradeDB(List<List<string>> listquerys)
    {

        MySqlDataReader reader = Query("SELECT id,nombre FROM varios WHERE tipo IS NULL LIMIT 1");
        if (reader != null)
        {
            int version = 0;
            string id = null;
            if (reader.Read())
            {
                id = reader["id"].ToString();
                try
                {
                    version = Convert.ToInt32(reader["nombre"]);
                }
                catch { }
            }
            if (listquerys.Count != version)
            {
                StartTransaction();
                for (int i = version; i < listquerys.Count; i++)
                {
                    foreach (string querystring in listquerys[i])
                    {
                        QueryMod(querystring);
                    }
                }
                Query query = new Query("varios");
                query["id"] = id;
                query["nombre"] = listquerys.Count;
                bool returnvalue = QueryMod(query.GetInsertUpdate()) != -1;
                Commit();
                return returnvalue;
            }
            return true;
        }
        return false;
    }
}
