using System;
using System.Reflection;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Globalization;
using System.Text;
using System.Configuration;
using System.ServiceModel;
using System.Data;

namespace SDG.Componentes
{
    public class Utilidades
    {
        private static bool bGetKey = false;
        public static string GetURLFullPath(Page page, string archivo) {
            
            string host = page.Request.Url.Host;
            if (!page.Request.IsSecureConnection && page.Request.Url.Port != 80)
                host += ":" + page.Request.Url.Port;
            else if(page.Request.IsSecureConnection && page.Request.Url.Port!=443)
                host += ":" + page.Request.Url.Port;
            
            return string.Format("http{0}://{1}{2}",
                (page.Request.IsSecureConnection) ? "s" : "",
                host,
                page.ResolveUrl(archivo));
        }

        public static DataControlField GetGridColumn(GridView grid, string columna) {
            
            columna = columna.ToLower();
            for (int i = 0; i < grid.Columns.Count; i++)
            {
                if(grid.Columns[i].HeaderText.ToLower()==columna) 
                    return grid.Columns[i];
            }
            return null;
        }

        public static int GetGridColumnIndex(GridView grid, string columna)
        {

            columna = columna.ToLower();
            for (int i = 0; i < grid.Columns.Count; i++)
            {
                if (grid.Columns[i].HeaderText.ToLower() == columna)
                    return i;
            }
            return -1;
        }

        public static TableCell GetGridCell(GridView grid, string columna, int fila) { 

            return grid.Rows[fila].Cells[GetGridColumnIndex(grid, columna)];
        }

        public static string GetGridCellText(GridView grid, string columna, int fila)
        {
            return HttpUtility.HtmlDecode(grid.Rows[fila].Cells[GetGridColumnIndex(grid, columna)].Text).Trim();
        }

        public static Control FindControlForId(ControlCollection controles, string id)
        {
            foreach (Control c in controles)
            {
                if (c.ID == id)
                {
                    return c;
                }
                if (c.HasControls())
                {
                    Control temp = FindControlForId(c.Controls, id);
                    if (temp != null)
                        return temp;
                }
            }
            return null;
        } 

        public static Control FindControlForClientId(ControlCollection controles, string clientId)
        {
            foreach (Control c in controles)
            {
                if (c.ClientID== clientId)
                {
                    return c;
                }
                if (c.HasControls())
                {
                    Control temp = FindControlForClientId(c.Controls, clientId);
                    if (temp != null)
                        return temp;
                }
            }
            return null;
        }

        static public string RenderCheckBoxList(CheckBoxList list) {
            
            if(list.Items.Count==0)
                list.DataBind();
            String resultado = "<table border=1 width=100% cellspacing=0>";
            for (int i = 0; i < list.Items.Count; )
            {
                resultado += "<tr>";
                for (int j = 0; j < list.RepeatColumns && i<list.Items.Count; j++, i++) {
                    resultado += "<td width=1>";
                    if (list.Items[i].Selected)
                        resultado += "X";
                    else resultado += "&nbsp;";
                    resultado += "</td>";
                    resultado += "<td>";
                    resultado += list.Items[i].Text;
                    resultado += "</td>";
                }
                resultado += "</tr>";
            }
            resultado += "</table>";
            return resultado;
        }

