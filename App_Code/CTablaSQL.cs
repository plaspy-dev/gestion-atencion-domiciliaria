using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Collections;
using MySql.Data.MySqlClient;
using System.ComponentModel;

public class CTablaSQL
{
    protected string m_szQuery;
    protected string m_szId;
    protected DataTable m_pTabla;

	public CTablaSQL()
	{
        m_szQuery = "";
        m_szId = "";
        m_pTabla = null;
	}
    virtual protected int GetColumns(MySqlDataReader reader)
    {
        if (reader == null || m_pTabla == null)
            return 0;
        for (int i = 0; i < reader.FieldCount; i++)
        {
            m_pTabla.Columns.Add(reader.GetName(i), reader.GetFieldType(i));
        }
        // if (m_szId2.Length==0)
            m_pTabla.PrimaryKey = new DataColumn[] { m_szId.Length==0 ? m_pTabla.Columns[reader.GetName(0)] : m_pTabla.Columns[m_szId]};
        // else m_pTabla.PrimaryKey = new DataColumn[] { m_pTabla.Columns[m_szId], m_pTabla.Columns[m_szId2] };
        return reader.FieldCount;
    }

    virtual protected DataTable GetDataTable()
    {
        m_pTabla = new DataTable();
        CConector pConector = CConector.GetConector();
        MySqlDataReader reader = pConector.Query(m_szQuery);
        if (reader != null)
        {
            GetColumns(reader);
            object[] todos = new object[reader.FieldCount];
            while (reader.Read())
            {
                reader.GetValues(todos);
                m_pTabla.Rows.Add(todos);
            }
        }
        return m_pTabla;
    }

    [DataObjectMethod(DataObjectMethodType.Select, true)]
    virtual public DataTable Select(string query, string szId, params object[]p)
    {
        m_szQuery = query;
        m_szId = szId;
        return GetDataTable();
    }
}
