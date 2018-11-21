using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SDG.Componentes;
using System.Globalization;
using System.IO;

public partial class archivo_digitalizacion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            CUsuario usuario = (CUsuario)CUsuario.GetUsuario();
            ViewState["entidades"] = usuario["entidades"];
            // PImportacion.Visible = Usuario.GetInstance().CanAdmin();
            BActualizar_Click(sender, e);
        }
    }

    protected void BImportar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        if (!FImportar.HasFile)
            return;

        List<string> campos = new List<string>();
        string debug = "";
        int id = -1;

        Query query = new Query("digitalizacion");
        StreamReader reader = new StreamReader(FImportar.FileContent, System.Text.Encoding.UTF7);
        if (reader.Peek() < 0)
        {
            LMensaje.Text = "No se puede leer el archivo";
            return;
        }
        string header = reader.ReadLine();
        string[] textos = header.ToLower().Split(';');
        for (int i = 0; i < textos.Length; i++)
        {
            textos[i] = textos[i].Trim();
            if (textos[i] == "fecha") {
                campos.Add("fecha");
            } else if (textos[i] == "factura") {
                campos.Add("factura");
            } else if (textos[i] == "c.c.") {
                campos.Add("documento");
                id = i;
            } else if (textos[i] == "asegura") {
                campos.Add("aseguradora");
            } else if (textos[i] == "nombre-imagen") {
                campos.Add("archivo");
            } else if (textos[i] == "total-img") {
                campos.Add("paginas");
            } else {
                LMensaje.Text = "No se encontro la columna '" + textos[i] + "'";
                return;
            }
        }
        if (id == -1)
        {
            // no se encontro el id
            LMensaje.Text = "No se encontro la columna C.C.";
            return;
        }
        if (campos.Count<4)
        {
            LMensaje.Text = "No se encontraron columnas a modificar";
            return;
        }

        using (CConector conector = new CConector())
        {
            conector.StartTransaction();
            int nuevos = 0, actualizados = 0;
            string valor;
            int linea = 1;

            while (reader.Peek() >= 0)
            {
                header = reader.ReadLine();
                textos = header.Split(';');
                string currentID = "";
                linea++;
                
                // hasta aca hacemos la importacion.
                if (textos[0].Length == 0)
                    break;

                for (int i = 0; i < textos.Length && i < campos.Count; i++)
                {
                    textos[i] = textos[i];
                    if (i == id)
                    {
                        valor= textos[i].Trim().Replace(".", "").Replace(",", "");
                        currentID = conector.QueryString(string.Format("SELECT pacId FROM paciente WHERE pacDocumento={0}", Query.GetValor(valor)));
                        
                        if (string.IsNullOrEmpty(currentID))
                        {
                            currentID = "0";
                            debug += "<br/>Paciente no encontrado " + Query.GetValor(valor) + " en línea " + linea;
                        }
                        query["paciente"] = currentID;
                        query["documento"] = valor;
                    } else {
                        valor = textos[i].Trim();
                        if (valor.Length == 0) {
                            LMensaje.Text = "No se puede ingresar el valor " + i + " en blanco en la línea " + linea;
                            return;
                        }
                        switch (campos[i])
                        {
                            case "fecha":
                                try
                                {
                                    valor = Query.GetMySQLDateFormat(DateTime.ParseExact(valor, "yyyyMMdd", CultureInfo.InvariantCulture));
                                } catch {
                                    LMensaje.Text = "La fecha no tiene el formato correcto YYYYMMDD en la línea " + linea;
                                    return;
                                }
                                break;
                        }
                        query[campos[i]] = valor;
                    }
                }

                if (conector.QueryString("SELECT fecha FROM digitalizacion WHERE paciente=" + Query.GetValor(query["paciente"].ToString()) + " AND factura=" + Query.GetValor(query["factura"].ToString())).Length == 0)
                {
                    nuevos++;
                    if (conector.QueryMod(query.GetInsert()) == -1)
                        return;
                } else {
                    if (conector.QueryMod(query.GetUpdate("paciente=" + Query.GetValor(query["paciente"].ToString()) + " AND factura=" + Query.GetValor(query["factura"].ToString()))) == -1)
                        return;
                    actualizados++;
                    debug += "<br/>Paciente actualizado paciente " + Query.GetValor(query["documento"].ToString()) + " y factura " + Query.GetValor(query["factura"].ToString()) + " en línea " + linea;
                }
            }
            reader.Close();
            conector.Commit();

            LMensaje.Text = string.Format("Importacion realizada con exito.<br/>{0} archivos, {1} Nuevos y {2} actualizados", nuevos + actualizados, nuevos, actualizados) + debug;

            GridUtils.GetRowsCount(GArchivo, LTotal);
        }
    }
    protected void BActualizar_Click(object sender, EventArgs e)
    {
        GridUtils.GetRowsCount(GArchivo, LTotal);
    }
}