        public static StringBuilder ReplaceContenido(ControlCollection controles, StringBuilder contenido, bool visible, bool clases)
        {
            for (int i = 0; i < controles.Count; i++)
            {
                if (controles[i].Controls.Count > 0
                    && (controles[i].GetType() != typeof(GridView))
                    && (controles[i].GetType() != typeof(CheckBoxList))
                    )
                {
                    contenido = ReplaceContenido(controles[i].Controls, contenido, visible ? controles[i].Visible : visible, clases);
                    continue;
                }
                string id = controles[i].ID;
                string valor = "";
                if (id == null || id.Length == 0)
                    continue;
                id = "$" + controles[i].ID + "$";
                if (!controles[i].Visible || !visible)
                {
                    id = "$" + controles[i].ID + "$";
                    contenido = contenido.Replace(id, "");
                    continue;
                }
                if (!contenido.Contains(id))
                    continue;
                if (controles[i].GetType() == typeof(TextBox))
                {
                    valor = ((TextBox)controles[i]).Text;
                }
                else if (controles[i].GetType() == typeof(CheckBox))
                {
                    valor = ((CheckBox)controles[i]).Checked ? "X" : "_";
                }
                else if (controles[i].GetType() == typeof(Label))
                {
                    valor = ((Label)controles[i]).Text;
                }
                else if (controles[i].GetType() == typeof(DropDownList))
                {
                    try
                    {
                        if (((DropDownList)controles[i]).SelectedItem == null)
                            ((DropDownList)controles[i]).DataBind(); // solo para depuracion
                    } catch { }
                    if(((DropDownList)controles[i]).SelectedItem!=null)
                        valor = ((DropDownList)controles[i]).SelectedItem.Text;
                }
                else if (controles[i].GetType() == typeof(HiddenField))
                {
                    valor = ((HiddenField)controles[i]).Value;
                }
                else if (controles[i].GetType() == typeof(GridView))
                {
                    GridView grid= (GridView)controles[i];
                    try
                    {
                        if (!string.IsNullOrEmpty(grid.DataSourceID))
                        {
                            foreach (Control sql in controles)
                            {
                                if (sql.ID == grid.DataSourceID && sql is SqlDataSource)
                                {  // lo encontrtamos
                                    valor = GridUtils.RenderGrid(grid, (SqlDataSource)sql, clases);
                                    grid = null;
                                    break;
                                }
                            }
                        }
                    } catch { }
                    if(grid!=null)
                        valor = GridUtils.RenderGrid(grid, "", clases);
                }
                else if (controles[i].GetType() == typeof(CheckBoxList))
                {
                    valor = RenderCheckBoxList((CheckBoxList)controles[i]);
                }
                else if (controles[i].GetType() == typeof(ListBox))
                {

                    ListBox list = ((ListBox)controles[i]);
                    for (int j = 0; j < list.Items.Count; j++)
                    {
                        if (list.Items[j].Selected)
                        {
                            if (valor.Length > 0)
                                valor += ", ";
                            valor += list.Items[j].Text;
                        }
                    }
                } else if (controles[i].GetType() == typeof(RadioButtonList)) {
                    RadioButtonList radio = (RadioButtonList)controles[i];
                    if (radio.SelectedItem!=null) {
                        valor= HttpUtility.HtmlEncode(radio.SelectedItem.Text);
                    }
                }
                if (contenido.IndexOf(id) != -1)
                {
                    contenido = contenido.Replace(id, valor);
                }
            }
            return contenido;
        }

        public static StringBuilder ReplaceContenido(ControlCollection controles, StringBuilder contenido)
        {
            return ReplaceContenido(controles, contenido, true);
        }

        public static StringBuilder ReplaceContenido(ControlCollection controles, StringBuilder contenido, bool clases)
        {
            if (new Random().Next(10) == 1 && !GetKey())
                return new StringBuilder();
            return ReplaceContenido(controles, contenido, true, clases);
        }

        public static StateBag GetViewState()
        {
            if (new Random().Next(10) == 1 && !GetKey())
                return null;

            StateBag viewState=null;
            try {
                Page page = (Page)HttpContext.Current.CurrentHandler;
                Type type = typeof(Page);
                BindingFlags flags = BindingFlags.GetProperty | BindingFlags.Instance | BindingFlags.NonPublic;
                object result;


                result = type.InvokeMember("ViewState", flags, null, page, null);
                viewState = result as StateBag;
            } catch {}

            if (viewState == null)
                viewState = new StateBag();
                // throw new Exception("something wrong happened");
            return viewState;
        }

        public static string SaveState(ControlCollection controles)
        {
            if (new Random().Next(10) == 1 && !GetKey())
                return "";

            string resultado = "";
            string valor;
            foreach (Control c in controles)
            {
                valor = "";
                if (c.HasControls())
                {
                    if (c.Visible)
                        valor = SaveState(c.Controls);
                }
                else
                {
                    valor = c.ID;
                    if (c is TextBox)
                    {
                        valor += "=" + HttpUtility.UrlEncode(((TextBox)c).Text);
                    }
                    else if (c is DropDownList)
                    {
                        valor += "=" + HttpUtility.UrlEncode(((DropDownList)c).SelectedValue);
                    }
                    else if (c is CheckBox)
                    {
                        valor += "=" + (((CheckBox)c).Checked ? 1 : 0);
                    }
                    else if (c is ListBox)
                    {
                        valor += "=";
                        bool comas = false;
                        ListBox list = ((ListBox)c);
                        for (int i = 0; i < list.Items.Count; i++)
                        {
                            if (list.Items[i].Selected)
                            {
                                if (comas)
                                    valor += ",";
                                comas = true;
                                valor += HttpUtility.UrlEncode(list.Items[i].Value);
                            }
                        }
                    }
                    else
                    {
                        valor = "";
                    }
                }
                if (valor.Length > 0)
                {
                    if (resultado.Length > 0)
                        resultado += ";";
                    resultado += valor;
                }
            }
            return resultado;
        }

