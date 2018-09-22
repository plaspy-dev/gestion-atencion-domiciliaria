using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace SDG.Componentes
{
    public class BootgridResponseData
    {
        public int current { get; set; } //? current page
        public int rowCount { get; set; } //? rows per page
        public List<Dictionary<string, object>> rows { get; set; } //? items
        public int total { get; set; } //? total rows for whole query

        public static object BasicFormat(string columnName, object value)
        {

            if (value is DateTime)
                return value.ToString();
            return HttpUtility.HtmlEncode(value);
        }

        public static BootgridResponseData GetFormatedData(Conector conector, string queryCount, string query, int current, int rowCount, Dictionary<string, string> sort, Func<string, object, object> FormatFunc = null)
        {
            BootgridResponseData data = new BootgridResponseData();

            int total = 0;
            int.TryParse(conector.QueryString(queryCount), out total);
            data.total = total;
            data.rows = new List<Dictionary<string, object>>();

            if (total > 0)
            {
                data.current = current;

                if (sort != null && sort.Count == 1)
                {
                    query += " ORDER BY ";
                    foreach (var keyValue in sort)
                    {
                        query += string.Format("{0} {1}", HttpUtility.UrlDecode(keyValue.Key), keyValue.Value);
                        break;
                    }
                }
                if (rowCount != -1)
                    query += string.Format(" LIMIT {0},{1}", rowCount * (current - 1), rowCount);

                MySqlDataReader reader = conector.Query(query);
                if (reader != null)
                {
                    while (reader.Read())
                    {

                        Dictionary<string, object> row = new Dictionary<string, object>();
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            if (reader[i] != DBNull.Value)
                            {
                                row[reader.GetName(i)] = FormatFunc == null ? BasicFormat(null, reader[i]) : FormatFunc(reader.GetName(i), reader[i]);
                            }
                        }
                        data.rows.Add(row);
                    }
                    data.rowCount = data.rows.Count;
                }
            }

            return data;
        }
    }
}