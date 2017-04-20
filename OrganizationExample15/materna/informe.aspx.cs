using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using MySql.Data.MySqlClient;
using System.Text.RegularExpressions;

public partial class materna_informe : System.Web.UI.Page
{
    public string CurrentSeguimiento = null;
    public Dictionary<string, string> cacheData = new Dictionary<string, string>();
    public static Regex RegexNumers = new Regex("^\\d+\\.\\d+$", RegexOptions.Compiled);
    public static Regex regexHeader = new Regex(@"(\d+.?\d*)(.+)", RegexOptions.Compiled);

    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);
        if (!IsPostBack)
        {
            CUsuario usuario = (CUsuario)CUsuario.GetInstance();
            TInicio.Text = Query.GetFromMySQLDate(DateTime.Now.AddDays(-15));
            TFin.Text = Query.GetFromMySQLDate(DateTime.Now);
            ((MasterPageI)Master).RestoreState();
            BBuscar_Click(sender, e);
        }
    }

    protected string GetCode(string text)
    {
        Match match = regexHeader.Match(text);
        if (match.Success)
            return match.Groups[1].Value;
        return text;
    }

    public void FillData(string idSeguimiento) {
        CurrentSeguimiento = idSeguimiento;
        cacheData = new Dictionary<string, string>();
        using (CConector conector = new CConector()) {

            Query query = new Query("seguimiento_materno_items");

            query += "tipo";
            query += "valor";
            query += "valor2";
            query += "valor3";

            MySqlDataReader reader= conector.Query(query.GetSelect("seguimiento=" + Query.GetValor(idSeguimiento)));
            if (reader != null) {
                while (reader.Read()) {
                    Varios varios= Varios.Get(reader["tipo"].ToString());
                    switch (varios.tipo) {
                        case 154:
                        case 141: // radio
                        case 142:
                        case 143: // text
                        case 145:
                        case 152:
                        case 153:
                        case 155:
                        case 144: // radio and text
                        case 148:
                        case 156: // postparto radio
                        case 157: // postparto text
                        case 158: // postparto radio and text
                        case 159:
                        case 160:
                        case 161:
                            cacheData[GetCode(varios.Nombre)] = reader["valor"].ToString();
                            if(!string.IsNullOrEmpty(varios.Descripcion))
                                cacheData[GetCode(varios.Descripcion)] = reader["valor2"].ToString();
                            break;
                        case 147: // twotext
                            cacheData[GetCode(varios.Nombre)] = reader["valor"].ToString();
                            cacheData[GetCode(varios.Nombre) + "_2"] = reader["valor2"].ToString();
                            break;
                        case 150: // 3 text
                        case 151:
                            cacheData[GetCode(varios.Nombre)] = reader["valor"].ToString();
                            cacheData[GetCode(varios.Nombre) + "_2"] = reader["valor2"].ToString();
                            cacheData[GetCode(varios.Nombre) + "_3"] = reader["valor3"].ToString();
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }

    public string GetCIE10(string codes) {
        List<string> descripcion = new List<string>();
        foreach (string code in codes.Split(','))
        {
            descripcion.Add(Procedimientos.GetCodigoCIE(code));
        }
        return string.Join(",", descripcion);
    }

    public string GetData(string idSeguimiento, string code) {

        if (CurrentSeguimiento != idSeguimiento || cacheData == null) {
            FillData(idSeguimiento);
        }
        try {
            string value = cacheData[code];
            if (!string.IsNullOrEmpty(value) && RegexNumers.IsMatch(value))
                return value.Replace(".", ",");
            return value;
        } catch { }
        return null;
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        if (sender == BBuscar && !IsValid)
            return;
        GPosParto.Visible=
        GGestante.Visible = false;
        GridView grid = DTipo.SelectedValue == "1" ? GGestante : GPosParto;
        Title= DTipo.SelectedValue == "1" ? "Informe Gestante" : "Informe Posparto";
        grid.Visible = true;
        if (GridUtils.GetRowsCount(grid, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir(grid);
            ((MasterPageI)Master).Excel(grid);
        }
        else
        {
            ((MasterPageI)Master).Imprimir((GridView)null);
            ((MasterPageI)Master).Excel(null);
        }
    }

    public void OnImprimir(object sender, EventArgs e)
    {
        PrintEventArgs evento = (PrintEventArgs)e;
        GridView grid = DTipo.SelectedValue == "1" ? GGestante : GPosParto;
        grid.Visible = true;
        grid.DataBind();
        grid.DataSourceID = "";
    }

}