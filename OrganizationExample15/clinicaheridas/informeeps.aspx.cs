using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using SDG.Componentes;
using SDG.Web.UI.WebControls;

public partial class clinicaheridas_informeeps : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ((MasterPageI)Master)._ImprimirClicked += new EventHandler(OnImprimir);

        if (!IsPostBack)
        {
            TDesde.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            THasta.Text = DateTime.Now.ToShortDateString();

            if (Request.QueryString["p"] == "1")
            {
                if(((MasterPageI)Master).RestoreState())
                    BBuscar_Click(sender, e);
            }
#if DEBUG
            // BBuscar_Click(sender, e);
#endif
        }
    }

    protected void BBuscar_Click(object sender, EventArgs e)
    {
        GResultados.Visible = true;
        if (GridUtils.GetRowsCount(GResultados, LTotal) > 0)
        {
            ((MasterPageI)Master).Imprimir("informeEPS.html", true); // .Excel(GResultados);
            // ((MasterPageI)Master).Imprimir(GResultados);
        }
    }

    static Dictionary<string, int> ColumnsIndex = new Dictionary<string, int>();

    public void ReplaceProducto(string columna, GridViewRow row) {

        int numero=-1;
        try { numero = ColumnsIndex[columna]; } catch { }
        if(numero==-1)
            ColumnsIndex[columna] = numero = GResultados.GetGridColumnIndex(columna);
        TableCell celda = row.Cells[numero];
        string texto = HttpUtility.HtmlDecode(celda.Text).Trim();
        if (!string.IsNullOrEmpty(texto))
            celda.Text = Producto.GetProducto(texto).NombreCompleto;
    }

    protected void GResultados_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex != -1)
        {
            ReplaceProducto("INSUMO 1", e.Row);
            ReplaceProducto("INSUMO 2", e.Row);
            ReplaceProducto("INSUMO 3", e.Row);
            ReplaceProducto("INSUMO 4", e.Row);
        }
    }

    public string GetVarios(string id, string defaultValue="(Ninguno)") {

        string resultado = Procedimientos.GetVarios(id);
        if (string.IsNullOrEmpty(resultado))
            resultado = defaultValue;
        return resultado;
    }

    public StringBuilderEx ImprimirFuncionario(Conector conector, StringBuilderEx contenido, string idFuncionario)
    {
        Query query = new Query("recurso_humano");

        query["TFuncionario"] = "recurso_humano.perNombre";
        query["szProfesional"] = "recurso_humano.perDocumento";
        query["szCargo"] = "cargo.carDescripcion";
        query["szNombrePersonal"] = "recurso_humano.perNombre";

        MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(idFuncionario), " LEFT JOIN cargo ON (cargo.carId=recurso_humano.carId)"));
        if (reader != null)
        {
            bool l = reader.Read();
            for (int j = 0; j < reader.FieldCount; j++)
            {
                contenido = contenido.Replace("$" + reader.GetName(j) + "$", l ? reader[j].ToString() : "");
            }
        }
        return contenido.Replace("$szIdUsuario$", conector.QueryString("SELECT id FROM usuario WHERE personal=" + Query.GetValor(idFuncionario)));
    }

    protected string AddPorcentajeDeTejido(string nombre, object valor, bool coma)
    {
        try
        {
            int porcentaje= Convert.ToInt32(valor);
            if (porcentaje > 0) {
                return (coma ? "," : "") + " <b>" + nombre + "</b> " + valor + "%";
            }
        } catch { }
        return null;
    }

    public StringBuilderEx ImprimirEvolucion(Conector conector, StringBuilderEx contenido, StringBuilderEx herida, string idEvolucion) {

        string idFuncionario = "";
        string fechaEvolucion = "";

        Query query = new Query("evolucion_herida");

        query += "funcionario";
        query["TFecha"] = "fecha";
        query["TTA"] = "ta";
        query["TFC"] = "fc";
        query["TFR"] = "fr";
        query["TT"] = "t";
        query["RPDistales"] = "pulsosdistales";
        query["TObservacionPulso"] = "observacion_pulso";
        query["szPlanManejo"] = "manejo";
        query["TOtros"] = "otros";


        MySqlDataReader reader = conector.Query(query.GetSelect("id={0}", null, Query.GetValor(idEvolucion)));
        if (reader != null && reader.Read())
        {
            contenido = contenido.Replace(string.Format("${0}$", "RPDistales"), HttpUtility.HtmlEncode(Procedimientos.GetVarios(reader["RPDistales"].ToString())));

            contenido = contenido.Replace("$szPlanManejo$",
                "<ol><li>"
                + string.Join("</li><li>", HttpUtility.HtmlEncode(reader["szPlanManejo"].ToString()).Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries))
                + "</li></ol>"
            );

            for (int j = 0; j < reader.FieldCount; j++)
            {
                contenido = contenido.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(reader.GetValue(j).ToString()));
            }
            idFuncionario = reader["funcionario"].ToString();
            fechaEvolucion = Query.GetFromMySQLDate(reader["TFecha"]);
        }

        query = new Query("evolucion_herida");

        query += "fecha";

        reader = conector.Query(query.GetSelect("paciente={0} AND id<{1} ORDER BY id DESC LIMIT 1", null, CCDetallePaciente.IdPaciente, idEvolucion));
        if (reader != null && reader.Read())
        {

            TimeSpan ts = DateTime.Parse(fechaEvolucion) - (DateTime)reader["fecha"];
            contenido = contenido.Replace("$LUltimaEvolucion$", HttpUtility.HtmlEncode(Query.GetFromMySQLDate(reader["fecha"])))
                .Replace("$LDiasEvolucion2$", ts.Days.ToString());
        }

        query = new Query("valoracion_herida");

        query += "fecha";

        reader = conector.Query(query.GetSelect("paciente=" + Query.GetValor(CCDetallePaciente.IdPaciente)));
        if (reader != null && reader.Read())
        {
            TimeSpan ts = DateTime.Parse(fechaEvolucion) - (DateTime)reader["fecha"];
            contenido = contenido.Replace("$LValoracionInicial$", HttpUtility.HtmlEncode(Query.GetFromMySQLDate(reader["fecha"])))
                .Replace("$LDiasEvolucion$", ts.Days.ToString())
                // por si no exisitican evoluciones anteriores
                .Replace("$LUltimaEvolucion$", HttpUtility.HtmlEncode(Query.GetFromMySQLDate(reader["fecha"])))
                .Replace("$LDiasEvolucion2$", ts.Days.ToString());
            ;
        }

        contenido = contenido.Replace("$szClinica$", HttpUtility.HtmlEncode(conector.QueryString(@"select group_concat(varios.nombre) from evolucion_herida_clinica 
left join varios ON(varios.id = evolucion_herida_clinica.concepto)
where evolucion = {0};", idEvolucion)));
        contenido = contenido.Replace("$szPlanEducativo$", HttpUtility.HtmlEncode(conector.QueryString(@"select group_concat(varios.nombre) from evolucion_herida_educativo 
left join varios ON (varios.id=evolucion_herida_educativo.concepto)
where evolucion={0};", idEvolucion)));

        foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
        {
            contenido = contenido.Replace("$sz" + escala.ToString() + "$", Calificacion.GetCalificacionYDescripcion(CCDetallePaciente.IdPaciente, fechaEvolucion, escala));
        }

        query = new Query("evolucion_herida_herida");

        query += "id";
        query["DLocalizacion"] = "localizacion";
        query["RLocalizacion2"] = "localizacion2";
        query["RLocalizacion3"] = "localizacion3";
        query["RMI"] = "mi";
        query["RPies"] = "pies";
        query["TUbicacionEspecifica"] = "ubicacion_especifica";
        query[""] = "etiologia";
        query[""] = "etiologia_otro";
        query["DClasificacion"] = "clasificacion";
        query["TFactoresRiesgo"] = "factores_riesgo";
        query["TLongitud"] = "longitud";
        query["TAnchura"] = "anchura";
        query["TProfunidad"] = "profundidad";
        query["CTunelizacion"] = "IF(tunelizacion IS NULL, '_', 'X')";
        query["TTunelizacion"] = "tunelizacion";
        query["TCavidad"] = "cavidad";
        query["CBolsillo"] = "IF(bolsillo_tamano IS NULL, '_', 'X')";
        query["TBolsilloProfundidad"] = "bolsillo_tamano";
        query["TBolsilloUbicacion"] = "bolsillo_ubicacion";
        query[""] = "tipo_tejido";
        query["TCompacto"] = "compacto";
        query["TDeFibrina"] = "fibrina";
        query["TEpitelizacion"] = "epitelizacion";
        query["TEscara"] = "escara";
        query["TGranulacion"] = "granulacion";
        query["THiperGranulacion"] = "hipergranulacion";
        query["TLimpio"] = "limpio";
        query["TNecrosis"] = "necrosis";
        query[""] = "seleccion_tejido";
        query["DExudado"] = "exudado";
        query["DTipoExudado"] = "tipo_exudado";
        query["DPielCircundante"] = "piel_circundante";
        query["DBordesHerida"] = "bordes_herida";
        query[""] = "olor";
        query[""] = "olor_descripcion";
        query["DSignosSintomas"] = "signos_sintomas";
        query[""] = "exudado_complicacion";
        query[""] = "exudado_definicion";
        query["DTipoCambios"] = "cambio_herida";
        query["TSignosInfeccion"] = "signo_infeccion";

        StringBuilderEx heridaCompleta = "";

        reader = conector.Query(query.GetSelect("evolucion=" + Query.GetValor(idEvolucion)));
        if (reader != null)
        {
            while (reader.Read())
            {
                heridaCompleta += herida.ToString();
                for (int j = 0; j < reader.FieldCount; j++)
                {
                    if (reader.GetName(j).StartsWith("D") || reader.GetName(j).StartsWith("R"))
                        heridaCompleta = heridaCompleta.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(GetVarios(reader.GetValue(j).ToString())));
                    else heridaCompleta = heridaCompleta.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(reader.GetValue(j).ToString()));
                }
                heridaCompleta = heridaCompleta.Replace("$szFotos$", Heridas.ImprimirFotos(CCDetallePaciente.IdPaciente, idEvolucion, reader["id"].ToString(), "e"));
            }
        }
        contenido = Heridas.RemoveSection(false, "seccionherida", contenido, heridaCompleta.ToString());

        return ImprimirFuncionario(conector, contenido, idFuncionario);
    }

    public StringBuilderEx ImprimirValoracion(Conector conector, StringBuilderEx contenido, StringBuilderEx herida, string idValoracion)
    {

        string idFuncionario = "";
        string fechaValoracion = "";

        contenido = contenido.Replace("$szPlanEducativo$", HttpUtility.HtmlEncode(conector.QueryString(@"select group_concat(varios.nombre) from valoracion_herida_educativo 
left join varios ON (varios.id=valoracion_herida_educativo.concepto)
where valoracion={0};", idValoracion)));

        Query query = new Query("valoracion_herida_antecedentes");

        query += "valoracion_herida_antecedentes.estado";
        query += "varios.nombre";
        query += "valoracion_herida_antecedentes.observaciones";

        contenido = contenido.Replace("$szAntecedentes$",
            ImprimirGrid(conector.Query(query.GetSelect("valoracion={0}", "LEFT JOIN varios ON (valoracion_herida_antecedentes.motivo=varios.id)", idValoracion))));

        query = new Query("valoracion_herida_riesgos");

        query += "valoracion_herida_riesgos.estado";
        query += "varios.nombre";
        query += "valoracion_herida_riesgos.observaciones";

        contenido = contenido.Replace("$szRiesgos$",
            ImprimirGrid(conector.Query(query.GetSelect("valoracion={0}", "LEFT JOIN varios ON (valoracion_herida_riesgos.motivo=varios.id)", idValoracion))));

        string clasificacion = "";
        string tipo = "";




        StringBuilderEx heridaCompleta = "";

        query = new Query("valoracion_herida_herida");

        query += "id";
        query["DLocalizacion"] = "localizacion";
        query["RLocalizacion2"] = "localizacion2";
        query["RLocalizacion3"] = "localizacion3";
        query["RMI"] = "mi";
        query["RPies"] = "pies";
        query["TUbicacionEspecifica"] = "ubicacion_especifica";
        query["DEtiologia"] = "etiologia";
        query["TOtroEtiologia"] = "etiologia_otro";
        query["DClasificacion"] = "clasificacion";
        query["TFactoresRiesgo"] = "factores_riesgo";
        query["TLongitud"] = "longitud";
        query["TAnchura"] = "anchura";
        query["TProfunidad"] = "profundidad";
        query["CTunelizacion"] = "IF(tunelizacion IS NULL, '_', 'X')";
        query["TTunelizacion"] = "tunelizacion";
        query["TCavidad"] = "cavidad";
        query["CBolsillo"] = "IF(bolsillo_tamano IS NULL, '_', 'X')";
        query["TBolsilloProfundidad"] = "bolsillo_tamano";
        query["TBolsilloUbicacion"] = "bolsillo_ubicacion";
        query["RTipoTejido"] = "tipo_tejido";
        query["TCompacto"] = "compacto";
        query["TDeFibrina"] = "fibrina";
        query["TEpitelizacion"] = "epitelizacion";
        query["TEscara"] = "escara";
        query["TGranulacion"] = "granulacion";
        query["THiperGranulacion"] = "hipergranulacion";
        query["TLimpio"] = "limpio";
        query["TNecrosis"] = "necrosis";
        query["DSeleccione"] = "seleccion_tejido";
        query["DExudado"] = "exudado";
        query["DTipoExudado"] = "tipo_exudado";
        query["DPielCircundante"] = "piel_circundante";
        query["DBordesHerida"] = "bordes_herida";
        query["DOlor"] = "olor";
        query["TOlorDescripcion"] = "olor_descripcion";
        query["DSignosSintomas"] = "signos_sintomas";
        query["TComplicaciones"] = "exudado_complicacion";
        query["CComplicaciones"] = "IF(exudado_complicacion IS NULL, '', 'X')";
        query["DDefina"] = "exudado_definicion";

        MySqlDataReader reader = conector.Query(query.GetSelect("valoracion=" + Query.GetValor(idValoracion)));
        if (reader != null)
        {
            while (reader.Read())
            {
                heridaCompleta += herida.ToString();
                for (int j = 0; j < reader.FieldCount; j++)
                {
                    if (reader.GetName(j).StartsWith("D") || reader.GetName(j).StartsWith("R"))
                        heridaCompleta = heridaCompleta.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(GetVarios(reader.GetValue(j).ToString())));
                    else heridaCompleta = heridaCompleta.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(reader.GetValue(j).ToString()));
                }
                clasificacion = HttpUtility.HtmlEncode(GetVarios(reader["DDefina"].ToString()));
                tipo = HttpUtility.HtmlEncode(GetVarios(reader["DEtiologia"].ToString()));
                heridaCompleta = heridaCompleta.Replace("$szFotos$", Heridas.ImprimirFotos(CCDetallePaciente.IdPaciente, idValoracion, reader["id"].ToString(), "v"));

                string porcentajedepedido = "";
                porcentajedepedido += AddPorcentajeDeTejido("Compacto", reader["TCompacto"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("De fibrina", reader["TDeFibrina"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("Epitelización", reader["TEpitelizacion"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("Esfacelo", reader["TEscara"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("Granulación", reader["TGranulacion"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("Hipergranulación", reader["THiperGranulacion"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("Limpio pero no granulado", reader["TLimpio"], porcentajedepedido.Length > 0);
                porcentajedepedido += AddPorcentajeDeTejido("Necrosis profunda", reader["TNecrosis"], porcentajedepedido.Length > 0);

                heridaCompleta = heridaCompleta.Replace("$szPorcentajedePedido$", porcentajedepedido);
            }
        }
        contenido = Heridas.RemoveSection(false, "seccionherida", contenido, heridaCompleta.ToString());


        // se reemplaza al reves por tener campos de la herida
        query = new Query("valoracion_herida");

        query["TFecha"] = "fecha";
        query["TTA"] = "ta";
        query["TFC"] = "fc";
        query["TFR"] = "fr";
        query["TT"] = "t";
        query["RPDistales"] = "pulsosdistales";
        query["COstomias"] = "ostomias";
        query["TUbicacion"] = "ubicacion";
        query["DColor"] = "color";
        query["DEstoma"] = "estoma";
        query["DComplicacion"] = "complicaciones";
        query["DEstadoPiel"] = "estado_piel";
        query["DTipoDispositivo"] = "tipo_dispositivo";
        query["DFuncional"] = "funcional";
        query["TFuncionalDescripcion"] = "funcional_descripcion";
        query+= "dolor";

        query["TTiempoEvolucion"] = "tiempo_evolucion_ulcera";
        query["DLugarOrigen"] = "lugar_origen_ulcera";
        query["DTejidoSospechoso"] = "tejido_profundo";
        query["THogarGeriatrico"] = "hogar_geriatrico";
        query[""] = "consentimiento";


        query["szPlanManejo"] = "manejo";
        query["RTipo"] = "costomias";
        query["CDispositivosMedicos"] = "cdispositivos_medicos";
        query["TPeriodicidad"] = "periodicidad";
        query["CFistulas"] = "fistula";
        query["TLocalizacionFistula"] = "localizacion_fistula";
        query["CSignosInfeccion"] = "signos_infeccion";
        query["TCAfluente"] = "cantidad_afluente";
        query["TObservacionPulso"] = "observacion_pulso";
        query += "funcionario";

        reader = conector.Query(query.GetSelect("id=" + Query.GetValor(idValoracion)));
        if (reader != null && reader.Read())
        {
            contenido = contenido.Replace("$szPlanManejo$",
                "<ol><li>"
                + string.Join("</li><li>", HttpUtility.HtmlEncode(reader["szPlanManejo"].ToString()).Split(new char[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries))
                + "</li></ol>"
            );
            contenido = contenido.Replace("$szImagenEscala$", GetVarios(reader["dolor"].ToString()));

            for (int j = 0; j < reader.FieldCount; j++)
            {
                if (reader.GetName(j).StartsWith("D") || reader.GetName(j).StartsWith("R"))
                    contenido = contenido.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(GetVarios(reader.GetValue(j).ToString())));
                contenido = contenido.Replace(string.Format("${0}$", reader.GetName(j)), HttpUtility.HtmlEncode(reader.GetValue(j).ToString()));
            }
            idFuncionario = reader["funcionario"].ToString();
            fechaValoracion = Query.GetFromMySQLDate(reader["TFecha"]);

            contenido = contenido.Replace("$DEscalaDolor$", GetVarios(reader["dolor"].ToString()) 
                + " - " 
                + conector.QueryString("SELECT descripcion FROM varios WHERE id={0}", Query.GetValor(reader["dolor"])));
        }

        foreach (Calificacion.Escalas escala in (Calificacion.Escalas[])Enum.GetValues(typeof(Calificacion.Escalas)))
        {
            contenido = contenido.Replace("$sz" + escala.ToString() + "$", Calificacion.GetCalificacionYDescripcion(CCDetallePaciente.IdPaciente, fechaValoracion, escala));
        }

        contenido = contenido.Replace("$LClasificacion$", clasificacion);
        contenido = contenido.Replace("$LTipo$", tipo);
        contenido = contenido.Replace("$LHogarGeriatrico$", "Especifique");
        contenido = contenido.Replace("$LOtroEtiologia$", "Otro");

        return ImprimirFuncionario(conector, contenido, idFuncionario);
    }

    public string ImprimirGrid(MySqlDataReader reader) {

        string resultado = "";
        if(reader!=null)
        {
            while (reader.Read()) {
                if (string.IsNullOrEmpty(reader[2].ToString()))
                    continue;
                if (resultado.Length > 0)
                    resultado += ", ";
                resultado += string.Format("<b>{1}: </b> {2}", HttpUtility.HtmlEncode(reader[0].ToString()), HttpUtility.HtmlEncode(reader[1].ToString()), HttpUtility.HtmlEncode(reader[2].ToString()));
            }
        }
        return resultado;
    }

    protected void OnImprimir(object sender, EventArgs e) {

        PrintEventArgs evento = (PrintEventArgs)e;
#if DEBUG
#else
        if (evento.pdf)
#endif
        {
            StringBuilderEx plantilla = new StringBuilderEx();
            StringBuilderEx plantillaValoracion = new StringBuilderEx();
            StringBuilderEx contenido = new StringBuilderEx();
            GResultados.AllowPaging = false;
            GResultados.DataBind();

            using (StreamReader reader = new StreamReader(Server.MapPath("~/clinicaheridas/evolucion.html")))
                evento.Contenido = reader.ReadToEnd();

            Regex regx = new Regex(".*<body.*?>(?<theBody>.*)\n.*</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            Match match = regx.Match(evento.Contenido.ToString());
            if (match.Success)
            {
                evento.Contenido = evento.Contenido.Replace(match.Groups["theBody"].Value, "{body}");
                plantilla = match.Groups["theBody"].Value;
            }

            using (StreamReader reader = new StreamReader(Server.MapPath("~/clinicaheridas/valoracion.html")))
            {
                string valoracion = reader.ReadToEnd();

                regx = new Regex(".*<body.*?>(?<theBody>.*)\n.*</body>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
                match = regx.Match(valoracion);
                if (match.Success)
                {
                    plantillaValoracion = match.Groups["theBody"].Value;
                }
            }

            StringBuilderEx herida= Heridas.GetSection("seccionherida", plantilla);
            StringBuilderEx heridaValoracion = Heridas.GetSection("seccionherida", plantillaValoracion);

            // Request.Cookies
            PP.Visible = true;
            string currentPaciente = "";

            using (CConector conector = new CConector())
            {
                for (int i = 0; i < GResultados.Rows.Count; i++)
                {
                    CCDetallePaciente.IdPaciente = GResultados.DataKeys[i].Values["paciente"].ToString();
                    Paciente paciente = Paciente.GetPaciente(CCDetallePaciente.IdPaciente);
                    TPaciente.Text = CCDetallePaciente.Documento;
                    LPaciente.Text = CCDetallePaciente.Nombres;

                    contenido += Heridas.RemoveSection(currentPaciente != CCDetallePaciente.IdPaciente, "datospaciente", plantillaValoracion.ToString(), "<tr><td colspan='5'><hr/></td></tr>").ToString();
                    contenido = ImprimirValoracion(conector, contenido, heridaValoracion, GResultados.DataKeys[i].Values["id"].ToString());
                    contenido = Utilidades.ReplaceContenido(PP.Controls, contenido);
                    currentPaciente = CCDetallePaciente.IdPaciente;

                    string idEvolucion = GResultados.DataKeys[i].Values["Idevolucion"].ToString();
                    foreach (string evolucion in idEvolucion.Split(','))
                    {
                        contenido += Heridas.RemoveSection(false, "datospaciente", plantilla.ToString(), "<tr><td colspan='5'><hr/></td></tr>").ToString();
                        contenido= ImprimirEvolucion(conector, contenido, herida, evolucion);
                        contenido = Utilidades.ReplaceContenido(PP.Controls, contenido);
                    }

                    contenido = contenido.Replace("$szCategoria$", Procedimientos.GetVarios(paciente.Categoria));
                    contenido = contenido.Replace("$szTipoAfiliacion$", paciente.TipoAfiliacion);
                }
            }

            evento.Contenido = evento.Contenido.Replace("{body}", contenido.ToString());
            return;
        }
    }
}
