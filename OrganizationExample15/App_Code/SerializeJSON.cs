using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SDG.Componentes;

public class SerializeJSON
{
    public static JsonSerializerSettings JSONSettings = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };

    public static void _Serialize(ControlCollection controls, JObject values, List<Control> skipControls)
    {
        foreach (Control control in controls)
        {
            if (control is Repeater || control is GridView || control is DataList || skipControls.Contains(control))
            {
                continue;
            }
            if (control.HasControls())
            {
                _Serialize(control.Controls, values, skipControls);
                continue;
            }
            if (string.IsNullOrEmpty(control.ID))
                continue;
            string value = null;
            if (control is TextBox)
            {
                value = ((TextBox)control).Text;
            }
            else if (control is RadioButtonList)
            {
                value = ((RadioButtonList)control).SelectedValue;
            }
            else if (control is DropDownList)
            {
                value = ((DropDownList)control).SelectedValue;
            }
            else if (control is CheckBox)
            {
                value = ((CheckBox)control).Checked ? "1" : "";
            }
            if (!string.IsNullOrEmpty(value))
                values[control.ID] = value;
        }
    }

    public static string Serialize(ControlCollection controls, Control[] skipControls = null, Dictionary<string, JToken> appendvalues = null)
    {

        JObject values = new JObject();
        _Serialize(controls, values
            , skipControls == null ? new List<Control>() : skipControls.ToList()
            );
        if (appendvalues != null)
        {
            foreach (var key in appendvalues)
            {
                values[key.Key] = key.Value;
            }
        }
        return JsonConvert.SerializeObject(values, JSONSettings);
    }

    protected static void _DesSerialize(ControlCollection controls, JObject values, List<Control> skipControls)
    {

        foreach (Control control in controls)
        {
            if (control is Repeater || control is GridView || control is DataList || skipControls.Contains(control))
            {
                continue;
            }
            if (control.HasControls())
            {
                _DesSerialize(control.Controls, values, skipControls);
                continue;
            }
            if (string.IsNullOrEmpty(control.ID))
                continue;
            string value = (string)values[control.ID];
            if (string.IsNullOrEmpty(value))
                continue;
            if (control is TextBox)
            {
                ((TextBox)control).Text = value;
            }
            else if (control is RadioButtonList)
            {
                try { ((RadioButtonList)control).SelectedValue = value; } catch { }
            }
            else if (control is DropDownList)
            {
                try { ((DropDownList)control).SelectedValue = value; } catch { }
            }
            else if (control is CheckBox)
            {
                ((CheckBox)control).Checked = value == "1";
            }
        }
    }

    public static JObject DesSerialize(ControlCollection controls, string value, Control[] skipControls = null)
    {
        if (string.IsNullOrEmpty(value))
            return null;
        try
        {
            JObject values = JObject.Parse(value);
            _DesSerialize(controls, values
                , skipControls == null ? new List<Control>() : skipControls.ToList()
                );
            return values;
        }
        catch { }
        return null;
    }


    public static bool SaveRepeaterRadio(Conector conector, Repeater repeater, string tablename, string fieldidname, string id)
    {
        Query query = new Query(tablename);

        query[fieldidname] = id;

        for (int i = 0; i < repeater.Items.Count; i++)
        {
            RadioButtonList radio = (RadioButtonList)repeater.Items[i].FindControl("R");
            TextBox textbox = (TextBox)repeater.Items[i].FindControl("T");
            HiddenField hidden = (HiddenField)repeater.Items[i].FindControl("H");
            CheckBox checkbox = (CheckBox)repeater.Items[i].FindControl("C");

            bool save = false;
            query["tipo"] = hidden.Value;

            if (radio != null && radio.SelectedValue == "1")
            {
                save = true;
                query["valor"] = "1";
            }
            if (checkbox != null && checkbox.Checked)
            {
                save = true;
                query["valor"] = "1";
            }
            if (textbox != null && !string.IsNullOrEmpty(textbox.Text))
            {
                save = true;
                query[radio == null ? "valor" : "valor2"] = textbox.Text;
            }

            if (save && conector.QueryMod(query.GetInsert()) == -1)
            {
                return false;
            }
        }
        return true;
    }

    public static bool SaveGriwRadio(Conector conector, GridView grid, string tablename, string fieldidname, string id)
    {

        Query query = new Query(tablename);

        query[fieldidname] = id;

        for (int i = 0; i < grid.Rows.Count; i++)
        {

            RadioButtonList radio = (RadioButtonList)grid.Rows[i].FindControl("R");
            TextBox textbox = (TextBox)grid.Rows[i].FindControl("T");
            TextBox textbox2 = (TextBox)grid.Rows[i].FindControl("T2");
            TextBox textbox3 = (TextBox)grid.Rows[i].FindControl("T3");

            bool save = false;
            query["tipo"] = grid.DataKeys[i].Values["id"].ToString();

            if (radio != null && radio.SelectedValue == "1")
            {
                save = true;
                query["valor"] = "1";
            }
            if (textbox != null && !string.IsNullOrEmpty(textbox.Text))
            {
                save = true;
                query[radio == null ? "valor" : "valor2"] = textbox.Text;
            }
            if (textbox2 != null && !string.IsNullOrEmpty(textbox2.Text))
            {
                save = true;
                query["valor2"] = textbox2.Text;
            }
            if (textbox3 != null && !string.IsNullOrEmpty(textbox3.Text))
            {
                save = true;
                query["valor3"] = textbox3.Text;
            }


            if (save && conector.QueryMod(query.GetInsert()) == -1)
            {
                return false;
            }
        }
        return true;
    }
}