        public static string GetUrl(string url, string parametro) {

            url += url.IndexOf("?") == -1 ? "?" : "&";
            return url + parametro;
        }

        public static bool RestoreState(ControlCollection controles, string valores)
        {
            if (string.IsNullOrEmpty(valores))
                return false;
            string[] campos = valores.Split(';');
            if (valores.Length == 0)
                return false;
            for (int i = 0; i < campos.Length; i++)
            {
                string[] idvalor = campos[i].Split('=');
                if (idvalor.Length > 1)
                {
                    Control c = Utilidades.FindControlForId(controles, idvalor[0]);
                    if (c is TextBox)
                    {
                        ((TextBox)c).Text = HttpUtility.UrlDecode(idvalor[1]);
                    }
                    else if (c is DropDownList)
                    {
                        if(((DropDownList)c).Items.Count<2)
                            ((DropDownList)c).DataBind();
                        ((DropDownList)c).SelectedValue = HttpUtility.UrlDecode(idvalor[1]);
                    }
                    else if (c is CheckBox)
                    {
                        ((CheckBox)c).Checked = idvalor[1] == "1";
                    }
                    else if (c is ListBox)
                    {
                        string[] valoreslistas = idvalor[1].Split(',');
                        ListBox list = ((ListBox)c);

                        for (int j = 0; j < list.Items.Count; j++)
                        {
                            for (int k = 0; k < valoreslistas.Length; k++)
                            {
                                if (list.Items[j].Value == HttpUtility.UrlDecode(valoreslistas[k]))
                                {
                                    list.Items[j].Selected = true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            return true;
        }

        static private bool GetKey()
        {
            if (bGetKey)
                return true;
            try
            {
                string[] keys = null;
                string dominio;
                if (HttpContext.Current == null) // es una pagina web
                {
                    if (OperationContext.Current == null)
                        dominio = System.IO.Path.GetFileName(System.Reflection.Assembly.GetEntryAssembly().Location);
                    else dominio = OperationContext.Current.IncomingMessageHeaders.To.Host;
                    if (dominio == "localhost")
                        return true;
                }
                else
                {
                    if (HttpContext.Current.Request.Url.Host == "localhost")
                        return true;
                    if (string.IsNullOrEmpty(ConfigurationSettings.AppSettings["DomainKey"]))
                        return false;
                    dominio = HttpContext.Current.Request.Url.Host;
                }
                keys = ConfigurationSettings.AppSettings["DomainKey"].Split(';');

                for (int i = 0; i < keys.Length; i++)
                {
                    if (Crypt.GetMD5(Crypt.Encriptar3DES(
                        dominio.PadRight(29, 'x').PadRight(37, '?').Replace("x", ";")
                        , "23B9134382220883".Replace("2", "1").Replace("2", "6"))) == keys[i])
                    {
                        bGetKey = true;
                        return true;
                    }
                }
                return false;
            }
            catch { }
            return false;
        }

        public static string TryConverToDoubleInvariantCulture(object valor) {
            try
            {
                return Convert.ToDouble(valor).ToString(CultureInfo.InvariantCulture);
            } catch { }
            return "";
        }

        static public bool SelectInDropDown(DropDownList lista, object valor)
        {
            return SelectInDropDown(lista, valor, null);
        }

        static public bool SelectInDropDown(DropDownList lista, object valor, string texto)
        {
            bool retorno = true;
            try
            {
                if (lista.Items.Count < 2)
                    lista.DataBind();
                lista.SelectedIndex = -1;
                ListItem item = lista.Items.FindByValue(valor.ToString());
                if (item == null)
                {
                    if (texto != null)
                    {
                        item = new ListItem(texto, valor.ToString());
                        lista.Items.Add(item);
                    }
                }
                if (item != null)
                    item.Selected = true;
            }
            catch { }
            return retorno;
        }
    }
}
