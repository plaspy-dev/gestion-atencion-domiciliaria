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
        public int Current { get; set; } //? current page
        public int RowCount { get; set; } //? rows per page
        public List<Dictionary<string, object>> Rows { get; set; } //? items
        public int Total { get; set; } //? total rows for whole query

        public static object BasicFormat(string columnName, object value)
        {
            if (value is DateTime)
            {
                DateTime date = (DateTime)value;
                return date.Hour==0 && date.Minute==0 && date.Second==0 ? date.ToShortDateString() : date.ToString();
            }
            return HttpUtility.HtmlEncode(value);
        }

        public static BootgridResponseData GetFormatedData(Conector conector, string queryCount, string query, int current, int rowCount, Dictionary<string, string> sort, Func<string, object, object> FormatFunc = null)
        {
            BootgridResponseData data = new BootgridResponseData();

            int total = 0;
            int.TryParse(conector.QueryString(queryCount), out total);
            data.Total = total;
            data.Rows = new List<Dictionary<string, object>>();

            if (total > 0 && rowCount > 0)
            {
                data.Current = current;

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
                        data.Rows.Add(row);
                    }
                    data.RowCount = data.Rows.Count;
                }
            }

            return data;
        }
    }
}